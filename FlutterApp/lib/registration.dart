// import 'dart:convert';
//
// import 'package:aura/login.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main(){
//   runApp(register());
// }
//
// class register extends StatelessWidget {
//   const register({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:registersub());
//   }
// }
// class registersub extends StatefulWidget {
//   const registersub({Key? key}) : super(key: key);
//
//   @override
//   State<registersub> createState() => _registersubState();
// }
//
// class _registersubState extends State<registersub> {
//   final name=new TextEditingController();
//   final email=new TextEditingController();
//   final phone=new TextEditingController();
//   final password=new TextEditingController();
//   final confirmPassword=new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body:
//     Center(child: SingleChildScrollView(child: Column(children: [
//       Text("REGISTER",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
//       SizedBox(height: 20,),
//       SizedBox(width: 200,child:  TextField( controller:name,decoration: InputDecoration(hintText: "enter name",labelText: "name",
//           border: OutlineInputBorder(borderRadius:
//           BorderRadius.circular(12)),prefixIcon:
//           Icon(Icons.person))),),
//
//       SizedBox(height: 20,),
//       SizedBox(width: 200,child:  TextField( controller: email,decoration: InputDecoration(hintText: "enter email",labelText: "email",
//            border: OutlineInputBorder(borderRadius:
//            BorderRadius.circular(12)),prefixIcon:
//            Icon(Icons.email))),),
//       SizedBox(height: 20,),
//       SizedBox(width: 200,child:  TextField( controller:phone,decoration: InputDecoration(hintText: "enter phone number",labelText: "phone",
//             border: OutlineInputBorder(borderRadius:
//             BorderRadius.circular(12)),prefixIcon:
//             Icon(Icons.phone))),),
//
//
//       SizedBox(height:20,),
//       SizedBox(width: 200,child: TextField(controller: password, decoration: InputDecoration(hintText: "enter password",labelText: "password",
//           border: OutlineInputBorder(borderRadius:
//           BorderRadius.circular(12)),prefixIcon:
//           Icon(Icons.password))),),
//
//       SizedBox(height: 20,),
//       SizedBox(width: 200,child: TextField( controller:confirmPassword,decoration: InputDecoration(hintText: "confirm password",labelText: "confirm password",
//           border: OutlineInputBorder(borderRadius:
//           BorderRadius.circular(12)),prefixIcon:
//           Icon(Icons.password))),),
//
//       SizedBox(height: 20,),
//       ElevatedButton(onPressed: () async {
//         SharedPreferences sh= await SharedPreferences.getInstance();
//         var data=await http.post(Uri.parse("${sh.getString("ip").toString()}/user_register"), body: {
//           "name": name.text,
//           "email": email.text,
//           "phone": phone.text,
//           "password": password.text,
//           "confirmPassword": confirmPassword.text
//         });
//
//         var decodd=json.decode(data.body);
//         if(decodd['status']=='ok'){
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
//         }
//
//
//
//
//       }, child: Text("REGISTER"))
//
//     ],)))
//     );
//   }
// }


import 'dart:convert';
import 'package:aura/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const register());
}

class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aura Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const registersub(),
    );
  }
}

class registersub extends StatefulWidget {
  const registersub({Key? key}) : super(key: key);

  @override
  State<registersub> createState() => _registersubState();
}

class _registersubState extends State<registersub> with SingleTickerProviderStateMixin {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (name.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your name');
      return false;
    }
    if (email.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text)) {
      setState(() => _errorMessage = 'Please enter a valid email');
      return false;
    }
    if (phone.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number');
      return false;
    }
    if (phone.text.length < 10) {
      setState(() => _errorMessage = 'Please enter a valid 10-digit phone number');
      return false;
    }
    if (password.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a password');
      return false;
    }
    if (password.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return false;
    }
    if (confirmPassword.text.isEmpty) {
      setState(() => _errorMessage = 'Please confirm your password');
      return false;
    }
    if (password.text != confirmPassword.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return false;
    }
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateInputs()) return;

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
        Uri.parse("$ip/user_register"),
        body: {
          "name": name.text,
          "email": email.text,
          "phone": phone.text,
          "password": password.text,
          "confirmPassword": confirmPassword.text
        },
      ).timeout(const Duration(seconds: 10));

      final decoded = json.decode(response.body);

      if (decoded['status'] == 'ok') {
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Registration successful! Please login.'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Navigate to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const login()),
          );
        }
      } else {
        setState(() {
          _errorMessage = decoded['message'] ?? 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed. Please check your network.';
      });
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
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.all(20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Section
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.app_registration_rounded,
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Welcome Text
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),

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
                                Icons.error_outline_rounded,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Form Fields
                      _buildInputField(
                        controller: name,
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        textInputType: TextInputType.name,
                      ),

                      _buildInputField(
                        controller: email,
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        hint: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                      ),

                      _buildInputField(
                        controller: phone,
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        hint: 'Enter 10-digit phone number',
                        textInputType: TextInputType.phone,
                        maxLength: 10,
                      ),

                      _buildPasswordField(
                        controller: password,
                        label: 'Password',
                        hint: 'Create a password (min. 6 characters)',
                        isVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),

                      _buildPasswordField(
                        controller: confirmPassword,
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        isVisible: _isConfirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Requirements
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password Requirements:',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '• Minimum 6 characters\n• Use letters & numbers for stronger password',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: const Color(0xFF3B82F6).withOpacity(0.5),
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
                                'CREATING ACCOUNT...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const login(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFF3B82F6),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Terms and Privacy
                      Text(
                        'By creating an account, you agree to our\nTerms of Service and Privacy Policy',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    TextInputType? textInputType,
    int? maxLength,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        controller: controller,
        keyboardType: textInputType,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
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
        cursorColor: const Color(0xFF3B82F6),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: Colors.grey.shade600,
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey.shade600,
              size: 22,
            ),
            onPressed: onToggleVisibility,
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
        cursorColor: const Color(0xFF3B82F6),
      ),
    );
  }
}