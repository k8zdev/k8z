# Change: Add events resource detail view

## Why
Users can currently view a list of Kubernetes Events in the resources section, but cannot inspect individual Event details. Event details are critical for debugging and understanding cluster issues, as they contain important information about the type, reason, message, and involved objects. Adding a detail view for Events will improve troubleshooting capabilities and provide complete feature parity with other resource types.

## What Changes
- Add "events" case to `buildDetailSection` switch statement in `lib/pages/k8s_detail/details_page.dart`
- Create new detail widget function `buildEventsDetailSectionTiles` in `lib/widgets/detail_widgets/` following same pattern as `buildServicesTiles`
- Display Event-specific fields: type, reason, message, count, involved object details, timestamps (first/last)
- Follow existing patterns from services/configmaps implementation for consistency

## Impact
- Affected specs: `resource-detail` (new capability)
- Affected code:
  - `lib/pages/k8s_detail/details_page.dart:601-740` - buildDetailSection switch
  - `lib/widgets/detail_widgets/` - new events_detail.dart file
- Testing:
  - Create BDD feature file for Events detail view navigation
  - Implement BDD step definitions
  - Run `make test-bdd-macos` to verify scenarios pass