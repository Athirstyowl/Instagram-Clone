import 'dart:typed_data';
import 'package:instagram_clone/model/user.dart' as model ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
class AuthMethods {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
   User currentUser = _auth.currentUser! ;
   DocumentSnapshot  snap = await _firestore.collection('users').doc(currentUser.uid).get();
   return model.User.fromSnap(snap);
}
  //signUp
  Future<String> signUp({
    required String username ,
    required String password,
    required String email,
    required String bio,
    required Uint8List file,
})async{
    String res = " Some error occured";
    try{
      // ignore: unnecessary_null_comparison
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty ||file!=null){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage("profilePics", file, false);
        //add user to database
        model.User user = model.User(
          email: email,
          uid : cred.user!.uid,
          username:username,
          bio : bio,
          followers : [],
          followings : [],
          photoUrl : photoUrl,
        );

        _firestore.collection("users").doc(cred.user!.uid).set(user.toJson(),);
      }
      res="success";
    }/* on FirebaseAuthException catch(err){
      if(err.code == 'invalid email'){
        res="The email is badly formatted";
      }
      else if(err.code == 'weak-password'){
        res="Your password should be at least 6 characters";
      }
    }*/
    catch(err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> login({
    required String email,
    required String password,
})async{
    String res = "Some error occurred" ;
    try{
      if( email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
      else{
        res = "Please enter all the credentials";
      }
    }
    catch(err){
      res=err.toString();
    }
    return res;
  }
  Future<void> signOut() async {
  await _auth.signOut();
  }
}

