import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = " Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        postId: postId,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('post').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> likePost(String postId,String uid,List likes) async {
    try{
      if(likes.contains(uid)){
        await _firestore.collection("post").doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid]),
        });
      }
      else{
       await _firestore.collection("post").doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid]),
        });
    }
    }
    catch(e){
      print(e.toString(),);
    }
  }
  Future<String> postComment(String postId,String text,String uid,String name,String profilePic) async {
    String res= " Some error occurred" ;
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('post').doc(postId).collection('comments').doc(commentId).set(
            {
              'profilePic': profilePic,
              'name':name,
              "uid":uid,
              'text':text,
              'commentId':commentId,
              'datePublished': DateTime.now(),
            });
        res = "success" ;
      }
      else{
       res = "Please enter a comment";
      }
    }
        catch(err){
          res = err.toString();
        }
        return res;
  }
  //delete the post
Future<String> deletePost(String postId) async{
    String res= " Some error occured" ;
    try{

      await _firestore.collection('post').doc(postId).delete();
      res="success";
    }
    catch(err){
      print(err.toString());
    }
    return res ;
}
Future<void> followUser(
    String uid,
    String followId
    ) async {
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['followings'];
      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayRemove([followId])
        });
      }
      else{
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayUnion([followId])
        });

      }
    }
    catch(e){
      print(e.toString());
    }
}
}
