import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  final String email;
  final String uid;
  final String bio;
  final String username;
  final String photoUrl;
  final List followers;
  final List followings;

  const User({
    required this.email,
    required this.uid,
    required  this.username,
    required this.bio,
    required this.followers,
    required this.followings,
    required this.photoUrl
});
  Map<String,dynamic> toJson() => {
    "username" :username,
    "uid" : uid,
    "email" : email,
    "bio" : bio,
    "followers" : followers,
    "followings" : followings,
    "photoUrl": photoUrl,
  };
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      followings: snapshot['followings'],
    );
  }
}