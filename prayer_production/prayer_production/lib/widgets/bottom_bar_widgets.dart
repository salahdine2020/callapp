import 'package:flutter/material.dart';
import 'package:prayer_production/views/accueil.dart';
import 'package:prayer_production/views/favorite_mosques.dart';
import 'package:prayer_production/views/profile.dart';
import 'package:prayer_production/views/profile_inf.dart';
import 'package:prayer_production/widgets/search_mosque.dart';

class HomeMainBottomBar extends StatefulWidget {
  HomeMainBottomBar({Key key}) : super(key: key);

  @override
  _HomeMainBottomBarState createState() => _HomeMainBottomBarState();
}

class _HomeMainBottomBarState extends State<HomeMainBottomBar> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  List<String> _appBarTitle = ['Home', 'Search', 'Favourite', 'Profile'];

  @override
  void initState() {
    super.initState();
    _children.add(
      /// maybe return to AppBar declared
      AccueilPage(),
    );
    _children.add(
      AppBarSearchExample(),
    );
    _children.add(
        FavoriteItemPage(),
    );
    _children.add(
        ProfileScreen(),
      //ProfilePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: _body_containt(),//_body(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _body() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.redAccent),
            actions: <Widget>[],
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: true,
            title: Text(
              _appBarTitle[_currentIndex],
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ];
      },
      body: _children[_currentIndex],
    );
  }

  Widget _body_containt() {
    return _children[_currentIndex];
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _onTabTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.teal,
    );
  }

  _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
  }
}
