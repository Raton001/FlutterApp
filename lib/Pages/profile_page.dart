import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Subpages/edit_profile_form.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          SizedBox(height: 32.0,),
          UpperSection(),
          SizedBox(height: 32.0,),
          Spacer(),
        ],
      ),
    );
  }
}

class UpperSection extends StatelessWidget {


  const UpperSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _showEditPanel() async{
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
          child: EditForm(),
        );
      });
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasError){
          return Text('errr');
        } else{
          return Column(
            children: <Widget>[
              SizedBox(
                height: 32.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.lightBlueAccent, Colors.blueGrey]
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                      ],
                    ),
                    SizedBox(height: 8.0,),
                    Text(snapshot.data['role']),
                    SizedBox(
                        height: 16.0
                    ),
                    Text(
                      snapshot.data['name'],
                      style: TextStyle(
                          fontSize: 24.0
                      ),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      snapshot.data['address'],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0
                      ),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      snapshot.data['phone'],
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      snapshot.data['gender'],
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.lightBlueAccent, Colors.blueGrey]
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Edit Profile', style: TextStyle(color: Colors.white),),
                      color: Colors.blue,
                      onPressed: () => _showEditPanel(),
                    )
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}

