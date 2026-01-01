import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildStorageClassDetailSectionTiles(
  BuildContext context,
  IoK8sApiStorageV1StorageClass? storageClass,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (storageClass == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  tiles.addAll([
    copyTileValue(
      lang.provisioner,
      storageClass.provisioner,
      langCode,
      enLen: 82.0,
      zhLen: 52.0,
    ),
  ]);

  if (storageClass.reclaimPolicy != null) {
    tiles.add(
      copyTileValue(
        lang.reclaim_policy,
        storageClass.reclaimPolicy!,
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  if (storageClass.volumeBindingMode != null) {
    tiles.add(
      copyTileValue(
        lang.volume_binding_mode,
        storageClass.volumeBindingMode!,
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  if (storageClass.allowVolumeExpansion != null) {
    tiles.add(
      copyTileValue(
        lang.allow_volume_expansion,
        storageClass.allowVolumeExpansion.toString(),
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  if (storageClass.mountOptions.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.mount_options,
        storageClass.mountOptions.join(", "),
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  if (storageClass.parameters.isNotEmpty) {
    final params = storageClass.parameters.entries
        .map((e) => "${e.key}=${e.value}")
        .join(", ");
    tiles.add(
      copyTileValue(
        lang.parameters,
        params,
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  if (storageClass.allowedTopologies.isNotEmpty) {
    final topologies = storageClass.allowedTopologies
        .map((term) => term.matchLabelExpressions
            .map((req) => "${req.key}=[${req.values.join(',')}]")
            .join(", "))
        .join("; ");
    tiles.add(
      copyTileValue(
        lang.allowed_topologies,
        topologies,
        langCode,
        enLen: 82.0,
        zhLen: 52.0,
      ),
    );
  }

  return tiles;
}
