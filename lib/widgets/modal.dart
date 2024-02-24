import 'package:flutter/material.dart';

void showModal(BuildContext context, Widget widget) {
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
        constraints: BoxConstraints(
          minHeight: 400,
          minWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: widget,
      );
    },
  );
}
