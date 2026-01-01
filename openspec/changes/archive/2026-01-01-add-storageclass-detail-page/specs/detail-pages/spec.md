## ADDED Requirements

### Requirement: StorageClass Detail Page

The application SHALL provide a detail page for Kubernetes StorageClass resources that displays all key configuration properties in a structured format.

#### Scenario: View StorageClass details with default properties
- **WHEN** user navigates to a StorageClass detail page
- **THEN** the provisioner name is displayed
- **AND** the reclaim policy (Delete or Retain) is displayed
- **AND** the volume binding mode (Immediate or WaitForFirstConsumer) is displayed
- **AND** the allow volume expansion setting is displayed

#### Scenario: View StorageClass with mount options
- **WHEN** a StorageClass has mount options configured
- **THEN** the mount options are displayed as a comma-separated list
- **AND** each mount option is visible to the user

#### Scenario: View StorageClass with provider parameters
- **WHEN** a StorageClass has provider-specific parameters
- **THEN** the parameters are displayed as key-value pairs
- **AND** each parameter is shown with its name and value
- **AND** parameters can be copied via UI interaction

#### Scenario: View StorageClass with allowed topologies
- **WHEN** a StorageClass defines allowed topologies
- **THEN** the topology constraints are displayed
- **AND** the topology selector terms are shown in the details view

#### Scenario: Navigation to StorageClass detail page
- **WHEN** user taps on a StorageClass item in the list
- **THEN** a detail page is opened showing the StorageClass metadata and spec
- **AND** the page title displays the StorageClass name
- **AND** action buttons (Delete, YAML) are available