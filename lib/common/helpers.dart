import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final ThemeData theme = Theme.of(this);
    return theme.brightness == Brightness.dark;
  }
}

double availableHeight(BuildContext context, double offset) {
  // 获取设备可用空间的高度
  final deviceHeight = MediaQuery.of(context).size.height;
  var height = deviceHeight - offset;
  return height;
}
