# Change: Add StorageClass Resource Detail Page

## Why

K8z currently lacks a dedicated detail page for Kubernetes StorageClass resources. Users can list StorageClasses but cannot view their detailed configuration including provisioner type, reclaim policy, volume binding mode, expansion settings, and provider parameters. This limits admin effectiveness when debugging storage issues or configuring storage for workloads.

## What Changes

- Add "storageclass" case branch to `buildDetailSection` method in `details_page.dart`
- Create new detail widget `buildStorageClassDetailSectionTiles` function in `lib/widgets/detail_widgets/storageclass.dart`
- Display StorageClass key properties:
  - Provisioner (type of storage provider)
  - Reclaim Policy (Delete/Retain)
  - Volume Binding Mode (Immediate/WaitForFirstConsumer)
  - Allow Volume Expansion (boolean)
  - Mount Options (list)
  - Parameters (key-value pairs for provider)
  - Allowed Topologies (if specified)
- Add corresponding localization strings for UI labels in Chinese/English

## Impact

- Affected specs: `detail-pages` capability
- Affected code:
  - `./lib/pages/k8s_detail/details_page.dart` - Add storageclass case
  - New file: `./lib/widgets/detail_widgets/storageclass.dart`
  - Localization files: `./lib/l10n/l10n_*.arb`
