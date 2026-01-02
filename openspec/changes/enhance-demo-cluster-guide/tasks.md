# Implementation Tasks

## 1. Foundation and Testing Setup

- [ ] 1.1 Add `tutorial_coach_mark` package to pubspec.yaml
- [ ] 1.2 Create database migration script for onboarding_guide_state table
- [ ] 1.3 Initialize flutter_gherkin feature file structure for guide tests
- [ ] 1.4 Write unit tests for OnboardingGuideService state management (TDD: test-first)
- [ ] 1.5 Write BDD feature file for guide auto-trigger scenario
- [ ] 1.6 Write BDD feature file for guide step navigation

## 2. Guide Step Definition Structure

- [ ] 2.1 Create GuideStepDefinition model class (TDD: unit tests first)
- [ ] 2.2 Define demo cluster guide steps array with routes and target keys
- [ ] 2.3 Write unit tests for guide step data structure validation
- [ ] 2.4 Write BDD scenarios for step definition with route parameters

## 3. Database Persistence Layer

- [ ] 3.1 Create OnboardingGuideDao class for database operations (TDD: unit tests first)
- [ ] 3.2 Implement saveCompletion() method with timestamp
- [ ] 3.3 Implement isGuideCompleted() query method
- [ ] 3.4 Implement resetGuide() method for clearing completion
- [ ] 3.5 Write unit tests for DAO CRUD operations
- [ ] 3.6 Write BDD scenario for completion persistence

## 4. OnboardingGuideService Enhancements

- [ ] 4.1 Update OnboardingGuideService to persist completion state (TDD: unit tests first)
- [ ] 4.2 Add getStepDefinition() method to return GuideStepDefinition with route
- [ ] 4.3 Add navigation coordination via Stream or callback for route changes
- [ ] 4.4 Implement checkCompletionAndStart() method for auto-trigger logic
- [ ] 4.5 Add restartGuide() method for manual restart
- [ ] 4.6 Update existing test suite for service enhancements
- [ ] 4.7 Write BDD scenarios for guide restart from settings

## 5. Interactive Guide Overlay Widget

- [ ] 5.1 Create InteractiveGuideOverlay widget using tutorial_coach_mark (TDD: widget tests first)
- [ ] 5.2 Implement spotlight configuration with target GlobalKey
- [ ] 5.3 Implement guide card with responsive positioning
- [ ] 5.4 Add navigation controls (Next, Previous, Skip, Complete)
- [ ] 5.5 Handle page jump on button click via Navigation callback
- [ ] 5.6 Write widget tests for spotlight positioning
- [ ] 5.7 Write BDD scenarios for element spotlight highlighting

## 6. Target Element GlobalKeys

- [ ] 6.1 Add GlobalKeys to PodsPage target elements (pod list, action buttons)
- [ ] 6.2 Add GlobalKeys to Pod detail page elements (logs tab, YAML button)
- [ ] 6.3 Add GlobalKeys to ClusterHomePage elements (demo cluster trigger)
- [ ] 6.4 Document key naming convention in code comments
- [ ] 6.5 Write widget tests verifying key attachment

## 7. Router Integration

- [ ] 7.1 Add optional guide parameter handling to relevant routes (if needed)
- [ ] 7.2 Create navigation helper for guide step transitions
- [ ] 7.3 Test navigation between guide steps across different pages
- [ ] 7.4 Write BDD scenario for multi-page guide navigation

## 8. Demo Cluster Integration

- [ ] 8.1 Update ClusterHomePage to check guide completion before triggering (TDD: tests first)
- [ ] 8.2 Attach InteractiveGuideOverlay to demo cluster flow
- [ ] 8.3 Connect guide service stream to overlay widget
- [ ] 8.4 Test auto-trigger on first-time demo cluster creation
- [ ] 8.5 Write BDD scenarios for first-time vs subsequent demo cluster access

## 9. Settings Page Integration

- [ ] 9.1 Add "Replay Onboarding Guide" option to settings page (TDD: tests first)
- [ ] 9.2 Implement reset button handler
- [ ] 9.3 Show guide completion status in settings
- [ ] 9.4 Write widget tests for settings UI
- [ ] 9.5 Write BDD scenarios for guide restart from settings

## 10. Cross-Platform Testing

- [ ] 10.1 Run BDD tests on macOS target (@logic tag)
- [ ] 10.2 Run critical BDD tests on iOS simulator (@ios-critical tag)
- [ ] 10.3 Fix any platform-specific issues
- [ ] 10.4 Verify tutorial_coach_mark behavior on all target platforms

## 11. Localization

- [ ] 11.1 Add guide text strings to localization files (English/Chinese)
- [ ] 11.2 Localize button labels (Next, Previous, Skip, Complete)
- [ ] 11.3 Test guide display in both languages
- [ ] 11.4 Update l10n files with flutter pub run intl_utils

## 12. Documentation and Cleanup

- [ ] 12.1 Update inline documentation for affected files
- [ ] 12.2 Add guide configuration notes to project README or wiki
- [ ] 12.3 Remove or deprecate old GuideOverlay if no longer used
- [ ] 12.4 Run flutter analyze to fix any lint issues
- [ ] 12.5 Run all tests and ensure 100% pass rate

## 13. Final Validation

- [ ] 13.1 Run `flutter test` for all unit tests
- [ ] 13.2 Run BDD tests with flutter_gherkin
- [ ] 13.3 Manual testing on demo cluster creation flow
- [ ] 13.4 Test guide restart functionality
- [ ] 13.5 Verify all acceptance criteria from spec are met
- [ ] 13.6 Fix any remaining issues found during testing
