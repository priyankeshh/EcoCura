import 'package:cloud_firestore/cloud_firestore.dart';

class GreenityPost {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<String> likedBy;
  final List<String> tags;

  GreenityPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.content,
    this.imageUrls = const [],
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likedBy = const [],
    this.tags = const [],
  });

  factory GreenityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GreenityPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userProfileImage: data['userProfileImage'],
      content: data['content'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      sharesCount: data['sharesCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'likedBy': likedBy,
      'tags': tags,
    };
  }

  GreenityPost copyWith({
    String? content,
    List<String>? imageUrls,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    List<String>? likedBy,
    List<String>? tags,
  }) {
    return GreenityPost(
      id: id,
      userId: userId,
      userName: userName,
      userProfileImage: userProfileImage,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      likedBy: likedBy ?? this.likedBy,
      tags: tags ?? this.tags,
    );
  }

  static List<GreenityPost> getSamplePosts() {
    return [
      GreenityPost(
        id: 'post1',
        userId: 'user1',
        userName: 'Suryasen',
        userProfileImage: 'assets/images/boy.png',
        content: 'Hello Greenites🌳, Welcome to my new app which facilitates to the upcycling of the waste♻️ while also generating income💰 to the artists and entrepreneurs.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 24,
        commentsCount: 8,
        sharesCount: 3,
        tags: ['#upcycling', '#sustainability', '#greentech'],
      ),
      GreenityPost(
        id: 'post2',
        userId: 'user2',
        userName: 'Ashi Gupta',
        userProfileImage: 'assets/images/girl.png',
        content: 'Just completed my first upcycling project! Turned old plastic bottles into beautiful planters 🌱',
        imageUrls: ['assets/images/vertical-farming.png'],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        likesCount: 15,
        commentsCount: 4,
        sharesCount: 2,
        tags: ['#diy', '#planters', '#upcycling'],
      ),
    ];
  }
}

class GreenityComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final List<String> likedBy;

  GreenityComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.likedBy = const [],
  });

  factory GreenityComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GreenityComment(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userProfileImage: data['userProfileImage'],
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }
}

class GreenityEvent {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String organizerId;
  final String organizerName;
  final List<String> attendees;
  final int maxAttendees;
  final bool isOnline;
  final String? meetingLink;

  GreenityEvent({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    this.attendees = const [],
    this.maxAttendees = 100,
    this.isOnline = false,
    this.meetingLink,
  });

  factory GreenityEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GreenityEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      organizerId: data['organizerId'] ?? '',
      organizerName: data['organizerName'] ?? '',
      attendees: List<String>.from(data['attendees'] ?? []),
      maxAttendees: data['maxAttendees'] ?? 100,
      isOnline: data['isOnline'] ?? false,
      meetingLink: data['meetingLink'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'attendees': attendees,
      'maxAttendees': maxAttendees,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
    };
  }
}
