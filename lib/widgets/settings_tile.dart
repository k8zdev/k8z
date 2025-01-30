import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:kubeconfig/kubeconfig.dart';
import 'package:settings_ui/settings_ui.dart';

AbstractSettingsTile metadataSettingsTile(
  BuildContext context,
  Widget child,
  String itemName,
  String? itemNamespace,
  String path,
  String resource, {
  void Function()? onTap,
  void Function()? onDoubleTap,
  ActionPane? startActionPane,
  ActionPane? endActionPane,
}) {
  final slide = startActionPane != null || endActionPane != null;
  final gd = GestureDetector(
    onDoubleTap: onDoubleTap,
    onTap: onTap ??
        () {
          GoRouter.of(context).pushNamed(
            "details",
            pathParameters: {
              "path": path,
              // empty namespace path param will case route miss,
              // we set default _ and remove it at the route.
              "namespace": itemNamespace.isNullOrEmpty ? "_" : itemNamespace!,
              "resource": resource,
              "name": itemName,
            },
          );
        },
    child: AbsorbPointer(child: child),
  );
  Widget internalChild;
  if (slide) {
    internalChild = Slidable(
      endActionPane: endActionPane,
      startActionPane: startActionPane,
      child: gd,
    );
  } else {
    internalChild = gd;
  }

  return CustomSettingsTile(
    child: internalChild,
  );
}
