import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'note.dart';
import '../cafe_page.dart';
import '../facilities_page.dart';
import '../food_page.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  final FirebaseUser user;
  SearchPage(this.user);
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  @override
  _SearchPageState createState() => _SearchPageState(user);
}

class _SearchPageState extends State<SearchPage> {

  final List<String> Stores = <String> [
    '본카츠야',
    '서가앤쿡',
    '모범떡볶이',
    '라라코스트',
    '오랑 발리',
    '도르리 식당',
    '동궁 찜닭',
    '토시래',
    '라멘 베라보', // 8
    '9월애',
    '일봉 족발',
    '쌀통닭',
    '신전 떡볶이',
    '논스탠다드',
    '달인의 찜닭',
    '호식이 두마리 치킨',
    '맛찬들 왕소금 구이',
    '투썸 플레이스',
    '달콤커피 장성점',
    '카페콩',
    '디저트39',
    '양덕동 마카롱',
    '잇브레드',
    '클래식 북스',
    '모캄보',
    '엣지브라운', // 25
    '미즈앤맘 산부인과',
    '포항온천',
    '디자인짐',
    '라안요가 필라테스',
    '양덕광천수온천',
    '클푸',
    '다비치 안경',
    'ABC볼링장',
    '알파 문구 양덕',
    '밝은성모안과',
    '만화라떼 24시',
    '바디 팩토리',
    '이가자 헤어비스',
    '바이크 엣지',
    '중앙콘택트안경점',
    '극동렌트카',
    'only u gym',
    '메디컬 닥터스',
  ];

  List<Note> _notes = List<Note>();

  List <Note> _notesForDisplay = List<Note>();
  final FirebaseUser user;
  _SearchPageState(this.user);


  Future<List<Note>> fetchNotes() async {
    var url = 'https://raw.githubusercontent.com/jiniljeil/Coding/master/note';
    var response = await http.get(url);

    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  String filter ;



  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    final suggestionList = filter.isEmpty
//        ?recentStores
//        :Stores.where((p) => p.startsWith(filter)).toList();
//    return DataSearch();

//    return Scaffold(
//      appBar: AppBar(
//        title: Image.asset('images/logo.png', width: 80),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.search,),
//              onPressed: (){
//                showSearch(context: context, delegate: DataSearch());
//              })
//        ],
//      ),
//      body: Center(child: Photo()),

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Image.asset('images/logo.png', width: 100),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    _search(),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _notesForDisplay.length,
                        itemBuilder: (context, index){
//                          return index == 0 ? _search() : _list(index-1);
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 30.0, right: 30.0),
                            onTap: (){
                              var i = 0;
                              var j = 0;
                              var _index = 0;
                              var check = 0;
                              var newindex = [ ];
                              for(i = 0; i < 44; i++) {
                                if (_notesForDisplay[index].title == Stores[i]) {
                                  newindex.add(index);
                                  check = i;
                                  break;
                                }
                              }
                              if(filter != ""){
                                if(check <= 16){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Screen(user: user, idx: i, food: _notesForDisplay[index].title)));
                                }
                                else if(check > 16 && check<=25){
                                  _index = check -17;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CScreen(user: user, idx: _index, Cafe: _notesForDisplay[index].title)));
                                }
                                else if(check > 25 && check < 44){
                                  _index = check - 26;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => FScreen(user: user, idx: _index, facility: _notesForDisplay[index].title)));
                                }
                              }else{ //검색안하고 page 이동
                                if(check <= 16){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Screen(user: user, idx: i, food: _notesForDisplay[index].title)));
                                }else if(check > 16 && check<=25){
                                  _index = check -17;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CScreen(user: user, idx:_index, Cafe: _notesForDisplay[index].title)));
                                }else{
                                  _index = check - 26;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => FScreen(user: user, idx:_index, facility: _notesForDisplay[index].title)));
                                }
                              }
                            },

                            title: Text(
                              '${_notesForDisplay[index].title}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            leading: Icon(Icons.store),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  _search(){
    return Padding(
        padding: EdgeInsets.only(top: 8.0, left: 30.0, bottom: 8.0, right: 30.0),
        child: Theme(
          data: ThemeData(
              primaryColor: Colors.pink
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search , color: Colors.pink,),

              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.pink)
              ),

            ),
            onChanged: (text){
              text = text.toLowerCase();
              filter = text;
              setState(() {
                _notesForDisplay = _notes.where((note){
                  var notetitle = note.title.toLowerCase();
                  return notetitle.contains(text);
                }).toList();
              });
            },
          ),
        )
    );
  }

//  _list(index) {
//    return Card(
//    child:Padding(
//        padding: EdgeInsets.all(8.0),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(
//              _notesForDisplay[index].title,
//              style: TextStyle(
//                fontSize: 15,
//                fontWeight: FontWeight.bold
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }

}



class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox.expand(
      child: Image.asset(
          'images/photo3.png',
          fit: BoxFit.cover
      ),
    );

  }
//  @override
////  Widget build(BuildContext context) {
////    return Column(children: <Widget>[
////      Row(children: <Widget>[
////        makeImage(BoxFit.fill),
////        makeImage(BoxFit.fill),
////      ]),
////      Row(children: <Widget>[
////        makeImage(BoxFit.fill),
////        makeImage(BoxFit.fill),
////      ]),
////      Row(children: <Widget>[
////        makeImage(BoxFit.fill),
////        makeImage(BoxFit.fill),
////      ]),
////    ]);
}

//  Widget makeImage(BoxFit option) {
//    return Container(
//      child: Image.asset('images/photo.jpeg', width: , height: 150, fit: option),
//      padding: EdgeInsets.only(left: 2, right: 2, bottom: 1),
//    );
//  }
//}