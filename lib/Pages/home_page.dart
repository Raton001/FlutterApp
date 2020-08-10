
import 'package:flutter_app/Pages/main_page.dart';
import 'package:flutter_app/Pages/profile_page.dart';
import 'package:flutter_app/Pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final heroTag;
  final name;

  const HomePage({Key key, this.heroTag, this.name}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuthorize = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  var _currentIndex = 1;

  List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    MainPage(),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Finder'),

      ),
      backgroundColor: Color(0xFFF0F0F0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items:const <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.account_box), title: Text('Profile')),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
    );
  }

}
