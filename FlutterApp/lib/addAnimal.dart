// // // 🌐💫 Flutter Power: Handling Data from Django → Setting Dropdown Values 💫🌐
// //
// // import 'package:aura/home.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class add_pet extends StatefulWidget {
// //   @override
// //   _add_petState createState() => _add_petState();
// // }
// //
// // class _add_petState extends State<add_pet> {
// //   final age = TextEditingController();
// //   final description = TextEditingController();
// //
// //   // 🔹 Breed data list
// //   List<Map<String, dynamic>> breed = [];
// //   String? selectedBreed;
// //
// //   PlatformFile? _selectedFile;
// //   Uint8List? _webFileBytes;
// //   String? _result;
// //   bool _isLoading = false;
// //
// //   Future<void> _pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       allowMultiple: false,
// //       type: FileType.any,
// //     );
// //
// //     if (result != null) {
// //       setState(() {
// //         _selectedFile = result.files.first;
// //         _result = null;
// //       });
// //
// //       if (kIsWeb) {
// //         _webFileBytes = result.files.first.bytes;
// //       }
// //     }
// //   }
// //
// //   Future<void> load_breed() async {
// //     try {
// //       SharedPreferences sh = await SharedPreferences.getInstance();
// //       final response = await http.post(
// //         Uri.parse("${sh.getString('ip')}/load_breed"),
// //       );
// //       var decode = json.decode(response.body);
// //
// //       decode['data'].forEach((item) {
// //         setState(() {
// //           breed.add({
// //             'id': item['id'].toString(),
// //             'name': item['breed'].toString(),
// //           });
// //         });
// //       });
// //
// //       print(breed);
// //     } catch (e) {
// //       print("Error fetching breed: $e");
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     load_breed(); // ✅ Call function on screen load
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     double fieldWidth = MediaQuery.of(context).size.width * 0.9;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //           leading: IconButton(
// //             icon: Icon(Icons.arrow_back),
// //             onPressed: () {
// //               Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
// //             },
// //           ),
// //           title: Text("ADD PET")),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // ================================
// //             // 🔹 Breed Dropdown UI
// //             // ================================
// //             SizedBox(
// //               width: fieldWidth,
// //               child: Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.green, width: 1.5),
// //                   borderRadius: BorderRadius.circular(12),
// //                   color: Colors.white,
// //                 ),
// //                 child: DropdownButton<String>(
// //                   value: selectedBreed,
// //                   hint: Text('Select breed'),
// //                   isExpanded: true,
// //                   underline: SizedBox(),
// //                   icon: Icon(Icons.arrow_drop_down, color: Colors.green),
// //                   onChanged: (value) {
// //                     setState(() {
// //                       selectedBreed = value;
// //                     });
// //                   },
// //                   items: breed.map((item) {
// //                     return DropdownMenuItem<String>(
// //                       value: item["id"].toString(),
// //                       child: Text(item["name"].toString()),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ),
// //
// //             SizedBox(height: 20),
// //             SizedBox(
// //               width: 200,
// //               child: TextField(
// //                 controller: age,
// //                 decoration: InputDecoration(
// //                   hintText: "enter age",
// //                   labelText: "age",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   prefixIcon: Icon(Icons.numbers),
// //                 ),
// //               ),
// //             ),
// //
// //             SizedBox(height: 20),
// //             SizedBox(
// //               width: 200,
// //               child: TextField(
// //                 controller: description,
// //                 decoration: InputDecoration(
// //                   hintText: "enter description",
// //                   labelText: "description",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   prefixIcon: Icon(Icons.text_fields),
// //                 ),
// //               ),
// //             ),
// //
// //             ElevatedButton.icon(
// //               icon: Icon(Icons.upload_file),
// //               label: Text("Select File"),
// //               onPressed: _pickFile,
// //             ),
// //             if (_selectedFile != null) ...[
// //               SizedBox(height: 10),
// //               Text("Selected: ${_selectedFile!.name}"),
// //             ],
// //
// //             SizedBox(height: 20),
// //
// //             // 🔹 Submit Button
// //             ElevatedButton(
// //               onPressed: () async {
// //                 SharedPreferences sh = await SharedPreferences.getInstance();
// //
// //                 var request = http.MultipartRequest(
// //                   'POST',
// //                   Uri.parse('${sh.getString('ip')}/add_pet'),
// //                 );
// //
// //                 // Normal data
// //                 request.fields['age'] = age.text;
// //                 request.fields['description'] = description.text;
// //                 request.fields['uid'] = sh.getString('uid').toString();
// //                 request.fields['breed'] = selectedBreed ?? "";
// //
// //                 // File part
// //                 if (_selectedFile != null) {
// //                   if (kIsWeb) {
// //                     request.files.add(http.MultipartFile.fromBytes(
// //                       'file',
// //                       _webFileBytes!,
// //                       filename: _selectedFile!.name,
// //                     ));
// //                   } else {
// //                     request.files.add(await http.MultipartFile.fromPath(
// //                       'file',
// //                       _selectedFile!.path!,
// //                     ));
// //                   }
// //                 }
// //
// //                 var response = await request.send();
// //
// //                 if (response.statusCode == 200) {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => Home()),
// //                   );
// //                 } else {
// //                   print("Upload failed: ${response.statusCode}");
// //                 }
// //               },
// //               child: Text("Submit"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// // 🌐💫 Flutter Power: Handling Data from Django → Setting Dropdown Values 💫🌐
//
// import 'package:aura/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class add_pet extends StatefulWidget {
//   @override
//   _add_petState createState() => _add_petState();
// }
//
// class _add_petState extends State<add_pet> with SingleTickerProviderStateMixin {
//   final age = TextEditingController();
//   final description = TextEditingController();
//
//   // 🔹 Breed data list
//   List<Map<String, dynamic>> breed = [];
//   String? selectedBreed;
//   String? selectedBreedName;
//
//   PlatformFile? _selectedFile;
//   Uint8List? _webFileBytes;
//   String? _result;
//   bool _isLoading = false;
//   bool _isUploading = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.image,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
//     );
//
//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.first;
//         _result = null;
//       });
//
//       if (kIsWeb) {
//         _webFileBytes = result.files.first.bytes;
//       }
//     }
//   }
//
//   Future<void> load_breed() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       final response = await http.post(
//         Uri.parse("${sh.getString('ip')}/load_breed"),
//       );
//       var decode = json.decode(response.body);
//
//       List<Map<String, dynamic>> loadedBreeds = [];
//       decode['data'].forEach((item) {
//         loadedBreeds.add({
//           'id': item['id'].toString(),
//           'name': item['name'].toString(),
//         });
//       });
//
//       setState(() {
//         breed = loadedBreeds;
//         _isLoading = false;
//       });
//
//       print(breed);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching breed: $e");
//
//       // Show error dialog
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to load breeds. Please try again.'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     load_breed(); // ✅ Call function on screen load
//
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
//     age.dispose();
//     description.dispose();
//     super.dispose();
//   }
//
//   bool _validateInputs() {
//     if (selectedBreed == null) {
//       _showErrorSnackBar('Please select a breed');
//       return false;
//     }
//     if (age.text.isEmpty) {
//       _showErrorSnackBar('Please enter age');
//       return false;
//     }
//     if (int.tryParse(age.text) == null) {
//       _showErrorSnackBar('Please enter a valid number for age');
//       return false;
//     }
//     if (description.text.isEmpty) {
//       _showErrorSnackBar('Please enter a description');
//       return false;
//     }
//     if (_selectedFile == null) {
//       _showErrorSnackBar('Please select an image file');
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
//         Uri.parse('${sh.getString('ip')}/add_pet'),
//       );
//
//       // Normal data
//       request.fields['age'] = age.text;
//       request.fields['description'] = description.text;
//       request.fields['uid'] = sh.getString('uid').toString();
//       request.fields['breed'] = selectedBreed ?? "";
//
//       // File part
//       if (_selectedFile != null) {
//         if (kIsWeb) {
//           request.files.add(http.MultipartFile.fromBytes(
//             'file',
//             _webFileBytes!,
//             filename: _selectedFile!.name,
//           ));
//         } else {
//           request.files.add(await http.MultipartFile.fromPath(
//             'file',
//             _selectedFile!.path!,
//           ));
//         }
//       }
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
//                   Text('Pet added successfully!'),
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
//           "Add New Pet",
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
//                       'Add Your Pet',
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
//                     // ================================
//                     // 🔹 Breed Dropdown UI
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
//                       child: DropdownButtonFormField<String>(
//                         value: selectedBreed,
//                         decoration: InputDecoration(
//                           labelText: 'Select Breed',
//                           labelStyle: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 15,
//                           ),
//                           prefixIcon: const Icon(
//                             Icons.pets_outlined,
//                             color: Color(0xFF4158D0),
//                             size: 22,
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
//                         hint: Text(
//                           'Choose a breed',
//                           style: TextStyle(
//                             color: Colors.grey.shade500,
//                           ),
//                         ),
//                         isExpanded: true,
//                         icon: const Icon(
//                           Icons.arrow_drop_down_circle_outlined,
//                           color: Color(0xFF4158D0),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedBreed = value;
//                             selectedBreedName = breed.firstWhere(
//                                   (item) => item['id'] == value,
//                             )['name'];
//                           });
//                         },
//                         items: _isLoading
//                             ? [
//                           DropdownMenuItem(
//                             value: null,
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Color(0xFF4158D0),
//                                   ),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Text('Loading breeds...'),
//                               ],
//                             ),
//                           )
//                         ]
//                             : breed.map((item) {
//                           return DropdownMenuItem<String>(
//                             value: item["id"].toString(),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFF4158D0),
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   item["name"].toString(),
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
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
//                         controller: age,
//                         keyboardType: TextInputType.number,
//                         style: const TextStyle(fontSize: 16),
//                         decoration: InputDecoration(
//                           hintText: "Enter age (in years)",
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 15,
//                           ),
//                           labelText: "Age",
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
//                             child: Text(
//                               'years',
//                               style: TextStyle(
//                                 color: Colors.grey.shade700,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                               ),
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
//                           hintText: "Enter description about your pet",
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
//                     // 🔹 File Upload Section
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
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: _pickFile,
//                             child: Container(
//                               padding: const EdgeInsets.all(24),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF4158D0).withOpacity(0.05),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(
//                                   color: const Color(0xFF4158D0).withOpacity(0.3),
//                                   width: 1.5,
//                                   style: BorderStyle.solid,
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Icon(
//                                     _selectedFile != null
//                                         ? Icons.check_circle
//                                         : Icons.cloud_upload_outlined,
//                                     size: 50,
//                                     color: _selectedFile != null
//                                         ? Colors.green
//                                         : const Color(0xFF4158D0),
//                                   ),
//                                   const SizedBox(height: 12),
//                                   Text(
//                                     _selectedFile != null
//                                         ? 'File Selected!'
//                                         : 'Tap to Upload Pet Image',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: _selectedFile != null
//                                           ? Colors.green
//                                           : const Color(0xFF4158D0),
//                                     ),
//                                   ),
//                                   if (_selectedFile == null) ...[
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'JPG, PNG, GIF supported',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           ),
//                           if (_selectedFile != null) ...[
//                             const Divider(height: 1),
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: const Icon(
//                                       Icons.insert_drive_file,
//                                       color: Colors.green,
//                                       size: 24,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           _selectedFile!.name,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 14,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.close,
//                                       color: Colors.red,
//                                       size: 20,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _selectedFile = null;
//                                         _webFileBytes = null;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 40),
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
//                               'ADDING PET...',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                           ],
//                         )
//                             : const Text(
//                           'ADD PET',
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

// 🌐💫 Flutter Power: Handling Data from Django → Setting Dropdown Values 💫🌐

import 'package:aura/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add_pet extends StatefulWidget {
  @override
  _add_petState createState() => _add_petState();
}

class _add_petState extends State<add_pet> with SingleTickerProviderStateMixin {
  final age = TextEditingController();
  final description = TextEditingController();

  // 🔹 Breed data list
  List<Map<String, dynamic>> breed = [];
  String? selectedBreed;
  String? selectedBreedName;

  PlatformFile? _selectedFile;
  Uint8List? _webFileBytes;
  String? _result;
  bool _isLoading = false;
  bool _isUploading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        // allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _result = null;
        });

        if (kIsWeb) {
          _webFileBytes = result.files.first.bytes;
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(child: Text('Image selected: ${_selectedFile!.name}')),
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
    } catch (e) {
      _showErrorSnackBar('Error picking file: $e');
    }
  }

  Future<void> load_breed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse("${sh.getString('ip')}/load_breed"),
      );
      var decode = json.decode(response.body);

      List<Map<String, dynamic>> loadedBreeds = [];
      decode['data'].forEach((item) {
        loadedBreeds.add({
          'id': item['id'].toString(),
          'name': item['name'].toString(),
        });
      });

      setState(() {
        breed = loadedBreeds;
        _isLoading = false;
      });

      print(breed);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching breed: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load breeds. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    load_breed();

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
    age.dispose();
    description.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (selectedBreed == null) {
      _showErrorSnackBar('Please select a breed');
      return false;
    }
    if (age.text.isEmpty) {
      _showErrorSnackBar('Please enter age');
      return false;
    }
    if (int.tryParse(age.text) == null) {
      _showErrorSnackBar('Please enter a valid number for age');
      return false;
    }
    if (description.text.isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return false;
    }
    if (_selectedFile == null) {
      _showErrorSnackBar('Please select an image file');
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

  Future<void> _submitPet() async {
    if (!_validateInputs()) return;

    setState(() {
      _isUploading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${sh.getString('ip')}/add_pet'),
      );

      // Normal data
      request.fields['age'] = age.text;
      request.fields['description'] = description.text;
      request.fields['uid'] = sh.getString('uid').toString();
      request.fields['breed'] = selectedBreed ?? "";

      // File part
      if (_selectedFile != null) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            _webFileBytes!,
            filename: _selectedFile!.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            _selectedFile!.path!,
          ));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Pet added successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          });
        }
      } else {
        print("Upload failed: ${response.statusCode}");
        _showErrorSnackBar('Upload failed. Please try again.');
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

  // Helper methods for file handling
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toUpperCase();
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  bool _isImageFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
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
          "Add New Pet",
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
                    // Header Icon
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
                        Icons.pets,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      'Add Your Pet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details below',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ================================
                    // 🔹 Breed Dropdown UI
                    // ================================
                    Container(
                      width: fieldWidth,
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
                      child: DropdownButtonFormField<String>(
                        value: selectedBreed,
                        decoration: InputDecoration(
                          labelText: 'Select Breed',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.pets_outlined,
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
                        hint: Text(
                          'Choose a breed',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Color(0xFF4158D0),
                        ),
                        onChanged: _isUploading
                            ? null
                            : (value) {
                          setState(() {
                            selectedBreed = value;
                            selectedBreedName = breed.firstWhere(
                                  (item) => item['id'] == value,
                            )['name'];
                          });
                        },
                        items: _isLoading
                            ? [
                          const DropdownMenuItem(
                            value: null,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF4158D0),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Loading breeds...'),
                              ],
                            ),
                          )
                        ]
                            : breed.map((item) {
                          return DropdownMenuItem<String>(
                            value: item["id"].toString(),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4158D0),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item["name"].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ================================
                    // 🔹 Age Input
                    // ================================
                    Container(
                      width: fieldWidth,
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
                        controller: age,
                        keyboardType: TextInputType.number,
                        enabled: !_isUploading,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Enter age (in years)",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          labelText: "Age",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.cake_outlined,
                            color: Color(0xFF4158D0),
                            size: 22,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'years',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                    const SizedBox(height: 20),

                    // ================================
                    // 🔹 Description Input
                    // ================================
                    Container(
                      width: fieldWidth,
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
                          hintText: "Enter description about your pet",
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
                    ),
                    const SizedBox(height: 20),

                    // ================================
                    // 🔹 Enhanced File Upload Section
                    // ================================
                    Container(
                      width: fieldWidth,
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
                      child: Column(
                        children: [
                          // Drag & Drop area (visual only)
                          InkWell(
                            onTap: _isUploading ? null : _pickFile,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: _selectedFile != null
                                    ? Colors.green.withOpacity(0.05)
                                    : const Color(0xFF4158D0).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _selectedFile != null
                                      ? Colors.green.withOpacity(0.5)
                                      : const Color(0xFF4158D0).withOpacity(0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Animated icon
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _selectedFile != null
                                        ? const Icon(
                                      Icons.check_circle,
                                      key: ValueKey('check'),
                                      size: 60,
                                      color: Colors.green,
                                    )
                                        : const Icon(
                                      Icons.cloud_upload_outlined,
                                      key: ValueKey('upload'),
                                      size: 60,
                                      color: Color(0xFF4158D0),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // File name or upload text
                                  if (_selectedFile != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.image,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              _selectedFile!.name,
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to change image',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      'Upload Pet Image',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4158D0),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to browse files',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Supports: JPG, PNG, GIF',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // File details section (when file is selected)
                          if (_selectedFile != null) ...[
                            const Divider(height: 1),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // File type icon
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: _getFileTypeColor(_selectedFile!.name),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _getFileIcon(_selectedFile!.name),
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // File info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedFile!.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    _getFileExtension(_selectedFile!.name),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _formatFileSize(_selectedFile!.size),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Remove button
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                        onPressed: _isUploading
                                            ? null
                                            : () {
                                          setState(() {
                                            _selectedFile = null;
                                            _webFileBytes = null;
                                          });

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Image removed'),
                                              duration: const Duration(seconds: 1),
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  // Image preview (if it's an image)
                                  if (_isImageFile(_selectedFile!.name) && _webFileBytes != null) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          _webFileBytes!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ================================
                    // 🔹 Submit Button
                    // ================================
                    SizedBox(
                      width: fieldWidth,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : _submitPet,
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
                              'ADDING PET...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        )
                            : const Text(
                          'ADD PET',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
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