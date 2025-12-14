# 📚 Glamora SaaS - Developer Quick Reference

## 🎯 Key Files & Their Purpose

### **Core Services**
```
lib/services/
├── api_service.dart          # All backend API calls
├── auth_service.dart         # Authentication & user management
├── subscription_service.dart # Subscription & commission logic
└── database_helper.dart      # DEPRECATED - Use repositories instead
```

### **Data Repositories**
```
lib/repositories/
└── data_repositories.dart
    ├── BookingRepository     # Booking operations
    ├── ProviderRepository    # Service provider operations
    ├── ReviewRepository      # Reviews & ratings
    ├── PaymentRepository     # Payments & wallet
    └── ChatRepository        # Messaging
```

### **Configuration**
```
lib/config/
└── app_config.dart           # Environment settings, feature flags
```

---

## 🚀 Common Usage Examples

### **1. User Authentication**

```dart
import 'package:glamora/services/auth_service.dart';

final authService = AuthService.instance;

// Sign in with Google
try {
  final result = await authService.signInWithGoogle();
  
  if (result['needsRoleSelection']) {
    // Show role selection screen
    Navigator.push(...);
  } else {
    // Navigate to home
    final user = result['user'];
    print('Welcome ${user['name']}!');
  }
} catch (e) {
  print('Sign in failed: $e');
}

// Complete registration with role
await authService.completeRegistration(
  email: user.email!,
  firebaseUid: user.uid,
  name: user.displayName!,
  role: 'customer', // or 'provider'
);

// Check current role
final role = await authService.getCurrentUserRole();
if (role == 'provider') {
  // Show provider dashboard
}

// Sign out
await authService.signOut();
```

### **2. Fetch Service Providers**

```dart
import 'package:glamora/repositories/data_repositories.dart';

final providerRepo = ProviderRepository.instance;

// Get all providers
final providers = await providerRepo.getProviders();

// Get providers by category
final hairSalons = await providerRepo.getProviders(
  category: 'Hair Salon',
);

// Get nearby providers
final nearbyProviders = await providerRepo.getProviders(
  lat: 31.5204,
  lng: 74.3587,
  radius: 10.0, // 10 km
);

// Get provider details
final provider = await providerRepo.getProvider('provider_id_123');
print('Provider: ${provider['businessName']}');
```

### **3. Create a Booking**

```dart
import 'package:glamora/repositories/data_repositories.dart';

final bookingRepo = BookingRepository.instance;

try {
  final booking = await bookingRepo.createBooking(
    providerId: 'provider_123',
    providerName: 'Glam Studio',
    serviceType: 'in_salon',
    services: [
      {'name': 'Hair Cut', 'price': 500},
      {'name': 'Beard Trim', 'price': 200},
    ],
    selectedDate: DateTime.now().add(Duration(days: 1)),
    selectedTime: '14:00',
    contactNumber: '+923001234567',
    totalAmount: 700,
    paymentMethod: 'COD',
    address: '123 Main Street, Lahore',
  );
  
  print('Booking created: ${booking['id']}');
} catch (e) {
  print('Booking failed: $e');
}

// Get user's bookings
final myBookings = await bookingRepo.getBookings();

// Get upcoming bookings
final upcoming = await bookingRepo.getUpcomingBookings();

// Cancel booking
await bookingRepo.cancelBooking(
  'booking_123',
  reason: 'Change of plans',
);
```

### **4. Submit a Review**

```dart
import 'package:glamora/repositories/data_repositories.dart';

final reviewRepo = ReviewRepository.instance;

// Create review
await reviewRepo.createReview(
  bookingId: 'booking_123',
  providerId: 'provider_123',
  providerName: 'Glam Studio',
  rating: 4.5,
  comment: 'Great service! Very professional.',
  servicesTaken: ['Hair Cut', 'Beard Trim'],
  photoUrls: ['photo1_url', 'photo2_url'],
);

// Get provider reviews
final reviews = await reviewRepo.getProviderReviews('provider_123');

// Get average rating
final avgRating = await reviewRepo.getProviderRating('provider_123');
print('Average rating: $avgRating stars');
```

### **5. Wallet & Payments**

```dart
import 'package:glamora/repositories/data_repositories.dart';

final paymentRepo = PaymentRepository.instance;

// Get wallet balance
final balance = await paymentRepo.getWalletBalance();
print('Wallet balance: ₨$balance');

// Add money to wallet
await paymentRepo.addToWallet(
  amount: 1000,
  method: 'JazzCash',
);

// Get transaction history
final transactions = await paymentRepo.getWalletTransactions();

// Create payment for booking
await paymentRepo.createPayment(
  bookingId: 'booking_123',
  amount: 700,
  method: 'Wallet',
);
```

### **6. Chat/Messaging**

```dart
import 'package:glamora/repositories/data_repositories.dart';

final chatRepo = ChatRepository.instance;

// Get all conversations
final conversations = await chatRepo.getConversations();

// Get messages for conversation
final messages = await chatRepo.getMessages('conversation_123');

// Send message
await chatRepo.sendMessage(
  conversationId: 'conversation_123',
  message: 'Hello! I have a question about your services.',
  messageType: 'text',
);

// Mark as read
await chatRepo.markMessagesAsRead('conversation_123');
```

### **7. Subscription Management (for Providers)**

```dart
import 'package:glamora/services/subscription_service.dart';

final subService = SubscriptionService.instance;

// Get available plans
final plans = subService.getAvailablePlans();
print('Plans: ${plans.keys}'); // [free, basic, premium]

// Get current subscription
final currentSub = await subService.getCurrentSubscription();
print('Current plan: ${currentSub?['plan']}');

// Check booking limit
final canBook = await subService.canCreateBooking();
if (!canBook) {
  // Show upgrade prompt
  print('Booking limit reached. Please upgrade.');
}

// Upgrade subscription
await subService.upgradeSubscription(
  planId: 'premium',
  paymentMethod: 'Card',
);

// Calculate commission
final commission = subService.calculateCommission(1000);
print('Platform commission: ₨$commission');

// Get earnings breakdown
final breakdown = subService.getCommissionBreakdown(1000);
print('Provider earns: ₨${breakdown['providerEarnings']}');
```

---

## ⚙️ Configuration

### **Change Backend URL**

Edit `lib/config/app_config.dart`:

```dart
static String get apiBaseUrl {
  switch (environment) {
    case 'production':
      return 'https://api.glamora.pk/api'; // 👈 Your production URL
    case 'development':
    default:
      return 'http://10.0.2.2:3000/api'; // Local development
  }
}
```

### **Feature Flags**

```dart
// Enable/disable SaaS features
static bool get useSaaSBackend => true;

// Fallback to SQLite if API fails (development only)
static bool get useLocalFallback => isDevelopment;

// Enable multi-tenant mode
static bool get isMultiTenant => useSaaSBackend;
```

### **Subscription Plans**

Modify plans in `app_config.dart`:

```dart
static const Map<String, Map<String, dynamic>> subscriptionPlans = {
  'free': {
    'name': 'Free',
    'price': 0,
    'maxBookingsPerMonth': 5, // 👈 Change limits
  },
  // ... other plans
};
```

### **Commission Settings**

```dart
/// Commission percentage for each booking
static const double platformCommissionPercent = 15.0; // 👈 Change %

/// Minimum commission amount
static const double minCommissionAmount = 50.0;
```

---

## 🧪 Testing

### **Test Authentication**
```dart
// In your test
final authService = AuthService.instance;
final result = await authService.signInWithGoogle(selectedRole: 'customer');
assert(result['success'] == true);
```

### **Test API Endpoints**
```bash
# Test backend is running
curl http://localhost:3000/api/health

# Test authentication
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### **Run Flutter Tests**
```bash
flutter test
```

---

## 🔥 Build Commands

### **Development**
```bash
# Run on Chrome (web)
flutter run -d chrome

# Run on Android emulator
flutter run

# Run with custom backend
flutter run --dart-define=API_URL=http://192.168.1.100:3000/api
```

### **Production**
```bash
# Build Android APK
flutter build apk --release --dart-define=ENV=production

# Build for Play Store (App Bundle)
flutter build appbundle --release --dart-define=ENV=production

# Build Web
flutter build web --release --dart-define=ENV=production

# Build iOS (macOS only)
flutter build ios --release --dart-define=ENV=production
```

---

## 🐛 Common Issues & Solutions

### **Issue**: "Connection refused" when testing on device
**Solution**: Use your local IP instead of localhost
```dart
// In app_config.dart (development)
return 'http://192.168.1.100:3000/api'; // Replace with your IP
```

### **Issue**: "Invalid token" errors
**Solution**: Clear app data and re-login
```bash
flutter clean
flutter pub get
flutter run
```

### **Issue**: API calls not working in production
**Solution**: Check CORS settings in backend
```javascript
// backend/server.js
app.use(cors({
  origin: ['https://your-app.com', 'http://localhost:3000'],
}));
```

### **Issue**: "Module not found" errors
**Solution**: Ensure all imports use correct paths
```dart
// ✅ Correct
import 'package:glamora/services/api_service.dart';

// ❌ Wrong
import '../services/api_service.dart';
```

---

## 📊 Architecture Overview

```
┌─────────────────────────────────────────┐
│         Flutter App (Frontend)          │
│  ┌───────────────────────────────────┐  │
│  │    UI Screens & Widgets           │  │
│  └────────────┬──────────────────────┘  │
│               │                          │
│  ┌────────────▼──────────────────────┐  │
│  │    Repositories Layer             │  │
│  │  (BookingRepo, ProviderRepo, etc) │  │
│  └────────────┬──────────────────────┘  │
│               │                          │
│  ┌────────────▼──────────────────────┐  │
│  │    Services Layer                 │  │
│  │  (ApiService, AuthService)        │  │
│  └────────────┬──────────────────────┘  │
└───────────────┼──────────────────────────┘
                │ HTTP/HTTPS
                │
┌───────────────▼──────────────────────────┐
│      Node.js Backend (API Server)        │
│  ┌───────────────────────────────────┐  │
│  │  Express.js Routes & Controllers  │  │
│  └────────────┬──────────────────────┘  │
│               │                          │
│  ┌────────────▼──────────────────────┐  │
│  │     MySQL Database               │  │
│  │  (Users, Bookings, Providers...)  │  │
│  └───────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

---

## 🎓 Next Steps

1. **Setup Backend**: Follow [SAAS_DEPLOYMENT_GUIDE.md](SAAS_DEPLOYMENT_GUIDE.md)
2. **Test Locally**: Run backend + Flutter app together
3. **Deploy Backend**: Choose Heroku/DigitalOcean/AWS
4. **Update Config**: Set production URL in `app_config.dart`
5. **Build & Release**: Generate APK/AAB and upload to Play Store

---

**Happy coding! 🚀**
