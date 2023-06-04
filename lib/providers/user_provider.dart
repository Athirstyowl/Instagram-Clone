// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

final AuthMethods _authMethods =AuthMethods();
class UserProvider extends ChangeNotifier{
  User? _user;
  User get getUser => _user!;
  Future<void> refreshUser  () async{
    User  user= await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}