# Change: Enhance Demo Cluster Onboarding Guide with Interactive Overlay

## Why

The current demo cluster onboarding guide has basic service infrastructure (`onboarding_guide_service.dart`) and a simple overlay widget (`guide_overlay.dart`), but lacks a complete interactive onboarding experience. Users cannot:
- Navigate to specific pages through the guide
- See visual highlights of UI elements (spotlight effect)
- Get guided step-by-step interactions with actual UI components
- Restart the guide after completion

This limits the effectiveness of first-time user onboarding for the demo cluster.

## What Changes

- Introduce `tutorial_coach_mark` package for interactive guide overlay capabilities
- Implement page jump coordination between guide steps and GoRouter navigation
- Add spotlight/highlight effects for target UI elements
- Enable step navigation (next, previous, skip, complete)
- Store guide completion status to avoid re-showing
- Add option to restart guide from settings

## Impact

- Affected specs: `onboarding-guide` (new capability)
- Affected code:
  - `lib/services/onboarding_guide_service.dart` - Enhanced with jump coordination and persistence
  - `lib/widgets/guide_overlay.dart` - Replaced/refactored to use tutorial_coach_mark
  - `lib/router.dart` - May need adjustments for guide-aware navigation
  - `lib/pages/k8s_list/cluster/home.dart` - Trigger point for demo cluster guide
  - Target pages (Pods, etc.) - Need key attributes for element highlighting
- Testing: Full TDD unit tests + BDD integration tests with flutter_gherkin
