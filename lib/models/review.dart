// Review Model
class Review {
  final String id;
  final String bookingId;
  final String customerId;
  final String customerName;
  final String customerPhotoUrl;
  final String providerId;
  final String providerName;
  final double rating; // 1.0 to 5.0
  final String comment;
  final List<String> photoUrls; // Before/after photos
  final DateTime createdAt;
  final int helpfulCount;
  final List<String> helpfulVotes; // User IDs who found it helpful
  final String? providerResponse;
  final DateTime? responseDate;
  final List<String> servicesTaken; // Services reviewed

  Review({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    required this.customerPhotoUrl,
    required this.providerId,
    required this.providerName,
    required this.rating,
    required this.comment,
    required this.photoUrls,
    required this.createdAt,
    this.helpfulCount = 0,
    this.helpfulVotes = const [],
    this.providerResponse,
    this.responseDate,
    this.servicesTaken = const [],
  });

  // Calculate time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhotoUrl': customerPhotoUrl,
      'providerId': providerId,
      'providerName': providerName,
      'rating': rating,
      'comment': comment,
      'photoUrls': photoUrls,
      'createdAt': createdAt.toIso8601String(),
      'helpfulCount': helpfulCount,
      'helpfulVotes': helpfulVotes,
      'providerResponse': providerResponse,
      'responseDate': responseDate?.toIso8601String(),
      'servicesTaken': servicesTaken,
    };
  }
}

// Rating Statistics
class RatingStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingBreakdown; // {5: 120, 4: 45, 3: 10, 2: 5, 1: 2}

  RatingStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingBreakdown,
  });

  // Get percentage for each star rating
  double getPercentage(int stars) {
    if (totalReviews == 0) return 0;
    return ((ratingBreakdown[stars] ?? 0) / totalReviews) * 100;
  }

  // Get count for specific star rating
  int getCount(int stars) {
    return ratingBreakdown[stars] ?? 0;
  }
}
