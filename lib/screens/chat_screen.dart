import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatScreen extends StatefulWidget {
  final ChatConversation conversation;
  final String currentUserId;
  final String userType; // 'customer' or 'provider'

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.userType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showQuickReplies = false;

  // Mock messages
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Mock conversation history
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: widget.userType == 'customer' ? widget.conversation.customerId : widget.conversation.providerId,
          senderName: widget.userType == 'customer' ? widget.conversation.customerName : widget.conversation.providerName,
          senderType: widget.userType,
          message: 'Hi! I have a booking for tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: MessageType.text,
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          senderId: widget.userType == 'customer' ? widget.conversation.providerId : widget.conversation.customerId,
          senderName: widget.userType == 'customer' ? widget.conversation.providerName : widget.conversation.customerName,
          senderType: widget.userType == 'customer' ? 'provider' : 'customer',
          message: 'Yes, I can see your booking. What can I help you with?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          type: MessageType.text,
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          senderId: widget.userType == 'customer' ? widget.conversation.customerId : widget.conversation.providerId,
          senderName: widget.userType == 'customer' ? widget.conversation.customerName : widget.conversation.providerName,
          senderType: widget.userType,
          message: 'Can I reschedule to 3 PM instead of 2 PM?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          type: MessageType.text,
          isRead: true,
        ),
      ]);
    });
  }

  void _startCall(String callType) {
    final otherPartyName = widget.conversation.getOtherPartyName(widget.currentUserId);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Call Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: callType == 'voice'
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [const Color(0xFFA855F7), const Color(0xFF9333EA)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  callType == 'voice' ? Icons.call : Icons.videocam,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Calling text
              Text(
                'Calling $otherPartyName...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                callType == 'voice' ? 'Voice Call' : 'Video Call',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Simulated ringing animation
              const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA855F7)),
                  strokeWidth: 3,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // End Call Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Call ended'),
                      backgroundColor: Colors.red.shade700,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.call_end),
                label: const Text('End Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Info text
              Text(
                'Call integration with WebRTC coming soon',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherPartyName = widget.conversation.getOtherPartyName(widget.currentUserId);
    
    return Scaffold(
      backgroundColor: const Color(0xFF050509),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF8D7C4).withValues(alpha: 0.3),
              child: Text(
                otherPartyName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherPartyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isTyping)
                    Text(
                      'typing...',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFFF8D7C4).withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Voice Call Button
          IconButton(
            icon: const Icon(Icons.call, color: Color(0xFF10B981)),
            tooltip: 'Voice Call',
            onPressed: () => _startCall('voice'),
          ),
          // Video Call Button
          IconButton(
            icon: const Icon(Icons.videocam, color: Color(0xFFA855F7)),
            tooltip: 'Video Call',
            onPressed: () => _startCall('video'),
          ),
          // Options Menu
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsMenu();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Booking Info Banner (if chat is related to booking)
          if (widget.conversation.bookingId != null) _buildBookingBanner(),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isMe = message.senderId == widget.currentUserId;
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          
          // Quick Replies
          if (_showQuickReplies) _buildQuickReplies(),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildBookingBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.2),
            Colors.blue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Related Booking',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: ${widget.conversation.bookingId}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('View booking details')),
              );
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFF8D7C4).withValues(alpha: 0.3),
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                        colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: !isMe
                    ? Border.all(color: Colors.white.withValues(alpha: 0.2))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? Colors.blue
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    final replies = widget.userType == 'customer'
        ? QuickReply.customerReplies
        : QuickReply.providerReplies;

    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: replies.length,
        itemBuilder: (context, index) {
          final reply = replies[index];
          return GestureDetector(
            onTap: () {
              _messageController.text = reply.text;
              setState(() {
                _showQuickReplies = false;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(reply.icon, size: 16, color: const Color(0xFFF8D7C4)),
                  const SizedBox(width: 6),
                  Text(
                    reply.text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF111827).withValues(alpha: 0.98),
            const Color(0xFF111827).withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quick Reply Toggle
            IconButton(
              icon: Icon(
                _showQuickReplies ? Icons.close : Icons.bolt,
                color: _showQuickReplies ? Colors.red : const Color(0xFFF8D7C4),
              ),
              onPressed: () {
                setState(() {
                  _showQuickReplies = !_showQuickReplies;
                });
              },
            ),
            
            // Attachments
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF8D7C4)),
              onPressed: () {
                _showAttachmentOptions();
              },
            ),
            
            // Text Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  onChanged: (text) {
                    // Simulate typing indicator
                    if (text.isNotEmpty && !_isTyping) {
                      setState(() => _isTyping = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _isTyping = false);
                      });
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Send Button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.currentUserId,
      senderName: widget.userType == 'customer'
          ? widget.conversation.customerName
          : widget.conversation.providerName,
      senderType: widget.userType,
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _showQuickReplies = false;
    });

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate other party response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: widget.userType == 'customer'
                  ? widget.conversation.providerId
                  : widget.conversation.customerId,
              senderName: widget.userType == 'customer'
                  ? widget.conversation.providerName
                  : widget.conversation.customerName,
              senderType: widget.userType == 'customer' ? 'provider' : 'customer',
              message: 'Sure! I\'ll update your booking right away.',
              timestamp: DateTime.now(),
              type: MessageType.text,
            ),
          );
        });
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAttachmentOption(
              Icons.photo_library,
              'Photo',
              Colors.purple,
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo upload coming soon!')),
                );
              },
            ),
            _buildAttachmentOption(
              Icons.location_on,
              'Location',
              Colors.green,
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location sharing coming soon!')),
                );
              },
            ),
            _buildAttachmentOption(
              Icons.calendar_today,
              'Booking Details',
              Colors.blue,
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking share coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.orange),
              title: const Text('Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear Chat', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
