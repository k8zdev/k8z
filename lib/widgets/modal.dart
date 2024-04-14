import 'package:flutter/material.dart';

void showModal(BuildContext context, Widget widget,
    {int minHeight = 400, double? height}) {
  if (minHeight < 100) {
    minHeight = 100;
  }
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    showDragHandle: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: height ?? minHeight.toDouble(),
        constraints: BoxConstraints(
          minHeight: minHeight.toDouble(),
          minWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: widget,
      );
    },
  );
}
