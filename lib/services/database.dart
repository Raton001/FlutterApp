import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/answer.dart';
import 'package:flutter_app/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference identityCollection =
      Firestore.instance.collection('users');
  final CollectionReference documentCollection =
      Firestore.instance.collection('questions');
  final CollectionReference answerCollection =
      Firestore.instance.collection('answers');
  final CollectionReference rateCollection =
      Firestore.instance.collection('rates');

  Future updateUserData(String name, String address, String gender,
      String phone, String dob, String img, String role, String subject) async {
    return await identityCollection.document(uid).setData({
      'name': name,
      'address': address,
      'gender': gender,
      'phone': phone,
      'dob': dob,
      'img': img,
      'role': role,
      'subject': subject,
    });
  }

  Future addDocument(String name, String type, String image_url) async {
    return await documentCollection
        .add({'uid': uid, 'name': name, 'type': type, 'image_url': image_url});
  }

  Future getDocument(String type) async {
    return await documentCollection.document('uid').snapshots();
  }

  UsersData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UsersData(
      uid: uid,
      name: snapshot.data['name'],
      address: snapshot.data['address'],
      gender: snapshot.data['gender'],
      phone: snapshot.data['phone'],
      dob: snapshot.data['dob'],
      img: snapshot.data['img'],
      role: snapshot.data['role'],
      subject: snapshot.data['subject'],
    );
  }

  Stream<UsersData> get userData {
    return identityCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  AnswersData _answersData(DocumentSnapshot snapshot) {
    return AnswersData(
      uid: uid,
      question_id: snapshot.data['question_id'],
      answer: snapshot.data['answer'],
    );
  }

  Stream<AnswersData> get answerData {
    return answerCollection.document(uid).snapshots().map((_answersData));
  }

  addAnswer(String answer, String question) async {
    return await answerCollection
        .add({'uid': uid, 'question_id': question, 'answer': answer});
  }

  addRate(int rate, String review, String teacher_id) async {
    return await rateCollection.add({
      'teacher_id': teacher_id,
      'rate': rate,
      'review': review,
    });
  }

  searchBySubject(String subject) {
    return identityCollection.where('subject', isEqualTo: subject).snapshots();
  }
}
