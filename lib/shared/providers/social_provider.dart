import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/social_models.dart';
import '../../core/services/firebase_service.dart';

// Social posts stream provider
final socialPostsProvider = StreamProvider<List<GreenityPost>>((ref) {
  return FirebaseService.firestore
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => GreenityPost.fromFirestore(doc))
          .toList());
});

// User posts provider
final userPostsProvider = StreamProvider.family<List<GreenityPost>, String>((ref, userId) {
  return FirebaseService.firestore
      .collection('posts')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => GreenityPost.fromFirestore(doc))
          .toList());
});

// Events provider
final eventsProvider = StreamProvider<List<GreenityEvent>>((ref) {
  return FirebaseService.firestore
      .collection('events')
      .where('startDate', isGreaterThan: Timestamp.now())
      .orderBy('startDate')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => GreenityEvent.fromFirestore(doc))
          .toList());
});

// Social service provider
final socialServiceProvider = Provider<SocialService>((ref) {
  return SocialService();
});

class SocialService {
  // Create a new post
  Future<void> createPost(GreenityPost post) async {
    try {
      await FirebaseService.firestore
          .collection('posts')
          .doc(post.id)
          .set(post.toFirestore());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Like a post
  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = FirebaseService.firestore.collection('posts').doc(postId);
      
      await FirebaseService.firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        
        if (postDoc.exists) {
          final post = GreenityPost.fromFirestore(postDoc);
          final likedBy = List<String>.from(post.likedBy);
          
          if (likedBy.contains(userId)) {
            // Unlike the post
            likedBy.remove(userId);
            transaction.update(postRef, {
              'likedBy': likedBy,
              'likesCount': FieldValue.increment(-1),
            });
          } else {
            // Like the post
            likedBy.add(userId);
            transaction.update(postRef, {
              'likedBy': likedBy,
              'likesCount': FieldValue.increment(1),
            });
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Comment on a post
  Future<void> commentOnPost(String postId, GreenityComment comment) async {
    try {
      // Add comment to comments subcollection
      await FirebaseService.firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toFirestore());

      // Update post comment count
      await FirebaseService.firestore
          .collection('posts')
          .doc(postId)
          .update({
        'commentsCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to comment on post: $e');
    }
  }

  // Share a post
  Future<void> sharePost(String postId) async {
    try {
      await FirebaseService.firestore
          .collection('posts')
          .doc(postId)
          .update({
        'sharesCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to share post: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await FirebaseService.firestore
          .collection('posts')
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Create an event
  Future<void> createEvent(GreenityEvent event) async {
    try {
      await FirebaseService.firestore
          .collection('events')
          .doc(event.id)
          .set(event.toFirestore());
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Join an event
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await FirebaseService.firestore
          .collection('events')
          .doc(eventId)
          .update({
        'attendees': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to join event: $e');
    }
  }

  // Leave an event
  Future<void> leaveEvent(String eventId, String userId) async {
    try {
      await FirebaseService.firestore
          .collection('events')
          .doc(eventId)
          .update({
        'attendees': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Failed to leave event: $e');
    }
  }

  // Get sample posts for development
  static List<GreenityPost> getSamplePosts() {
    return GreenityPost.getSamplePosts();
  }

  // Get sample events for development
  static List<GreenityEvent> getSampleEvents() {
    final now = DateTime.now();
    return [
      GreenityEvent(
        id: 'event1',
        title: 'Delhi River Cleanup Drive',
        description: 'Join Priya and team for cleaning Yamuna riverbank and creating awareness about water pollution.',
        startDate: now.add(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 7, hours: 4)),
        location: 'Yamuna Ghat, Old Delhi',
        organizerId: 'organizer1',
        organizerName: 'Priya Sharma - Green Delhi Initiative',
        attendees: ['user1', 'user2'],
        maxAttendees: 50,
      ),
      GreenityEvent(
        id: 'event2',
        title: 'Upcycling Workshop by Arjun',
        description: 'Learn from Arjun how to create beautiful home decor from waste plastic and cardboard.',
        startDate: now.add(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 14, hours: 3)),
        location: 'Connaught Place Community Center',
        organizerId: 'organizer2',
        organizerName: 'Arjun Gupta - EcoCraft Delhi',
        attendees: ['user3', 'user4', 'user5'],
        maxAttendees: 30,
      ),
    ];
  }
}

// Social posts notifier for local state management
class SocialPostsNotifier extends StateNotifier<AsyncValue<List<GreenityPost>>> {
  SocialPostsNotifier() : super(const AsyncValue.loading()) {
    _loadPosts();
  }

  void _loadPosts() {
    // For development, use sample posts
    final samplePosts = SocialService.getSamplePosts();
    state = AsyncValue.data(samplePosts);
  }

  void addPost(GreenityPost post) {
    state.whenData((posts) {
      final updatedPosts = [post, ...posts];
      state = AsyncValue.data(updatedPosts);
    });
  }

  void updatePost(GreenityPost updatedPost) {
    state.whenData((posts) {
      final updatedPosts = posts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();
      state = AsyncValue.data(updatedPosts);
    });
  }

  void removePost(String postId) {
    state.whenData((posts) {
      final updatedPosts = posts.where((post) => post.id != postId).toList();
      state = AsyncValue.data(updatedPosts);
    });
  }
}

final socialPostsNotifierProvider = StateNotifierProvider<SocialPostsNotifier, AsyncValue<List<GreenityPost>>>((ref) {
  return SocialPostsNotifier();
});
