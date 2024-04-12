import 'package:flutter/material.dart';
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
}) {
  return CustomSettingsTile(
    child: GestureDetector(
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
    ),
  );
}
