import 'package:flutter/material.dart';

// Chat Message Model
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderType; // 'customer' or 'provider'
  final String message;
  final DateTime timestamp;
  final MessageType type; // text, image, voice, booking_details
  final bool isRead;
  final String? imageUrl;
  final String? voiceUrl;
  final Map<String, dynamic>? metadata; // For booking details, location, etc.

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.imageUrl,
    this.voiceUrl,
    this.metadata,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'metadata': metadata,
    };
  }
}

// Message Types
enum MessageType {
  text,
  image,
  voice,
  bookingDetails,
  location,
}

// Chat Conversation Model
class ChatConversation {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerAvatar;
  final String providerId;
  final String providerName;
  final String? providerAvatar;
  final String? bookingId; // Related booking if any
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;
  final bool isActive;

  ChatConversation({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerAvatar,
    required this.providerId,
    required this.providerName,
    this.providerAvatar,
    this.bookingId,
    this.lastMessage,
    this.unreadCount = 0,
    required this.lastActivity,
    this.isActive = true,
  });

  String getOtherPartyName(String currentUserId) {
    return currentUserId == customerId ? providerName : customerName;
  }

  String? getOtherPartyAvatar(String currentUserId) {
    return currentUserId == customerId ? providerAvatar : customerAvatar;
  }
}

// Quick Reply Templates
class QuickReply {
  final String id;
  final String text;
  final IconData icon;

  QuickReply({
    required this.id,
    required this.text,
    required this.icon,
  });

  static List<QuickReply> customerReplies = [
    QuickReply(
      id: '1',
      text: 'What time are you available?',
      icon: Icons.access_time,
    ),
    QuickReply(
      id: '2',
      text: 'Can I reschedule?',
      icon: Icons.event,
    ),
    QuickReply(
      id: '3',
      text: 'Do you have home service?',
      icon: Icons.home,
    ),
    QuickReply(
      id: '4',
      text: 'What are your prices?',
      icon: Icons.attach_money,
    ),
  ];

  static List<QuickReply> providerReplies = [
    QuickReply(
      id: '1',
      text: 'I can confirm your booking',
      icon: Icons.check_circle,
    ),
    QuickReply(
      id: '2',
      text: 'Please share your location',
      icon: Icons.location_on,
    ),
    QuickReply(
      id: '3',
      text: 'We are open from 10 AM to 8 PM',
      icon: Icons.schedule,
    ),
    QuickReply(
      id: '4',
      text: 'Thank you for booking!',
      icon: Icons.thumb_up,
    ),
  ];
}

// Typing Indicator Model
class TypingIndicator {
  final String userId;
  final String userName;
  final bool isTyping;

  TypingIndicator({
    required this.userId,
    required this.userName,
    required this.isTyping,
  });
}
