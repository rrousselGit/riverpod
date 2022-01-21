import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateManager extends ChangeNotifier {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  void login() {
    _loggedIn = true;
    notifyListeners();
  }
  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}

final appStateManager =
    ChangeNotifierProvider<AppStateManager>((ref) => AppStateManager());
