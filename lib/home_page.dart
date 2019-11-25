import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    show AppBar, BuildContext, Center, Colors, Column, EdgeInsets, FontWeight, Image, InkWell, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, RaisedButton, Row, Scaffold, State, StatefulWidget, StatelessWidget, Text, TextStyle, Widget;
import 'package:google_sign_in/google_sign_in.dart';
import 'food_page.dart' show FoodScreen;
import 'cafe_page.dart' show CafeScreen;
import 'facilities_page.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser user;
  HomePage(this.user);
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/logo.png', width: 80),
            ],
          )
      ),
      body: Options(user),
    );
  }
}

class Options extends StatefulWidget {
  final FirebaseUser user;
  Options(this.user);
  @override
  OptionsState createState() => new OptionsState(user);
}

class OptionsState extends State<Options> {
  final FirebaseUser user;
  OptionsState(this.user);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Image.asset('images/food.png', width: 270),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodScreen(user) ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Image.asset('images/cafe.png', width: 270),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CafeScreen(user) ),
                  );
                },

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                child: Image.asset('images/geta.png', width: 270),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FacilitiesScreen(user) ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}