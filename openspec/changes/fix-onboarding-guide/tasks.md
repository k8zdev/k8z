# Implementation Tasks

## 1. Fix Skip Guide Persistence Bug

- [ ] 1.1 Modify `skipGuide()` in `onboarding_guide_service.dart` to persist completion
  - Call `OnboardingGuideDao.saveCompletion()` with `OnboardingGuideState.completed()`
  - Store skip timestamp in `completed_at` field
  - Store skipped step in `last_step` field
- [ ] 1.2 Update analytics logging for skip event to include timestamp
- [ ] 1.3 Write unit test for `skipGuide()` persistence (TDD: test-first)
- [ ] 1.4 Write BDD scenario for skip persistence across app restart
- [ ] 1.5 Write BDD scenario for retrying skipped guide from settings

## 2. Fix Back Button Route Navigation

- [ ] 2.1 Implement `_handlePreviousStep()` in `landing.dart`
  - Get previous step ID via `DemoClusterGuide.getPreviousStepId()`
  - Get `GuideStepDefinition` via `DemoClusterGuide.getStepById()`
  - Call `navigateToStep()` to update state
  - Navigate to route via `_navigateToRoute()` with route params
- [ ] 2.2 Update step index tracking on back navigation
- [ ] 2.3 Ensure back button is hidden/disabled on first step
- [ ] 2.4 Write widget test for back navigation with route changes
- [ ] 2.5 Write BDD scenarios for all back button transitions (pod list ← workloads, pod detail ← pod list, resources ← pod detail, nodes ← resources, node detail ← nodes)

## 3. Add i18n Keys to ARB Files

- [ ] 3.1 Add guide text keys to `lib/l10n/intl_en.arb`
  - 8 step titles (`guide_step_1_title` through `guide_step_8_title`)
  - 8 step descriptions (`guide_step_1_desc` through `guide_step_8_desc`)
  - Button labels (`guide_button_next`, `guide_button_skip`, `guide_button_back`, `guide_button_complete`)
  - Ensure proper `@description` metadata for each key
- [ ] 3.2 Add guide text keys to `lib/l10n/intl_zh_CN.arb` (Chinese translations)
  - Translate all step titles to Chinese
  - Translate all step descriptions to Chinese (include swipe gesture explanations)
  - Translate all button labels to Chinese
- [ ] 3.3 Run `flutter pub run intl_utils` to generate updated `S` class
- [ ] 3.4 Verify i18n build succeeds without errors

## 4. Update GuideStepDefinition for i18n Support

- [ ] 4.1 Add i18n key properties to `GuideStepDefinition` class
  - `l10nTitle`, `l10nDescription`, `l10nButtonNext`, `l10nButtonSkip`, `l10nButtonPrev`, `l10nButtonComplete`
  - Keep existing direct text properties with `@Deprecated` annotation for backward compatibility
- [ ] 4.2 Add `getLocalizedTitle(BuildContext context)` method
  - Return localized string if `l10nTitle` is set
  - Fall back to direct `title` property if `l10nTitle` is null
- [ ] 4.3 Add similar getter methods for description and button labels
- [ ] 4.4 Write unit tests for i18n fallback logic (TDD: test-first)
- [ ] 4.5 Update `InteractiveGuideOverlay` to use localized getters
  - Replace direct `step.title` with `step.getLocalizedTitle(context)`
  - Replace direct `step.description` with `step.getLocalizedDescription(context)`
  - Replace direct button labels with localized getter methods

## 5. Add New GlobalKeys for Extended Flow

- [ ] 5.1 Add `workloadsTargetKey` to `GuideKeys` class
- [ ] 5.2 Add `podDetailTargetKey` to `GuideKeys` class
- [ ] 5.3 Add `resourcesTargetKey` to `GuideKeys` class
- [ ] 5.4 Add `nodeDetailTargetKey` to `GuideKeys` class
- [ ] 5.5 Remove unnecessary old keys (`podSwipeTargetKey`, `detailTabsTargetKey`, `detailActionTargetKey`, `nodesSwipeTargetKey` if keeping design simpler)
- [ ] 5.6 Add `completedTargetKey` to `GuideKeys` class
- [ ] 5.7 Update `GuideKeyRegistry` to map new keys
- [ ] 5.8 Write unit tests for key registry completeness

## 6. Attach GlobalKeys to Target Widgets

- [ ] 6.1 Attach `workloadsTargetKey` to workloads list section in `workloads.dart`
- [ ] 6.2 Attach `podListTargetKey` to pods list in `pods.dart` (ensure already attached correctly)
- [ ] 6.3 Attach `podDetailTargetKey` to detail page tab/action area in `details_page.dart`
- [ ] 6.4 Attach `resourcesTargetKey` to resources list section in `resources.dart`
- [ ] 6.5 Attach `nodesTargetKey` to nodes list in `nodes.dart` (ensure already attached correctly)
- [ ] 6.6 Attach `nodeDetailTargetKey` to node detail sections in appropriate node detail page
- [ ] 6.7 Verify all existing keys are still attached correctly

## 7. Redefine Guide Steps for 8-Step Flow

- [ ] 7.1 Update `DemoClusterGuide` step IDs constant
  - Add `workloadsOverviewStepId`
  - Add `podListWithSwipeStepId` (renamed from podListStepId)
  - Add `podDetailStepId`
  - Add `resourcesMenuStepId`
  - Add `nodesListWithSwipeStepId` (renamed from nodesStepId)
  - Add `nodeDetailStepId`
  - Keep `welcomeStepId` and `completedStepId`
- [ ] 7.2 Add target key constants for new steps
- [ ] 7.3 Update `getSteps()` to return 8 steps with proper order:
  - Step 1: welcome (route: 'clusters')
  - Step 2: workloadsOverview (route: 'workloads')
  - Step 3: podListWithSwipe (route: 'pods')
  - Step 4: podDetail (route: 'details', params: path=workloads, resource=pods, name=demo-pod)
  - Step 5: resourcesMenu (route: 'resources')
  - Step 6: nodesListWithSwipe (route: 'nodes')
  - Step 7: nodeDetail (route: 'details', params: path=/api/v1, namespace=_, resource=nodes, name=<dynamic-first-node>)
  - Step 8: completed (route: 'clusters')
- [ ] 7.4 Use i18n keys for all step text (titles, descriptions, buttons)
- [ ] 7.5 Configure appropriate route parameters for podDetail step
- [ ] 7.6 Configure appropriate route parameters for nodeDetail step
- [ ] 7.7 Verify `getNextStepId()` works for all 8 steps
- [ ] 7.8 Verify `getPreviousStepId()` works for all 8 steps
- [ ] 7.9 Write unit tests for step ordering and navigation

## 8. Update Landing Page Navigation Handlers

- [ ] 8.1 Ensure `_handleNextStep()` handles new step transitions
  - Navigate to workloads from welcome
  - Navigate to pods from workloads overview
  - Navigate to pod detail from pods list
  - Navigate to resources from pod detail
  - Navigate to nodes from resources menu
  - Navigate to node detail from nodes list
  - Navigate to clusters for completion
- [ ] 8.2 Ensure `_handlePreviousStep()` handles all reverse transitions
- [ ] 8.3 Handle route navigation with params for podDetail step (fixed name: web-demo)
- [ ] 8.4 Handle route navigation with params for nodeDetail step using **Scheme B**:
  - Add `_getFirstNodeName()` helper method in LandingPage to fetch nodes from API
  - Use `k8z_native` or existing K8s service to get node list
  - In `_handleNextStep()`, when navigating to nodeDetail step:
    - Call `_getFirstNodeName()` to get first node name asynchronously
    - Build route params map with dynamic node name: `{'name': nodeName}`
    - Log warning and skip step if no nodes available
  - **Design choice**: Dynamic node fetching happens in LandingPage (not in OnboardingGuideService) to maintain clear architecture
- [ ] 8.5 Add `@RouteSettings` or similar for identifying route-based guide state
- [ ] 8.6 Write BDD tests for all multi-step navigation (forward and back)

## 9. Check Router Routes Exist

- [ ] 9.1 Verify 'workloads' route exists in router configuration
- [ ] 9.2 Verify 'pods' route exists in router configuration
- [ ] 9.3 Verify 'details' route with params exists in router configuration
- [ ] 9.4 Verify 'resources' route exists in router configuration
- [ ] 9.5 Verify 'nodes' route exists in router configuration
- [ ] 9.6 Verify 'details' route with params exists for node detail (path=/api/v1, namespace=_, resource=nodes, name)
- [ ] 9.7 Verify 'clusters' route exists for landing/welcome/completion

## 10. Implement Demo Cluster Resources for Guide

- [ ] 10.1 Ensure demo cluster has at least one pod named "demo-pod" (or use first available pod)
- [ ] 10.2 Ensure demo cluster has at least one node (use first available node)
- [ ] 10.3 Add fallback logic to use first pod/node if "demo-pod"/"demo-node" not found
- [ ] 10.4 Verify pod detail step can be navigated to from demo cluster
- [ ] 10.5 Verify node detail step can be navigated to from demo cluster

## 11. Update BDD Tests for New Requirements

- [ ] 11.1 Update `test/bdd/features/onboarding_guide.feature` with new scenarios
  - Skip persistence scenarios
  - All back navigation scenarios (5 transitions: pod list ← workloads, pod detail ← pod list, resources ← pod detail, nodes ← resources, node detail ← nodes)
  - i18n scenarios
  - Extended flow scenarios (all 8 steps)
  - Dynamic node selection scenario
- [ ] 11.2 Update existing step definitions to match new requirements
- [ ] 11.3 Add new step definitions for extended flow testing
- [ ] 11.4 Add step definition for dynamic node fetching from API

## 12. Testing and Validation - REQUIRED TEST EXECUTION

The following test commands MUST be executed before the change is considered complete:

- [ ] 12.1 **REQUIRED**: Execute `flutter test` to ensure all unit tests pass
  - This command MUST run successfully with zero test failures
  - Fix any failing tests before proceeding
- [ ] 12.2 **REQUIRED**: Execute `flutter build ios --debug --no-codesign` to build iOS debug version
  - This command MUST complete successfully without compilation errors
  - The app MUST be buildable for iOS simulator
  - Fix any build errors before proceeding
- [ ] 12.3 **REQUIRED**: Execute `make test-bdd-macos` to run BDD tests on macOS
  - This command MUST complete successfully with all BDD scenarios passing
  - Fix any BDD test failures before proceeding
- [ ] 12.4 Run `flutter analyze` to fix any lint issues
- [ ] 12.5 Test guide in English locale (manual testing or BDD scenarios)
- [ ] 12.6 Test guide in Chinese locale (manual testing or BDD scenarios)
- [ ] 12.7 Test skip flow: skip at welcome, skip mid-flow, restart from settings
- [ ] 12.8 Test back flow: verify all back button transitions work correctly
- [ ] 12.9 Test complete 8-step flow end-to-end
- [ ] 12.10 Verify swipe gesture explanations are clear in guide text
- [ ] 12.11 Verify all target keys highlight correctly with spotlight effect
- [ ] 12.12 Test that guide doesn't reappear after skip/complete
- [ ] 12.13 Test app restart with saved skip/complete state
- [ ] 12.14 Verify pod detail navigation uses correct parameters (web-demo)
- [ ] 12.15 Verify node detail navigation uses dynamic first node from API
- [ ] 12.16 **REQUIRED**: Re-run `flutter test` after any code changes to ensure all tests still pass
- [ ] 12.17 **REQUIRED**: Re-run `make test-bdd-macos` after any code changes to ensure all BDD tests still pass
- [ ] 12.18 **REQUIRED**: Re-run `flutter build ios --debug --no-codesign` after any code changes to ensure build still succeeds

## 13. TDD Implementation - Tests Before Code

Following Test-Driven Development principles, unit tests MUST be written before implementation:

- [ ] 13.1 Write unit test for `skipGuide()` persistence BEFORE implementing the method
  - Test file: `test/services/onboarding_guide_service_test.dart`
  - Test: Verify `OnboardingGuideDao.saveCompletion()` is called
  - Test: Verify `isGuideCompleted()` returns true after skip
- [ ] 13.2 Implement `skipGuide()` method to pass the tests
- [ ] 13.3 Write unit test for `getLocalizedTitle()` i18n fallback BEFORE implementing the method
  - Test file: `test/models/guide_step_definition_test.dart`
  - Test: Verify i18n key is used when available
  - Test: Verify direct text fallback when i18n key is null
- [ ] 13.4 Implement `getLocalizedTitle()` and related methods to pass the tests
- [ ] 13.5 Write unit test for back navigation route handling BEFORE implementing
  - Test file: `test/pages/landing_test.dart`
  - Test: Verify correct route is selected when navigating back
  - Test: Verify route parameters are passed correctly
- [ ] 13.6 Implement `_handlePreviousStep()` method to pass the tests
- [ ] 13.7 Write unit test for dynamic node fetching BEFORE implementing
  - Test file: `test/services/onboarding_guide_service_test.dart`
  - Test: Verify first node is fetched from API
  - Test: Verify node name is used for navigation
- [ ] 13.8 Implement dynamic node selection logic to pass the tests

## 14. Documentation and Code Quality

- [ ] 14.1 Add inline documentation for new i18n properties in `GuideStepDefinition`
- [ ] 14.2 Add comments explaining skip persistence behavior in `skipGuide()`
- [ ] 14.3 Document new step IDs and their purposes in `DemoClusterGuide`
- [ ] 14.4 Document that pod name "web-demo" is expected for pod detail step
- [ ] 14.5 Document that node name is dynamically fetched from API
- [ ] 14.6 Update AGENTS.md or README if guide configuration notes are needed
- [ ] 14.7 Remove `@Deprecated` annotations from old code if fully migrated
- [ ] 14.8 Ensure no TODO comments remain in production code

## 15. Completion Criteria - All Tests Must Pass

Before this change is considered complete, the following MUST be verified:

- [ ] 15.1 **CRITICAL**: `flutter test` passes with zero failures
- [ ] 15.2 **CRITICAL**: `flutter build ios --debug --no-codesign` succeeds without errors
- [ ] 15.3 **CRITICAL**: `make test-bdd-macos` passes all scenarios
- [ ] 15.4 All TDD unit tests written BEFORE implementation (Section 13 complete)
- [ ] 15.5 All BDD scenarios pass (Section 11 and 12.3 complete)
- [ ] 15.6 iOS build works (Section 12.2 complete)
- [ ] 15.7 Manual testing or BDD confirms i18n works in both English and Chinese
- [ ] 15.8 Skip persistence confirmed working (guide doesn't reappear)
- [ ] 15.9 Back navigation working for all 5 transitions
- [ ] 15.10 Dynamic node selection working (uses first node from API)
- [ ] 15.11 Pod detail navigation to "web-demo" working correctly
