import '../config/app_config.dart';
import 'auth_service.dart';

/// Subscription Service - Manages provider subscription plans
class SubscriptionService {
  static final SubscriptionService instance = SubscriptionService._init();
  SubscriptionService._init();

  // Note: API integration will be added when backend subscription endpoints are ready

  // ==================== SUBSCRIPTION MANAGEMENT ====================

  /// Get available subscription plans
  Map<String, Map<String, dynamic>> getAvailablePlans() {
    return AppConfig.subscriptionPlans;
  }

  /// Get current subscription for provider
  Future<Map<String, dynamic>?> getCurrentSubscription() async {
    try {
      final userData = await AuthService.instance.getCachedUserData();
      if (userData == null || userData['role'] != 'provider') {
        return null;
      }

      // This would call your backend API
      // For now, return free plan as default
      return {
        'plan': 'free',
        'startDate': DateTime.now().toIso8601String(),
        'endDate': null, // No expiry for free plan
        'status': 'active',
        'bookingsThisMonth': 0,
        'maxBookings': AppConfig.subscriptionPlans['free']!['maxBookingsPerMonth'],
      };
    } catch (e) {
      return null;
    }
  }

  /// Upgrade subscription plan
  Future<Map<String, dynamic>> upgradeSubscription({
    required String planId,
    required String paymentMethod,
  }) async {
    try {
      // This would integrate with your payment gateway
      final planDetails = AppConfig.subscriptionPlans[planId];
      if (planDetails == null) {
        throw Exception('Invalid plan selected');
      }

      // Call backend API to process subscription
      // For now, return mock success response
      return {
        'success': true,
        'plan': planId,
        'message': 'Subscription upgraded successfully',
        'nextBillingDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to upgrade subscription: $e');
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription({String? reason}) async {
    try {
      // Call backend API to cancel subscription
      // This would downgrade to free plan
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  /// Check if feature is available in current plan
  Future<bool> isFeatureAvailable(String featureName) async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) return false;

      final planId = subscription['plan'] as String;
      final planDetails = AppConfig.subscriptionPlans[planId];
      
      if (planDetails == null) return false;

      final features = planDetails['features'] as List<dynamic>;
      return features.any((f) => f.toString().toLowerCase().contains(featureName.toLowerCase()));
    } catch (e) {
      return false;
    }
  }

  /// Check if booking limit reached
  Future<bool> canCreateBooking() async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) return false;

      final maxBookings = subscription['maxBookings'] as int;
      if (maxBookings == -1) return true; // Unlimited

      final currentBookings = subscription['bookingsThisMonth'] as int;
      return currentBookings < maxBookings;
    } catch (e) {
      return false;
    }
  }

  /// Get subscription status message
  Future<String> getSubscriptionStatusMessage() async {
    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) {
        return 'No active subscription';
      }

      final status = subscription['status'] as String;
      
      if (status != 'active') {
        return 'Subscription expired. Please renew.';
      }

      final maxBookings = subscription['maxBookings'] as int;
      final currentBookings = subscription['bookingsThisMonth'] as int;

      if (maxBookings == -1) {
        return 'Premium Plan - Unlimited bookings';
      }

      final remaining = maxBookings - currentBookings;
      if (remaining <= 0) {
        return 'Booking limit reached. Upgrade to continue.';
      }

      return '$remaining bookings remaining this month';
    } catch (e) {
      return 'Unable to fetch subscription status';
    }
  }

  // ==================== PLAN COMPARISON ====================

  /// Get plan comparison data for UI
  List<Map<String, dynamic>> getPlanComparison() {
    final plans = AppConfig.subscriptionPlans;
    
    return [
      {
        'planId': 'free',
        'name': plans['free']!['name'],
        'price': plans['free']!['price'],
        'priceText': 'Free',
        'features': plans['free']!['features'],
        'maxBookings': plans['free']!['maxBookingsPerMonth'],
        'recommended': false,
      },
      {
        'planId': 'basic',
        'name': plans['basic']!['name'],
        'price': plans['basic']!['price'],
        'priceText': '₨${plans['basic']!['price']}/month',
        'features': plans['basic']!['features'],
        'maxBookings': plans['basic']!['maxBookingsPerMonth'],
        'recommended': true,
      },
      {
        'planId': 'premium',
        'name': plans['premium']!['name'],
        'price': plans['premium']!['price'],
        'priceText': '₨${plans['premium']!['price']}/month',
        'features': plans['premium']!['features'],
        'maxBookings': -1, // Unlimited
        'recommended': false,
      },
    ];
  }

  // ==================== COMMISSION CALCULATION ====================

  /// Calculate platform commission for booking
  double calculateCommission(double bookingAmount) {
    final commissionPercent = AppConfig.platformCommissionPercent;
    final commission = (bookingAmount * commissionPercent) / 100;
    
    // Apply minimum commission
    if (commission < AppConfig.minCommissionAmount) {
      return AppConfig.minCommissionAmount;
    }
    
    return commission;
  }

  /// Calculate provider earnings (after commission)
  double calculateProviderEarnings(double bookingAmount) {
    final commission = calculateCommission(bookingAmount);
    return bookingAmount - commission;
  }

  /// Get commission breakdown
  Map<String, double> getCommissionBreakdown(double bookingAmount) {
    final commission = calculateCommission(bookingAmount);
    final providerEarnings = bookingAmount - commission;

    return {
      'totalAmount': bookingAmount,
      'platformCommission': commission,
      'providerEarnings': providerEarnings,
      'commissionPercent': AppConfig.platformCommissionPercent,
    };
  }
}
