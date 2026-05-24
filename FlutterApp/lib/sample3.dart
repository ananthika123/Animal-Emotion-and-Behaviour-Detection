// 🌐💫 Flutter Power: Handling Data from Django → Setting Dropdown Values 💫🌐

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class add_pet extends StatefulWidget {
  @override
  _add_petState createState() => _add_petState();
}

class _add_petState extends State<add_pet> {

  // 🔹 STEP 1: Declare Panchayath data list
  List<Map<String, dynamic>> breed = [];  // ✅ Holds data fetched from Django

  // 🔹 STEP 2: Store selected Panchayath
  String? selectedBreed;  // ✅ Holds selected Panchayath ID

  // ================================
  // 🔹 STEP 3: Load data from Django
  // ================================
  Future<void> load_breed() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse("${sh.getString('ip')}/load_breed"), // replace with your function
      );
      var decode = json.decode(response.body);
      decode['data'].forEach((item){
        setState(() {
          breed.add({
            // ✅ ID from Django model
            // ✅ Panchayath name field

            item['id'].toString():
            item['name'].toString()});


        });
        print(breed);

      });

    } catch (e) {
      print("Error fetching breed: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    load_breed(); // ✅ Call function on screen load
  }

  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(title: Text("ADD PET")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ================================
            // 🔹 STEP 4: Panchayath Dropdown UI
            // ================================
            SizedBox(
              width: fieldWidth,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  value: selectedBreed,                // ✅ Selected Value
                  hint: Text('Select breed'),          // ✅ Placeholder
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.green),
                  onChanged: (value) {
                    setState(() {
                      selectedBreed = value;           // ✅ Store selected
                    });
                  },
                  items: breed.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["id"].toString(),          // ✅ ID as value
                      child: Text(item["name"].toString()),  // ✅ Display name
                    );
                  }).toList(),
                ),
              ),
            ),




            SizedBox(height: 20),

            // 🔹 Button to check selected value
            ElevatedButton(
              onPressed: () {
                print("Selected breed ID: $selectedBreed");
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}