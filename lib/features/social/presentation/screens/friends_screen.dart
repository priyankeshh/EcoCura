import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<EcoFriend> _friends = [];
  List<FriendRequest> _friendRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    _friends = _getSampleFriends();
    _friendRequests = _getSampleFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Friends'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Friends (${_friends.length})',
              icon: const Icon(Icons.people),
            ),
            Tab(
              text: 'Requests (${_friendRequests.length})',
              icon: const Icon(Icons.person_add),
            ),
            const Tab(
              text: 'Discover',
              icon: Icon(Icons.explore),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildRequestsTab(),
          _buildDiscoverTab(),
        ],
      ),
    );
  }

  Widget _buildFriendsTab() {
    if (_friends.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: 'No friends yet',
        subtitle: 'Connect with fellow eco-warriors to share tips and experiences!',
        actionText: 'Discover Friends',
        onAction: () => _tabController.animateTo(2),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        return _buildFriendCard(_friends[index]);
      },
    );
  }

  Widget _buildRequestsTab() {
    if (_friendRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_add_outlined,
        title: 'No friend requests',
        subtitle: 'When someone sends you a friend request, it will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(_friendRequests[index]);
      },
    );
  }

  Widget _buildDiscoverTab() {
    final suggestedFriends = _getSuggestedFriends();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestedFriends.length,
      itemBuilder: (context, index) {
        return _buildSuggestedFriendCard(suggestedFriends[index]);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
              ),
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFriendCard(EcoFriend friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildAvatar(friend.name, friend.avatarColor),
        title: Text(
          friend.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${friend.ecoPoints} eco points'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.eco, size: 14, color: AppTheme.primaryGreen),
                const SizedBox(width: 4),
                Text(
                  friend.ecoActivity,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'message',
              child: Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(width: 8),
                  Text('Message'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'unfriend',
              child: Row(
                children: [
                  Icon(Icons.person_remove, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Unfriend', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleFriendAction(friend, value.toString()),
        ),
        onTap: () => _showFriendProfile(friend),
      ),
    );
  }

  Widget _buildRequestCard(FriendRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(request.senderName, request.avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.senderName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wants to be your eco-friend',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _acceptRequest(request),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          minimumSize: const Size(80, 32),
                        ),
                        child: const Text('Accept', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _declineRequest(request),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(80, 32),
                        ),
                        child: const Text('Decline', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedFriendCard(EcoFriend friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(friend.name, friend.avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${friend.ecoPoints} eco points',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend.ecoActivity,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _sendFriendRequest(friend),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                minimumSize: const Size(80, 36),
              ),
              child: const Text('Add Friend', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String name, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _handleFriendAction(EcoFriend friend, String action) {
    switch (action) {
      case 'message':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening chat with ${friend.name}...')),
        );
        break;
      case 'profile':
        _showFriendProfile(friend);
        break;
      case 'unfriend':
        _showUnfriendDialog(friend);
        break;
    }
  }

  void _showFriendProfile(EcoFriend friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(friend.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🌱 Eco Points: ${friend.ecoPoints}'),
            const SizedBox(height: 8),
            Text('♻️ Activity: ${friend.ecoActivity}'),
            const SizedBox(height: 8),
            Text('🏆 Tier: ${friend.tier}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUnfriendDialog(EcoFriend friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfriend'),
        content: Text('Are you sure you want to unfriend ${friend.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _friends.removeWhere((f) => f.id == friend.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unfriended ${friend.name}')),
              );
            },
            child: const Text('Unfriend', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(FriendRequest request) {
    setState(() {
      _friendRequests.removeWhere((r) => r.id == request.id);
      _friends.add(EcoFriend(
        id: request.senderId,
        name: request.senderName,
        ecoPoints: 150,
        ecoActivity: 'New eco-friend',
        tier: 'Bronze',
        avatarColor: request.avatarColor,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${request.senderName} is now your eco-friend!')),
    );
  }

  void _declineRequest(FriendRequest request) {
    setState(() {
      _friendRequests.removeWhere((r) => r.id == request.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request declined')),
    );
  }

  void _sendFriendRequest(EcoFriend friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent to ${friend.name}!')),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Friends'),
        content: const Text('Friend search feature coming soon!\n\nThis will allow you to search for eco-community members by name or interests.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<EcoFriend> _getSampleFriends() {
    return [
      EcoFriend(
        id: 'friend1',
        name: 'Sarah Green',
        ecoPoints: 450,
        ecoActivity: 'Completed 5 upcycling projects',
        tier: 'Silver',
        avatarColor: AppTheme.primaryGreen,
      ),
      EcoFriend(
        id: 'friend2',
        name: 'Mike Eco',
        ecoPoints: 320,
        ecoActivity: 'Organized beach cleanup',
        tier: 'Bronze',
        avatarColor: Colors.blue,
      ),
      EcoFriend(
        id: 'friend3',
        name: 'Emma Sustainable',
        ecoPoints: 680,
        ecoActivity: 'Zero waste champion',
        tier: 'Gold',
        avatarColor: Colors.purple,
      ),
    ];
  }

  List<FriendRequest> _getSampleFriendRequests() {
    return [
      FriendRequest(
        id: 'req1',
        senderId: 'user4',
        senderName: 'Alex Nature',
        avatarColor: Colors.orange,
      ),
    ];
  }

  List<EcoFriend> _getSuggestedFriends() {
    return [
      EcoFriend(
        id: 'suggest1',
        name: 'Luna Earth',
        ecoPoints: 280,
        ecoActivity: 'Urban gardening enthusiast',
        tier: 'Bronze',
        avatarColor: Colors.teal,
      ),
      EcoFriend(
        id: 'suggest2',
        name: 'River Clean',
        ecoPoints: 520,
        ecoActivity: 'Water conservation advocate',
        tier: 'Silver',
        avatarColor: Colors.indigo,
      ),
    ];
  }
}

class EcoFriend {
  final String id;
  final String name;
  final int ecoPoints;
  final String ecoActivity;
  final String tier;
  final Color avatarColor;

  EcoFriend({
    required this.id,
    required this.name,
    required this.ecoPoints,
    required this.ecoActivity,
    required this.tier,
    required this.avatarColor,
  });
}

class FriendRequest {
  final String id;
  final String senderId;
  final String senderName;
  final Color avatarColor;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.avatarColor,
  });
}
