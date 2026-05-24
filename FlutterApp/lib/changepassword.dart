import 'package:flutter/material.dart';

void main(){
  runApp(changepassword());
}
class changepassword extends StatelessWidget {
  const changepassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:changepasswordsub());
  }
}
class changepasswordsub extends StatefulWidget {
  const changepasswordsub({Key? key}) : super(key: key);

  @override
  State<changepasswordsub> createState() => _changepasswordsubState();
}

class _changepasswordsubState extends State<changepasswordsub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Center(child: SingleChildScrollView(child: Column(children: [
      Text("CHANGE PASSWORD",style: TextStyle(fontSize: 40,fontWeight:FontWeight.bold),),
      SizedBox(height: 20,),
      SizedBox(width: 200,child:  TextField(decoration: InputDecoration(hintText: "enter current password",labelText: "current password",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.password))),),

      SizedBox(height:20,),
      SizedBox(width: 200,child: TextField(decoration: InputDecoration(hintText: "enter new password",labelText: "new password",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.password))),),


      SizedBox(height: 20,),
      SizedBox(width: 200,child: TextField(decoration: InputDecoration(hintText: "confirm password",labelText: "confirm password",
          border: OutlineInputBorder(borderRadius:
          BorderRadius.circular(12)),prefixIcon:
          Icon(Icons.password))),),

      SizedBox(height: 20,),
      ElevatedButton(onPressed: (){

      }, child: Text("CHANGE PASSWORD"))

    ],)))
    );
  }
}

