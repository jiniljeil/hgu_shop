import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hgu_shop/review/UploadPhoto_page.dart';
import 'package:hgu_shop/review/upload_page.dart';
import 'location_page.dart';
import "package:url_launcher/url_launcher.dart";
import 'favorite_page.dart';


class FoodScreen extends StatelessWidget {
  final List<String> Food = <String>[
    '본카츠야',
    '서가앤쿡',
    '모범떡볶이',
    '라라코스트',
    '오랑 발리',
    '도르리 식당',
    '동궁 찜닭 (양덕점)',
    '토시래',
    '라멘 베라보',
    '9월애',
    '일봉 족발',
    '쌀통닭',
    '신전 떡볶이',
    '논스탠다드',
    '달인의 찜닭',
    '호식이 두마리 치킨',
    '맛찬들 왕소금 구이',  ];

  final FirebaseUser user;
  FoodScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("요식업"),
      ),
      body: ListView.builder(
        itemCount: Food.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            title: Container(
              margin: EdgeInsets.fromLTRB(16, 9, 16, 9),
              child: Row(
                children: <Widget>[
                  Icon(Icons.restaurant),
                  Text('         '),
                  Container(
//                      width: 280.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${Food[index]}', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          Text('place', style: TextStyle(
                            color: Colors.pink[200],
                          ),),
                        ],
                      )
                  )
                ],
              ),
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Screen(idx: index, food: Food[index], user: user),
                ),
              );
            },
          );
        },
      ),
    );

  }
}




class Screen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final int idx;
  final String food;
  final FirebaseUser user;
  const Screen({Key key, this.idx, this.food, this.user}) : super(key: key);

  // In the constructor, require a Todo.


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(food,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              FavoriteWidget(),
            ],
          )

      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          _buildImageSection(idx),
          _buildBotton(idx, food, user),
          _buildTimeSetting(),
          _buildTime(idx),
          _buildBenefitSetting(),
          _buildBenefit(idx),
          _buildMenuSetting(),
          _buildMenu(idx),
        ],
      ),
    );
  }
}


_buildImageSection(int idx){
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text('Loading data...');
            return Column(children: <Widget>[
              Image.network(snapshot.data.documents[idx]['photo2'])
            ],
            );
          }
      )
  );//Image.network('https://scontent-frt3-2.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/68691547_1170594069806054_2682214321596042182_n.jpg?_nc_ht=scontent-frt3-2.cdninstagram.com&oh=a54dd9b0fb9b4aeb0c4493a910f29c8e&oe=5DF0E8F8&ig_cache_key=MjExMjI2OTM3MDg5MjgxNTE5Mw%3D%3D.2',fit:BoxFit.fill);
}

_buildBotton(int idx, String food, FirebaseUser user){
  return Container(
      color: Colors.white,
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data...');
            return Row(
              //crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    //materialTapTargetSize: ,
                    child: _buildButtonItems(Icons.call, 'CALL'),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => _showDialog(idx)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    child:  _buildButtonItems(Icons.place, 'PLACE'),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Food_Store_LocationPage(idx: idx, latitude: snapshot.data.documents[idx]['latitude'], longitud: snapshot.data.documents[idx]['longitude'])),
                        //MaterialPageRoute(builder: (context) => Store_LocationPage(idx: idx)),
                      );
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: _buildButtonItems(Icons.create, 'REVEIW'),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadPage(food, user)),
                      );
                    },
                  ),
                ),
              ],
            );
          })
  );

}

_showDialog(int idx) {
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text('Loading data...');
            _callPhone() async {
              if (await canLaunch(snapshot.data.documents[idx]['''전화 번호'''])) {
                await launch(snapshot.data.documents[idx]['''전화 번호''']);
              } else {
                throw 'Could not Call Phone';
              }
            }
            return AlertDialog(
              title: Text('전화연결'),
              content: Text(snapshot.data.documents[idx]['''전화 번호'''],
                softWrap: true,
                style: TextStyle(
                    color: Colors.grey[500]
                ),),
              // 주석으로 막아놓은 actions 매개변수도 확인해 볼 것.
              actions: <Widget>[
                FlatButton(child: Text('확인', style: TextStyle(color:
                Colors.pinkAccent)), onPressed: _callPhone),
                FlatButton(child: Text('취소', style: TextStyle(color:
                Colors.pinkAccent)), onPressed: () => Navigator.pop(context)),
              ],
            );
          }
      )
  );
}


_buildButtonItems(IconData icon, String name){
  return Column(
    children: <Widget>[
      Icon(icon, color: Colors.grey[700],),
      Text(name, style: TextStyle(
        color: Colors.grey[700],
      )
      ),
    ],
  );
}

_buildTimeSetting(){
  return Container(
    color: Colors.white,
    margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Text('영업시간', style: TextStyle(
      color: Colors.grey[800],
      fontSize: 13,
      fontWeight: FontWeight.bold,)
    ),
  );
}

_buildTime(int idx){
  return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(32, 0, 16, 0),
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text('Loading data...');
            return Container(
                margin: EdgeInsets.all(16),
                child: Text(snapshot.data.documents[idx]['''영업시간'''],
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.grey[500]
                  ),)
            );
          })
  );
}

_buildBenefitSetting(){
  return Container(
    color: Colors.white,
    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Text('HGU 혜택', style: TextStyle(
      color: Colors.grey[800],
      fontSize: 13,
      fontWeight: FontWeight.bold,)
    ),
  );
}

_buildBenefit(int idx){
  return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(32, 0, 16, 0),
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data...');
            return

              Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  snapshot.data.documents[idx]['혜택'], style: TextStyle(
                    color: Colors.grey[500]),
                ),);
          }
      ));
}
_buildMenuSetting(){
  return Container(
    color: Colors.white,
    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Text('주요 메뉴', style: TextStyle(
      color: Colors.grey[800],
      fontSize: 13,
      fontWeight: FontWeight.bold,)
    ),
  );
}

_buildMenu(int idx){
  return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(44, 0, 16, 0),
      child: StreamBuilder(
          stream: Firestore.instance.collection('요식업').snapshots(),
          builder: (context, snapshot) {
            var i = 0;
            List<String> str = List();
            for(i = 0; i<snapshot.data.documents[idx]['items'].length; i++) {
              str.add(snapshot.data.documents[idx]['items'][i]);
            }
            print(str);
            if (!snapshot.hasData) return Text('Loading data...');
            return
              Container(
                  margin: EdgeInsets.all(1),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents[idx]['items'].length,
                      itemBuilder: (context, index){

                        return Container(
                          margin: EdgeInsets.all(1),
                          child: Text('${str[index]}',
                            softWrap: true,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        );
                      })
              );
          }
      ));
}

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("EmptyPage"),
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      if(_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      padding: EdgeInsets.all(0.0),
      child: IconButton(
        icon: (_isFavorited
            ? Icon(Icons.favorite)
            : Icon(Icons.favorite_border, color: Colors.grey[700],)),
        color: Colors.red[500],
        onPressed: _toggleFavorite,
      ),
    );
  }
}