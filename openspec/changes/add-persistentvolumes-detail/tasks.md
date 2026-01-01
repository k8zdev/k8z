## 1. Implementation

- [ ] 1.1 Create persistentvolume detail widget at `/lib/widgets/detail_widgets/persistentvolume.dart`
- [ ] 1.2 Add `buildPersistentVolumeDetailTiles` function with parameters: context, IoK8sApiCoreV1PersistentVolume, langCode
- [ ] 1.3 Display PV status with appropriate styling (Available: blue, Bound: green, Released: orange, Failed: red)
- [ ] 1.4 Display capacity value in human-readable format (e.g., '10Gi', '500Mi')
- [ ] 1.5 Display access modes as comma-separated list
- [ ] 1.6 Display reclaim policy
- [ ] 1.7 Display storage class name reference
- [ ] 1.8 Display PVC claim reference if bound (namespace/name format)
- [ ] 1.9 Display reason field if present
- [ ] 1.10 Display volume attributes if present
- [ ] 1.11 Display node affinity information if present
- [ ] 1.12 Add "persistentvolumes" case to buildDetailSection switch statement in details_page.dart
- [ ] 1.13 Import persistentvolume widget in details_page.dart
- [ ] 1.14 Test the PV detail view with demo cluster data
- [ ] 1.15 Verify UI consistency with existing resource detail pages

## 2. Testing

- [ ] 2.1 Write BDD feature file for PersistentVolumes details page navigation
- [ ] 2.2 Implement BDD step definitions for PV scenarios
- [ ] 2.3 Add unit tests for buildPersistentVolumeDetailTiles
- [ ] 2.4 Test with PV in Available status
- [ ] 2.5 Test with PV in Bound status
- [ ] 2.6 Test with PV in Failed status
- [ ] 2.7 Run `flutter test` to ensure all tests pass
- [ ] 2.8 Run `make test-bdd-macos` to verify BDD scenarios pass
- [ ] 2.9 Fix any BDD test failures immediately before proceeding
- [ ] 2.10 Test with various access modes combinations
- [ ] 2.11 Test with node affinity present
- [ ] 2.12 Test edge cases (null spec, null status, empty fields)

## 3. iOS Build Verification (MANDATORY)
- [ ] 3.1 Run `flb ios --debug --no-codesign` to verify iOS debug build compiles successfully
- [ ] 3.2 If build fails, **fix issues immediately** before proceeding
- [ ] 3.3 Re-run `flb ios --debug --no-codesign` to confirm build succeeds
