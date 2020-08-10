
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list.dart';

class AnswerPage extends StatefulWidget {
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  Future _data;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future getDocuments() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('answers').getDocuments();
    return qn.documents;
  }

  void initState() {
    super.initState();

    refreshList();
  }

  navigateToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(documentSnapshot: documentSnapshot,)));
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
        title: Text('Answered'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('answer').where('uid', isEqualTo: user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text('Err');
          }
          else if(snapshot.data == null){
            return Text('You havent answered any question');
          }
          else{
            return RefreshIndicator(
              key: refreshKey,
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    if(user.uid == snapshot.data.documents[index].data['uid']){
                      return Card(
                          margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                          child: ListTile(
                            title: Text(snapshot.data.documents[index].data['answer']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever),
                              color: Colors.red,
                              onPressed: ()async{
                                await Firestore.instance.runTransaction((Transaction my)async{
                                  await my.delete(snapshot.data.documents[index].reference);
                                });
                              },
                            ),
                          )
                      );
                    }
                    else{
                      return SizedBox(height: 0.0,);
                    }
                  }
              ),
              onRefresh: refreshList,
            );
          }
        },
      ),
    );
  }
}
