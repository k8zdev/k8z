# pro-features Specification

## ADDED Requirements

### Requirement: Pro Subscription Status Verification

The system SHALL verify whether a user has an active Pro subscription by checking RevenueCat CustomerInfo entitlements.

#### Scenario: User has active monthly subscription
- **WHEN** RevenueCat CustomerInfo contains an active monthly subscription entitlement
- **THEN** the system SHALL return true for isPro status
- **AND** all Pro features SHALL be unlocked

#### Scenario: User has active annual subscription
- **WHEN** RevenueCat CustomerInfo contains an active annual subscription entitlement
- **THEN** the system SHALL return true for isPro status
- **AND** all Pro features SHALL be unlocked

#### Scenario: User has active lifetime subscription
- **WHEN** RevenueCat CustomerInfo contains an active lifetime subscription entitlement
- **THEN** the system SHALL return true for isPro status
- **AND** all Pro features SHALL be unlocked

#### Scenario: User has no active subscriptions
- **WHEN** RevenueCat CustomerInfo contains no active entitlements
- **THEN** the system SHALL return false for isPro status
- **AND** Pro features SHALL be locked with upgrade prompts

### Requirement: Cluster Count Limitation

The system SHALL limit the number of clusters that can be added based on the user's subscription tier.

#### Scenario: Free user with fewer than 2 clusters can add clusters
- **WHEN** a Free user has 0 or 1 existing clusters
- **THEN** the system SHALL allow adding a new cluster
- **AND** no upgrade prompt SHALL be shown

#### Scenario: Free user with 2 clusters cannot add more
- **WHEN** a Free user has exactly 2 existing clusters
- **THEN** the system SHALL prevent adding a new cluster
- **AND** display an upgrade dialog: "Free version allows max 2 clusters"

#### Scenario: Pro user can add unlimited clusters
- **WHEN** a Pro user attempts to add a cluster
- **THEN** the system SHALL always allow the addition
- **AND** no cluster count limit SHALL be enforced

#### Scenario: Grandfathered user can add clusters freely
- **WHEN** a user was grandfathered before limit enforcement (existing clusters > 2)
- **THEN** the system SHALL allow adding new clusters regardless of count
- **AND** the grandfathering flag SHALL remain active

### Requirement: App Open Counter and Probabilistic Upgrade Prompt

The system SHALL track the number of times the app has been opened and display a Pro upgrade dialog probabilistically after the user is engaged enough (10+ opens), based on a modulo-based frequency (every 3rd eligible open).

#### Scenario: App open counter increments on each launch
- **WHEN** the app is launched
- **THEN** the system SHALL increment the app open counter stored in persistent storage
- **AND** the counter SHALL persist across app launches

#### Scenario: No upgrade prompt shown in first 9 app opens
- **WHEN** a Free user opens the app for the 1st through 9th time
- **THEN** no Pro upgrade dialog SHALL be displayed
- **AND** the app open counter SHALL be incremented

#### Scenario: Upgrade prompt shows on eligible opens (10, 13, 16, ...)
- **WHEN** a Free user opens the app for the 10th time (count >= 10 AND count % 3 == 1)
- **THEN** the upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 11th time (count % 3 == 2)
- **THEN** no upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 12th time (count % 3 == 0)
- **THEN** no upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 13th time (count % 3 == 1)
- **THEN** the upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 14th time (count % 3 == 2)
- **THEN** no upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 15th time (count % 3 == 0)
- **THEN** no upgrade dialog SHALL be shown
- **WHEN** a Free user opens the app for the 16th time (count % 3 == 1)
- **THEN** the upgrade dialog SHALL be shown

#### Scenario: Upgrade prompt only shows to Free users
- **WHEN** a Pro user opens the app at any time (even if count >= 10 and count % 3 == 0)
- **THEN** no Pro upgrade dialog SHALL be displayed
- **AND** the app open counter SHALL still be incremented

#### Scenario: Upgrade prompt displays general Pro value proposition
- **WHEN** the probabilistic upgrade prompt is shown
- **THEN** the dialog SHALL display general Pro benefits
- **AND** SHALL NOT reference a specific locked feature
- **AND** SHALL include navigation to paywall page

### Requirement: Emergency Operations Are Free

The system SHALL allow emergency operations (Delete, Scale, Restart, View Logs) for all users regardless of subscription tier.

#### Scenario: Free user can delete resources
- **WHEN** a Free user initiates a Delete operation on a Pod, Deployment, or other resource
- **THEN** the operation SHALL proceed without upgrade prompt
- **AND** the resource SHALL be deleted

#### Scenario: Free user can scale workloads
- **WHEN** a Free user initiates a Scale operation on a Deployment, StatefulSet, or other workload
- **THEN** the operation SHALL proceed without upgrade prompt
- **AND** the replica count SHALL be updated

#### Scenario: Free user can view real-time logs
- **WHEN** a Free user opens the logs view for a Pod or container
- **THEN** real-time log streaming SHALL be available
- **AND** no upgrade prompt SHALL be shown

### Requirement: Node Shell Is Pro Only

The system SHALL restrict Node Shell access to Pro users only.

#### Scenario: Free user cannot access Node Shell
- **WHEN** a Free user taps on the Node Shell button
- **THEN** the system SHALL display a Pro upgrade dialog
- **AND** the dialog SHALL show "Node Shell is a Pro feature"
- **AND** no actual Node Shell access SHALL be provided

#### Scenario: Pro user can access Node Shell
- **WHEN** a Pro user taps on the Node Shell button
- **THEN** the system SHALL open a Node Shell session
- **AND** the user SHALL be able to execute commands on the node

### Requirement: YAML Editing And Apply Is Pro Only

The system SHALL restrict YAML editing and Apply operations to Pro users only.

#### Scenario: Free user cannot edit YAML
- **WHEN** a Free user taps on the YAML edit button
- **THEN** the system SHALL display a Pro upgrade dialog
- **AND** the dialog SHALL show "YAML editing is a Pro feature"
- **AND** the YAML editor SHALL not be opened

#### Scenario: Free user cannot Apply YAML changes
- **WHEN** a Free user attempts to Apply YAML changes
- **THEN** the operation SHALL be blocked
- **AND** a Pro upgrade dialog SHALL be shown

#### Scenario: Pro user can edit and Apply YAML
- **WHEN** a Pro user edits YAML in the editor and clicks Apply
- **THEN** the system SHALL apply the YAML changes to the cluster
- **AND** the resource SHALL be updated successfully

### Requirement: Pro Features Display Lock Badge

The system SHALL display a lock icon badge on Pro-only features to indicate they are locked for Free users.

#### Scenario: Pro feature shows lock badge for Free users
- **WHEN** a Free user views a page containing Pro-only buttons (Node Shell, YAML Edit)
- **THEN** each Pro-only button SHALL display a lock badge overlay
- **AND** the badge SHALL be visible and not obstruct button content

#### Scenario: Pro features show no lock badge for Pro users
- **WHEN** a Pro user views a page containing Pro-only buttons
- **THEN** no lock badges SHALL be displayed
- **AND** buttons SHALL appear normally

### Requirement: Pro Upgrade Dialog

The system SHALL display a consistent Pro upgrade dialog when locked features are accessed.

#### Scenario: Upgrade dialog shows locked feature name
- **WHEN** a Free user taps on a locked feature
- **THEN** a dialog SHALL appear with the feature name prominently displayed
- **AND** the dialog title SHALL be "k8z Pro"

#### Scenario: Upgrade dialog shows Pro benefits list
- **WHEN** the Pro upgrade dialog is displayed
- **THEN** a list of 6 Pro benefits SHALL be shown:
  - "Unlock unlimited clusters"
  - "Real-time alert push notifications"
  - "AI natural language operations"
  - "YAML editing and Apply"
  - "Multi-terminal concurrent debugging"
  - "Historical log search"

#### Scenario: Upgrade dialog has Cancel button
- **WHEN** the Pro upgrade dialog is displayed
- **THEN** the user SHALL be able to tap "Cancel" to close the dialog
- **AND** no navigation SHALL occur

#### Scenario: Upgrade dialog has View Pro Plans button
- **WHEN** the Pro upgrade dialog is displayed
- **THEN** the user SHALL be able to tap "View Pro Plans"
- **AND** the system SHALL navigate to the paywall page

### Requirement: Pro Status Updates Notify UI

The system SHALL notify UI components when Pro subscription status changes.

#### Scenario: UI updates when user upgrades to Pro
- **WHEN** a user completes a Pro subscription purchase
- **THEN** the RevenueCatCustomer provider SHALL call notifyListeners()
- **AND** UI components SHALL update to show unlocked Pro features
- **AND** lock badges SHALL disappear from Pro features

#### Scenario: UI updates when subscription expires
- **WHEN** a user's Pro subscription expires
- **THEN** the RevenueCatCustomer provider SHALL call notifyListeners()
- **AND** UI components SHALL update to show Pro features as locked
- **AND** lock badges SHALL appear on Pro features
