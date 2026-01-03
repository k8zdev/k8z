## ADDED Requirements

### Requirement: Skip Guide Persistence

The system SHALL permanently record when a user skips the onboarding guide, ensuring the guide does not reappear on subsequent visits to the cluster list page.

#### Scenario: User skips guide at welcome step
- **GIVEN** a demo cluster has been added
- **WHEN** the user enters the cluster list page for the first time
- **AND** the welcome guide overlay is displayed
- **AND** the user clicks "Skip Guide" button
- **THEN** the guide state shall be saved as completed in the database
- **AND** the guide overlay shall be dismissed
- **WHEN** the user later enters the cluster list page again
- **THEN** the guide shall NOT reappear

#### Scenario: User skips guide mid-flow
- **GIVEN** the onboarding guide is active
- **AND** the user is on any intermediate step (not the first step)
- **WHEN** the user clicks "Skip" button
- **THEN** the guide state shall be saved as completed in the database
- **AND** the guide overlay shall be dismissed
- **WHEN** the user later enters the cluster list page again
- **THEN** the guide shall NOT reappear

#### Scenario: Skip record persists across app restarts
- **GIVEN** a user has skipped the guide on a demo cluster
- **WHEN** the user fully restarts the application
- **WHEN** the user enters the cluster list page
- **THEN** the guide shall NOT reappear

#### Scenario: User can retry skipped guide from settings
- **GIVEN** the guide was previously skipped
- **WHEN** the user navigates to settings
- **AND** the user clicks "Retry Guide" option
- **WHEN** the user returns to cluster list page
- **THEN** the guide shall reappear and start from the welcome step

### Requirement: Back Button Route Navigation

The system SHALL navigate to the previous step's page route when the back button is clicked, ensuring the user returns to the appropriate page for that step.

#### Scenario: Back from pod list returns to workloads overview
- **GIVEN** the user is on the pod list guide step
- **WHEN** the user clicks the "Back" button
- **THEN** the guide state shall update to the previous step ID
- **AND** the app shall navigate to the workloads overview page
- **AND** the guide overlay shall show the workloads overview step content

#### Scenario: Back from pod detail returns to pod list
- **GIVEN** the user is on the pod detail guide step
- **WHEN** the user clicks the "Back" button
- **THEN** the guide state shall update to the pod list step ID
- **AND** the app shall navigate to the pods list page
- **AND** the guide overlay shall show the pod list step content

#### Scenario: Back from resources returns to pod detail
- **GIVEN** the user is on the resources menu guide step
- **WHEN** the user clicks the "Back" button
- **THEN** the guide state shall update to the pod detail step ID
- **AND** the app shall navigate to the pod detail page
- **AND** the guide overlay shall show the pod detail step content

#### Scenario: Back from nodes returns to resources
- **GIVEN** the user is on the nodes list guide step
- **WHEN** the user clicks the "Back" button
- **THEN** the guide state shall update to the resources menu step ID
- **AND** the app shall navigate to the resources page
- **AND** the guide overlay shall show the resources step content

#### Scenario: Back from node detail returns to nodes list
- **GIVEN** the user is on the node detail guide step
- **WHEN** the user clicks the "Back" button
- **THEN** the guide state shall update to the nodes list step ID
- **AND** the app shall navigate to the nodes list page
- **AND** the guide overlay shall show the nodes list step content

#### Scenario: Back button disabled on first step
- **GIVEN** the user is on the welcome step (first step)
- **WHEN** the user views the guide overlay
- **THEN** the "Back" button shall not be visible or shall be disabled

#### Scenario: Back with route parameters
- **GIVEN** the user is on a step with route parameters (e.g., pod detail, node detail)
- **WHEN** the user clicks the "Back" button
- **THEN** the navigation shall use the parameters from the previous step definition

### Requirement: Comprehensive Internationalization

The system SHALL provide complete internationalization support for all onboarding guide text in both English and Chinese (zh_CN).

#### Scenario: Guide displays in English locale
- **GIVEN** the app language is set to English
- **WHEN** the onboarding guide is displayed
- **THEN** all guide titles shall be in English
- **AND** all guide descriptions shall be in English
- **AND** all button labels (Next, Skip, Back, Complete) shall be in English

#### Scenario: Guide displays in Chinese locale
- **GIVEN** the app language is set to Chinese (zh_CN)
- **WHEN** the onboarding guide is displayed
- **THEN** all guide titles shall be in Chinese
- **AND** all guide descriptions shall be in Chinese
- **AND** all button labels shall be in Chinese

#### Scenario: Guide text updates when language changes
- **GIVEN** the onboarding guide is active
- **AND** the app is in English
- **WHEN** the user switches the app language to Chinese
- **THEN** the guide overlay shall update to show Chinese text
- **AND** the content shall reflect the current step in the new language

#### Scenario: Guide step definitions hold i18n keys
- **GIVEN** the `GuideStepDefinition` class is used
- **THEN** each step shall have i18n key properties (l10nTitle, l10nDescription, l10nButtonNext, etc.)
- **AND** the i18n keys shall follow a consistent naming convention (e.g., "guide_step_1_title")

### Requirement: Extended Guide Flow - Workloads Overview

The system SHALL include a step that displays the workloads overview page, explaining the available workload resource types.

#### Scenario: User navigates to workloads overview step
- **GIVEN** the user is on the welcome step (cluster list page)
- **WHEN** the user clicks "Next"
- **THEN** the app shall navigate to the workloads overview page
- **AND** the guide overlay shall highlight the workloads list
- **AND** the guide shall explain that workloads include Pods, Deployments, DaemonSets, and StatefulSets
- **AND** the guide shall explain clicking on a workload type shows a list of resources

#### Scenario: Workloads step has correct target key
- **GIVEN** the workloads page is displayed with the guide
- **THEN** the workloads list section shall have the `workloadsTargetKey` GlobalKey attached
- **AND** the spotlight effect shall highlight the workloads list item

### Requirement: Extended Guide Flow - Pod List with Swipe Gestures

The system SHALL include a step that displays the pod list page with swipe gesture explanations, showing how left and right swipes trigger different actions.

#### Scenario: User navigates to pod list with swipe explanation
- **GIVEN** the user is on the workloads overview step
- **WHEN** the user clicks "Next"
- **THEN** the app shall navigate to the pods list page
- **AND** the guide overlay shall highlight the pod list
- **AND** the guide shall explain that users can view all pods in the cluster
- **AND** the guide shall explain that right swipe shows more actions (details, logs, terminal)
- **AND** the guide shall explain that left swipe provides a quick delete option

#### Scenario: Pod list step has correct target key
- **GIVEN** the pods page is displayed with the guide
- **THEN** the pod list section shall have the `podListTargetKey` GlobalKey attached
- **AND** the spotlight effect shall highlight the pod list
- **AND** the guide text shall reference swipe actions on the list items

### Requirement: Extended Guide Flow - Pod Detail Features

The system SHALL include a step that displays the pod detail page for a demo pod, explaining the available features like viewing YAML, logs, and terminal.

#### Scenario: User navigates to pod detail step
- **GIVEN** the demo cluster has at least one pod named "web-demo"
- **GIVEN** the user is on the pod list with swipe explanation step
- **WHEN** the user clicks "Next"
- **THEN** the app shall navigate to the pod detail page for "web-demo"
- **AND** the guide overlay shall highlight the detail tabs or action buttons
- **AND** the guide shall explain the YAML tab shows the pod configuration
- **AND** the guide shall explain the Logs tab shows real-time pod logs
- **AND** the guide shall explain the Terminal action opens a shell session

#### Scenario: Pod detail has target keys
- **GIVEN** a pod detail page is displayed with the guide
- **THEN** the detail tab area shall have the `podDetailTargetKey` GlobalKey attached
- **AND** the action buttons shall be highlighted by the overlay

### Requirement: Extended Guide Flow - Resources Menu

The system SHALL include a step that displays the resources navigation menu page, explaining the available resource categories.

#### Scenario: User navigates to resources menu step
- **GIVEN** the user is on the pod detail step
- **WHEN** the user clicks "Next"
- **THEN** the app shall navigate to the resources menu page
- **AND** the guide overlay shall highlight the resources list
- **AND** the guide shall explain the Config category (ConfigMaps, Secrets)
- **AND** the guide shall explain the Storage category (PVs, PVCs, StorageClass)
- **AND** the guide shall explain the Networking category (Services, Ingresses)

#### Scenario: Resources step has correct target key
- **GIVEN** the resources page is displayed with the guide
- **THEN** the resources list section shall have the `resourcesTargetKey` GlobalKey attached
- **AND** the spotlight effect shall highlight the resources categories

### Requirement: Extended Guide Flow - Nodes List with Swipe Gestures

The system SHALL include a step that displays the nodes list page with swipe gesture explanations.

#### Scenario: User navigates to nodes list with swipe explanation
- **GIVEN** the user is on the resources menu step
- **WHEN** the user clicks "Next"
- **THEN** the app shall navigate to the nodes list page
- **AND** the guide overlay shall highlight the nodes list
- **AND** the guide shall explain that nodes are the worker machines in the cluster
- **AND** the guide shall explain swiping right shows node details
- **AND** the guide shall explain swiping left provides a cordon/uncordon action

#### Scenario: Nodes list step has correct target key
- **GIVEN** the nodes page is displayed with the guide
- **THEN** the nodes list section shall have the `nodesTargetKey` GlobalKey attached
- **AND** the spotlight effect shall highlight the nodes list
- **AND** the guide text shall reference swipe actions on node items

### Requirement: Extended Guide Flow - Node Detail Features

The system SHALL include a step that displays the detail page for the first node from the nodes list, explaining node monitoring features.

#### Scenario: User navigates to node detail step
- **GIVEN** the demo cluster has at least one node
- **GIVEN** the user is on the nodes list step
- **WHEN** the user clicks "Next"
- **THEN** the app SHALL fetch the nodes list from the Kubernetes API
- **AND** the app SHALL select the first node from the list
- **AND** the app shall navigate to the node detail page for the first node
- **AND** the guide overlay shall highlight the node detail sections
- **AND** the guide shall explain the Overview shows node status and metrics
- **AND** the guide shall explain the Pods section shows pods running on this node
- **AND** the guide shall explain monitoring CPU and memory usage

#### Scenario: System dynamically selects first node
- **GIVEN** the demo cluster has multiple nodes
- **WHEN** the guide needs to navigate to node detail step
- **THEN** the guide SHALL fetch the complete nodes list from the API
- **AND** the guide SHALL select the first node in the returned list
- **AND** the guide SHALL use the selected node's name for navigation

#### Scenario: Node detail has target keys
- **GIVEN** a node detail page is displayed with the guide
- **THEN** the node detail sections shall have the `nodeDetailTargetKey` GlobalKey attached
- **AND** the spotlight effect shall highlight the key information sections

### Requirement: Extended Guide Flow - Completion

The system SHALL include a final step that concludes the guide on the cluster list page, mentioning the availability of help documentation.

#### Scenario: Guide completion displays on cluster list page
- **GIVEN** the user is on the node detail step
- **WHEN** the user clicks "Complete"
- **THEN** the app shall navigate to the cluster list page
- **AND** the guide overlay shall show a completion message
- **AND** the guide shall mention that users can access help documentation anytime
- **AND** the guide shall encourage exploring the demo cluster features

#### Scenario: Completion marks guide as finished
- **WHEN** the user completes the final step
- **THEN** the guide completion shall be saved to the database
- **AND** the guide shall not reappear on subsequent cluster list visits
- **AND** analytics shall log the guide completion event

#### Scenario: User can access help after completion
- **GIVEN** the guide has been completed
- **AND** the completion message mentioned help docs
- **WHEN** the user navigates to settings or help
- **THEN** the user shall be able to find and access help documentation

## MODIFIED Requirements

### Requirement: Guide Step Definition Structure

The `GuideStepDefinition` class SHALL support both direct text values and internationalization keys for all text properties, with localization keys taking precedence.

#### Scenario: Step uses i18n keys when available
- **GIVEN** a `GuideStepDefinition` with `l10nTitle`, `l10nDescription`, and `l10nButtonNext` set
- **WHEN** the guide overlay is rendered
- **THEN** the title shall be retrieved using `S.of(context)` with the i18n key
- **AND** the description shall be retrieved using `S.of(context)` with the i18n key
- **AND** the button labels shall be retrieved using `S.of(context)` with i18n keys

#### Scenario: Step falls back to direct text when i18n key is missing
- **GIVEN** a `GuideStepDefinition` with `l10nTitle` set to null but `title` has a direct string value
- **WHEN** the guide overlay is rendered
- **THEN** the title shall display the direct string value from `title` property
- **AND** no error shall occur for the missing i18n key

#### Scenario: Step definition includes route params for navigation
- **GIVEN** a `GuideStepDefinition` for a pod detail page
- **WHEN** the step is used for navigation
- **THEN** the `routeProvider` shall provide the route name
- **AND** the `routeParams` map shall provide necessary parameters (path, resource, name)

### Requirement: Demo Cluster Guide Flow

The demo cluster onboarding guide SHALL consist of 8 steps in the following order: welcome (clusters), workloads overview, pod list with swipe gestures, pod detail, resources menu, nodes list with swipe gestures, node detail, and completion (clusters).

#### Scenario: Guide steps are in correct order
- **WHEN** `DemoClusterGuide.getSteps()` is called
- **THEN** the steps array shall return 8 steps in order:
  1. welcome (clusters - cluster list page)
  2. workloadsOverview (workloads)
  3. podListWithSwipe (pods)
  4. podDetail (details with params for web-demo)
  5. resourcesMenu (resources)
  6. nodesListWithSwipe (nodes)
  7. nodeDetail (node_detail with dynamic first node from API)
  8. completed (clusters - return to cluster list)

#### Scenario: Next step navigation follows the flow
- **GIVEN** the user is on the welcome step
- **WHEN** `DemoClusterGuide.getNextStepId('welcome')` is called
- **THEN** it shall return 'workloadsOverview'
- **AND** when called with 'workloadsOverview', it shall return 'podListWithSwipe'
- **AND** when called with 'podListWithSwipe', it shall return 'podDetail'
- **AND** the sequence shall continue through all 8 steps
- **AND** when called with the last step (completed), it shall return null

#### Scenario: Previous step navigation reverses the flow
- **GIVEN** the user is on the completed step
- **WHEN** `DemoClusterGuide.getPreviousStepId('completed')` is called
- **THEN** it shall return 'nodeDetail'
- **AND** when called with 'nodeDetail', it shall return 'nodesListWithSwipe'
- **AND** when called with 'nodesListWithSwipe', it shall return 'resourcesMenu'
- **AND** the sequence shall continue backwards through all steps
- **AND** when called with the first step (welcome), it shall return null

#### Scenario: Each step has the correct route configuration
- **WHEN** any step is retrieved by ID
- **THEN** the `routeName` shall match the expected page
- **AND** the `routeParams` shall be populated for steps requiring parameters (podDetail, nodeDetail)
- **AND** the `targetKey` shall reference a valid GlobalKey from `GuideKeys`

#### Scenario: Demo cluster has required resources for guide
- **GIVEN** the demo cluster is loaded
- **THEN** the demo cluster shall have at least one pod named "web-demo"
- **AND** the demo cluster shall have at least one node (name will be dynamically fetched from API)
- **IF** the required resources are not present, the guide SHALL skip or adapt accordingly

### Requirement: TDD Quality Assurance - Test-Driven Development

The implementation SHALL follow Test-Driven Development (TDD) principles where unit tests are written before implementation to ensure code quality.

#### Scenario: Unit tests written before code implementation
- **GIVEN** a new feature or function is being implemented
- **WHEN** starting development
- **THEN** unit tests SHALL be written first to specify the expected behavior
- **AND** code SHALL be implemented to make the tests pass
- **AND** tests SHALL fail initially (red phase)
- **AND** code SHALL be written to make tests pass (green phase)
- **AND** code SHALL be refactored while keeping tests passing (refactor phase)

#### Scenario: SkipGuide persistence unit test
- **GIVEN** test file `onboarding_guide_service_test.dart`
- **BEFORE** implementing `skipGuide()` persistence logic
- **WHEN** a unit test is written for skip persistence
- **THEN** the test SHALL verify `OnboardingGuideDao.saveCompletion()` is called
- **AND** the test SHALL use a mock DAO to verify the call
- **AND** the test SHALL verify `isGuideCompleted()` returns true after skip
- **THEN** `skipGuide()` implementation SHALL be written to pass the test

#### Scenario: i18n fallback logic unit test
- **BEFORE** implementing `getLocalizedTitle()` method
- **WHEN** a unit test is written for i18n fallback
- **THEN** the test SHALL verify i18n key is used when available
- **AND** the test SHALL verify direct text fallback when i18n key is null
- **THEN** `getLocalizedTitle()` implementation SHALL be written to pass the test

### Requirement: BDD Functional Testing - Behavior-Driven Development

The implementation SHALL include BDD tests using flutter_gherkin to guarantee all functionality works as specified, with the actual test execution required before the change is considered complete.

#### Scenario: Skip functionality works end-to-end
- **GIVEN** the feature file `test/bdd/features/onboarding_guide.feature`
- **WHEN** the BDD scenario for skip persistence is executed with `make test-bdd-macos`
- **THEN** the scenario SHALL pass
- **AND** the guide SHALL NOT reappear after skip
- **AND** the database SHALL contain the completion record

#### Scenario: Back navigation works across all pages
- **WHEN** BDD scenarios for all back button transitions are executed
- **THEN** all back navigation scenarios SHALL pass
- **AND** the app SHALL navigate to correct previous pages
- **AND** the guide overlay SHALL update correctly

#### Scenario: Complete 8-step guide flow works
- **WHEN** the full guide flow BDD scenario is executed
- **THEN** all 8 steps shall execute in correct order
- **AND** each navigation shall succeed
- **AND** the guide shall complete successfully
- **AND** completion shall be persisted

#### Scenario: i18n works correctly
- **WHEN** BDD scenarios for i18n are executed
- **THEN** guide SHALL display in English when locale is English
- **AND** guide SHALL display in Chinese when locale is zh_CN
- **AND** all button labels SHALL be localized

#### Scenario: All unit tests pass
- **WHEN** `flutter test` is executed
- **THEN** all unit tests SHALL pass
- **AND** no test failures SHALL occur
- **AND** code coverage SHALL be acceptable for modified code

#### Scenario: iOS debug build succeeds
- **WHEN** `flutter build ios --debug --no-codesign` is executed
- **THEN** the build SHALL succeed without errors
- **AND** the app SHALL be installable on iOS simulator
- **AND** no compilation errors SHALL occur

## REMOVED Requirements

None.
