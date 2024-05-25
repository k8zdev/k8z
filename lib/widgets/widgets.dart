import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/styles.dart';

const Widget topSizeBox = SizedBox(height: 12);
const Widget naviNextIcon = Icon(Icons.navigate_next);
Widget divider200() =>
    Divider(height: 0, indent: 0, color: Colors.grey.shade200);

Widget safeSca(
  BuildContext context,
  Widget title,
  Widget child, {
  Widget? leading,
  List<Widget>? actions,
}) {
  return Scaffold(
    extendBody: true,
    appBar: AppBar(
      title: title,
      actions: actions,
      leading: leading,
    ),
    body: child,
    backgroundColor: context.isDarkMode ? navDarkColor : Colors.white,
  );
}

const errorIcon = Icon(
  Icons.error_outline,
  color: Colors.red,
);

const runningIcon = Icon(
  Icons.donut_large_rounded,
  color: Colors.green,
);

const quizIcon = Icon(
  Icons.donut_large_rounded,
  color: Colors.amber,
);

final buildingWidget = Center(
  child: TextButton.icon(
    onPressed: null,
    icon: const Icon(Icons.work_history_rounded),
    label: const Text("Building"),
  ),
);

const smallProgressIndicator = SizedBox(
  height: 16,
  width: 16,
  child: CircularProgressIndicator(),
);

Widget leadingText(String label, String langCode, {zhLen, enLen}) {
  late double len;
  switch (langCode) {
    case "zh":
      len = zhLen ?? 32.0;
    default:
      len = enLen ?? 52.0;
  }
  return SizedBox(
    width: len,
    child: AutoHyphenatingText(
      label,
    ),
  );
}

Widget maxWidthText(BuildContext context, String label,
    {double rate = 0.5,
    double maxWidth = double.infinity,
    TextStyle? style,
    bool hpyhenationg = false}) {
  final size = MediaQuery.of(context).size;
  var width = size.width * rate;
  style ??= tileValueStyle;
  if (maxWidth.isFinite && width > maxWidth) {
    width = maxWidth;
  }
  return SizedBox(
    width: width,
    child: hpyhenationg
        ? AutoHyphenatingText(
            label,
            style: style,
          )
        : Text(
            label,
            style: style,
          ),
  );
}
