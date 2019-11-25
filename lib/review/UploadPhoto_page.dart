//import 'package:flutter/material.dart';
//import 'package:hgu_shop/review/upload_page.dart';
//import 'package:intl/intl.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
//import 'write_page.dart';
//
//class UploadPhotoPage extends StatefulWidget {
//
//  @override
//  _UploadPhotoPageState createState() => _UploadPhotoPageState();
//}
//
//class _UploadPhotoPageState extends State<UploadPhotoPage> {
//  File sampleImage;
//  String _myValue;
//  String url;
//
//  final formKey = GlobalKey<FormState>();
//  //await을 써야해서 future로 return
//  Future getImage() async {
//    //비동기 처리
//    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
//    //image를 바꿔줘야함
//    //이미지 상태에 따라서 바뀌어야 함
//    setState(() {
//      sampleImage = tempImage;
//    });
//  }
//
//  bool validateAndSave() {
//    final form = formKey.currentState;
//
//    if (form.validate()) {
//      form.save();
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  void uploadStatusImage() async {
//    if (validateAndSave()) {
//      final StorageReference postImageRef = FirebaseStorage.instance.ref()
//          .child("Post Images");
//
//      var timeKey = new DateTime.now();
//
//      final StorageUploadTask uploadTask = postImageRef.child(
//          timeKey.toString() + ".jpg").putFile(sampleImage);
//
//      var Imageurl = await(await uploadTask.onComplete).ref.getDownloadURL();
//
//      url = Imageurl.toString();
//
//      print("Image Url = " + url);
//
//    }
//  }
//
//  void saveToDatabase(url) {
//    var dbTimeKey = DateTime.now();
//    var formatDate = DateFormat('MMM d, yyyy');
//    var formatTime = DateFormat('EEEE, hh:mm aaa');
//
//    String date = formatDate.format(dbTimeKey);
//    String time = formatTime.format(dbTimeKey);
//
//    DatabaseReference ref = FirebaseDatabase.instance.reference();
//
//    var data = {
//      "image": url,
//      "description": _myValue,
//      "data": date,
//      "time": time,
//    };
//
//    ref.child("Posts").push().set(data);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Upload Page",
//          style: TextStyle(color: Colors.pink),
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.edit),
//            color: Colors.pink,
//            onPressed: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => WritePage())
//              );
//            },
//          ),
//          IconButton(icon: Icon(Icons.search),
//              color: Colors.pink,
//              onPressed: () {
//                showSearch(context: context, delegate: DataSearch());
//              }),
//        ],
//      ),
//      //drawer: Drawer(), // Search Function
//      body: Center(
//        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
//      ),
//
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: getImage,
//        tooltip: 'Add Image',
//        icon: Icon(Icons.add_a_photo, color: Colors.pink),
//        label: Text("Add Image"),
//        foregroundColor: Colors.pink,
//        backgroundColor: Colors.white,
//      ),
//    );
//  }
//
//  Widget enableUpload() {
//    return Container(
//      child: Form(
//        key: formKey,
//        child: ListView(
//          children: <Widget>[
//            Image.file(sampleImage, height: 310.0, width: 660.0,),
//
//            SizedBox(
//              height: 15.0,
//            ),
//            TextFormField(
//              decoration: InputDecoration(labelText: 'Description'),
//              validator: (value) {
//                return value.isEmpty ? 'Blod Description is required' : null;
//              },
//              onSaved: (value) {
//                return _myValue = value;
//              },
//            ),
//
//            SizedBox(height: 15.0,),
//
//            RaisedButton(
//              elevation: 10.0,
//              child: Text("Add a New Post"),
//              textColor: Colors.pink,
//              color: Colors.white,
//
//              onPressed:
//                uploadStatusImage,
//
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//
//  void goToReviewList() {
//    Navigator.push(context,
//      MaterialPageRoute(builder: (context) {
//        return UploadPage();
//      }
//      ),
//    );
//  }
//
//}
//
//// Search Page (아래)
//class DataSearch extends SearchDelegate<String> {
//
//  final Stores=[
//    '엽기떡볶이',
//    'raracost',
//    '롯데리아',
//    '맥도날드',
//    '신전떡볶이',
//    '투썸플레이스',
//    '스타벅스',
//    '설빙',
//    '한동대 편의점',
//    '한동대 매점',
//    '이디야',
//    '학관',
//  ];
//
//  final recentStores = [
//    '한동대 편의점',
//    '한동대 매점',
//    '이디야',
//    '학관',
//    '엽기떡볶이',
//    'raracost',
//    '롯데리아',
//    '맥도날드',
//    '신전떡볶이',
//    '투썸플레이스',
//    '스타벅스',
//    '설빙',
//  ];
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    // actions for app bar
//    return [
//      IconButton(icon: Icon(Icons.clear), onPressed: () {
//        query = "";
//      })
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // leading icon on the left of the app bar
//    return IconButton(icon: AnimatedIcon(
//        icon: AnimatedIcons.menu_arrow,
//        progress: transitionAnimation),
//        onPressed: (){
//          //close(context, null);
//        });
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    // show some result based on the selection
//    return Container( // 이건 예시이므로 한개의 함수를 만들고
//      height: 100.0, //그 안에 다른 함수들을 넣어 각 경우 마다 page를 달리한다.
//      width: 100.0,
//      child: Card(
//        color: Colors.pink,
//        shape: StadiumBorder(),
//        child: Center(
//          child: Text(query),
//        ),
//      ),
//    );
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // show when someone searchs for something
//    final suggestionList = query.isEmpty
//        ?recentStores
//        :Stores.where((p) => p.startsWith(query)).toList(); // 유사한 글자로 찾아주는 기능
//
//    return ListView.builder(
//      itemBuilder: (context,index) => ListTile(
//        onTap: (){
//          showResults(context);
//        },
//        leading: Icon(Icons.location_city), // Icon 변경 가능
//        title: RichText(text: TextSpan(
//            text: suggestionList[index].substring(0,query.length),
//            style: TextStyle(
//                color: Colors.black, fontWeight: FontWeight.bold
//            ),
//            children: [TextSpan(
//                text: suggestionList[index].substring(query.length),
//                style: TextStyle(color: Colors.grey)
//            )]
//        ),
//        ),
//      ),
//      itemCount: suggestionList.length,
//    );
//  }
//}
//
