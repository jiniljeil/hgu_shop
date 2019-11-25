// 모캄보 본카츠야 디자인 짐
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hgu_shop/review/upload_page.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'favorite_save_page.dart';
import 'cafe_page.dart';
import 'food_page.dart';
import 'facilities_page.dart';
import 'location_page.dart';
class FavoritePage extends StatefulWidget {
//  final int idx;
//  final String food;
//  final FirebaseUser user;
//
//  FavoritePage({Key key, this.idx,this.food, this.user}) : super(key : key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {



  final Set<String> _saved = Set<String>();
  final List<String> Stores = [
    '모캄보 ',
    '본카츠야',
    '디자인짐'
  ] as List
  ;
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
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: Stores.length,
        itemBuilder: (context, index) {

          var realIndex = index ;

          return _buildRow(Stores.toList()[realIndex]);
        });
  }

  Widget _buildRow(String pair){
    final bool alreadySaved = _saved.contains(pair);
    int i = 0;

    return ListTile(
      title: Container(
        // margin: EdgeInsets.fromLTRB(8, 9, 8, 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.pets),
              // Text('         '),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(pair.toString(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    ],

                  )
              ),
              Text('                   '),
              Icon(Icons.favorite, color: Colors.red[500],)
            ],)
      ),
      onTap: (){
        if(i == 0 ){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                CCScreen(idx: 7, food: '모캄보')),
          );
        }
        // 디테일 페이지로 이동
      },
      /*onTap: (){ // 터치 기능
        setState(() { // 계속 셋팅
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);

            print(_saved.toString()); // 저장되었는지 출력
          }
        });
      },*/
    );
  }
}


class CCScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final int idx;
  final String food;
  // In the constructor, require a Todo.
  CCScreen({Key key, @required this.idx, this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
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
          _buildBotton(idx, food),
          _buildTimeSetting(),
          _buildTime(idx),
          _buildBenefitSetting(),
          _buildBenefit(idx)
        ],
      ),
    );
  }
}


_buildImageSection(int idx){
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
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

_buildBotton(int idx, String food){
  return Container(
      color: Colors.white,
      child: StreamBuilder(
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
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
                        MaterialPageRoute(builder: (context) => Food_Store_LocationPage(idx: idx)),
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
                      FirebaseUser user;
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
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
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
                FlatButton(child: Text('확인'), onPressed: _callPhone),
                FlatButton(child: Text('취소'), onPressed: () => Navigator.pop(context)),
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
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
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

_buildName(int idx){
  return Container(
      margin: EdgeInsets.all(16),
      child: StreamBuilder(
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text('Loading data...');
            return Text(snapshot.data.documents[idx]['''name'''],
              softWrap: true,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:24
              ),);
          }
      ));

}


_buildTitleSection(int idx){
  return Container(
      margin: EdgeInsets.all(16),
      child: StreamBuilder(
          stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text('Loading data...');

            return Row(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(snapshot.data.documents[idx]['''name'''],
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:24
                    ),),
                  Row(
                    children: <Widget>[
                      Text('영업시간', style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,)),
                      Text(snapshot.data.documents[idx]['''영업시간'''],

                        softWrap: true,
                        style: TextStyle(
                            color: Colors.grey[500]
                        ),),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Text('HGU 혜택', style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,)),
                      Text(snapshot.data.documents[idx]['혜택'],style: TextStyle(
                          color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            );
          }));
}


_buildButtonSection(int idx){
  return Container(
    margin: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
//        new GestureDetector(
//        onTap: () => Navigator.push(_buildButtonItem(Icons.call, Colors.pink, 'CALL'),
//            MaterialPageRoute(builder: (context) => Store_LocationPage())),

        _buildButtonItem(Icons.call, Colors.pink, 'CALL'),
        _buildButtonItem(Icons.place, Colors.pink, 'PLACE'),
        _buildButtonItem(Icons.favorite_border, Colors.pink, 'LIKE'),
      ],
    ),
  );
}

_buildButtonItem(IconData icon, MaterialColor color, String name){
  return Column(
    children: <Widget>[
      Icon(icon, color: color,),
      Text(name, style: TextStyle(color: color),),
    ],
  );
}

_buildTextSection(){
  return Container(
    margin: EdgeInsets.all(16),
    //child:
  );
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
  bool _isFavorited = true;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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