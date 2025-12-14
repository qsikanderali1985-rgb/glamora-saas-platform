import 'package:flutter/material.dart';
import '../models/chat.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;
  final String userType; // 'customer' or 'provider'

  const ChatListScreen({
    super.key,
    required this.currentUserId,
    required this.userType,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock conversations
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      customerId: 'C001',
      customerName: 'Fatima Ahmed',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      bookingId: 'BK001',
      lastMessage: ChatMessage(
        id: 'M1',
        senderId: 'C001',
        senderName: 'Fatima',
        senderType: 'customer',
        message: 'Can I reschedule my appointment to 3 PM?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      unreadCount: 2,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatConversation(
      id: '2',
      customerId: 'C002',
      customerName: 'Sara Malik',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      bookingId: 'BK002',
      lastMessage: ChatMessage(
        id: 'M2',
        senderId: 'P001',
        senderName: 'Glow Beauty',
        senderType: 'provider',
        message: 'Your bridal makeup is confirmed for tomorrow!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        isRead: true,
      ),
      unreadCount: 0,
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ChatConversation(
      id: '3',
      customerId: 'C003',
      customerName: 'Zainab Hassan',
      providerId: 'P001',
      providerName: 'Glow Beauty Salon',
      lastMessage: ChatMessage(
        id: 'M3',
        senderId: 'C003',
        senderName: 'Zainab',
        senderType: 'customer',
        message: 'Thank you for the amazing service! ❤️',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: MessageType.text,
        isRead: true,
      ),
      unreadCount: 0,
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<ChatConversation> get _filteredConversations {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }
    return _conversations.where((conv) {
      final otherPartyName = conv.getOtherPartyName(widget.currentUserId).toLowerCase();
      return otherPartyName.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int get _totalUnread {
    return _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chat_bubble, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Messages'),
            if (_totalUnread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_totalUnread',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Conversations List
          Expanded(
            child: _filteredConversations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredConversations.length,
                    itemBuilder: (context, index) {
                      return _buildConversationCard(_filteredConversations[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Color(0xFFF8D7C4)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildConversationCard(ChatConversation conversation) {
    final otherPartyName = conversation.getOtherPartyName(widget.currentUserId);
    final hasUnread = conversation.unreadCount > 0;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversation: conversation,
              currentUserId: widget.currentUserId,
              userType: widget.userType,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasUnread
                ? [
                    const Color(0xFFA855F7).withValues(alpha: 0.2),
                    const Color(0xFFA855F7).withValues(alpha: 0.1),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasUnread
                ? const Color(0xFFA855F7).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFF8D7C4).withValues(alpha: 0.3),
                  child: Text(
                    otherPartyName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        conversation.unreadCount > 9
                            ? '9+'
                            : '${conversation.unreadCount}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Conversation Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherPartyName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (conversation.bookingId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.calendar_today, size: 10, color: Colors.blue),
                              SizedBox(width: 2),
                              Text(
                                'Booking',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.message ?? 'No messages yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: hasUnread
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.6),
                            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.lastMessage?.timeAgo ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: hasUnread
                              ? const Color(0xFFF8D7C4)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Chevron
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF8D7C4).withValues(alpha: 0.2),
                  const Color(0xFFA855F7).withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Color(0xFFF8D7C4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty ? 'No Conversations Yet' : 'No Results Found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Start chatting with service providers!'
                : 'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
