## ADDED Requirements

### Requirement: PVC Resource Detail View

The system SHALL provide a detailed view page for PersistentVolumeClaim (PVC) resources when users navigate to a PVC from the resource list. The detail view SHALL display key PVC properties computed from the Kubernetes API response.

#### Scenario: View PVC details for a bound claim

- **WHEN** a user navigates to a PVC detail page for a PVC that is in "Bound" phase
- **THEN** the system SHALL display the PVC status as "Bound"
- **THEN** the system SHALL display the storage capacity (e.g., "10Gi")
- **THEN** the system SHALL display the access modes (e.g., "ReadWriteOnce")
- **THEN** the system SHALL display the storage class name
- **THEN** the system SHALL display the bound volume name

#### Scenario: View PVC details for a pending claim

- **WHEN** a user navigates to a PVC detail page for a PVC that is in "Pending" phase
- **THEN** the system SHALL display the PVC status as "Pending"
- **THEN** the system SHALL display the requested storage capacity
- **THEN** the system SHALL display the access modes
- **THEN** the system SHALL display the storage class name
- **THEN** the system SHALL display the reason if available (e.g., "waiting for volume")

#### Scenario: View PVC details with volume mode

- **WHEN** a PVC has `spec.volumeMode` set to "Filesystem" or "Block"
- **THEN** the system SHALL display the volume mode (e.g., "Filesystem")
- **THEN** the volume mode SHALL be shown alongside other PVC spec properties

#### Scenario: PVC detail integration with existing detail page framework

- **WHEN** the `buildDetailSection` method receives a response for "persistentvolumeclaims" resource type
- **THEN** the system SHALL call `buildPVCDetailSectionTiles` to generate the detail tiles
- **THEN** the system SHALL render the tiles within a SettingsSection with "spec" as the section title
- **THEN** the implementation SHALL follow the same pattern as Services and ConfigMaps