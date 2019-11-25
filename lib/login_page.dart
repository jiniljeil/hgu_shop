import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hgu_shop/model/tab_page.dart';

class LoginPage extends StatelessWidget{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
              )
              ,
              Image.asset('images/firstlogo.png', width: 180),
              /*Text('HGU Shop',
                    style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),*/
              Padding(
                padding: EdgeInsets.all(80.0),
              ),
              /*SignInButton(
                    Buttons.Google,
                    onPressed: (){
                      _handleSignIn().then((user){
//                  print('TEST');
//                  print(user);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => TabPage(user)));
                      });
                    },
                  )*/
              Padding(padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Image.asset('images/login.png', width: 180),
                  onTap: (){
                    _handleSignIn().then((user){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => TabPage(user))
                      );
                    }
                    );
                  },
                ),
              )
              /*SignInButton(
                    Buttons.GoogleDark,
                    onPressed: (){}
                  )*/
            ],
          ),
        ),
      ),

    );
  }

  //비동기
  //firebase와 연결
  Future<FirebaseUser> _handleSignIn() async{
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))) as FirebaseUser;
    return user;
  }
}