import 'package:flutter/material.dart';

void main(){
  runApp(editAnimal());
}
class editAnimal extends StatelessWidget {
  const editAnimal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:editAnimalsub());
  }
}
class editAnimalsub extends StatefulWidget {
  const editAnimalsub({Key? key}) : super(key: key);

  @override
  State<editAnimalsub> createState() => _editAnimalsubState();
}

class _editAnimalsubState extends State<editAnimalsub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Center(child: SingleChildScrollView(child: Column(children: [
      Text("EDIT ANIMAL",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
      SizedBox(height: 20,),
      SizedBox(width: 200,child:  TextField(decoration: InputDecoration(hintText: "enter name",labelText: "name",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.person))),),

      SizedBox(height:20,),
      SizedBox(width: 200,child: TextField(decoration: InputDecoration(hintText: "enter photo",labelText: "photo",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.image))),),


      SizedBox(height: 20,),
      SizedBox(width: 200,child: TextField(decoration: InputDecoration(hintText: "enter age",labelText: "age",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.numbers))),),

      SizedBox(height: 20,),
      SizedBox(width: 200,child: TextField(decoration: InputDecoration(hintText: "enter description",labelText: "description",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.text_fields))),),

      SizedBox(height: 20,),
      ElevatedButton(onPressed: (){

      }, child: Text("EDIT"))

    ],)))
    );
  }
}

