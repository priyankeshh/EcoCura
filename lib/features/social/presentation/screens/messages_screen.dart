import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  List<ChatConversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    _conversations = _getSampleConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showNewMessageDialog,
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return _buildConversationTile(_conversations[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with fellow eco-warriors!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showNewMessageDialog,
            icon: const Icon(Icons.add),
            label: const Text('New Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(ChatConversation conversation) {
    return ListTile(
      leading: _buildAvatar(conversation.otherUserName),
      title: Text(
        conversation.otherUserName,
        style: TextStyle(
          fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: conversation.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
          fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0 ? AppTheme.primaryGreen : Colors.grey[500],
              fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () => _openChat(conversation),
    );
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryGreen.withValues(alpha: 0.2),
        border: Border.all(
          color: AppTheme.primaryGreen,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _openChat(ChatConversation conversation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversation: conversation),
      ),
    );
  }

  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Message'),
        content: const Text('Start a new conversation feature coming soon!\n\nThis will allow you to message other eco-community members.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<ChatConversation> _getSampleConversations() {
    return [
      ChatConversation(
        id: 'conv1',
        otherUserId: 'user1',
        otherUserName: 'Sarah Green',
        lastMessage: 'Thanks for the upcycling tips! They were really helpful.',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: 2,
      ),
      ChatConversation(
        id: 'conv2',
        otherUserId: 'user2',
        otherUserName: 'Mike Eco',
        lastMessage: 'Are you joining the beach cleanup event this weekend?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
      ),
      ChatConversation(
        id: 'conv3',
        otherUserId: 'user3',
        otherUserName: 'Emma Sustainable',
        lastMessage: 'I love your latest post about zero waste living!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
      ),
    ];
  }
}

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

class ChatScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    _messages = [
      ChatMessage(
        id: 'msg1',
        senderId: widget.conversation.otherUserId,
        senderName: widget.conversation.otherUserName,
        content: 'Hey! I saw your post about upcycling. Do you have any tips for beginners?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg2',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Hi! Sure, I\'d love to help. Start with simple projects like turning jars into planters.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isFromCurrentUser: true,
      ),
      ChatMessage(
        id: 'msg3',
        senderId: widget.conversation.otherUserId,
        senderName: widget.conversation.otherUserName,
        content: widget.conversation.lastMessage,
        timestamp: widget.conversation.lastMessageTime,
        isFromCurrentUser: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.otherUserName),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isFromCurrentUser 
              ? AppTheme.primaryGreen 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: message.isFromCurrentUser ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      senderName: 'You',
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isFromCurrentUser;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isFromCurrentUser,
  });
}
