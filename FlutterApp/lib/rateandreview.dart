// import 'dart:convert';
//
// import 'package:aura/home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main(){
//   runApp(rateandreview());
// }
//
// class rateandreview extends StatelessWidget {
//   const rateandreview({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:rateandreviewsub());
//   }
// }
//
// class rateandreviewsub extends StatefulWidget {
//
//   const rateandreviewsub({Key? key}) : super(key: key);
//
//   @override
//   State<rateandreviewsub> createState() => _rateandreviewsubState();
// }
//
// class _rateandreviewsubState extends State<rateandreviewsub> {
//   final rating =new TextEditingController();
//   final review =new TextEditingController();
//   final uid=new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body:
//     Center(child: SingleChildScrollView(child: Column(children: [
//       Text("RATE AND REVIEW",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
//       SizedBox(height: 20,),
//       SizedBox(width: 200,child:  TextField( controller:rating,decoration: InputDecoration(hintText: "enter rating",labelText: "rate",
//           border: OutlineInputBorder(borderRadius:
//           BorderRadius.circular(12)),prefixIcon:
//           Icon(Icons.numbers))),),
//
//       SizedBox(height:20,),
//       SizedBox(width: 200,child: TextField( controller:review,decoration: InputDecoration(hintText: "enter review",labelText: "review",
//           border: OutlineInputBorder(borderRadius:
//           BorderRadius.circular(12)),prefixIcon:
//           Icon(Icons.text_fields))),),
//
//       SizedBox(height: 20,),
//       ElevatedButton(onPressed: () async {
//       SharedPreferences sh= await SharedPreferences.getInstance();
//       var data=await http.post(Uri.parse("${sh.getString("ip").toString()}/rate_review"), body: {
//       "rating": rating.text,
//       "review": review.text,
//         "uid": sh.getString('uid') ?? ""
//
//       });
//
//       var decodd=json.decode(data.body);
//       if(decodd['status']=='ok'){
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
//       }
//
//
//
//
//       }, child: Text("SEND"))
//
//     ],)))
//     );
//   }
// }


import 'dart:convert';
import 'package:aura/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const rateandreview());
}

class rateandreview extends StatelessWidget {
  const rateandreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rate & Review',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const rateandreviewsub(),
    );
  }
}

class rateandreviewsub extends StatefulWidget {
  const rateandreviewsub({Key? key}) : super(key: key);

  @override
  State<rateandreviewsub> createState() => _rateandreviewsubState();
}

class _rateandreviewsubState extends State<rateandreviewsub> with SingleTickerProviderStateMixin {
  final rating = TextEditingController();
  final review = TextEditingController();
  final uid = TextEditingController();

  double _currentRating = 0.0;
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
    rating.dispose();
    review.dispose();
    uid.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (_currentRating == 0.0) {
      setState(() {
        _errorMessage = 'Please select a rating';
      });
      return false;
    }
    if (review.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your review';
      });
      return false;
    }
    if (review.text.length < 10) {
      setState(() {
        _errorMessage = 'Review must be at least 10 characters';
      });
      return false;
    }
    return true;
  }

  Future<void> _submitReview() async {
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
        Uri.parse("$ip/rate_review"),
        body: {
          "rating": _currentRating.toString(),
          "review": review.text,
          "uid": sh.getString('uid') ?? ""
        },
      ).timeout(const Duration(seconds: 10));

      final decoded = json.decode(response.body);

      if (decoded['status'] == 'ok') {
        if (mounted) {
          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Thank You!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your review has been submitted successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA500),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        setState(() {
          _errorMessage = decoded['message'] ?? 'Submission failed. Please try again.';
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
        ),
        title: const Text(
          "Rate & Review",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA500),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.orange.shade50,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Header Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFA500), Color(0xFFFF6B6B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '5.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      'Share Your Experience',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your feedback helps us improve',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
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

                    // ================================
                    // 🔹 Rating Section
                    // ================================
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Rating',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Star Rating
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentRating = index + 1.0;
                                      rating.text = _currentRating.toString();
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      children: [
                                        Icon(
                                          index < _currentRating
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: index < _currentRating
                                              ? const Color(0xFFFFA500)
                                              : Colors.grey.shade300,
                                          size: 45,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: index < _currentRating
                                                ? const Color(0xFFFFA500)
                                                : Colors.grey.shade400,
                                            fontWeight: index < _currentRating
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          if (_currentRating > 0) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFA500).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: const Color(0xFFFFA500),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'You rated ${_currentRating.toStringAsFixed(0)} out of 5',
                                      style: const TextStyle(
                                        color: Color(0xFFFFA500),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ================================
                    // 🔹 Review Input
                    // ================================
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Review',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: review,
                                  maxLines: 5,
                                  maxLength: 500,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: "Tell us about your experience...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFFFA500),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  cursorColor: const Color(0xFFFFA500),
                                ),
                              ],
                            ),
                          ),

                          // Quick Review Suggestions
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quick feedback:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildSuggestionChip('Great service!'),
                                    _buildSuggestionChip('Very helpful'),
                                    _buildSuggestionChip('Easy to use'),
                                    _buildSuggestionChip('Excellent support'),
                                    _buildSuggestionChip('Could be better'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ================================
                    // 🔹 Submit Button
                    // ================================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA500),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: const Color(0xFFFFA500).withOpacity(0.5),
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
                              'SUBMITTING...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        )
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded),
                            SizedBox(width: 10),
                            Text(
                              'SUBMIT REVIEW',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Thank You Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your feedback helps us serve you better!',
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return FilterChip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFFFA500),
      ),
      selected: false,
      onSelected: (selected) {
        setState(() {
          if (review.text.isEmpty) {
            review.text = label;
          } else {
            review.text = '${review.text} $label';
          }
        });
      },
      backgroundColor: Colors.amber.shade50,
      selectedColor: Colors.amber.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.amber.shade200),
      ),
    );
  }
}