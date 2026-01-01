import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildPVCDetailSectionTiles(
  BuildContext context,
  IoK8sApiCoreV1PersistentVolumeClaim? pvc,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (pvc == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  // Status (phase)
  if (pvc.status?.phase != null) {
    tiles.add(
      copyTileValue(
        lang.status,
        pvc.status!.phase ?? "",
        langCode,
        zhLen: 48,
      ),
    );
  }

  // Capacity from spec.resources.requests['storage']
  if (pvc.spec?.resources?.requests != null &&
      pvc.spec!.resources!.requests.containsKey('storage')) {
    tiles.add(
      copyTileValue(
        lang.capacity,
        pvc.spec!.resources!.requests['storage'] ?? "",
        langCode,
        zhLen: 48,
      ),
    );
  }

  // Access Modes
  if (pvc.spec?.accessModes.isNotEmpty ?? false) {
    tiles.add(
      copyTileValue(
        lang.access_modes,
        pvc.spec!.accessModes.join(", "),
        langCode,
        zhLen: 48,
      ),
    );
  }

  // Storage Class Name
  if (pvc.spec?.storageClassName != null) {
    tiles.add(
      copyTileValue(
        lang.storage_class,
        pvc.spec!.storageClassName ?? "",
        langCode,
        zhLen: 48,
      ),
    );
  }

  // Volume Name
  if (pvc.spec?.volumeName != null) {
    tiles.add(
      copyTileValue(
        lang.volume_name,
        pvc.spec!.volumeName ?? "",
        langCode,
        zhLen: 48,
      ),
    );
  }

  // Volume Mode
  if (pvc.spec?.volumeMode != null) {
    tiles.add(
      copyTileValue(
        lang.volume_mode,
        pvc.spec!.volumeMode ?? "",
        langCode,
        zhLen: 48,
      ),
    );
  }

  return tiles;
}