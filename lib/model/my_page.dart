import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hgu_shop/review/UploadPhoto_page.dart';
import 'package:hgu_shop/review/posts.dart';
import 'package:hgu_shop/review/upload_page.dart';

class MyPage extends StatelessWidget {
  final FirebaseUser user;
  MyPage(this.user);
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//            title: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Image.asset('images/logo.png', width: 80),
//              ],
//            )
//        ),
        body: Stack(
          children: <Widget>[
            //바탕화면 색깔 핑꾸
            ClipPath(
              child: Container(color: Colors.pinkAccent.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)])),
                    SizedBox(height: 40.0),
                    Text(user.displayName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
                    SizedBox(height: 10.0),
                    Text(user.email, style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic, fontFamily: 'Montserrat'),),
                    SizedBox(height: 35.0),
                    Container(
                        height: 40.0,
                        width: 350.0,
                        child: Material(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ReviewList())
                              );},
                            child: Center(
                                child: InkWell(
                                  child: Image.asset('images/review.png'),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => MyRiviewPage(user))
                                    );
                                  },
                                )
                              //Text('My review', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),),
                            ),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                        height: 40.0,
                        width: 350.0,
                        child: Material(
                          child: GestureDetector(
                            child: Center(
                              child: InkWell(
                                child: Image.asset('images/logout.png', width: 270,),
                                onTap: (){
                                  FirebaseAuth.instance.signOut();
                                  _googleSignIn.signOut();
                                  print("User Sign Out");
                                },
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ));

  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

//// TODO: 내가 작성한 리뷰 목록 보여줄거야아ㅏ아
class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("내가 남긴 리뷰",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}




class MyRiviewPage extends StatefulWidget {
  final FirebaseUser user;
  MyRiviewPage(this.user);
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  @override
  _MyRiviewPageState createState() => _MyRiviewPageState(user);

}


class _MyRiviewPageState extends State<MyRiviewPage> {
  List<Posts> postMessages = List();
  Posts posts;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseUser user;

  DatabaseReference databaseReference;

  _MyRiviewPageState(this.user);
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  void initState() {
    super.initState();

    posts = Posts("" ,"", "");
    databaseReference = database.reference().child("post_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY리뷰', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5, bottom: 10)),

          Flexible(
            child: FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if(user.displayName != postMessages[index].subject) return Row();
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.message),
                      ),
                      title: Text(postMessages[index].name),
                      subtitle: Text(postMessages[index].body),
                    ),
                  );
                }),
          ),

        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      postMessages.add(Posts.fromSnapshot(event.snapshot));
    });
  }

  void _submitPostForm() {
    final FormState state = formKey.currentState;

    if (state.validate()) {
      state.save();
      state.reset();

      databaseReference.push().set(posts.toJson());
    }
  }

  void _onEntryChanged(Event event) {
    var oldData = postMessages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      postMessages[postMessages.indexOf(oldData)] =
          Posts.fromSnapshot(event.snapshot);
    });
  }
}