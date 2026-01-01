## 1. Implementation
- [ ] 1.1 Create `./lib/widgets/detail_widgets/crd.dart` file
- [ ] 1.2 Implement `buildCrdDetailSectionTiles` function with CRD-specific fields (group, version, kind, scope, names, shortNames, storage version)
- [ ] 1.3 Add import for the new CRD widget in details_page.dart
- [ ] 1.4 Add "crds" case branch to `buildDetailSection` switch statement in details_page.dart
- [ ] 1.5 Test the CRD details page displays correctly with sample CRD data

## 2. Testing
- [ ] 2.1 Write BDD feature file for CRD details page navigation
- [ ] 2.2 Implement BDD step definitions for CRD scenarios
- [ ] 2.3 Write unit tests for `buildCrdDetailSectionTiles` function
- [ ] 2.4 Test with mock CRD data (namespaced and cluster-scoped)
- [ ] 2.5 Run `flutter test` to ensure all tests pass
- [ ] 2.6 Run `make test-bdd-macos` to verify BDD scenarios pass
- [ ] 2.7 Fix any BDD test failures immediately before proceeding

## 3. Documentation
- [ ] 3.1 Update l10n strings if new labels are needed (verify existing l10n covers CRD fields)
- [ ] 3.2 Verify the change follows existing code conventions

## 4. iOS Build Verification (MANDATORY)
- [ ] 4.1 Run `flb ios --debug --no-codesign` to verify iOS debug build compiles successfully
- [ ] 4.2 If build fails, **fix issues immediately** before proceeding
- [ ] 4.3 Re-run `flb ios --debug --no-codesign` to confirm build succeeds