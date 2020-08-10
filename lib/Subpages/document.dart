
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentForm extends StatefulWidget {

  const DocumentForm({Key key}) : super(key: key);

  @override
  _DocumentFormState createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentDocuments;
  String _currentDocumentName;


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);


    return StreamBuilder<UsersData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Form(
              key: _formKey,
              autovalidate: true,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  SizedBox(height: 5,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Question Title'),
                    onChanged: (val) => setState(() => _currentDocumentName = val),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Question Content'),
                    onChanged: (val) => setState(() => _currentDocuments= val),
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    color: Colors.brown,
                    child: Text('Ask', style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                       String downurl ="";
                        await DatabaseService(uid: user.uid).addDocument(_currentDocumentName, _currentDocuments, downurl);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
          );
        }
        else {
          return Loading();
        }
      },
    );
  }
}


