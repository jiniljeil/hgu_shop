import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show AppBar, BuildContext, Colors, Container, EdgeInsets, FontWeight, MediaQuery, Scaffold, Stack, State, StatefulWidget, StreamBuilder, Text, TextStyle, Widget;
// ignore: implementation_imports
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
class Cafe_Store_LocationPage extends StatefulWidget {
  final int idx;
  final double latitude;
  final double longitud;

  const Cafe_Store_LocationPage({Key key, this.idx, this.latitude, this.longitud}) : super(key: key);

  @override
  _Cafe_Store_LocationPageState createState() => _Cafe_Store_LocationPageState(idx,latitude,longitud);
}

// ignore: camel_case_types
class _Cafe_Store_LocationPageState extends State<Cafe_Store_LocationPage> {
  List<Marker> allMarkers=[];
  final int idx;
  final double latitude;
  final double longitud;

  _Cafe_Store_LocationPageState(this.idx, this.latitude, this.longitud);
//  double latitude = 36.055427 ;
//  double longitud = 129.363059;





  @override
  void initState(){
    super.initState();
    allMarkers.add(Marker(markerId: MarkerId(' '),

        draggable: false, // marker 드래그 불가능 상태

        onTap: (){
          print('Marker Tapped');
        },
        position: LatLng(latitude, longitud)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: Firestore.instance.collection('카페 및 베이커리').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading data...');
              return

                Container(
                    margin: EdgeInsets.all(16),
                    child: Text(
                      snapshot.data.documents[idx]['name'], style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),));
            }
        ),
      ),

      body: Stack(
          children: [Container( // 기준이되는 Marker
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            GoogleMap(initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitud), // 한동대 위도 경도
                zoom: 15.0
            ),
              markers: Set.from(allMarkers), // marker
              // onMapCreated: mapCreated,
            ),
          ),
          ]
      ),
    );
  }
}