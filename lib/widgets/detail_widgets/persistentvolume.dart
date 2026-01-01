import 'package:flutter/material.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/modal.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildPersistentVolumeDetailTiles(
  BuildContext context,
  IoK8sApiCoreV1PersistentVolume? pv,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  if (pv == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  final spec = pv.spec;
  final status = pv.status;

  // Status with color coding
  if (status != null && status.phase != null) {
    Color statusColor = Colors.blue;
    switch (status.phase!.toLowerCase()) {
      case 'bound':
        statusColor = Colors.green;
        break;
      case 'released':
        statusColor = Colors.orange;
        break;
      case 'failed':
        statusColor = Colors.red;
        break;
      case 'available':
      default:
        statusColor = Colors.blue;
    }

    tiles.add(
      SettingsTile(
        leading: leadingText(lang.status, langCode),
        title: Text(
          status.phase ?? "-",
          style: tileValueStyle.copyWith(color: statusColor),
        ),
      ),
    );
  }

  // Capacity
  if (spec != null && spec.capacity.isNotEmpty) {
    // Extract storage value from capacity (usually 'storage' key)
    final storageValue = spec.capacity.entries
            .firstWhere(
              (e) => e.key.toLowerCase() == 'storage',
              orElse: () => MapEntry('storage', ''),
            )
            .value;

    tiles.add(
      copyTileValue(
        lang.pv_capacity,
        storageValue,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );

    // Display all capacity values if more than just storage
    if (spec.capacity.length > 1) {
      tiles.add(
        copyTileYaml(
          lang.pv_capacity_details,
          spec.capacity,
          langCode,
          enLen: 72.0,
          zhLen: 72.0,
        ),
      );
    }
  }

  // Access Modes
  if (spec != null && spec.accessModes.isNotEmpty) {
    final accessModesString = spec.accessModes.join(', ');
    tiles.add(
      copyTileValue(
        lang.pv_access_modes,
        accessModesString,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Reclaim Policy
  if (spec != null && spec.persistentVolumeReclaimPolicy != null) {
    tiles.add(
      copyTileValue(
        lang.pv_reclaim_policy,
        spec.persistentVolumeReclaimPolicy!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Storage Class
  final storageClassName = lang.storage_class;
  final storageClassValue = spec?.storageClassName ?? "-";
  tiles.add(
    copyTileValue(
      storageClassName,
      storageClassValue,
      langCode,
      enLen: 72.0,
      zhLen: 72.0,
    ),
  );

  // Claim (PVC reference) - when PV is bound
  if (spec != null && spec.claimRef != null) {
    final claimRef = spec.claimRef!;
    final namespace = claimRef.namespace ?? "";
    final claimString = namespace.isEmpty
        ? claimRef.name ?? ""
        : "$namespace/${claimRef.name}";
    tiles.add(
      copyTileValue(
        lang.pv_claim,
        claimString,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Reason
  if (status != null && status.reason != null && status.reason!.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.pv_reason,
        status.reason!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Volume Attributes - Mount Options
  if (spec != null && spec.mountOptions.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.pv_mount_options,
        spec.mountOptions.join(', '),
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Display volume mode if available
  if (spec != null && spec.volumeMode != null) {
    tiles.add(
      copyTileValue(
        lang.pv_volume_mode,
        spec.volumeMode!,
        langCode,
        enLen: 72.0,
        zhLen: 72.0,
      ),
    );
  }

  // Node Affinity
  if (spec != null && spec.nodeAffinity != null) {
    final nodeAffinity = spec.nodeAffinity!;
    final hasRequired = nodeAffinity.required_ != null;

    // Only show node affinity if there's content
    if (hasRequired) {
      tiles.add(
        SettingsTile.navigation(
          title: const Text(''),
          leading: leadingText(lang.pv_node_affinity, langCode, enLen: 72.0, zhLen: 72.0),
          value: Text(lang.pv_show, style: tileValueStyle),
          onPressed: (context) {
            List<AbstractSettingsTile> affinityTiles = [];

            if (nodeAffinity.required_ != null) {
              affinityTiles.add(
                copyTileYaml(
                  'Required',
                  nodeAffinity.required_!.toJson(),
                  langCode,
                ),
              );
            }

            showModal(
              context,
              SettingsList(
                sections: [
                  SettingsSection(
                    title: Text(lang.pv_node_affinity),
                    tiles: affinityTiles.isEmpty
                        ? [SettingsTile(title: Text(lang.empty))]
                        : affinityTiles,
                  ),
                ],
                contentPadding: EdgeInsets.zero,
              ),
            );
          },
        ),
      );
    }
  }

  return tiles;
}
