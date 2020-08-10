import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Subpages/answer_form.dart';
import 'package:flutter_app/anime/constants.dart';
import 'package:flutter_app/anime/loading.dart';
import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:provider/provider.dart';

class TeacherAnswerList extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  TeacherAnswerList({this.documentSnapshot});

  @override
  _TeacherAnswerListState createState() => _TeacherAnswerListState();
}

class _TeacherAnswerListState extends State<TeacherAnswerList> {
  final _formKey = GlobalKey<FormState>();
  String _answer;
  String _question;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentSnapshot.data['name']),
      ),
      body: Column(
        children: <Widget>[
          Card(
              child: Container(
            child: ListTile(
              title: Text(widget.documentSnapshot.data['name']),
              subtitle: Text(widget.documentSnapshot.data['type']),
            ),
          )),
          SizedBox(
            height: 5,
          ),
          Text(
            "Answer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('answers')
                .where('question_id',
                    isEqualTo: widget.documentSnapshot.documentID)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Loading();
                  break;
                default:
                  if (snapshot.hasError) {
                    return Text('Err');
                  } else {
                    print(snapshot);
                    return Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: Container(
                                child: ListTile(
                                  title: Text("The Answer"),
                                  subtitle: Text(snapshot
                                      .data.documents[index].data['answer']),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.star,
                                    ),
                                  ),
                                ),
                              ));
                            }),
                      ),
                    );
                  }
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<UsersData>(
                    stream: DatabaseService(uid: user.uid).userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Form(
                          key: _formKey,
                          autovalidate: true,
                          child: ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            children: <Widget>[
                              Text(
                                'Answer this question',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Answer'),
                                onChanged: (val) =>
                                    setState(() => _answer = val),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "Answer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _question =
                                        widget.documentSnapshot.documentID;
                                    await DatabaseService(uid: user.uid)
                                        .addAnswer(_answer, _question);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Loading();
                      }
                    },
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
