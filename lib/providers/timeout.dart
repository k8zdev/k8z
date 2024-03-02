import 'package:flutter/material.dart';
import 'package:k8zdev/services/stash.dart';

const String key = "k8s_api_timeout";

class TimeoutProvider extends ChangeNotifier {
  int _timeout = 300;

  int get timeout => _timeout;

  void update(int seconds) {
    _timeout = seconds;
    vset(key, seconds);
    notifyListeners();
  }
}
