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
  Icons.quiz,
  color: Colors.black12,
);

final buildingWidget = Center(
  child: TextButton.icon(
    onPressed: null,
    icon: const Icon(Icons.work_history_rounded),
    label: const Text("Building"),
  ),
);
