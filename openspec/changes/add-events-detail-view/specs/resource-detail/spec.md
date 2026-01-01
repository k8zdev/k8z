## ADDED Requirements

### Requirement: Events Resource Detail View
The system SHALL provide a detail view for individual Kubernetes Event resources when a user navigates to an Event from the Events list.

#### Scenario: User views Event detail page
- **WHEN** a user taps on an Event item in the Events list
- **THEN** the system SHALL navigate to the Event detail page
- **AND** display the Event's type (Normal/Warning)
- **AND** display the Event's reason
- **AND** display the Event's message
- **AND** display the Event's count (number of occurrences)
- **AND** display the involved object (kind, name, namespace)
- **AND** display the first timestamp
- **AND** display the last timestamp
- **AND** display eventTime if available
- **AND** display reporting component if available
- **AND** display reporting instance if available

#### Scenario: Warning events show visual distinction
- **WHEN** an Event of type "Warning" is viewed
- **THEN** the system SHALL display a warning icon
- **OR** use warning color styling

#### Scenario: Normal events show standard styling
- **WHEN** an Event of type "Normal" is viewed
- **THEN** the system SHALL use standard styling
- **AND** display a normal status indicator

#### Scenario: Display involved object details
- **WHEN** viewing Event details with involved object reference
- **THEN** the system SHALL display the involved object's kind
- **AND** display the involved object's name
- **AND** display the involved object's namespace
- **AND** display the involved object's UID if available

#### Scenario: Display event timestamps
- **WHEN** viewing Event details
- **THEN** the system SHALL display firstTimestamp if available
- **AND** display lastTimestamp if available
- **AND** display eventTime if available (for newer Event API version)

#### Scenario: Display event series information
- **WHEN** viewing Event details with series information
- **THEN** the system SHALL display the series count if available
- **AND** display the series last observed time if available

#### Scenario: Display event source information
- **WHEN** viewing Event details with source information
- **THEN** the system SHALL display the reporting component (host, component)
- **AND** display the reporting instance (e.g., kubelet ID)

#### Scenario: Display event message with copy option
- **WHEN** viewing Event details
- **THEN** the message field SHALL be copyable via clipboard button
- **AND** support multi-line display for long messages

#### Scenario: Metadata section displays standard fields
- **WHEN** viewing Event detail page
- **THEN** the metadata section SHALL display name
- **AND** display namespace
- **AND** display creation timestamp
- **AND** display UID
- **AND** display resource version
- **AND** support standard actions (Delete, YAML view)