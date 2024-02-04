import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:k8sapp/services/stash.dart';

const localeKey = "app_settings_locale_code";

class CurrentLocale with ChangeNotifier {
  late Locale? _locale;
  Locale? get locale => _locale;
  bool get isAuto => (_locale?.languageCode == null);

  init() async {
    String? code = await vget<String>(localeKey);
    _locale = (code != null) ? Locale(code) : null;
  }

  void setLocale(Locale? locale) {
    _locale = locale;
    vset(localeKey, locale?.languageCode);
    notifyListeners();
  }
}
