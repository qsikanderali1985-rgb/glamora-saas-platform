/// Application Configuration
/// Manages environment-specific settings
class AppConfig {
  // ==================== ENVIRONMENT ====================
  
  /// Current environment (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Check if running in development mode
  static bool get isDevelopment => environment == 'development';
  
  /// Check if running in production mode
  static bool get isProduction => environment == 'production';

  // ==================== BACKEND API ====================
  
  /// Backend API base URL
  /// 
  /// Development: Use localhost or your local IP
  /// - For Android Emulator: http://10.0.2.2:3000/api
  /// - For iOS Simulator: http://localhost:3000/api
  /// - For Physical Device: http://YOUR_LOCAL_IP:3000/api
  /// 
  /// Production: Use your deployed backend URL
  /// Example: https://api.glamora.com/api
  static String get apiBaseUrl {
    const customUrl = String.fromEnvironment('API_URL');
    if (customUrl.isNotEmpty) return customUrl;

    switch (environment) {
      case 'production':
        return 'https://api.glamora.com/api';
      case 'staging':
        return 'https://staging-api.glamora.com/api';
      case 'development':
      default:
        // Change this to your local backend URL
        return 'http://10.0.2.2:3000/api'; // Android Emulator
        // return 'http://localhost:3000/api'; // iOS Simulator
        // return 'http://192.168.1.100:3000/api'; // Physical Device
    }
  }

  // ==================== APP METADATA ====================
  
  static const String appName = 'Glamora';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.glamora.app';

  // ==================== FEATURES FLAGS ====================
  
  /// Enable/disable SaaS features
  static bool get useSaaSBackend => true;
  
  /// Fallback to local SQLite if API fails
  static bool get useLocalFallback => isDevelopment;
  
  /// Enable debug logging
  static bool get enableLogging => isDevelopment;
  
  /// Enable analytics
  static bool get enableAnalytics => isProduction;

  // ==================== TIMEOUTS ====================
  
  /// API request timeout in seconds
  static const int apiTimeout = 30;
  
  /// Connection timeout in seconds
  static const int connectionTimeout = 10;

  // ==================== CACHE ====================
  
  /// Cache duration for provider data (in minutes)
  static const int providerCacheDuration = 15;
  
  /// Cache duration for user profile (in minutes)
  static const int profileCacheDuration = 60;

  // ==================== PAGINATION ====================
  
  /// Number of items per page
  static const int itemsPerPage = 20;
  
  /// Number of providers to load initially
  static const int initialProvidersCount = 10;

  // ==================== PAYMENT ====================
  
  /// Supported payment methods
  static const List<String> paymentMethods = [
    'COD',
    'JazzCash',
    'EasyPaisa',
    'Card',
    'Wallet',
  ];
  
  /// Minimum wallet balance
  static const double minWalletBalance = 0.0;
  
  /// Maximum wallet balance
  static const double maxWalletBalance = 50000.0;

  // ==================== LOCATION ====================
  
  /// Default search radius in kilometers
  static const double defaultSearchRadius = 10.0;
  
  /// Maximum search radius in kilometers
  static const double maxSearchRadius = 50.0;

  // ==================== BOOKING ====================
  
  /// Minimum booking advance time (in hours)
  static const int minBookingAdvanceHours = 2;
  
  /// Maximum booking days in advance
  static const int maxBookingDaysAdvance = 30;
  
  /// Cancellation policy (hours before booking)
  static const int cancellationPolicyHours = 24;

  // ==================== MULTI-TENANT (SaaS) ====================
  
  /// Enable multi-tenant mode
  static bool get isMultiTenant => useSaaSBackend;
  
  /// Tenant ID (for single-tenant deployments)
  static const String? tenantId = null;
  
  /// Allow salon owners to register
  static const bool allowProviderRegistration = true;
  
  /// Require admin approval for new providers
  static const bool requireProviderApproval = true;

  // ==================== SUBSCRIPTION TIERS ====================
  
  /// Available subscription plans
  static const Map<String, Map<String, dynamic>> subscriptionPlans = {
    'free': {
      'name': 'Free',
      'price': 0,
      'maxBookingsPerMonth': 5,
      'features': ['Basic features', 'Email support'],
    },
    'basic': {
      'name': 'Basic',
      'price': 2999,
      'maxBookingsPerMonth': 50,
      'features': [
        'Unlimited bookings',
        'Priority support',
        'Analytics dashboard',
      ],
    },
    'premium': {
      'name': 'Premium',
      'price': 9999,
      'maxBookingsPerMonth': -1, // Unlimited
      'features': [
        'Everything in Basic',
        'AI Style Finder',
        'Premium placement',
        'Advanced analytics',
        '24/7 phone support',
      ],
    },
  };

  // ==================== PLATFORM COMMISSION ====================
  
  /// Commission percentage for each booking
  static const double platformCommissionPercent = 15.0;
  
  /// Minimum commission amount
  static const double minCommissionAmount = 50.0;

  // ==================== HELPER METHODS ====================
  
  /// Print current configuration (for debugging)
  static void printConfig() {
    if (!enableLogging) return;

    print('=== GLAMORA APP CONFIGURATION ===');
    print('Environment: $environment');
    print('API Base URL: $apiBaseUrl');
    print('SaaS Mode: $useSaaSBackend');
    print('Multi-Tenant: $isMultiTenant');
    print('Local Fallback: $useLocalFallback');
    print('=================================');
  }
}
