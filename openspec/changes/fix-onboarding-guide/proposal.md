# Change: Fix Onboarding Guide Issues and Implement Extended Guide Flow

## Why

The current demo cluster onboarding guide has three critical bugs discovered during testing:

1. **Skip persistence issue**: Clicking "Skip Guide" at welcome step or "Skip" during the guide doesn't mark the guide as completed, causing the guide to reappear on subsequent visits to the cluster list page.

2. **Back navigation broken**: The back button doesn't navigate to the previous step's page route, only updates the step state internally.

3. **No i18n support**: All guide text (titles, descriptions, buttons) is hardcoded in English, violating the project's bilingual support (English/Chinese) requirement.

Additionally, the current guide flow is too brief (3 steps) and doesn't adequately cover key features like swipe gestures and the resources overview page.

## What Changes

- **Bug fix - Skip persistence**: Modify `skipGuide()` in `onboarding_guide_service.dart` to persist guide completion to database (via `OnboardingGuideDao.saveCompletion()`) similar to `completeGuide()`, ensuring guides don't reappear after skipping.

- **Bug fix - Back navigation**: Update `previousStep()` handler in `landing.dart` to navigate to the previous step's route using `DemoClusterGuide.getPreviousStepId()` and `GuideStepDefinition.routeName`/`routeParams`.

- **Feature - i18n support**:
  - Add all guide text keys to `lib/l10n/intl_en.arb` and `lib/l10n/intl_zh_CN.arb`
  - Modify `GuideStepDefinition` to accept localization keys instead of hardcoded text
  - Update `InteractiveGuideOverlay` and guide rendering to use `S.of(context)` for localized strings

- **Feature - Extended guide flow**: Redefine guide steps from 3 to 8 steps:
  1. Welcome step (cluster list page)
  2. Workloads overview page (explain available workload resources)
  3. Pod list with swipe gestures explanation (left swipe = delete, right swipe = more actions)
  4. Pod detail page (explain YAML, logs, terminal features)
  5. Resources navigation menu page (explain available resource categories like Config, Storage, Networking)
  6. Nodes list with swipe gestures explanation
  7. First node detail page (explain node monitoring features)
  8. Guide completion (return to cluster list page, mention help documentation)

- Update `DemoClusterGuide` step definitions with new routes and target keys
- Add new GlobalKeys for target elements (workloads, pod list, pod detail, resources, nodes, node detail)
- Ensure demo cluster has pod "web-demo" and at least one node (dynamically fetched) for the guide steps

## Impact

- Affected specs: `onboarding-guide` (new capability or modify existing)
- Affected code:
  - `lib/services/onboarding_guide_service.dart` - Fix `skipGuide()` to persist completion
  - `lib/pages/landing.dart` - Fix back navigation with route handling
  - `lib/models/guide_step_definition.dart` - Support i18n keys
  - `lib/widgets/interactive_guide_overlay.dart` - Use localized strings
  - `lib/l10n/intl_en.arb` / `lib/l10n/intl_zh_CN.arb` - Add guide text keys
  - `lib/models/guide_keys.dart` - Add new target keys for extended steps
- Testing:
  - **TDD required**: Unit tests MUST be written before implementation
  - **BDD required**: Must pass `make test-bdd-macos`, `flutter test`, and `flutter build ios --debug --no-codesign`
  - Update existing BDD tests for skip behavior
  - Add new BDD scenarios for back navigation, i18n, dynamic node selection
  - Verify skip persistence and back navigation work correctly
