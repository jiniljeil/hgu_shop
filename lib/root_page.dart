import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:hgu_shop/home_page.dart';
import 'package:hgu_shop/model/tab_page.dart';
import 'package:hgu_shop/login_page.dart';


class RootPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    //if login / 그냥 들어갈 것인지
    return StreamBuilder<FirebaseUser>(
      // ignore: missing_return
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //로그인 성공시, 데이터가 들어있음
        if (snapshot.hasData) {
          //tabpage는 파이어베이스 유저 데이터를 받는다
          return TabPage(snapshot.data);
        } else {
          return //TabPage(snapshot.data);
            LoginPage();
          //TabPage(snapshot.data);
        }
      },
    );
  }
}