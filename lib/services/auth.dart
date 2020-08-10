import 'package:flutter_app/model/user.dart';
import 'package:flutter_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid:user.uid): null;
  }

  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future register(String email, String password, String name, String address, String gender, String phone, String dob, String img, String role, String subject) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(name, address, gender, phone, dob, img, role,subject);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}