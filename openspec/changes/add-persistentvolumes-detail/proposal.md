# Change: Add PersistentVolumes Detail View

## Why

Users need to view detailed information about Kubernetes PersistentVolume (PV) resources to effectively manage storage in their clusters. Currently, PV resources are listed but there is no detail view to inspect PV properties such as status, capacity, access modes, reclaim policy, storage class, and referenced PVC. This limits the ability to troubleshoot storage issues and understand the state of persistent volumes.

## What Changes

- Add a new case branch for "persistentvolumes" in the `buildDetailSection` method of `/lib/pages/k8s_detail/details_page.dart`
- Create a new detail widget file `/lib/widgets/detail_widgets/persistentvolume.dart` that displays PV-specific information
- Display key PV properties:
  - Status (Available, Bound, Released, Failed)
  - Capacity (storage size)
  - Access Modes (ReadWriteOnce, ReadOnlyMany, ReadWriteMany, ReadWriteOncePod)
  - Reclaim Policy (Retain, Delete, Recycle)
  - Storage Class name
  - Claim (namespace/name of the referenced PVC)
  - Reason (for Failed status or other conditions)
  - Volume attributes (custom attributes)
  - Node affinity (if any)
- Follow existing implementation patterns similar to `services` and `configmaps` widgets

## Impact

- Affected code:
  - `/lib/pages/k8s_detail/details_page.dart` - add pvs case in buildDetailSection switch statement
  - `/lib/widgets/detail_widgets/persistentvolume.dart` - new file with PV detail builder function
- Affected specs:
  - `specs/resource-detail/spec.md` - new spec capability for resource detail views
- No breaking changes - this is purely additive functionality