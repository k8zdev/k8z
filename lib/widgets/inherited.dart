import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

const noneNetwork = ConnectivityResult.none;

class AppScope extends InheritedWidget {
  final ConnectivityResult networkStatus;

  const AppScope({
    super.key,
    required this.networkStatus,
    required super.child,
  });

  static AppScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>();
  }

  bool get offline {
    return networkStatus == ConnectivityResult.none;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return networkStatus != oldWidget.networkStatus;
  }
}
