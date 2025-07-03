import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/widgets/theme_toggle_widget.dart';
import '../widgets/comments_screen.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {
  late List<GreenityPost> _posts;
  @override
  void initState() {
    super.initState();
    _posts = GreenityPost.getSamplePosts();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with light green background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(
                color: AppTheme.headerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Greenity',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      const QuickThemeToggle(),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add, color: AppTheme.textPrimary),
                        onPressed: _showCreatePostDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
            // Profile Gauge/Circle
            currentUserAsync.when(
              data: (user) => _buildProfileGauge(user),
              loading: () => _buildProfileGauge(null),
              error: (_, __) => _buildProfileGauge(null),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Events', Icons.event, () {
                  context.push('/events');
                }),
                _buildActionButton('Friends', Icons.people, () {
                  context.push('/friends');
                }),
                _buildActionButton('Messages', Icons.message, () {
                  context.push('/messages');
                }),
              ],
            ),

            const SizedBox(height: 24),

            // Community Posts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Posts',
                  style: AppTextStyles.heading3,
                ),
                TextButton(
                  onPressed: _showCreatePostDialog,
                  child: const Text('Create Post'),
                ),
              ],
            ),

            const SizedBox(height: 16),

                    // Posts List
                    ..._posts.map((post) => _buildPostCard(post)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGauge(dynamic user) {
    final progress = user?.points != null ? (user.points / 1000).clamp(0.0, 1.0) : 0.3;

    return GestureDetector(
      onTap: () {
        context.push('/coins');
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.primaryGreen,
            width: 4,
          ),
        ),
        child: Stack(
          children: [
            // Progress circle
            Positioned.fill(
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryGreen,
                ),
              ),
            ),
            // Profile image
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightGreen,
                ),
                child: user?.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.profileImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
              ),
            ),
            // Points indicator
            if (user?.points != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${user.points}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryGreen.withOpacity(0.9),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPostCard(GreenityPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                _buildUserAvatar(post.userName.substring(0, 1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatDate(post.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report'),
                    ),
                    const PopupMenuItem(
                      value: 'hide',
                      child: Text('Hide'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Post content
            Text(
              post.content,
              style: const TextStyle(fontSize: 14),
            ),

            // Post images
            if (post.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.lightGreen.withOpacity(0.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    post.imageUrls.first,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: AppTheme.primaryGreen,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                _buildPostAction(
                  Icons.favorite_border,
                  post.likesCount.toString(),
                  () => _likePost(post),
                ),
                const SizedBox(width: 24),
                _buildPostAction(
                  Icons.comment_outlined,
                  post.commentsCount.toString(),
                  () => _showCommentsDialog(post),
                ),
                const SizedBox(width: 24),
                _buildPostAction(
                  Icons.share_outlined,
                  post.sharesCount.toString(),
                  () => _sharePost(post),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String initial) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryGreen.withOpacity(0.2),
        border: Border.all(
          color: AppTheme.primaryGreen,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _likePost(GreenityPost post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post.copyWith(
          likesCount: post.likesCount + 1,
        );
      }
    });
  }

  void _sharePost(GreenityPost post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post.copyWith(
          sharesCount: post.sharesCount + 1,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared!')),
    );
  }

  void _showCommentsDialog(GreenityPost post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentsScreen(post: post),
      ),
    );
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: TextField(
          controller: contentController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                _createPost(contentController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _createPost(String content) {
    final newPost = GreenityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'You',
      content: content,
      createdAt: DateTime.now(),
    );

    setState(() {
      _posts.insert(0, newPost);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );
  }
}
