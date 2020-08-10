import 'package:flutter_app/Pages/authenticate.dart';
import 'package:flutter_app/Pages/home_page.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null){
      return Authenticate();
    } else{
      print(user.uid);
      return HomePage();
    }


  }
}
