import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hgu_shop/review/posts.dart';


class UploadPage extends StatefulWidget {
  final String name;
  final FirebaseUser user;
  UploadPage(this.name, this.user);


  @override
  _UploadPageState createState() => _UploadPageState(user, name);

}


class _UploadPageState extends State<UploadPage> {
  List<Posts> postMessages = List();
  Posts posts;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseUser user;
  final String name;

  DatabaseReference databaseReference;

  _UploadPageState(this.user, this.name);
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
        title: Text('리뷰', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5, bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                //color: Colors.white,
                margin: EdgeInsets.fromLTRB(30, 0, 0, 15),
                child:  Text(name, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              child: Image.asset('images/리뷰남기기.png', width: 300),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewPage(user: user, name: name) ),
                );
              },
            ),
          ),


//          Padding(padding: EdgeInsets.only(top: 20, bottom: 10)),


          Flexible(
            child: FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if(name != postMessages[index].name) return Row();
                  return Container(
                    decoration: BoxDecoration(color: Colors.white,
                      border: Border.all(color: Colors.grey[200]),),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              )),
                          title: Text(postMessages[index].subject, style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,)
                          ),
                          subtitle: Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(postMessages[index].body,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.grey[500]
                                ),)
                          ),
                        )

                      ],
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


class ReviewPage extends StatefulWidget {

  final String name;
  final FirebaseUser user;

  const ReviewPage({Key key, this.name, this.user}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState(user, name);

}


class _ReviewPageState extends State<ReviewPage> {
  List<Posts> postMessages = List();
  Posts posts;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseUser user;
  final String name;


  DatabaseReference databaseReference;

  _ReviewPageState(this.user, this.name);

  @override
  void initState() {
    super.initState();

    posts = Posts("", "" , "");
    databaseReference = database.reference().child("post_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
    posts.name = name;
    posts.subject = user.displayName;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
//                InkWell(
//                  child: Text('취소', style: TextStyle(color: Colors.pink, fontSize: 14)),
//                  onTap: () => UploadPage(name: name),
//                ),
              Text('리뷰 작성', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              InkWell(
                child: Text('확인', style: TextStyle(color: Colors.pink, fontSize: 14)),
                onTap: () =>  _submitPostForm(),
              ),
            ]
        ),
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "  가게에 대한 평을 남겨주세요"
                          ),
                          initialValue: "",
                          onSaved: (value) => posts.body = value,
                          validator: (value) => value == "" ? value : null),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    posts.name = name;

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

//                    Card(
//                    child: ListTile(
//                      leading: Container(
//                          width: 30.0,
//                          height: 30.0,
//                          decoration: BoxDecoration(
//                              image: DecorationImage(image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
//                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                              )),
//                      title: Text(postMessages[index].subject),
//                      subtitle: Text(postMessages[index].body),
//                    ),
//                  );