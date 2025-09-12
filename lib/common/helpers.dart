import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shortid/shortid.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final ThemeData theme = Theme.of(this);
    return theme.brightness == Brightness.dark;
  }
}

double availableHeight(BuildContext context, double offset) {
  // 获取设备可用空间的高度
  // 获取设备的物理尺寸
  final Size physicalScreenSize = View.of(context).physicalSize;
  // 获取设备的设备像素比率
  final double devicePixelRatio = View.of(context).devicePixelRatio;
  // 将物理尺寸转换为逻辑尺寸
  final Size logicalScreenSize = physicalScreenSize / devicePixelRatio;
  var height = logicalScreenSize.height - offset;
  return height;
}

const k8sNodeLabelPrefix = "node-role.kubernetes.io/";
String nodeRoles(Map<String, String> labels) {
  var roles = [];

  labels.forEach((key, value) {
    if (key.startsWith(k8sNodeLabelPrefix) && value.toLowerCase() == "true") {
      roles.add(key.replaceAll(k8sNodeLabelPrefix, ""));
    }
  });
  if (roles.isEmpty) {
    roles.add("<none>");
  }

  return roles.join(",");
}

extension PrettyFormat on Duration {
  String get pretty {
    var stop = false;
    var components = <String>[];

    var days = this.inDays;
    if (days != 0) {
      stop = true;
      components.add('${days}d');
    }
    var hours = this.inHours % 24;
    if (hours != 0 && !stop) {
      stop = true;
      components.add('${hours}h');
    }
    var minutes = this.inMinutes % 60;
    if (minutes != 0 && !stop) {
      stop = true;
      components.add('${minutes}m');
    }

    var seconds = this.inSeconds % 60;
    if ((components.isEmpty || seconds != 0) && !stop) {
      components.add('$seconds s');
    }
    return components.join();
  }

  String get prettyMs {
    var stop = false;
    var components = <String>[];

    var minutes = this.inMinutes % 60;
    if (minutes != 0 && !stop) {
      stop = true;
      components.add('${minutes}m');
    }

    var seconds = this.inSeconds % 60;
    if (seconds != 0 && !stop) {
      components.add('${seconds}s');
    }
    var milliseconds = this.inMilliseconds % 1000;
    if (components.isEmpty || milliseconds != 0) {
      components.add('${milliseconds}ms');
    }
    return components.join();
  }
}

const podOkStatusList = ["Running", "Succeeded"];

bool isOkStatus(String status) {
  return podOkStatusList.contains(status);
}

/// 向后兼容的屏幕访问记录函数
/// 
/// @deprecated 请使用 AnalyticsService.logPageView 替代
/// 这个函数保持向后兼容，但内部使用新的 AnalyticsService
Future<void> logScreenView({
  String? screenClass,
  String? screenName,
  Map<String, Object>? parameters,
  AnalyticsCallOptions? callOptions,
}) async {
  // 为了向后兼容，仍然调用原始的 Firebase Analytics
  // 但同时也会通过路由观察器自动处理
  try {
    FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      parameters: parameters,
      callOptions: callOptions,
    );
  } catch (e) {
    debugPrint('Analytics: Legacy logScreenView failed - $e');
  }
}

Future<void> logEvent(
  String name, {
  Map<String, Object>? parameters,
  AnalyticsCallOptions? callOptions,
}) async {
  FirebaseAnalytics.instance.logEvent(
    name: name,
    parameters: parameters,
    callOptions: callOptions,
  );
}

Future<void> logPurchase(
    {String? currency = "CNY",
    double? value,
    List<AnalyticsEventItem>? items,
    String? transactionId,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions}) async {
  FirebaseAnalytics.instance.logPurchase(
    currency: currency,
    value: value,
    transactionId: transactionId,
    parameters: parameters,
    callOptions: callOptions,
  );
}

const _shortidCharacters = '0123456789abcdefghijklmnopqrstuvwxyz';

String sid() {
  shortid.characters(_shortidCharacters);
  return shortid.generate();
}
