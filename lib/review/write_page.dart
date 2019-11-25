import 'dart:io'; // File image  File에서 import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // package 추가 !!

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _formKey = GlobalKey<FormState>();
  String error = '공백은 허용되지 않습니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review',
          style: TextStyle(color: Colors.pink),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //_decideImageView(),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: ' 제목을 입력해 주세요.',
                        labelText: '  제목',
                      ),
                      autofocus: false,

                      validator: (value) {
                        if(value.isEmpty){
                          return error;
                        }
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 7.0),
                      height: 300.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextFormField(
                        maxLines: 10,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: ' 내용을 입력해 주세요.',
                         // controller: textEditingController,
                          border: InputBorder.none,
                          labelText: '  내용',

                        ),
                        autofocus: false,

                        validator: (value) {
                          if(value.isEmpty){
                            return error;
                          }
                        },
                      ),
                    ),
                  ],
                )
                ,)
            ],
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        icon: Icon(Icons.edit, color: Colors.white,),
        label: Text("Post Up"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink,
      ),
    );
  }
}