import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:typed_data';

import 'home.dart';

void main(){
  runApp(add_missing_item());
}

class add_missing_item extends StatelessWidget {
  const add_missing_item({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: add_missing_itemsub(),);
  }
}

class add_missing_itemsub extends StatefulWidget {
  const add_missing_itemsub({Key? key}) : super(key: key);

  @override
  State<add_missing_itemsub> createState() => _add_missing_itemsubState();
}

class _add_missing_itemsubState extends State<add_missing_itemsub> {

  final item_name=new TextEditingController();
  final description=new TextEditingController();
  final location =new TextEditingController();

  //step1

  PlatformFile? _selectedFile;
  Uint8List? _webFileBytes;
  String? _result;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any, // Any file type allowed
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        _result = null;
      });

      if (kIsWeb) {
        _webFileBytes = result.files.first.bytes;
      }
    }
  }

  //endstep1

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child:
    SingleChildScrollView(child:
    SizedBox(height: 500,width: 500,child:
    Column(children: [

      ElevatedButton.icon(
        icon: Icon(Icons.upload_file),
        label: Text("Select File"),
        onPressed: _pickFile,
      ),
      if (_selectedFile != null) ...[
        SizedBox(height: 10),
        Text("Selected: ${_selectedFile!.name}"),
      ],
      SizedBox(height: 20),            TextField(controller: item_name,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'enter item name',
          labelText: 'item name',
        ),),SizedBox(height: 20,),
      TextField(controller: description,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: 'enter description',
            labelText: 'description',
            border: OutlineInputBorder()
        ),),SizedBox(height: 20,),
      TextField(controller: location,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'enter location',
          labelText: 'location',
        ),),SizedBox(height: 20,),



      ElevatedButton(onPressed: () async {
        print(item_name.text);
        print(description.text);
        print(location.text);

        SharedPreferences sh=await SharedPreferences.getInstance();
        // var data=await http.post(Uri.parse('${sh.getString('ip')}/aadd_missing_item'),
        // body: {'item':item_name.text,'des':description.text,
        //   'loc':location.text,'uid':sh.getString('uid').toString()});


        var request =   await http.MultipartRequest('POST',Uri.parse('${sh.getString('ip')}/aadd_missing_item'));

        //Normal data

        request.fields['item'] = item_name.text;
        request.fields['des'] = description.text;
        request.fields['loc'] = location.text;
        request.fields['uid'] = sh.getString('uid').toString();

        //endNormal data


        //File part
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

        //  endfilepart

        var response = await request.send();

        Navigator.push(context, MaterialPageRoute(builder: (context)=>home()));
        // var decodeddata=json.decode(data.body);


      }, child: Text('send'))

    ],),),),),);
  }
}