# Change: Add PVC Resource Detail Page

## Why

Currently, the K8z application supports viewing details for various Kubernetes resources (Services, ConfigMaps, Secrets, Pods, etc.), but PersistentVolumeClaims (PVCs) resource details are not implemented. When users click on a PVC from the resource list to view its details, they see a "building" placeholder message instead of actual PVC information. This creates an incomplete user experience and limits users' ability to manage storage-related resources in their clusters.

## What Changes

- Add "persistentvolumeclaims" case in the `buildDetailSection` method in `/Users/kofj/works/projects/github.com/k8zdev/k8z-detail-pvcs/lib/pages/k8s_detail/details_page.dart`
- Create a new widget file `/Users/kofj/works/projects/github.com/k8zdev/k8z-detail-pvcs/lib/widgets/detail_widgets/pvcs.dart` to display PVC detail tiles
- Implement PVC detail view displaying:
  - **Status**: Current phase of the PVC (Bound, Pending, Lost, etc.)
  - **Capacity**: Storage capacity requested (e.g., 10Gi)
  - **Access Modes**: ReadWriteOnce, ReadOnlyMany, ReadWriteMany, etc.
  - **Storage Class**: The StorageClass name used by the PVC
  - **Volume Name**: The name of the PersistentVolume bound to this PVC (if any)
  - **Volume Mode**: Filesystem or Block
  - **Reason**: Additional information about the PVC state
- Follow the existing implementation pattern used for Services and ConfigMaps

## Impact

- **Affected specs**: `resource-detail` - adds PVC support to the resource detail capability
- **Affected code**:
  - `/Users/kofj/works/projects/github.com/k8zdev/k8z-detail-pvcs/lib/pages/k8s_detail/details_page.dart` - add case branch in buildDetailSection
  - New file: `/Users/kofj/works/projects/github.com/k8zdev/k8z-detail-pvcs/lib/widgets/detail_widgets/pvcs.dart` - PVC detail widget
  - Minor import updates in details_page.dart for the new widget
