import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:settings_ui/settings_ui.dart';

/// Length constants for UI tiles
const double _tileEnLen = 72.0;
const double _tileZhLen = 45.0;
const double _tileZhLenMedium = 60.0;

List<AbstractSettingsTile> buildNodeDetailSectionTiles(
  BuildContext context,
  IoK8sApiCoreV1NodeSpec? spec,
  IoK8sApiCoreV1NodeStatus? status,
  String langCode,
) {
  final lang = S.of(context);

  List<AbstractSettingsTile> tiles = [];

  // Handle null or empty data
  if (spec == null || status == null) {
    return [
      SettingsTile(
        title: Text(lang.empty),
        description: Text(lang.empty),
        leading: const Icon(Icons.warning, color: Colors.orange),
      ),
    ];
  }

  final nodeInfo = status.nodeInfo;
  if (nodeInfo == null) {
    return [
      SettingsTile(
        title: Text(lang.empty),
        description: const Text('Node information not available'),
        leading: const Icon(Icons.info, color: Colors.blue),
      ),
    ];
  }

  // Display Operating System Image
  if (nodeInfo.osImage.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.os_image,
        nodeInfo.osImage,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display Architecture
  if (nodeInfo.architecture.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.architecture,
        nodeInfo.architecture,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display Kernel Version
  if (nodeInfo.kernelVersion.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.kernel_version,
        nodeInfo.kernelVersion,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLenMedium,
      ),
    );
  }

  // Display Container Runtime Version
  if (nodeInfo.containerRuntimeVersion.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.container_runtime_version,
        nodeInfo.containerRuntimeVersion,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileEnLen,
      ),
    );
  }

  // Display Kubelet Version
  if (nodeInfo.kubeletVersion.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.kubelet_version,
        nodeInfo.kubeletVersion,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLenMedium,
      ),
    );
  }

  // Display OS Type
  if (nodeInfo.operatingSystem.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.os_type,
        nodeInfo.operatingSystem,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display Pod CIDR
  final podCidr = spec.podCIDR;
  if (podCidr != null && podCidr.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.pod_cidr,
        podCidr,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display IP Addresses
  if (status.addresses.isNotEmpty) {
    for (final addr in status.addresses) {
      // Only add if both type and address are non-empty
      if (addr.type.isNotEmpty && addr.address.isNotEmpty) {
        tiles.add(
          copyTileValue(
            addr.type,
            addr.address,
            langCode,
            enLen: _tileEnLen,
            zhLen: _tileZhLenMedium,
          ),
        );
      }
    }
  }

  // Display Unschedulable status
  if (spec.unschedulable ?? false) {
    tiles.add(
      copyTileValue(
        lang.unschedulable,
        spec.unschedulable.toString(),
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLenMedium,
      ),
    );
  }

  // Display Node Capacity
  if (status.capacity.isNotEmpty) {
    tiles.add(
      copyTileYaml(
        lang.capacity,
        status.capacity,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display Node Allocatable
  if (status.allocatable.isNotEmpty) {
    tiles.add(
      copyTileYaml(
        lang.allocatable,
        status.allocatable,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLen,
      ),
    );
  }

  // Display Node Conditions
  if (status.conditions.isNotEmpty) {
    final validConditions = status.conditions
        .where((c) => c.type.isNotEmpty)
        .map((c) {
          final statusPart = c.status.isNotEmpty ? c.status : 'Unknown';
          final reason = c.reason;
          return '${c.type}: $statusPart${reason != null && reason.isNotEmpty ? ' ($reason)' : ''}';
        })
        .where((s) => s.isNotEmpty)
        .toList();

    if (validConditions.isNotEmpty) {
      tiles.add(
        copyTileValue(
          lang.conditions,
          validConditions.join('\n'),
          langCode,
          enLen: _tileEnLen,
          zhLen: _tileZhLen,
        ),
      );
    }
  }

  // Display Pod CIDRs (if multiple and different from single podCIDR)
  final podCidrs = spec.podCIDRs;
  if (podCidrs.isNotEmpty && podCidrs.length > 1) {
    tiles.add(
      copyTileValue(
        lang.pod_cidrs,
        podCidrs.join(', '),
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLenMedium,
      ),
    );
  }

  // Display Provider ID (if available)
  final providerId = spec.providerID;
  if (providerId != null && providerId.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.provider_id,
        providerId,
        langCode,
        enLen: _tileEnLen,
        zhLen: _tileZhLenMedium,
      ),
    );
  }

  // Return empty state if no data was added
  if (tiles.isEmpty) {
    return [
      SettingsTile(
        title: Text(lang.empty),
        leading: const Icon(Icons.info, color: Colors.blue),
      ),
    ];
  }

  return tiles;
}
