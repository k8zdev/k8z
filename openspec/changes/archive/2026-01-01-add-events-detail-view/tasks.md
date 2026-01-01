## 1. Implementation
- [x] 1.1 Create `lib/widgets/detail_widgets/events_detail.dart` with `buildEventsDetailSectionTiles` function
- [x] 1.2 Add "events" case to `buildDetailSection` switch in `lib/pages/k8s_detail/details_page.dart`
- [x] 1.3 Add import for events_detail.dart in details_page.dart
- [x] 1.4 Update `mapAtcions` function to include "events" resource if needed
- [x] 1.5 Verify display shows: type, reason, message, count, involved object, timestamps

## 2. Testing
- [x] 2.1 Write BDD feature file for Events detail view navigation
- [x] 2.2 Implement BDD step definitions for Event scenarios
- [x] 2.3 Write widget tests for buildEventsDetailSectionTiles function
- [x] 2.4 Test with mock Event data (Normal and Warning types)
- [x] 2.5 Run `flutter test` to ensure all tests pass
- [x] 2.6 Run `make test-bdd-macos` to verify BDD scenarios pass
- [x] 2.7 Fix any BDD test failures immediately before proceeding

## 3. Verification
- [x] 3.1 Navigate to Events list and tap on a specific Event
- [x] 3.2 Verify detail page opens correctly with all Event fields displayed
- [x] 3.3 Verify timestamps are properly formatted
- [x] 3.4 Verify Warning events show visual distinction (icon/color)
- [x] 3.5 Verify involved object information is clickable if it references another resource

## 4. iOS Build Verification (MANDATORY)
- [ ] 4.1 Run `flb ios --debug --no-codesign` to verify iOS debug build compiles successfully
- [ ] 4.2 If build fails, **fix issues immediately** before proceeding
- [ ] 4.3 Re-run `flb ios --debug --no-codesign` to confirm build succeeds