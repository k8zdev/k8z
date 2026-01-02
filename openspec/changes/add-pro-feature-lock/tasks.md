# Tasks for add-pro-feature-lock

**TDD/BDD Requirements:**
- All code MUST be written test-first (TDD)
- Write BDD feature files before implementing user-facing behavior
- Tests MUST pass before committing code
- Issues found during testing MUST be fixed immediately before proceeding
- Run `flutter test` and `make test-bdd-macos` after each implementation

## 1. BDD Feature Files (TDD: Write BEFORE implementation)

- [ ] 1.1 Create BDD feature file `test_features/pro_feature_lock.feature` for Pro subscription status
- [ ] 1.2 Create BDD feature file `test_features/cluster_limit.feature` for cluster count limitation
- [ ] 1.3 Create BDD feature file `test_features/emergency_operations.feature` for free emergency operations
- [ ] 1.4 Create BDD feature file `test_features/node_shell_lock.feature` for Node Shell lock
- [ ] 1.5 Create BDD feature file `test_features/yaml_edit_lock.feature` for YAML edit lock
- [ ] 1.6 Create BDD feature file `test_features/probabilistic_prompt.feature` for app open counter

## 2. BDD Step Definitions (TDD: Write BEFORE implementation)

- [ ] 2.1 Implement step definitions for Pro subscription status scenarios
- [ ] 2.2 Implement step definitions for cluster count limitation scenarios
- [ ] 2.3 Implement step definitions for emergency operations scenarios
- [ ] 2.4 Implement step definitions for Node Shell lock scenarios
- [ ] 2.5 Implement step definitions for YAML edit lock scenarios
- [ ] 2.6 Implement step definitions for probabilistic upgrade prompt scenarios

## 3. Core Service Implementation (TDD: Test BEFORE code)

- [ ] 3.1 Write unit test for ProFeatures.isPro() with all subscription states
- [ ] 3.2 Write unit test for canAddCluster() with all edge cases
- [ ] 3.3 Run tests: FAIL (red) → Create minimal implementation → Pass (green)
- [ ] 3.4 Create `lib/services/pro_features.dart` with ProFeatures service class
- [ ] 3.5 Implement `isPro(CustomerInfo?)` static method
- [ ] 3.6 Run tests: verify ProFeatures.isPro() passes
- [ ] 3.7 Implement `canAddCluster(int currentCount, bool isPro)` method
- [ ] 3.8 Run tests: verify canAddCluster() passes
- [ ] 3.9 Implement `canUseNodeShell(bool isPro)` method
- [ ] 3.10 Write unit test for grandfathering logic
- [ ] 3.11 Run tests: FAIL → Implement grandfathering → Pass
- [ ] 3.12 Implement grandfathering check logic
- [ ] 3.13 Run tests: verify tests pass
- [ ] [ ] 3.14 Fix any test failures immediately

## 4. RevenueCat Integration Update (TDD: Test BEFORE code)

- [ ] 4.1 Write unit test for RevenueCatCustomer.isPro getter with mock CustomerInfo
- [ ] 4.2 Run tests: FAIL → Add isPro getter → Pass
- [ ] 4.3 Update `lib/providers/revenuecat_customer.dart` to add isPro getter
- [ ] 4.4 Run tests: verify isPro getter works correctly
- [ ] 4.5 Test notifyListeners() is called on subscription status change
- [ ] 4.6 Fix any test failures immediately

## 5. App Open Counter and Probabilistic Upgrade Prompt (TDD: Test BEFORE code)

- [ ] 5.1 Write unit test for AppUsageTracker.incrementOpenCount()
- [ ] 5.2 Write unit test for AppUsageTracker.getOpenCount()
- [ ] 5.3 Write unit test for AppUsageTracker.shouldShowUpgradePrompt()
- [ ] 5.4 Run tests: FAIL → Create implementation → Pass
- [ ] 5.5 Create `lib/services/app_usage_tracker.dart`
- [ ] 5.6 Implement incrementOpenCount() method
- [ ] 5.7 Implement getOpenCount() method
- [ ] 5.8 Implement shouldShowUpgradePrompt() with logic: openCount >= 10 AND openCount % 3 == 1 AND not Pro
- [ ] 5.9 Run tests: verify prompt shows on opens 10, 13, 16, 19...
- [ ] 5.10 Run tests: verify prompt does NOT show on opens 11, 12, 14, 15...
- [ ] 5.11 Write widget test for probabilistic upgrade dialog trigger
- [ ] 5.12 Run tests: FAIL → Add trigger in main.dart → Pass
- [ ] 5.13 Integrate incrementOpenCount() in main.dart after initialization
- [ ] 5.14 Add probabilistic upgrade prompt check after app initialization
- [ ] 5.15 Run tests: verify prompt trigger works correctly
- [ ] 5.16 Fix any test failures immediately

## 6. Upgrade Dialog Component (TDD: Widget test BEFORE code)

- [ ] 6.1 Write widget test for ProUpgradeDialog component
- [ ] 6.2 Test dialog displays locked feature name
- [ ] 6.3 Test dialog displays 6 Pro benefits
- [ ] 6.4 Test Cancel button closes dialog
- [ ] 6.5 Test View Pro Plans button navigates to paywall
- [ ] 6.6 Run tests: FAIL → Create widget → Pass
- [ ] 6.7 Create `lib/widgets/pro_upgrade_dialog.dart`
- [ ] 6.8 Implement dialog with lock icon and "k8z Pro" title
- [ ] 6.9 Implement feature description display
- [ ] 6.10 Implement Pro benefits list (6 items)
- [ ] 6.11 Implement Cancel and View Pro Plans buttons
- [ ] 6.12 Implement navigation to paywall
- [ ] 6.13 Run widget tests: verify all tests pass
- [ ] 6.14 Fix any test failures immediately

## 7. Cluster Count Lock Implementation (TDD: Test BEFORE code)

- [ ] 7.1 Write BDD scenarios for cluster addition limit
- [ ] 7.2 Write widget tests for grandfathering flag check
- [ ] 7.3 Run tests: FAIL → Implement → Pass
- [ ] 7.4 Implement grandfathering flag storage in SharedPreferences
- [ ] 7.5 Set grandfathering flag on first launch if cluster count > 2
- [ ] 7.6 Update `lib/pages/clusters/add_cluster_page.dart` with Pro check
- [ ] 7.7 Implement cluster count check logic
- [ ] 7.8 Run BDD tests: verify cluster limit enforcement
- [ ] 7.9 Run unit tests: verify grandfathering logic works
- [ ] 7.10 Fix any test failures immediately before proceeding

## 8. Node Shell Lock Implementation (TDD: Test BEFORE code)

- [ ] 8.1 Write BDD scenarios for Node Shell vs Pod Shell differentiation
- [ ] 8.2 Write widget test for Pro badge on Node Shell button
- [ ] 8.3 Write widget test for upgrade dialog on Node Shell tap
- [ ] 8.4 Run tests: FAIL → Implement → Pass
- [ ] 8.5 Find Node Shell button entry point in code
- [ ] 8.6 Add Pro badge icon overlay widget
- [ ] 8.7 Integrate Pro badge into Node Shell button
- [ ] 8.8 Implement Pro check on Node Shell button tap
- [ ] 8.9 Run BDD tests: verify Free user sees upgrade dialog
- [ ] 8.10 Run BDD tests: verify Pro user can access Node Shell
- [ ] 8.11 Fix any test failures immediately

## 9. YAML Edit/Apply Lock Implementation (TDD: Test BEFORE code)

- [ ] 9.1 Write BDD scenarios for YAML edit lock behavior
- [ ] 9.2 Write widget test for Pro badge on YAML edit button
- [ ] 9.3 Write widget test for upgrade dialog on YAML edit tap
- [ ] 9.4 Run tests: FAIL → Implement → Pass
- [ ] 9.5 Find YAML edit button in resource detail pages
- [ ] 9.6 Integrate Pro badge into YAML edit button
- [ ] 9.7 Implement Pro check before opening YAML editor
- [ ] 9.8 Implement Pro check for YAML Apply operation
- [ ] 9.9 Run BDD tests: verify YAML edit locked for Free users
- [ ] 9.10 Run BDD tests: verify YAML edit unlocked for Pro users
- [ ] 9.11 Fix any test failures immediately before proceeding

## 10. UI Badge Widget (TDD: Widget test BEFORE code)

- [ ] 10.1 Write widget test for ProLockedBadge component
- [ ] 10.2 Test badge displays lock icon overlay
- [ ] 10.3 Test badge does not obstruct button content
- [ ] 10.4 Run tests: FAIL → Create widget → Pass
- [ ] 10.5 Create `lib/widgets/pro_locked_badge.dart`
- [ ] 10.6 Implement lock icon overlay widget
- [ ] 10.7 Run widget tests: verify badge renders correctly
- [ ] 10.8 Fix any test failures immediately

## 11. UI Badge Integration (TDD: Widget tests AFTER component)

- [ ] 11.1 Write widget test for Node Shell button with Pro badge
- [ ] 11.2 Write widget test for YAML edit button with Pro badge
- [ ] 11.3 Run tests: FAIL → Integrate badges → Pass
- [ ] 11.4 Integrate ProLockedBadge into Node Shell button
- [ ] 11.5 Integrate ProLockedBadge into YAML edit button
- [ ] 11.6 Integrate ProLockedBadge into log search button (if exists)
- [ ] 11.7 Run widget tests: verify badges visible on buttons
- [ ] 11.8 Fix any test failures immediately

## 12. BDD Integration Tests (TDD: Write scenarios BEFORE code, run AFTER)

- [ ] 12.1 Run `make test-bdd-macos` to verify all BDD scenarios pass
- [ ] 12.2 If any BDD test fails, analyze failure and fix immediately
- [ ] 12.3 Re-run `make test-bdd-macos` until all tests pass
- [ ] 12.4 Create BDD scenario for end-to-end cluster limit enforcement
- [ ] 12.5 Create BDD scenario for end-to-end Pro upgrade flow
- [ ] 12.6 Run BDD tests: FAIL → Fix issues → Pass
- [ ] 12.7 Document any issues found and how they were resolved

## 13. Localization & Testing (TDD: Test after strings added)

- [ ] 13.1 Add localization strings for upgrade dialog title
- [ ] 13.2 Add localization strings for Pro benefits list
- [ ] 13.3 Add localization strings for cluster limit messages
- [ ] 13.4 Add localization strings for feature locked messages
- [ ] 13.5 Write widget tests for localization (English and Chinese)
- [ ] 13.6 Run tests: verify all strings display correctly
- [ ] 13.7 Fix any localization test failures immediately

## 14. iOS Build Verification (MANDATORY - After all tests pass)

- [ ] 14.1 Run `flutter test` to verify all unit and widget tests pass
- [ ] 14.2 Run `make test-bdd-macos` to verify all BDD tests pass
- [ ] 14.3 Run `flutter analyze` to verify no compilation errors
- [ ] 14.4 If any test fails, fix immediately before proceeding
- [ ] 14.5 If build fails, fix issues immediately before proceeding
- [ ] 14.6 Re-run `flutter analyze` and `flutter test` to confirm all pass
- [ ] 14.7 Document any issues found during testing and how they were resolved

## 15. Issue Resolution & Code Quality (MANDATORY - Fix issues found during testing)

- [ ] 15.1 Review all test failures and fix root cause (not just symptoms)
- [ ] 15.2 Ensure fix includes test coverage for the specific issue
- [ ] 15.3 Re-run tests to verify fix works
- [ ] 15.4 Check for code coverage gaps and add tests if needed
- [ ] 15.5 Run linter and fix any warnings
- [ ] 15.6 Ensure code follows project conventions
- [ ] 15.7 Document any edge cases discovered during testing
