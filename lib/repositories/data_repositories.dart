import '../services/api_service.dart';

/// Booking Repository - Manages booking data from backend API
class BookingRepository {
  static final BookingRepository instance = BookingRepository._init();
  BookingRepository._init();

  final ApiService _api = ApiService.instance;

  /// Create a new booking
  Future<Map<String, dynamic>> createBooking({
    required String providerId,
    required String providerName,
    required String serviceType,
    required List<Map<String, dynamic>> services,
    required DateTime selectedDate,
    required String selectedTime,
    required String contactNumber,
    required double totalAmount,
    required String paymentMethod,
    String? staffName,
    String? address,
    String? specialInstructions,
  }) async {
    try {
      final response = await _api.createBooking({
        'providerId': providerId,
        'providerName': providerName,
        'serviceType': serviceType,
        'services': services,
        'selectedDate': selectedDate.toIso8601String(),
        'selectedTime': selectedTime,
        'contactNumber': contactNumber,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        if (staffName != null) 'staffName': staffName,
        if (address != null) 'address': address,
        if (specialInstructions != null) 'specialInstructions': specialInstructions,
      });

      return response['booking'];
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get all bookings for current user
  Future<List<Map<String, dynamic>>> getBookings({String? status}) async {
    try {
      final bookings = await _api.getBookings(status: status);
      return bookings.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }

  /// Get booking by ID
  Future<Map<String, dynamic>> getBooking(String id) async {
    try {
      return await _api.getBooking(id);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String id, String status) async {
    try {
      await _api.updateBookingStatus(id, status);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String id, {String? reason}) async {
    try {
      await _api.cancelBooking(id, reason: reason);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Get bookings by status
  Future<List<Map<String, dynamic>>> getBookingsByStatus(String status) async {
    return await getBookings(status: status);
  }

  /// Get upcoming bookings
  Future<List<Map<String, dynamic>>> getUpcomingBookings() async {
    return await getBookings(status: 'confirmed');
  }

  /// Get past bookings
  Future<List<Map<String, dynamic>>> getPastBookings() async {
    return await getBookings(status: 'completed');
  }
}

/// Provider Repository - Manages service provider data
class ProviderRepository {
  static final ProviderRepository instance = ProviderRepository._init();
  ProviderRepository._init();

  final ApiService _api = ApiService.instance;

  /// Get all providers with filters
  Future<List<Map<String, dynamic>>> getProviders({
    String? category,
    String? city,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    try {
      final providers = await _api.getProviders(
        category: category,
        city: city,
        lat: lat,
        lng: lng,
        radius: radius,
      );
      return providers.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get providers: $e');
    }
  }

  /// Get provider by ID
  Future<Map<String, dynamic>> getProvider(String id) async {
    try {
      return await _api.getProvider(id);
    } catch (e) {
      throw Exception('Failed to get provider: $e');
    }
  }

  /// Register as service provider
  Future<Map<String, dynamic>> registerProvider({
    required String businessName,
    required String businessType,
    required String category,
    required String address,
    required String city,
    required String phoneNumber,
    required Map<String, dynamic> location,
    List<Map<String, dynamic>>? services,
    List<Map<String, dynamic>>? staff,
    Map<String, dynamic>? workingHours,
    String? description,
  }) async {
    try {
      final response = await _api.registerProvider({
        'businessName': businessName,
        'businessType': businessType,
        'category': category,
        'address': address,
        'city': city,
        'phoneNumber': phoneNumber,
        'location': location,
        if (services != null) 'services': services,
        if (staff != null) 'staff': staff,
        if (workingHours != null) 'workingHours': workingHours,
        if (description != null) 'description': description,
      });

      return response['provider'];
    } catch (e) {
      throw Exception('Failed to register provider: $e');
    }
  }

  /// Update provider information
  Future<Map<String, dynamic>> updateProvider(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _api.updateProvider(id, updates);
      return response['provider'];
    } catch (e) {
      throw Exception('Failed to update provider: $e');
    }
  }

  /// Search providers by name or category
  Future<List<Map<String, dynamic>>> searchProviders(String query) async {
    // This would need a search endpoint in the backend
    // For now, get all and filter client-side
    final providers = await getProviders();
    return providers.where((p) {
      final name = (p['businessName'] ?? '').toString().toLowerCase();
      final category = (p['category'] ?? '').toString().toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || category.contains(q);
    }).toList();
  }
}

/// Review Repository - Manages reviews and ratings
class ReviewRepository {
  static final ReviewRepository instance = ReviewRepository._init();
  ReviewRepository._init();

  final ApiService _api = ApiService.instance;

  /// Create a review
  Future<Map<String, dynamic>> createReview({
    required String bookingId,
    required String providerId,
    required String providerName,
    required double rating,
    required String comment,
    required List<String> servicesTaken,
    List<String>? photoUrls,
  }) async {
    try {
      final response = await _api.createReview({
        'bookingId': bookingId,
        'providerId': providerId,
        'providerName': providerName,
        'rating': rating,
        'comment': comment,
        'servicesTaken': servicesTaken,
        if (photoUrls != null) 'photoUrls': photoUrls,
      });

      return response['review'];
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  /// Get reviews for a provider
  Future<List<Map<String, dynamic>>> getProviderReviews(String providerId) async {
    try {
      final reviews = await _api.getProviderReviews(providerId);
      return reviews.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  /// Mark review as helpful
  Future<void> markReviewHelpful(String reviewId) async {
    try {
      await _api.markReviewHelpful(reviewId);
    } catch (e) {
      throw Exception('Failed to mark review as helpful: $e');
    }
  }

  /// Get average rating for provider
  Future<double> getProviderRating(String providerId) async {
    try {
      final reviews = await getProviderReviews(providerId);
      if (reviews.isEmpty) return 0.0;

      final total = reviews.fold<double>(
        0.0,
        (sum, review) => sum + (review['rating'] as num).toDouble(),
      );

      return total / reviews.length;
    } catch (e) {
      return 0.0;
    }
  }
}

/// Payment Repository - Manages payments and wallet
class PaymentRepository {
  static final PaymentRepository instance = PaymentRepository._init();
  PaymentRepository._init();

  final ApiService _api = ApiService.instance;

  /// Create payment for booking
  Future<Map<String, dynamic>> createPayment({
    required String bookingId,
    required double amount,
    required String method,
  }) async {
    try {
      final response = await _api.createPayment(
        bookingId: bookingId,
        amount: amount,
        method: method,
      );
      return response['payment'];
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    try {
      return await _api.getPaymentStatus(paymentId);
    } catch (e) {
      throw Exception('Failed to get payment status: $e');
    }
  }

  /// Get wallet balance
  Future<double> getWalletBalance() async {
    try {
      return await _api.getWalletBalance();
    } catch (e) {
      return 0.0;
    }
  }

  /// Add money to wallet
  Future<Map<String, dynamic>> addToWallet({
    required double amount,
    required String method,
  }) async {
    try {
      final response = await _api.addToWallet(
        amount: amount,
        method: method,
      );
      return response['transaction'];
    } catch (e) {
      throw Exception('Failed to add money to wallet: $e');
    }
  }

  /// Get wallet transactions
  Future<List<Map<String, dynamic>>> getWalletTransactions() async {
    try {
      final transactions = await _api.getWalletTransactions();
      return transactions.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get wallet transactions: $e');
    }
  }
}

/// Chat Repository - Manages chat conversations and messages
class ChatRepository {
  static final ChatRepository instance = ChatRepository._init();
  ChatRepository._init();

  final ApiService _api = ApiService.instance;

  /// Get all conversations
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final conversations = await _api.getConversations();
      return conversations.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  /// Get messages for a conversation
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final messages = await _api.getMessages(conversationId);
      return messages.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  /// Send a message
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
    String messageType = 'text',
  }) async {
    try {
      final response = await _api.sendMessage(
        conversationId: conversationId,
        message: message,
        messageType: messageType,
      );
      return response['message'];
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      await _api.markMessagesAsRead(conversationId);
    } catch (e) {
      // Silently fail
    }
  }
}
