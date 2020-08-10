
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Subpages/studentprofile.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Future _data;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future getDocuments() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('users').where('role',isEqualTo: 'Student').getDocuments();
    return qn.documents;
  }

  void initState() {
    super.initState();

    refreshList();
  }

  navigateToDetail(DocumentSnapshot documentSnapshot){
    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDetailPage(documentSnapshot: documentSnapshot,)));
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
        title: Text('Student List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').where('role', isEqualTo: 'Student').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text('Err');
          }
          else if(snapshot.data == null){
            return Loading();
          }
          else{
            return RefreshIndicator(
              key: refreshKey,
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    print(snapshot);
                      return Card(
                          margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                          child: ListTile(
                            title: Text(snapshot.data.documents[index].data['name']),
                            onTap: ()=> navigateToDetail(snapshot.data.documents[index]),
                          )
                      );
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
