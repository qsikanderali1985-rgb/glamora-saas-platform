import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// API Service for Backend Communication
/// Handles all HTTP requests to Node.js backend
class ApiService {
  // Backend URL - Change this to your deployed backend URL
  static String get baseUrl => AppConfig.apiBaseUrl;
  
  // Singleton pattern
  static final ApiService instance = ApiService._init();
  ApiService._init();

  String? _authToken;
  
  // ==================== TOKEN MANAGEMENT ====================
  
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    return _authToken;
  }
  
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ==================== HTTP HELPERS ====================
  
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  // ==================== AUTHENTICATION ====================
  
  /// Register new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role, // 'customer', 'provider', 'admin'
    Map<String, dynamic>? additionalData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        ...?additionalData,
      }),
    );
    
    final data = await _handleResponse(response);
    if (data['token'] != null) {
      await setAuthToken(data['token']);
    }
    return data;
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    final data = await _handleResponse(response);
    if (data['token'] != null) {
      await setAuthToken(data['token']);
    }
    return data;
  }

  /// Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );
    return await _handleResponse(response);
  }

  // ==================== SERVICE PROVIDERS ====================
  
  /// Get all service providers with optional filters
  Future<List<dynamic>> getProviders({
    String? category,
    String? city,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (city != null) queryParams['city'] = city;
    if (lat != null) queryParams['lat'] = lat.toString();
    if (lng != null) queryParams['lng'] = lng.toString();
    if (radius != null) queryParams['radius'] = radius.toString();
    
    final uri = Uri.parse('$baseUrl/providers').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _getHeaders());
    final data = await _handleResponse(response);
    return data['providers'] ?? [];
  }

  /// Get provider details by ID
  Future<Map<String, dynamic>> getProvider(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers/$id'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  /// Register as service provider
  Future<Map<String, dynamic>> registerProvider(Map<String, dynamic> providerData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/providers'),
      headers: _getHeaders(),
      body: jsonEncode(providerData),
    );
    return await _handleResponse(response);
  }

  /// Update provider information
  Future<Map<String, dynamic>> updateProvider(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/providers/$id'),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );
    return await _handleResponse(response);
  }

  // ==================== BOOKINGS ====================
  
  /// Create new booking
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: _getHeaders(),
      body: jsonEncode(bookingData),
    );
    return await _handleResponse(response);
  }

  /// Get user's bookings
  Future<List<dynamic>> getBookings({String? status}) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    
    final uri = Uri.parse('$baseUrl/bookings').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _getHeaders());
    final data = await _handleResponse(response);
    return data['bookings'] ?? [];
  }

  /// Get booking by ID
  Future<Map<String, dynamic>> getBooking(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  /// Update booking status
  Future<Map<String, dynamic>> updateBookingStatus(String id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/bookings/$id/status'),
      headers: _getHeaders(),
      body: jsonEncode({'status': status}),
    );
    return await _handleResponse(response);
  }

  /// Cancel booking
  Future<Map<String, dynamic>> cancelBooking(String id, {String? reason}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings/$id/cancel'),
      headers: _getHeaders(),
      body: jsonEncode({'reason': reason}),
    );
    return await _handleResponse(response);
  }

  // ==================== REVIEWS ====================
  
  /// Create review for booking
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> reviewData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: _getHeaders(),
      body: jsonEncode(reviewData),
    );
    return await _handleResponse(response);
  }

  /// Get reviews for provider
  Future<List<dynamic>> getProviderReviews(String providerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers/$providerId/reviews'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return data['reviews'] ?? [];
  }

  /// Mark review as helpful
  Future<Map<String, dynamic>> markReviewHelpful(String reviewId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/$reviewId/helpful'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  // ==================== PAYMENTS ====================
  
  /// Create payment
  Future<Map<String, dynamic>> createPayment({
    required String bookingId,
    required double amount,
    required String method,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: _getHeaders(),
      body: jsonEncode({
        'bookingId': bookingId,
        'amount': amount,
        'method': method,
      }),
    );
    return await _handleResponse(response);
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$paymentId'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  /// Get wallet balance
  Future<double> getWalletBalance() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/balance'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return (data['balance'] ?? 0.0).toDouble();
  }

  /// Add money to wallet
  Future<Map<String, dynamic>> addToWallet({
    required double amount,
    required String method,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wallet/add'),
      headers: _getHeaders(),
      body: jsonEncode({
        'amount': amount,
        'method': method,
      }),
    );
    return await _handleResponse(response);
  }

  /// Get wallet transactions
  Future<List<dynamic>> getWalletTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/transactions'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return data['transactions'] ?? [];
  }

  // ==================== CHAT ====================
  
  /// Get all conversations
  Future<List<dynamic>> getConversations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat/conversations'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return data['conversations'] ?? [];
  }

  /// Get conversation messages
  Future<List<dynamic>> getMessages(String conversationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/messages'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return data['messages'] ?? [];
  }

  /// Send message
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
    String messageType = 'text',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/messages'),
      headers: _getHeaders(),
      body: jsonEncode({
        'conversationId': conversationId,
        'message': message,
        'messageType': messageType,
      }),
    );
    return await _handleResponse(response);
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    await http.post(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/read'),
      headers: _getHeaders(),
    );
  }

  // ==================== ANALYTICS (for providers) ====================
  
  /// Get provider analytics
  Future<Map<String, dynamic>> getProviderAnalytics({
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;
    
    final uri = Uri.parse('$baseUrl/analytics/provider').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _getHeaders());
    return await _handleResponse(response);
  }

  /// Get admin dashboard stats
  Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analytics/admin'),
      headers: _getHeaders(),
    );
    return await _handleResponse(response);
  }

  // ==================== NOTIFICATIONS ====================
  
  /// Get notifications
  Future<List<dynamic>> getNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: _getHeaders(),
    );
    final data = await _handleResponse(response);
    return data['notifications'] ?? [];
  }

  /// Mark notification as read
  Future<void> markNotificationRead(String notificationId) async {
    await http.patch(
      Uri.parse('$baseUrl/notifications/$notificationId/read'),
      headers: _getHeaders(),
    );
  }

  /// Register device for push notifications
  Future<void> registerDeviceToken(String deviceToken) async {
    await http.post(
      Uri.parse('$baseUrl/notifications/device'),
      headers: _getHeaders(),
      body: jsonEncode({'deviceToken': deviceToken}),
    );
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
