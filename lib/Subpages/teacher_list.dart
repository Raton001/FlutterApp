import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Subpages/answer_form.dart';
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:provider/provider.dart';

class TeacherDetailPage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  TeacherDetailPage({this.documentSnapshot});

  @override
  _TeacherDetailPageState createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _answer;
  String _questionTitle;
  String _questionContent;
  String _review;
  int _rate;
  int _totalrate =0;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentSnapshot.data['name']),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5,),
            Text("Name"),
            Text(widget.documentSnapshot.data['name']),
            SizedBox(height: 10,),
            Text("Role"),
            Text(widget.documentSnapshot.data['role']),
            SizedBox(height: 15,),
            Text("Subject"),
            Text(widget.documentSnapshot.data['subject']),
            SizedBox(height: 15,),
            Text("Rate"),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("rates").where("teacher_id", isEqualTo: widget.documentSnapshot.documentID).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                for(int i = 0; i<snapshot.data.documents.length;i++){
                  _totalrate += snapshot.data.documents[i].data['rate'];
                }
                return Text(_totalrate.toString());

              },
            ),
            RaisedButton(
              child:Text("Rate Teacher", style: TextStyle(color: Colors.white),),
              color: Colors.blue,
              onPressed: (){
                showModalBottomSheet(context: context, builder: (context){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "Rate"),
                            keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                          ],
                            onChanged: (val)=> setState(()=>_rate = int.parse(val)),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "Review"),
                            onChanged: (val)=>setState(()=>_review = val),
                          ),
                          RaisedButton(
                            child: Text("Rate this teacher"),
                            onPressed: () async{
                              if(_formKey.currentState.validate()){
                                await DatabaseService(uid: user.uid).addRate(_rate,_review, widget.documentSnapshot.documentID);
                                Navigator.pop(context);
                              }

                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context, builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<UsersData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return Form(
                      key: _formKey,
                      autovalidate: true,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Text("Ask Away", style: TextStyle(fontSize: 20),),
                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: 'Question Title'),
                            onChanged: (val) => setState(() => _questionTitle = val),
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: 'Question Content'),
                            onChanged: (val) => setState(() => _questionContent = val),
                          ),
                          SizedBox(height: 10,),
                          RaisedButton(
                            color: Colors.green,
                            child: Text("Answer", style: TextStyle(color: Colors.white),),
                            onPressed: () async{
                              if(_formKey.currentState.validate()){
                                _answer = widget.documentSnapshot.documentID;
                                await DatabaseService(uid: user.uid).addDocument(_questionTitle, _questionContent,_answer );
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
              ),
            );
          });
        },
        child: Icon(Icons.flash_on),
        backgroundColor: Colors.green,
      ),
    );
  }
}
