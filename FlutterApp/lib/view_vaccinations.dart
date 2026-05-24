import 'dart:convert';

import 'package:aura/home.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'worker_add_service.dart';
import 'package:http/http.dart' as http;

class vaccination_view extends StatefulWidget {
  const vaccination_view({Key? key}) : super(key: key);


  @override
  _vaccination_view_State  createState() => _vaccination_view_State();

}

class _vaccination_view_State  extends State<vaccination_view> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid').toString();

    var data =
    await http.post(Uri.parse(prefs.getString("ip").toString()+"/user_view_vaccination"),
        body: {"uid":uid}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["data"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["age"].toString(),
        joke["breed"].toString(),
        joke["title"].toString(),
        joke["date"].toString(),
        joke["description"].toString(),
        prefs.getString("ip").toString()+ joke["photo"].toString(),

      );
      jokes.add(newJoke);
    }
    return jokes;
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
          },
        ),
        backgroundColor:Colors.teal,
        title: Text("Vaccinations"),
      ),
      body:


      Container(

        child:
        FutureBuilder(
          future: _getJokes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
//              print("snapshot"+snapshot.toString());
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 10),
                            Image.network(snapshot.data[index].photo, height: 200, width: 300, fit: BoxFit.cover,),
                            _buildRow("Age", snapshot.data[index].age.toString()),
                            _buildRow("Breed", snapshot.data[index].breed.toString()),
                            _buildRow("Vaccine", snapshot.data[index].title.toString()),
                            _buildRow("Date", snapshot.data[index].date.toString()),
                            _buildRow("Description", snapshot.data[index].description.toString()),


                            Row(children: [
                              ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences sh = await SharedPreferences.getInstance();

                                  var request = http.MultipartRequest(
                                    'POST',
                                    Uri.parse('${sh.getString('ip')}/user_delete_vaccination'),
                                  );

                                  // Normal data
                                  request.fields['vid'] = snapshot.data[index].id.toString();


                                  var response = await request.send();

                                  if (response.statusCode == 200) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: Colors.white),
                                              SizedBox(width: 12),
                                              Text('Vaccination deleted successfully!'),
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
                                          MaterialPageRoute(builder: (context) => vaccination_view()),
                                        );
                                      });
                                    }
                                  } else {
                                    print("Delete failed: ${response.statusCode}");
                                    _showErrorSnackBar('Detlete failed. Please try again.');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadowColor: const Color(0xFF4158D0).withOpacity(0.5),
                                ),
                                child: const Text(
                                  'Delete Vaccination',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],)

                          ],
                        ),
                      ),
                    ),
                  );
                },
              );


            }
          },


        ),





      ),
    );
  }
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Joke {
  final String id;
  final String age;
  final String breed;
  final String title;
  final String date;
  final String description;
  final String photo;
  Joke(this.id,
      this.age,
      this.breed,
      this.title,
      this.date,
      this.description,
      this.photo);
//  print("hiiiii");
}