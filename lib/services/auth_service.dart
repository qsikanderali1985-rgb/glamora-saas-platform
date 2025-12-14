import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// Authentication Service - Hybrid Firebase + Backend
/// Uses Firebase for Google Sign-In, then syncs with backend
class AuthService {
  static final AuthService instance = AuthService._init();
  AuthService._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiService _api = ApiService.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ==================== SIGN IN WITH GOOGLE ====================
  
  /// Sign in with Google and sync with backend
  Future<Map<String, dynamic>> signInWithGoogle({String? selectedRole}) async {
    try {
      // 1. Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2. Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // 3. Check if user exists in backend, otherwise register
      try {
        // Try to login to backend
        final response = await _api.login(
          email: user.email!,
          password: user.uid, // Use Firebase UID as password
        );
        
        // Save user data locally
        await _saveUserData(response['user']);
        
        return {
          'success': true,
          'user': response['user'],
          'isNewUser': false,
        };
      } catch (e) {
        // User doesn't exist in backend, register them
        if (selectedRole == null) {
          // Need role selection
          return {
            'success': true,
            'needsRoleSelection': true,
            'firebaseUser': user,
          };
        }

        // Register with backend
        final registerResponse = await _api.register(
          email: user.email!,
          password: user.uid,
          name: user.displayName ?? 'User',
          role: selectedRole,
          additionalData: {
            'photoUrl': user.photoURL,
            'phoneNumber': user.phoneNumber,
          },
        );

        await _saveUserData(registerResponse['user']);

        return {
          'success': true,
          'user': registerResponse['user'],
          'isNewUser': true,
        };
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // ==================== COMPLETE REGISTRATION ====================
  
  /// Complete registration with role selection
  Future<Map<String, dynamic>> completeRegistration({
    required String email,
    required String firebaseUid,
    required String name,
    required String role,
    String? photoUrl,
    String? phoneNumber,
    Map<String, dynamic>? providerData,
  }) async {
    try {
      final response = await _api.register(
        email: email,
        password: firebaseUid,
        name: name,
        role: role,
        additionalData: {
          'photoUrl': photoUrl,
          'phoneNumber': phoneNumber,
          if (providerData != null) ...providerData,
        },
      );

      await _saveUserData(response['user']);

      return {
        'success': true,
        'user': response['user'],
      };
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // ==================== USER DATA MANAGEMENT ====================
  
  /// Save user data to local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData['id'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_role', userData['role'] ?? '');
    await prefs.setString('user_photo', userData['photoUrl'] ?? '');
    
    // Save additional role-specific data
    if (userData['providerId'] != null) {
      await prefs.setString('provider_id', userData['providerId']);
    }
  }

  /// Get cached user data
  Future<Map<String, dynamic>?> getCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    
    if (userId == null || userId.isEmpty) {
      return null;
    }

    return {
      'id': userId,
      'email': prefs.getString('user_email') ?? '',
      'name': prefs.getString('user_name') ?? '',
      'role': prefs.getString('user_role') ?? '',
      'photoUrl': prefs.getString('user_photo') ?? '',
      'providerId': prefs.getString('provider_id'),
    };
  }

  /// Get current user's role
  Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _api.updateProfile(data);
      await _saveUserData(response['user']);
      return response;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  /// Refresh user data from backend
  Future<Map<String, dynamic>> refreshUserData() async {
    try {
      final response = await _api.getProfile();
      await _saveUserData(response['user']);
      return response['user'];
    } catch (e) {
      throw Exception('Failed to refresh user data: $e');
    }
  }

  // ==================== SIGN OUT ====================
  
  /// Sign out from both Firebase and backend
  Future<void> signOut() async {
    try {
      // Clear backend token
      await _api.clearAuthToken();
      
      // Clear local user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_role');
      await prefs.remove('user_photo');
      await prefs.remove('provider_id');
      
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // ==================== SESSION MANAGEMENT ====================
  
  /// Check if user is authenticated (both Firebase and backend)
  Future<bool> isAuthenticated() async {
    // Check Firebase auth
    if (_auth.currentUser == null) {
      return false;
    }

    // Check backend token
    final token = await _api.getAuthToken();
    if (token == null) {
      return false;
    }

    // Verify token is still valid by making an API call
    try {
      await _api.getProfile();
      return true;
    } catch (e) {
      // Token expired or invalid
      await signOut();
      return false;
    }
  }

  /// Restore session on app start
  Future<bool> restoreSession() async {
    try {
      // Check if Firebase user exists
      if (_auth.currentUser == null) {
        return false;
      }

      // Check if backend token exists
      final token = await _api.getAuthToken();
      if (token == null) {
        // Try to re-authenticate with backend using Firebase UID
        final user = _auth.currentUser!;
        await _api.login(
          email: user.email!,
          password: user.uid,
        );
      }

      // Refresh user data
      await refreshUserData();
      return true;
    } catch (e) {
      // Session restore failed, sign out
      await signOut();
      return false;
    }
  }
}
