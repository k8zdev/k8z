import 'package:flutter/material.dart';
import 'package:k8sapp/services/stash.dart';

const String key = "app_talker_mode";

class TalkerModeProvider with ChangeNotifier {
  bool? _enabled;

  bool? get enabled => _enabled;

  init() async {
    _enabled = await vget<bool>(key) ?? false;
  }

  void changeMode(mode) async {
    _enabled = mode;
    vset(key, mode);
    notifyListeners();
  }
}
