// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `k8z`
  String get appName {
    return Intl.message(
      'k8z',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `version`
  String get version {
    return Intl.message(
      'version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `error`
  String get error {
    return Intl.message(
      'error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `load file`
  String get load_file {
    return Intl.message(
      'load file',
      name: 'load_file',
      desc: '',
      args: [],
    );
  }

  /// `next step`
  String get next_step {
    return Intl.message(
      'next step',
      name: 'next_step',
      desc: '',
      args: [],
    );
  }

  /// `Clusters`
  String get clusters {
    return Intl.message(
      'Clusters',
      name: 'clusters',
      desc: '',
      args: [],
    );
  }

  /// `save clusters`
  String get save_clusters {
    return Intl.message(
      'save clusters',
      name: 'save_clusters',
      desc: '',
      args: [],
    );
  }

  /// `appearance`
  String get appearance {
    return Intl.message(
      'appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `auto`
  String get theme_auto {
    return Intl.message(
      'auto',
      name: 'theme_auto',
      desc: '',
      args: [],
    );
  }

  /// `dark mode`
  String get theme_dark {
    return Intl.message(
      'dark mode',
      name: 'theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `light mode`
  String get theme_light {
    return Intl.message(
      'light mode',
      name: 'theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `general`
  String get general {
    return Intl.message(
      'general',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get general_language {
    return Intl.message(
      'language',
      name: 'general_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get general_language_en {
    return Intl.message(
      'English',
      name: 'general_language_en',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get general_language_zh {
    return Intl.message(
      'Chinese',
      name: 'general_language_zh',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get general_language_ja {
    return Intl.message(
      'Japanese',
      name: 'general_language_ja',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get general_language_null {
    return Intl.message(
      'Auto',
      name: 'general_language_null',
      desc: '',
      args: [],
    );
  }

  /// `debug`
  String get general_debug {
    return Intl.message(
      'debug',
      name: 'general_debug',
      desc: '',
      args: [],
    );
  }

  /// `sqlview`
  String get general_debug_sqlview {
    return Intl.message(
      'sqlview',
      name: 'general_debug_sqlview',
      desc: '',
      args: [],
    );
  }

  /// `Add cluster`
  String get add_cluster {
    return Intl.message(
      'Add cluster',
      name: 'add_cluster',
      desc: '',
      args: [],
    );
  }

  /// `Load kubeconfig file`
  String get manual_load_kubeconfig {
    return Intl.message(
      'Load kubeconfig file',
      name: 'manual_load_kubeconfig',
      desc: '',
      args: [],
    );
  }

  /// `can not get cluster kubeconfig, contexts maybe empty`
  String get empyt_context {
    return Intl.message(
      'can not get cluster kubeconfig, contexts maybe empty',
      name: 'empyt_context',
      desc: '',
      args: [],
    );
  }

  /// `Select cluster(s)`
  String get select_clusters {
    return Intl.message(
      'Select cluster(s)',
      name: 'select_clusters',
      desc: '',
      args: [],
    );
  }

  /// `flush database`
  String get debug_flushdb {
    return Intl.message(
      'flush database',
      name: 'debug_flushdb',
      desc: '',
      args: [],
    );
  }

  /// `database flushed`
  String get debug_flushdb_done {
    return Intl.message(
      'database flushed',
      name: 'debug_flushdb_done',
      desc: '',
      args: [],
    );
  }

  /// `will flush all data at database`
  String get debug_flushdb_desc {
    return Intl.message(
      'will flush all data at database',
      name: 'debug_flushdb_desc',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get running {
    return Intl.message(
      'Running',
      name: 'running',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
