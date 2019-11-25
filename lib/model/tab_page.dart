import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hgu_shop/favorite_page.dart';
import 'package:hgu_shop/home_page.dart' as prefix0;
import '../home_page.dart';
import 'my_page.dart';
import 'search_page.dart';

class TabPage extends StatefulWidget {
  final FirebaseUser user;
  TabPage(this.user);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  List _pages;
  @override
  void initState(){
    super.initState();
    _pages = [
      HomePage(widget.user),
      SearchPage(widget.user),
      FavoritePage(),
      MyPage(widget.user),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//       title: Text('HGU Shop'),
//      ),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.pinkAccent,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('favorite')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('My page')),
          ]),
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
}