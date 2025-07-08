import 'package:flutter/material.dart';

class UserStore extends ChangeNotifier {
  String _username = '';
  String get username => _username;
  bool _userLoggedIn = false;
  bool get userLoggedIn => _userLoggedIn;

  void setUserLoggedIn(bool value) {
    _userLoggedIn = value;
    notifyListeners();
  }

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }
}
