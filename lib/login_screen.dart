import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'role_selection_screen.dart';
import 'widgets/glamora_logo.dart';
import 'main.dart';
import 'screens/customer_registration_screen.dart';
import 'screens/provider_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole selectedRole;
  
  const LoginScreen({super.key, required this.selectedRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _rememberMe = true; // Default to checked
  bool _isCheckingAuth = true; // Check if user is already logged in

  @override
  void initState() {
    super.initState();
    _checkExistingAuth();
  }

  // Check if user is already logged in
  Future<void> _checkExistingAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final savedRole = prefs.getString('user_role');
    
    // If remember me is enabled and user has a role, auto-login
    if (rememberMe && savedRole != null && FirebaseAuth.instance.currentUser != null) {
      // User is already logged in, navigate to home with saved role
      if (mounted) {
        final role = savedRole == 'customer' ? UserRole.customer : UserRole.serviceProvider;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GlamoraHomeShell(userRole: role),
          ),
        );
      }
    } else {
      setState(() {
        _isCheckingAuth = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Save remember me preference and selected role
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
      await prefs.setString('user_role', widget.selectedRole == UserRole.customer ? 'customer' : 'serviceProvider');
      
      // Check if registration is complete
      final isRegistrationComplete = prefs.getBool('registration_complete') ?? false;
      
      // Navigate to registration or home
      if (mounted) {
        if (isRegistrationComplete) {
          // Already registered, go to home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => GlamoraHomeShell(userRole: widget.selectedRole),
            ),
          );
        } else {
          // First time user, go to registration
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => widget.selectedRole == UserRole.customer
                  ? const CustomerRegistrationScreen()
                  : const ProviderRegistrationScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isCheckingAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA855F7)),
          ),
        ),
      );
    }
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glamora Logo
            const AnimatedGlamoraLogo(
              size: 100,
              showText: true,
            ),
            const SizedBox(height: 20),
            Text(
              widget.selectedRole == UserRole.customer
                  ? 'Sign in to book beauty services'
                  : 'Sign in to manage your salon',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              widget.selectedRole == UserRole.customer
                  ? 'Discover beauty. Book smarter. Earn rewards.'
                  : 'Manage bookings, staff & grow your business.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            
            // Remember Me Checkbox
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: _rememberMe
                            ? const LinearGradient(
                                colors: [Color(0xFFF8D7C4), Color(0xFFA855F7)],
                              )
                            : null,
                        color: _rememberMe ? null : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _rememberMe
                              ? Colors.transparent
                              : Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: _rememberMe
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Keep me signed in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stay logged in on this device',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 18,
                  ),
                ],
              ),
            ),
            
            // Google Sign In Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.g_mobiledata, color: Colors.blue),
              label: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }
}