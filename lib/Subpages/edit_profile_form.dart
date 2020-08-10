
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {

  final _formKey = GlobalKey<FormState>();

  String _name;
  String _address;
  String _gender;
  String _phone;
  String _dob;
  String _img;
  String _role;
  String _subject;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return StreamBuilder<UsersData>(
      stream: DatabaseService(uid:  user.uid).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          UsersData usersData = snapshot.data;
          _role = usersData.role;
          _subject = usersData.subject;
          return Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: <Widget>[
                SizedBox(height: 5,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  initialValue: usersData.name,
                  onChanged: (val) => setState(() => _name = val),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Address'),
                  initialValue: usersData.address,
                  onChanged: (val) => setState(() => _address = val),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Gender'),
                  initialValue: usersData.gender,
                  onChanged: (val) => setState(() => _gender = val),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                  initialValue: usersData.phone,
                  onChanged: (val) => setState(() => _phone = val),

                ),
                SizedBox(height: 10,),
                RaisedButton(
                  color: Colors.brown,
                  child: Text(' Update Profile ', style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      _role = usersData.role;
                      _subject = usersData.subject;
                      await DatabaseService(uid: user.uid).updateUserData(_name, _address, _gender, _phone, _dob, _img, _role,_subject);
                      Navigator.pop(context);
                    }
                  },
                )

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
