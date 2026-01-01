# Change: Add CRD Resource Details Page

## Why
Users can currently list CRDs (Custom Resource Definitions) in the resources section, but when they click on a specific CRD to view its details, the page shows a "Building" placeholder. The implementation is missing the case branch in `buildDetailSection` method to properly display CRD resource information such as group, version, kind, scope, names, shortNames, and storage version.

## What Changes
- Add "crds" case branch to `buildDetailSection` method in `./lib/pages/k8s_detail/details_page.dart`
- Create new detail widget file `./lib/widgets/detail_widgets/crd.dart` with function `buildCrdDetailSectionTiles`
- Display CRD metadata fields: group, version, kind, scope, names (plural, singular, categories), shortNames, and storage version
- Import the new CRD widget in details_page.dart
- Follow the existing pattern used by services and configmaps implementations

## Impact
- Affected specs: resource-details capability
- Affected code:
  - `./lib/pages/k8s_detail/details_page.dart` (switch statement)
  - New file: `./lib/widgets/detail_widgets/crd.dart`
