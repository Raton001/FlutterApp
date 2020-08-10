import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Subpages/document.dart';
import 'package:flutter_app/Subpages/answer_page.dart';
import 'package:flutter_app/Subpages/question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Subpages/student_page.dart';
import 'package:flutter_app/Subpages/teacher_page.dart';
import 'package:flutter_app/Subpages/teacher_question_page.dart';
import 'package:flutter_app/model/user.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final itemname = ['My Question', 'Answered', 'Teacher List'];

  final item = ['Student Asking', 'Questions', 'My Answer'];

  final icons = [
    Icons.branding_watermark,
    Icons.assignment_ind,
    Icons.assessment
  ];

  final icon = [Icons.assignment, Icons.branding_watermark, Icons.list];

  final List<Widget> _widgetOptions = <Widget>[
    QuestionPage(),
    AnswerPage(),
    TeacherPage()
  ];

  final List<Widget> _widgetOpt = <Widget>[
    StudentPage(),
    TeacherQuestionPage(),
    AnswerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _showDocumentPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
              child: DocumentForm(),
            );
          });
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Err');
          } else if (snapshot.hasData) {
            return checkRole(snapshot.data);
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  GridView checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return GridView.builder(
        itemCount: 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
      );
    }
    if (snapshot.data['role'] == 'teacher') {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  GridView adminPage(DocumentSnapshot snapshot) {
    return GridView.builder(
        itemCount: itemname.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _widgetOpt.elementAt(index)));
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    icon[index],
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      item[index],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  GridView userPage(DocumentSnapshot snapshot) {
    return GridView.builder(
        itemCount: itemname.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _widgetOptions.elementAt(index)));
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    icons[index],
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      itemname[index],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
