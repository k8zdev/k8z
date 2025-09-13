import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/locale.dart' as intl;
import 'package:k8zdev/services/stash.dart';
import 'package:k8zdev/services/title_update_service.dart';

const localeKey = "app_settings_locale_code";

class CurrentLocale with ChangeNotifier {
  late Locale? _locale;
  Locale? get locale => _locale;
  bool get isAuto => (_locale?.languageCode == null);

  String get languageCode =>
      _locale?.languageCode ??
      (intl.Locale.tryParse(Platform.localeName)?.languageCode ?? "en");

  // 保存当前的 BuildContext 用于标题更新
  BuildContext? _currentContext;

  init() async {
    String? code = await vget<String>(localeKey);
    _locale = (code != null) ? Locale(code) : null;
  }

  /// 设置当前的 BuildContext（用于标题更新）
  void setCurrentContext(BuildContext? context) {
    _currentContext = context;
  }

  void setLocale(Locale? locale) {
    final oldLanguage = languageCode;
    final newLanguage = locale?.languageCode ?? 
        (intl.Locale.tryParse(Platform.localeName)?.languageCode ?? "en");
    
    _locale = locale;
    vset(localeKey, locale?.languageCode);
    
    // 如果有当前上下文，处理语言切换的标题更新
    if (_currentContext != null && _currentContext!.mounted) {
      TitleUpdateService.handleLanguageChange(
        context: _currentContext!,
        newLanguage: newLanguage,
        oldLanguage: oldLanguage != newLanguage ? oldLanguage : null,
      );
    }
    
    notifyListeners();
  }
}
