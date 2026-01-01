# Tasks for add-pvcs-detail

## 1. Implementation

- [x] 1.1 Create the PVC detail widget file at `/Users/kofj/works/projects/github.com/k8zdev/k8z-detail-pvcs/lib/widgets/detail_widgets/pvcs.dart`
- [x] 1.2 Implement `buildPVCDetailSectionTiles` function that returns a list of settings tiles for PVC details
- [x] 1.3 Display PVC status (phase) using `status.phase`
- [x] 1.4 Display PVC capacity using `spec.resources.requests['storage']`
- [x] 1.5 Display access modes using `spec.accessModes`
- [x] 1.6 Display storage class name using `spec.storageClassName`
- [x] 1.7 Display volume name using `spec.volumeName`
- [x] 1.8 Display volume mode using `spec.volumeMode`
- [ ] 1.9 Display reason using `status.reason` - NOTE: PVC status doesn't have a reason field, this is only available in PV status
- [x] 1.10 Add import statement for the new PVC widget in details_page.dart
- [x] 1.11 Add "persistentvolumeclaims" case in `buildDetailSection` method in details_page.dart
- [x] 1.12 Test the PVC detail page with a real cluster

## 2. Testing

- [x] 2.1 Write BDD feature file for PVCs details page navigation
- [x] 2.2 Implement BDD step definitions for PVC scenarios
- [x] 2.3 Write widget tests for buildPVCDetailSectionTiles function
- [x] 2.4 Test with PVC in Bound status
- [x] 2.5 Test with PVC in Pending status
- [x] 2.6 Run `flutter test` to ensure all tests pass
- [x] 2.7 Run `make test-bdd-macos` to verify BDD scenarios pass
- [x] 2.8 Fix any BDD test failures immediately before proceeding
- [x] 2.9 Verify all PVC fields (status, capacity, access modes, storage class, volume name) are shown correctly
- [x] 2.10 Verify the implementation follows the same pattern as Services and ConfigMaps

## 3. Documentation

- [x] 3.1 Add relevant localization strings (if needed) in the i18n files

## 4. iOS Build Verification (MANDATORY)
- [x] 4.1 Run `flutter analyze` to verify no compilation errors
- [x] 4.2 If build fails, **fix issues immediately** before proceeding
- [x] 4.3 Re-run `flutter analyze` to confirm build succeeds
