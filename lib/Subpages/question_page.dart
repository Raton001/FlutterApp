import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/Subpages/list.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Future _data;
  TextEditingController controller = new TextEditingController();

  String filter ='';

  Future getDocuments() async {
//    User user = Provider.of<User>(context);
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('questions').getDocuments();
//    QuerySnapshot qn1 = await firestore.collection('documents').where('uid', isEqualTo: user.uid).getDocuments();
    return qn.documents;
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    refreshList();
  }

  navigateToDetail(DocumentSnapshot documentSnapshot) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  documentSnapshot: documentSnapshot,
                )));
  }

  Future<Null> refreshList() async {
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
    var firestore = Firestore.instance;
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Question List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('questions').where('uid',isEqualTo: user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Waiting');
              break;
            default:
              if (snapshot.hasError) {
                print('Has Error');
                return Text('Amir jelek');
              } else {
                return Material(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration:
                            InputDecoration(labelText: "Search Question"),
                        controller: controller,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                            key: refreshKey,
                            child: ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  print(snapshot);
                                  return
                                  Card(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 6.0, 10.0, 0.0),
                                      child: ListTile(
                                          title: Text(snapshot.data
                                              .documents[index].data['name']),
                                          leading: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['image_url'] !=
                                                  null
                                              ? Image.network(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['image_url'])
                                              : Icon(
                                                  Icons.broken_image,
                                                  size: 25.0,
                                                ),
                                          subtitle: Text(snapshot.data
                                              .documents[index].data['type']),
                                          onTap: () => navigateToDetail(
                                              snapshot.data.documents[index]),
                                          trailing: Wrap(
                                            spacing: 12,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.message),
                                                color: Colors.blue,
                                                onPressed: () async {
//                                        await Firestore.instance
//                                            .runTransaction((Transaction my) async {
//                                          await my.delete(snapshot
//                                              .data.documents[index].reference);
//                                        });
                                                },
                                              ),
                                            ],
                                          )
                                      )
                                  );

                                }),
                            onRefresh: () async {
                              refreshKey.currentState?.show(atTop: false);
                              await Future.delayed(Duration(seconds: 2));
                              setState(() {
                                _data = getDocuments();
                              });
                              return null;
                            }),
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
