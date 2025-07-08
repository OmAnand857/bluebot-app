import 'package:flutter/material.dart';

class UserStore extends ChangeNotifier {
  String _username = '';
  bool _userLoggedIn = false;
  String _backendUrl = 'https://bluebot-backend.onrender.com';

  String get username => _username;
  bool get userLoggedIn => _userLoggedIn;
  String get backendUrl => _backendUrl;

  void setUserLoggedIn(bool value) {
    _userLoggedIn = value;
    notifyListeners();
  }

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }

  void setBackendUrl(String url) {
    _backendUrl = url;
    notifyListeners();
  }
}
