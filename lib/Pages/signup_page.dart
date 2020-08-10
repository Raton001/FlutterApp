import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  SignUpPage({this.toggleView});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String address = '';
  String gender;
  String phone = '';
  String dob = '';
  String imgUrl = '';
  String subject;
  String role;
  final List<String> _genderType = <String>['Male', 'Female'];
  final List<String> _roleType = <String>['Student', 'teacher'];
  final List<String> _subject = <String>[
    'Mathemetics',
    'Science',
    'iT',
    'English',
    'Java',
    'C++',
    'Python',
    'Dataminig'
  ];
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        backgroundColor: Colors.indigo[100],
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Register Account',
                    style: TextStyle(
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'email'),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'password'),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Address'),
                    onChanged: (val) {
                      setState(() => address = val);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownButtonFormField(
                    value: gender,
                    items: _genderType.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose gender'),
                    decoration: textInputDecoration,
                    onChanged: (selectedGender) {
                      setState(() {
                        gender = selectedGender;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    hint: Text('Choose Role'),
                    value: role,
                    items: _roleType.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        role = val;
                        if (role == 'teacher') {
                          _isVisible = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) =>
                          _isVisible == true,
                      widgetBuilder: (BuildContext context) {
                        return DropdownButtonFormField(
                          value: subject,
                          items: _subject.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('Choose subject'),
                          decoration: textInputDecoration,
                          onChanged: (selectedSubject) {
                            setState(() {
                              subject = selectedSubject;
                            });
                          },
                        );
                      },
                      fallbackBuilder: (BuildContext context) {
                        return SizedBox(
                          height: 0.0,
                        );
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Phone Number'),
                    onChanged: (val) {
                      setState(() => phone = val);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() => loading = true);
//                        String fileName = basename(_imageFile.path);
//                        StorageReference f = FirebaseStorage.instance.ref().child(fileName);
//                        StorageUploadTask uploadTask = f.putFile(_imageFile);
//                        StorageTaskSnapshot task = await uploadTask.onComplete;
                            imgUrl = "";
                            dynamic result = await _auth.register(
                                email,
                                password,
                                name,
                                address,
                                gender,
                                phone,
                                dob,
                                imgUrl,
                                role,
                                subject);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Error';
                              });
                            }
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
