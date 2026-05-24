import 'dart:convert';
import 'package:aura/home.dart';
import 'package:aura/registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'locationservice.dart';

void main() {
  runApp(const login());
}

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aura Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const loginsub(),
    );
  }
}

class loginsub extends StatefulWidget {
  const loginsub({Key? key}) : super(key: key);

  @override
  State<loginsub> createState() => _loginsubState();
}

class _loginsubState extends State<loginsub> with SingleTickerProviderStateMixin {
  final username = TextEditingController(text: "bb@gmail.com");
  final password = TextEditingController(text: "12345678");
  final uid = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Location service instance
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    // Initialize notification helper
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    if (!kIsWeb) {
      await NotificationHelper.initialize();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    username.dispose();
    password.dispose();
    uid.dispose();
    super.dispose();
  }

  Future<void> _startLocationService(String userId) async {
    try {
      // Set up notification callback
      _locationService.onNotificationMessage = (message) {
        if (mounted) {
          // Show in-app snackbar for web and mobile
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: Color(0xFF4158D0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 4),
            ),
          );

          // Also show local notification for mobile
          if (!kIsWeb) {
            NotificationHelper.showNotification('📢 Vaccination Reminder', message);
          }
        }
      };

      // Start location service for periodic checks
      if (!kIsWeb) {
        // Only start on mobile devices
        await _locationService.startLocationUpdates(userId);
        print('✅ Service started for user: $userId');
      } else {
        print('ℹ️ Service not started on web platform');
      }

    } catch (e) {
      print('❌ Failed to start service: $e');

      // Show warning but don't block login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Service warning: $e')),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleLogin() async {
    // Validation
    if (username.text.isEmpty || password.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final ip = sh.getString("ip") ?? "";

      if (ip.isEmpty) {
        throw Exception('Server IP not configured');
      }

      final response = await http.post(
        Uri.parse("$ip/login_user"),
        body: {
          "username": username.text,
          "password": password.text,
          "uid": sh.getString('uid') ?? ""
        },
      ).timeout(const Duration(seconds: 10));

      final decoded = json.decode(response.body);

      if (decoded['status'] == 'ok') {
        // Save user data
        final String userId = decoded['uid'];
        final String userName = decoded['uname'] ?? 'User';
        final String userMail = decoded['umail'] ?? 'User@gmail.com';

        await sh.setString("uid", userId);
        await sh.setString("uname", userName);
        await sh.setString("umail", userMail);

        print('✅ Login successful for user: $userName (ID: $userId)');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Welcome back, $userName!')),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Start location service after successful login
        await _startLocationService(userId);

        // Navigate to home page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      } else {
        setState(() {
          _errorMessage = decoded['message'] ?? 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed. Please check your network.';
      });
      print('❌ Login error: $e');
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo and Welcome Section
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4158D0).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Welcome Back Text
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sign in to continue to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Username Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: username,
                          enabled: !_isLoading,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Enter your username",
                            labelText: "Username",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.grey.shade600,
                              size: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          cursorColor: const Color(0xFF4158D0),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: password,
                          obscureText: !_isPasswordVisible,
                          enabled: !_isLoading,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.grey.shade600,
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey.shade600,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          cursorColor: const Color(0xFF4158D0),
                        ),
                      ),

                      // Location Service Info (only shown on mobile)
                      if (!kIsWeb)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Location service will start after login',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4158D0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: const Color(0xFF4158D0).withOpacity(0.5),
                          ),
                          child: _isLoading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'LOGGING IN...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const register(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4158D0),
                            side: const BorderSide(
                              color: Color(0xFF4158D0),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'CREATE NEW ACCOUNT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Terms and Privacy
                      Text(
                        'By signing in, you agree to our\nTerms of Service and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}