
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Subpages/search_page.dart';
import 'package:flutter_app/Subpages/teacher_list.dart';
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/database.dart';
import 'package:provider/provider.dart';

import 'list.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  Future _data;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  String _questiontitle;
  String _questioncontent;
  int _totalrate =0;

  String searchKey;

  Future getDocuments() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('users').where('role',isEqualTo: 'teacher').getDocuments();
    return qn.documents;
  }

  void initState() {
    super.initState();

    refreshList();
  }

  navigateToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherDetailPage(documentSnapshot: documentSnapshot,)));
  }

  Future<Null> refreshList() async{
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _data = getDocuments();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Teacher List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').where('role', isEqualTo: 'teacher').where('subject', isEqualTo: searchKey).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text('Err');
          }
          else if(snapshot.data == null){
            return Loading();
          }
          else{
            return Material(
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (val){
                      if(val.isNotEmpty){
                        searchKey = val;
                        refreshList();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search by subject",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      key: refreshKey,
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index){
                            print(snapshot);
                            return Card(
                                margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                                child: ListTile(
                                  leading: Icon(Icons.account_circle),
                                  title: Text(snapshot.data.documents[index].data['name']),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text("Subject:"),
                                      Text(snapshot.data.documents[index].data['subject']),
                                      SizedBox(height: 2,),
                                      Text("Phone Number:"),
                                      Text(snapshot.data.documents[index].data['phone']),
                                      SizedBox(height: 2,),
                                      Text("Rate:"),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: Firestore.instance.collection("rates").where("teacher_id", isEqualTo: snapshot.data.documents[index].documentID).snapshots(),
                                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot1){
                                          if(snapshot.hasError){
                                            return Text("Err");
                                          }
                                          else{
                                            for(int i = 0; i<snapshot1.data.documents.length;i++){
                                              _totalrate += snapshot1.data.documents[i].data['rate'];
                                            }
                                            return Text("$_totalrate");
                                          }


                                        },
                                      ),
                                      SizedBox(height: 2,),
                                      RaisedButton(child: Text("Reach this teacher"),onPressed: (){

                                      },
                                      ),
                                    ],

                                  ),
                                  onTap: ()=>navigateToDetail(snapshot.data.documents[index]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.question_answer, color: Colors.blue,),
                                    onPressed: (){
                                      showModalBottomSheet(context: context, builder: (context){
                                        return Container(
                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                            child: Form(
                                              key: _formKey,
                                              autovalidate: true,
                                              child: ListView(
                                                children: <Widget>[
                                                  Text('Ask'),
                                                  SizedBox(height: 2,),
                                                  TextFormField(
                                                    decoration: textInputDecoration.copyWith(hintText: 'Question Title'),
                                                    onChanged: (val)=> setState(()=> _questiontitle = val),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  TextFormField(
                                                    decoration: textInputDecoration.copyWith(hintText: 'Question Content'),
                                                    onChanged: (val)=> setState(()=> _questioncontent = val),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.save, color: Colors.green,),
                                                    onPressed: () async{
                                                      if(_formKey.currentState.validate()){
                                                        String downurl = snapshot.data.documents[index].documentID;
                                                        await DatabaseService(uid: user.uid).addDocument(_questiontitle, _questioncontent, downurl);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                        );
                                      });
                                    },
                                  ),
                                )
                            );
                          }
                      ),
                      onRefresh: refreshList,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
