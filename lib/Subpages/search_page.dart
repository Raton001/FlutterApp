import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var query = [];
  var temp = [];

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        query = [];
        temp =[];
      });
    }

    if(query.length == 0 && value.length ==1){
      Firestore.instance.collection("users").where("subject", isEqualTo: value).getDocuments().then((QuerySnapshot snap){
        for(int i = 0;i<snap.documents.length; ++i){
          query.add(snap.documents[i].data);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Subject'),
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
