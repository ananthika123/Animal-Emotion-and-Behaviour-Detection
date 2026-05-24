import 'dart:convert';

import 'package:aura/home.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'worker_add_service.dart';
import 'package:http/http.dart' as http;



// void main() {
//   runApp(MyApp());
// }
//
class animalview extends StatefulWidget {
  const animalview({Key? key, this.title="View Pets"}) : super(key: key);

  final String title;

  @override
  _animalview_State  createState() => _animalview_State();

}

class _animalview_State  extends State<animalview> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid').toString();

    var data =
    await http.post(Uri.parse(prefs.getString("ip").toString()+"/view_animal"),
        body: {"uid":uid}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["data"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["name"].toString(),
        prefs.getString("ip").toString()+ joke["photo"].toString(),
        joke["detail"].toString(),

      );
      jokes.add(newJoke);
    }
    return jokes;
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
        title: Text(widget.title),
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
                            _buildRow("id:", snapshot.data[index].id.toString()),
                            _buildRow("name:", snapshot.data[index].name.toString()),
                            _buildRow("photo:", snapshot.data[index].photo.toString()),
                            Image.network(snapshot.data[index].photo, height: 200, width: 200, fit: BoxFit.cover,),
                            _buildRow("detail:", snapshot.data[index].detail.toString()),


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
  final String name;
  final String photo;
  final String detail;
  Joke(this.id,this.name, this.photo,this.detail);
//  print("hiiiii");
}