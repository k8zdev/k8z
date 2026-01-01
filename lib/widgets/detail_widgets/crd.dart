import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/tiles.dart';
import 'package:settings_ui/settings_ui.dart';

List<AbstractSettingsTile> buildCrdDetailSectionTiles(
  BuildContext? context,
  IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition? crd,
  String langCode,
) {
  // Fallback S for testing purposes when context is null
  final lang = context != null ? S.of(context) : S();

  List<AbstractSettingsTile> tiles = [];

  if (crd == null) {
    return [SettingsTile(title: Text(lang.empty))];
  }

  final spec = crd.spec;
  final status = crd.status;

  // Add group
  tiles.add(
    copyTileValue(
      lang.crd_group,
      spec.group,
      langCode,
      enLen: 72.0,
      zhLen: 52.0,
    ),
  );

  // Add scope
  tiles.add(
    copyTileValue(
      lang.crd_scope,
      spec.scope,
      langCode,
      enLen: 72.0,
      zhLen: 52.0,
    ),
  );

  // Add names section
  final names = spec.names;
  final kind = names.kind;

  // Add kind
  tiles.add(
    copyTileValue(
      lang.kind,
      kind,
      langCode,
      enLen: 72.0,
      zhLen: 52.0,
    ),
  );

  // Add plural
  tiles.add(
    copyTileValue(
      lang.crd_plural,
      names.plural,
      langCode,
      enLen: 72.0,
      zhLen: 52.0,
    ),
  );

  // Add singular if exists
  if (names.singular != null && names.singular!.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.crd_singular,
        names.singular!,
        langCode,
        enLen: 72.0,
        zhLen: 52.0,
      ),
    );
  }

  // Add shortNames if exists
  if (names.shortNames.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.crd_shortNames,
        names.shortNames.join(', '),
        langCode,
        enLen: 72.0,
        zhLen: 52.0,
      ),
    );
  }

  // Add categories if exists
  if (names.categories.isNotEmpty) {
    tiles.add(
      copyTileValue(
        lang.crd_categories,
        names.categories.join(', '),
        langCode,
        enLen: 72.0,
        zhLen: 52.0,
      ),
    );
  }

  // Add versions list if exists
  if (spec.versions.isNotEmpty) {
    // Find the storage version
    final storageVersion = spec.versions.firstWhere(
      (v) => v.storage,
      orElse: () => spec.versions.first,
    );

    // Add storage version
    tiles.add(
      copyTileValue(
        lang.crd_storageVersion,
        storageVersion.name,
        langCode,
        enLen: 72.0,
        zhLen: 52.0,
      ),
    );

    // Add all versions with metadata
    final versionList = spec.versions.map((v) {
      var versionStr = v.name;
      if (v.storage) {
        versionStr += ' (storage)';
      }
      if (!v.served) {
        versionStr += ' (not served)';
      }
      return versionStr;
    }).join(', ');

    tiles.add(
      copyTileValue(
        lang.crd_versions,
        versionList,
        langCode,
        enLen: 72.0,
        zhLen: 52.0,
      ),
    );
  }

  // Add stored versions from status if exists and versions are defined
  if (status != null && status.storedVersions.isNotEmpty) {
    // Only show stored versions if we have versions defined
    if (spec.versions.isNotEmpty) {
      final storedVersionsList = status.storedVersions.join(', ');
      tiles.add(
        copyTileValue(
          lang.crd_storedVersions,
          storedVersionsList,
          langCode,
          enLen: 72.0,
          zhLen: 52.0,
        ),
      );
    }
  }

  return tiles;
}