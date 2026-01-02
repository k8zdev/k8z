# onboarding-guide Specification

## Purpose
Interactive onboarding guide for the demo cluster that uses spotlight highlighting to guide first-time users through key features across multiple pages.

## ADDED Requirements

### Requirement: Demo Cluster Guide Auto-Trigger

The application SHALL automatically start the interactive onboarding guide when a user accesses the demo cluster for the first time. The application MUST NOT auto-start the guide if the user has previously completed it. Users MUST be able to optionally restart the guide from the settings page even after completion.

#### Scenario: First-time demo cluster access starts guide
- **WHEN** user creates demo cluster for the first time
- **THEN** onboarding guide is automatically activated
- **AND** first guide step (welcome) is displayed

#### Scenario: Guide does not auto-start after completion
- **WHEN** user accesses demo cluster after previously completing guide
- **THEN** guide does not automatically start
- **AND** user can optionally restart guide from settings

### Requirement: Guide Step Navigation with Page Jump

The guide flow SHALL support page jumping where clicking "Next" automatically navigates to the target feature page. The application MUST trigger GoRouter navigation to the step's target route when advancing steps.

#### Scenario: Navigate from welcome to pods list
- **WHEN** user clicks "Next" on the welcome step
- **THEN** application navigates to Pods list page
- **AND** next guide step is prepared for display

#### Scenario: Page jump after navigation completes
- **WHEN** navigation to guide step's target page completes
- **THEN** guide overlay displays with spotlight on target element
- **AND** step content (title, description) is shown near highlighted element

### Requirement: Element Spotlight Highlighting

The guide overlay SHALL display spotlight effects on target UI elements to highlight operation targets. The application MUST outline the target widget and dim the surrounding area.

#### Scenario: Spotlight highlights pod list section
- **WHEN** guide step targets the pod list section
- **THEN** spotlight outlines the pod list widget
- **AND** surrounding area is dimmed
- **AND** guide card appears adjacent to highlighted element

#### Scenario: Spotlight highlights action button
- **WHEN** guide step targets a specific action button (e.g., "View Logs")
- **THEN** spotlight outlines the button
- **AND** guide card positions near the button
- **AND** user can interact with highlighted button to proceed

#### Scenario: Multiple targets in single step
- **WHEN** guide step defines multiple target elements
- **THEN** all targets are highlighted with separate spotlights
- **AND** guide card positions relative to primary target

### Requirement: Guide Navigation Controls

The guide interface MUST provide complete navigation controls including Previous, Next, Skip, and Complete buttons. Each button SHALL trigger the appropriate state change and navigation action.

#### Scenario: Next button advances to following step
- **WHEN** user clicks "Next" button
- **THEN** current guide step is marked as completed
- **AND** next guide step is displayed
- **AND** if next step is on different page, navigation is triggered

#### Scenario: Previous button returns to earlier step
- **WHEN** user is on step 2 or later and clicks "Previous" button
- **THEN** current guide step is reverted
- **AND** previous guide step is displayed
- **AND** app navigates back to previous step's page if needed

#### Scenario: Skip button exits guide early
- **WHEN** user clicks "Skip" button
- **THEN** guide overlay is dismissed
- **AND** guide progress is NOT saved as completed
- **AND** user can manually restart guide later from settings

#### Scenario: Complete button finishes guide on last step
- **WHEN** user clicks "Complete" button on final step
- **THEN** guide overlay is dismissed
- **AND** guide completion is persisted to database
- **AND** guide does not auto-start on subsequent visits

### Requirement: Guide Completion Persistence

The guide completion status SHALL be persisted to the SQLite database to prevent repeated display. The application MUST store the completion timestamp and cluster ID association.

#### Scenario: Save completed guide state
- **WHEN** user completes all guide steps
- **THEN** completion status is saved to database
- **AND** completion timestamp is recorded
- **AND** cluster ID is associated with completed guide

#### Scenario: Check completion status before starting
- **WHEN** demo cluster is loaded
- **THEN** database is queried for guide completion status
- **AND** if guide is already completed, auto-guide is skipped
- **AND** if guide was not completed or was skipped, auto-guide starts

#### Scenario: Reset guide completion from settings
- **WHEN** user selects "Reset Onboarding Guide" from settings
- **THEN** guide completion status is cleared from database
- **AND** user can optionally start guide again immediately

### Requirement: Guide Restart Capability

Users SHALL be able to manually restart the guide flow from the settings page, even after previously completing or skipping the guide.

#### Scenario: Restart completed guide
- **WHEN** user clicks "Replay Guide" in settings after completing guide
- **THEN** guide is started from first step
- **AND** previous completion status is not cleared
- **AND** new completion updates the existing record

#### Scenario: Restart skipped guide
- **WHEN** user clicks "Replay Guide" in settings after previously skipping guide
- **THEN** guide starts from first step
- **AND** navigation to demo cluster page is triggered if needed

### Requirement: Guide Step Definition Structure

Guide steps SHALL be defined using a declarative data structure including route information and target element references. The structure MUST include route name, route parameters, and target GlobalKey.

#### Scenario: Guide step includes route name
- **WHEN** defining a guide step
- **THEN** step includes target route name from GoRouter configuration
- **AND** navigation uses context.goNamed() with specified route

#### Scenario: Guide step includes route parameters
- **WHEN** guide step targets a detail page
- **THEN** step includes path parameters (namespace, resource name, etc.)
- **AND** navigation includes these parameters for correct routing

#### Scenario: Guide step includes target key
- **WHEN** guide step needs to highlight a specific widget
- **THEN** step includes GlobalKey reference to target widget
- **AND** tutorial_coach_mark uses this key for spotlight positioning

### Requirement: Responsive Guide Card Positioning

The guide card SHALL automatically adjust display position based on target element location and screen dimensions. The application MUST position the card above, below, or centered based on available space.

#### Scenario: Guide card positions above target
- **WHEN** target element is near bottom of screen
- **THEN** guide card displays above the highlighted element
- **AND** card does not overflow screen boundaries

#### Scenario: Guide card positions below target
- **WHEN** target element is near top of screen
- **THEN** guide card displays below the highlighted element
- **AND** card margin provides adequate spacing

#### Scenario: Guide card centers when no target
- **WHEN** guide step has no target element (e.g., welcome step)
- **THEN** guide card displays centered on screen
- **AND** full-screen dimmed overlay is shown

## MODIFIED Requirements

### Requirement: OnboardingGuideService Navigation Coordination

OnboardingGuideService SHALL coordinate guide steps with GoRouter navigation. The service MUST notify navigation targets via stream or callback and persist guide completion to database.

#### Scenario: Service handles step transition with navigation
- **WHEN** nextStep() is called with a step that includes a route
- **THEN** service notifies navigation target via stream or callback
- **AND** current step is updated after navigation completes
- **AND** listeners are notified of state change

#### Scenario: Service provides step definitions with routes
- **WHEN** components request current step definition
- **THEN** service returns GuideStepDefinition with route and target key
- **AND** definition can be used for navigation and spotlight targeting

#### Scenario: Service persists guide completion
- **WHEN** completeGuide() is called
- **THEN** service saves completion to database
- **AND** completion can be queried via isGuideCompleted() method
