import 'package:flutter_app/Pages/signup_page.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  final Function toggleView;
  LoginPage({this.toggleView});


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Positioned(
              top:0,
              bottom: MediaQuery.of(context).size.height/4,
              child: Image.asset("assets/images/martian_surface.png"),
            ),

            Positioned(
              top: 100,
              left: 32,
              child: Text('Sign In',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
            ),

            Positioned(
              top: 200,
              child: Container(
                padding: EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(62),
                      topRight: Radius.circular(62),
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formkey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Email'
                            ),
                            onChanged: (val){
                              setState(()=> email = val);
                            },
                            validator: (val){
                              if(val.isEmpty){
                                return 'Email is not there';
                              }
                              else{
                                return null;
                              }
                            },
                          ),

                          Padding(
                            padding: EdgeInsets.only(top:16, bottom: 62),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              onChanged: (val){ setState(() => password = val);},
                              validator: (val){
                                if(val.isEmpty){
                                  return 'Password is not there';
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    RaisedButton(
                      color: Colors.indigo[400],
                      child: Text('Login', style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () async{
                        if(_formkey.currentState.validate()){
                          setState(()=>loading = true);
                          dynamic result = await _auth.signIn(email, password);
                          if(result == null){
                            setState(() {
                              loading = false;
                              error = 'Could not sign in with these credentials. Have them checked up again';
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error),));
                            });
                          }
                        }

                      },
                    ),
                    RaisedButton(
                      color: Colors.brown[400],
                      child: Text('Register', style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpPage())),
                    ),
                    RaisedButton(
                      color: Colors.red[400],
                      child: Text('Forgot Password', style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () async {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        final sb = SnackBar(content: Text('An email has been sent to you'),);
                        _scaffoldKey.currentState.showSnackBar(sb);
                      },
                    ),
                    Container( height: 8,),

                    Container(height: 70,),

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
