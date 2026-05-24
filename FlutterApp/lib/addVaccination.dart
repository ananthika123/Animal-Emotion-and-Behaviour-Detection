// import 'package:aura/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class add_vaccination extends StatefulWidget {
//   @override
//   _add_vaccination createState() => _add_vaccination();
// }
//
// class _add_vaccination extends State<add_vaccination> with SingleTickerProviderStateMixin {
//   final title = TextEditingController();
//   final date = TextEditingController();
//   final description = TextEditingController();
//
//
//   String? _result;
//   bool _isLoading = false;
//   bool _isUploading = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     title.dispose();
//     date.dispose();
//     description.dispose();
//     super.dispose();
//   }
//
//   bool _validateInputs() {
//     if (title.text.isEmpty) {
//       _showErrorSnackBar('Please enter Title');
//       return false;
//     }
//     if (date.text.isEmpty) {
//       _showErrorSnackBar('Please enter Date');
//       return false;
//     }
//     if (description.text.isEmpty) {
//       _showErrorSnackBar('Please enter a description');
//       return false;
//     }
//     return true;
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _submitPet() async {
//     if (!_validateInputs()) return;
//
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${sh.getString('ip')}/add_vaccination'),
//       );
//
//       // Normal data
//       request.fields['title'] = title.text;
//       request.fields['description'] = description.text;
//       request.fields['pid'] = sh.getString('pid').toString();
//       request.fields['date'] = date.text;
//
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         // Show success message
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   SizedBox(width: 12),
//                   Text('Vaccination added successfully!'),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//
//           Future.delayed(Duration(milliseconds: 500), () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => Home()),
//             );
//           });
//         }
//       } else {
//         print("Upload failed: ${response.statusCode}");
//         _showErrorSnackBar('Upload failed. Please try again.');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Connection failed. Please check your network.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUploading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double fieldWidth = MediaQuery.of(context).size.width * 0.9;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => Home()),
//               );
//             },
//           ),
//         ),
//         title: const Text(
//           "Add New Vaccination",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF4158D0),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.white,
//                   Colors.grey.shade50,
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Header Icon
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF4158D0).withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.pets,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Title
//                     const Text(
//                       'Add Vaccination Details',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1E1E1E),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Fill in the details below',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//
//
//                     // ================================
//                     // 🔹 Age Input
//                     // ================================
//                     Container(
//                       width: fieldWidth,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: title,
//                         keyboardType: TextInputType.text,
//                         style: const TextStyle(fontSize: 16),
//                         decoration: InputDecoration(
//                           hintText: "Enter title",
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 15,
//                           ),
//                           labelText: "Title",
//                           labelStyle: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 15,
//                           ),
//                           prefixIcon: const Icon(
//                             Icons.cake_outlined,
//                             color: Color(0xFF4158D0),
//                             size: 22,
//                           ),
//                           suffixIcon: Container(
//                             margin: const EdgeInsets.all(12),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         cursorColor: const Color(0xFF4158D0),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
// // ================================
//                     // 🔹 Age Input
//                     // ================================
//                     Container(
//                       width: fieldWidth,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: date,
//                         keyboardType: TextInputType.text,
//                         style: const TextStyle(fontSize: 16),
//                         decoration: InputDecoration(
//                           hintText: "Enter date",
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 15,
//                           ),
//                           labelText: "Date",
//                           labelStyle: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 15,
//                           ),
//                           prefixIcon: const Icon(
//                             Icons.cake_outlined,
//                             color: Color(0xFF4158D0),
//                             size: 22,
//                           ),
//                           suffixIcon: Container(
//                             margin: const EdgeInsets.all(12),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         cursorColor: const Color(0xFF4158D0),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // ================================
//                     // 🔹 Description Input
//                     // ================================
//                     Container(
//                       width: fieldWidth,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: description,
//                         maxLines: 4,
//                         style: const TextStyle(fontSize: 16),
//                         decoration: InputDecoration(
//                           hintText: "Enter description about vaccination",
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 15,
//                           ),
//                           labelText: "Description",
//                           labelStyle: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 15,
//                           ),
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.only(bottom: 40),
//                             child: Icon(
//                               Icons.description_outlined,
//                               color: Color(0xFF4158D0),
//                               size: 22,
//                             ),
//                           ),
//                           alignLabelWithHint: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         cursorColor: const Color(0xFF4158D0),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // ================================
//                     // 🔹 Submit Button
//                     // ================================
//                     SizedBox(
//                       width: fieldWidth,
//                       height: 55,
//                       child: ElevatedButton(
//                         onPressed: _isUploading ? null : _submitPet,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4158D0),
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           shadowColor: const Color(0xFF4158D0).withOpacity(0.5),
//                         ),
//                         child: _isUploading
//                             ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 24,
//                               height: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               'ADDING VACCINATION...',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                           ],
//                         )
//                             : const Text(
//                           'ADD VACCINATION',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:aura/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class add_vaccination extends StatefulWidget {
  @override
  _add_vaccination createState() => _add_vaccination();
}

class _add_vaccination extends State<add_vaccination> with SingleTickerProviderStateMixin {
  final title = TextEditingController();
  final date = TextEditingController();
  final description = TextEditingController();

  // Date picker
  DateTime? _selectedDate;


  String? _result;
  bool _isLoading = false;
  bool _isUploading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4158D0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        date.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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
    title.dispose();
    date.dispose();
    description.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (title.text.isEmpty) {
      _showErrorSnackBar('Please enter vaccination title');
      return false;
    }
    if (date.text.isEmpty) {
      _showErrorSnackBar('Please select vaccination date');
      return false;
    }
    if (description.text.isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _submitVaccination() async {
    if (!_validateInputs()) return;

    setState(() {
      _isUploading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${sh.getString('ip')}/add_vaccination'),
      );

      // Normal data
      request.fields['title'] = title.text;
      request.fields['description'] = description.text;
      request.fields['pid'] = sh.getString('pid').toString();
      request.fields['date'] = date.text;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        if (mounted) {
          _showSuccessSnackBar('Vaccination added successfully!');

          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          });
        }
      } else {
        print("Upload failed: ${response.statusCode}");
        _showErrorSnackBar(jsonResponse['message'] ?? 'Upload failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Connection failed. Please check your network.');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4158D0).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.medical_services_outlined,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Add Vaccination',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Keep your pet healthy with timely vaccinations',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Container(
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
        controller: title,
        enabled: !_isUploading,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: "e.g., Rabies Vaccine, DHPP Booster",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          labelText: "Vaccination Title",
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.vaccines_outlined,
            color: Color(0xFF4158D0),
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
    );
  }

  Widget _buildDateField() {
    return Container(
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
        controller: date,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: "Select date",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          labelText: "Vaccination Date",
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF4158D0),
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.event,
              color: const Color(0xFF4158D0),
            ),
            onPressed: _selectDate,
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
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
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
        controller: description,
        maxLines: 4,
        enabled: !_isUploading,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: "Enter details about the vaccination...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          labelText: "Description",
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Icon(
              Icons.description_outlined,
              color: Color(0xFF4158D0),
              size: 22,
            ),
          ),
          alignLabelWithHint: true,
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
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4158D0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4158D0).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF4158D0),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4158D0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep track of your pet\'s vaccination schedule for their health and safety.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.9;

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
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
        title: const Text(
          "Vaccination",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4158D0),
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
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section
                    _buildHeader(),
                    const SizedBox(height: 40),

                    // Form Fields
                    SizedBox(
                      width: fieldWidth,
                      child: Column(
                        children: [
                          _buildTitleField(),
                          const SizedBox(height: 20),


                          _buildDateField(),
                          const SizedBox(height: 20),

                          _buildDescriptionField(),
                          const SizedBox(height: 20),

                          _buildInfoCard(),
                          const SizedBox(height: 30),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isUploading ? null : _submitVaccination,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4158D0),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: const Color(0xFF4158D0).withOpacity(0.5),
                              ),
                              child: _isUploading
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
                                    'ADDING VACCINATION...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              )
                                  : const Text(
                                'ADD VACCINATION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
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
}