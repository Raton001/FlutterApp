import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Subpages/answer_form.dart';
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:provider/provider.dart';

class StudentDetailPage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  StudentDetailPage({this.documentSnapshot});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _answer;
  String _question;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentSnapshot.data['name']),
      ),
      body: Column(
        children: <Widget>[
          Card(
              child: Container(
                child: ListTile(
                  title: Text(widget.documentSnapshot.data['name']),
                  subtitle: Text(widget.documentSnapshot.data['gender']),
                ),
              )
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }
}
