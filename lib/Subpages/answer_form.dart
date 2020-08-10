import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Subpages/answer_page.dart';
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/answer.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:provider/provider.dart';

class AnswerForm extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  AnswerForm({this.documentSnapshot});

  @override
  _AnswerFormState createState() => _AnswerFormState();
}

class _AnswerFormState extends State<AnswerForm> {

  final _formKey = GlobalKey<FormState>();
  String _answer;
  String _question;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UsersData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: <Widget>[
                SizedBox(height: 5,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Answer'),
                  onChanged: (val) => setState(() => _answer = val),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  color: Colors.green,
                  child: Text("Answer", style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      _question = widget.documentSnapshot.documentID;
                      await DatabaseService(uid: user.uid).addAnswer(_answer, _question);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      },
    );
  }
}
