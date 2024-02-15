import 'package:flutter/material.dart';
import 'package:k8zdev/services/stash.dart';

const String key = "app_theme_mode";

class ThemeModeProvider with ChangeNotifier {
  ThemeMode? _mode;

  ThemeMode? get mode => _mode;

  init() async {
    var modeIdx = await vget<int>(key) ?? 0;
    _mode = ThemeMode.values[modeIdx];
  }

  void changeMode(ThemeMode mode) async {
    _mode = mode;
    vset(key, mode.index);
    notifyListeners();
  }

  bool isCurrent(ThemeMode mode) => _mode == mode;
}
