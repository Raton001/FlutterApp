import 'package:flutter_app/services/auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  bool switching = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () async{
                await _auth.signOut();
              },
              child: Card(
                color: Colors.blueGrey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log Out', style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
