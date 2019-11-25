import 'package:flutter/material.dart';
import 'package:hgu_shop/root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.white,
        ),
      home: RootPage(),
    );
  }
}

