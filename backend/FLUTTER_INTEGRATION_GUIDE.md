# Flutter App Integration with Backend

## 🔌 **CONNECTING FLUTTER TO BACKEND**

Once the buyer deploys the backend, they just need to update the Flutter app configuration.

---

## 📝 **STEP 1: Update API Configuration**

### **File:** `lib/config/app_config.dart`

**Current (Mock Data):**
```dart
class AppConfig {
  static const bool USE_MOCK_DATA = true;
  static const String API_BASE_URL = 'http://localhost:3000';
}
```

**After Backend Deployment:**
```dart
class AppConfig {
  static const bool USE_MOCK_DATA = false; // Change to false
  static const String API_BASE_URL = 'https://your-backend.onrender.com'; // Buyer's backend URL
}
```

---

## 🔐 **STEP 2: Update Authentication Service**

### **File:** `lib/services/auth_service.dart`

**Add this method to send Firebase token to backend:**

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

class AuthService {

  Future<Map<String, dynamic>> loginWithBackend(String firebaseToken, String role) async {
    final response = await http.post(
      Uri.parse('${AppConfig.API_BASE_URL}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firebaseToken': firebaseToken,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Save JWT token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', data['token']);
      return data;
    } else {
      throw Exception('Login failed');
    }
  }
}
```

---

## 📊 **STEP 3: Update Data Repository**

### **File:** `lib/repositories/data_repositories.dart`

**Add HTTP methods for API calls:**

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class DataRepository {
  // Get JWT token from storage
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Fetch providers from backend
  Future<List<dynamic>> fetchProviders({String? city, String? type}) async {
    if (AppConfig.USE_MOCK_DATA) {
      // Return mock data (existing code)
      return mockProviders;
    }

    final headers = await _getHeaders();
    final queryParams = <String, String>{};
    if (city != null) queryParams['city'] = city;
    if (type != null) queryParams['type'] = type;

    final uri = Uri.parse('${AppConfig.API_BASE_URL}/api/providers')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['providers'];
    } else {
      throw Exception('Failed to load providers');
    }
  }

  // Create booking
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    if (AppConfig.USE_MOCK_DATA) {
      // Mock success
      return {'success': true, 'bookingNumber': 'BK${DateTime.now().millisecondsSinceEpoch}'};
    }

    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${AppConfig.API_BASE_URL}/api/bookings'),
      headers: headers,
      body: json.encode(bookingData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create booking');
    }
  }

  // Get user bookings
  Future<List<dynamic>> fetchUserBookings(String userId) async {
    if (AppConfig.USE_MOCK_DATA) {
      return mockBookings;
    }

    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${AppConfig.API_BASE_URL}/api/bookings?userId=$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['bookings'];
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Get admin stats
  Future<Map<String, dynamic>> fetchAdminStats() async {
    if (AppConfig.USE_MOCK_DATA) {
      return {
        'totalUsers': 1247,
        'totalProviders': 89,
        'activeBookings': 156,
        'totalBookings': 2341,
      };
    }

    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${AppConfig.API_BASE_URL}/api/admin/stats'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }
}
```

---

## 📦 **STEP 4: Add HTTP Package**

### **File:** `pubspec.yaml`

**Add this dependency:**
```yaml
dependencies:
  # ... existing dependencies ...
  http: ^1.1.0
```

**Run:**
```bash
flutter pub get
```

---

## 🎯 **STEP 5: Update Login Flow**

### **File:** `lib/login_screen.dart`

**Modify the Google Sign-In handler:**

```dart
Future<void> _handleGoogleSignIn(BuildContext context) async {
  setState(() => _isLoading = true);

  try {
    // Sign in with Google (existing code)
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // NEW: Send token to backend
    final firebaseToken = await userCredential.user?.getIdToken();
    if (firebaseToken != null) {
      final authService = AuthService();
      final backendResponse = await authService.loginWithBackend(
        firebaseToken,
        widget.selectedRole.toString().split('.').last, // customer/provider/admin
      );

      // Backend login successful - save user data
      print('Backend login successful: ${backendResponse['user']}');
    }

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', userCredential.user?.email ?? '');
    await prefs.setString('userName', userCredential.user?.displayName ?? '');
    await prefs.setString('userRole', widget.selectedRole.toString().split('.').last);

    // Navigate to appropriate screen
    if (widget.selectedRole == UserRole.admin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GlamoraHomeShell(userRole: widget.selectedRole),
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## 🧪 **TESTING THE INTEGRATION**

### **Test Mode (Before Backend Deployment):**
```dart
// lib/config/app_config.dart
static const bool USE_MOCK_DATA = true; // Uses local mock data
```

### **Production Mode (After Backend Deployment):**
```dart
// lib/config/app_config.dart
static const bool USE_MOCK_DATA = false; // Uses real backend API
static const String API_BASE_URL = 'https://glamora-backend.onrender.com';
```

---

## ✅ **VERIFICATION CHECKLIST**

After buyer deploys backend:

1. ✅ **Test Health Endpoint**
   - Visit: `https://your-backend.onrender.com/health`
   - Should return: `{"status":"healthy",...}`

2. ✅ **Update Flutter Config**
   - Change `USE_MOCK_DATA = false`
   - Set `API_BASE_URL` to backend URL

3. ✅ **Test Login**
   - Sign in with Google
   - Check console for "Backend login successful"

4. ✅ **Test Provider List**
   - Open app
   - Verify providers load from backend

5. ✅ **Test Booking Creation**
   - Create a test booking
   - Verify it's saved in database

6. ✅ **Test Admin Dashboard**
   - Login as admin
   - Check stats are loading

---

## 🔄 **GRADUAL MIGRATION STRATEGY**

**Option 1: Immediate Switch**
- Set `USE_MOCK_DATA = false`
- All features use backend immediately

**Option 2: Feature-by-Feature**
```dart
class AppConfig {
  static const bool USE_MOCK_PROVIDERS = false; // Use backend
  static const bool USE_MOCK_BOOKINGS = true;  // Still use mock
  static const bool USE_MOCK_USERS = true;     // Still use mock
}
```

This allows testing one feature at a time.

---

## 🚨 **ERROR HANDLING**

**Add this to all API calls:**

```dart
try {
  final response = await http.get(uri, headers: headers);
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401) {
    // Token expired - redirect to login
    throw Exception('Session expired. Please login again.');
  } else if (response.statusCode == 404) {
    throw Exception('Resource not found');
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
} catch (e) {
  // Handle network errors
  if (e is SocketException) {
    throw Exception('No internet connection');
  }
  rethrow;
}
```

---

## 📱 **BUYER'S INTEGRATION STEPS**

**Time Required: 10 minutes**

1. ✅ Deploy backend (15 min) ← Already covered in backend README
2. ✅ Update `app_config.dart` (1 min)
3. ✅ Run `flutter pub get` (1 min)
4. ✅ Test on Chrome (2 min)
5. ✅ Verify all features (5 min)
6. ✅ **DONE!** 🎉

---

## 🎁 **BONUS: Loading States**

**Add this to show loading:**

```dart
class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  bool _isLoading = true;
  List<dynamic> _providers = [];

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    try {
      final repo = DataRepository();
      final providers = await repo.fetchProviders();
      setState(() {
        _providers = providers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load providers: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        // Build provider cards
      },
    );
  }
}
```

---

## 🏆 **RESULT**

After integration:
- ✅ **Real-time data** from backend
- ✅ **Live bookings** saved to database
- ✅ **Admin dashboard** shows real stats
- ✅ **User authentication** via Firebase + JWT
- ✅ **Production-ready** scalable system

**The app is now a complete, functional, revenue-generating platform!** 🚀

---

*This integration takes the buyer just 10 minutes and transforms the app from demo to production!*
