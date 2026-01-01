# resource-detail Specification

## Purpose
TBD - created by archiving change add-events-detail-view. Update Purpose after archive.
## Requirements
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

### Requirement: PersistentVolume Detail View Display

The system SHALL display detailed information for Kubernetes PersistentVolume resources when a user navigates to a PV resource detail page.

#### Scenario: Display PV availability status
- **WHEN** a user views a PersistentVolume detail page
- **THEN** the system SHALL display the PV status (Available, Bound, Released, or Failed) with appropriate color coding
- **AND** the status SHALL use blue for Available, green for Bound, orange for Released, and red for Failed

#### Scenario: Display PV capacity
- **WHEN** a user views a PersistentVolume detail page
- **THEN** the system SHALL display the storage capacity in human-readable format (e.g., "10Gi", "500Mi")

#### Scenario: Display PV access modes
- **WHEN** a user views a PersistentVolume detail page
- **THEN** the system SHALL display all access modes configured for the PV as a comma-separated list
- **AND** SHALL include any combination of ReadWriteOnce, ReadOnlyMany, ReadWriteMany, or ReadWriteOncePod

#### Scenario: Display PV reclaim policy
- **WHEN** a user views a PersistentVolume detail page
- **THEN** the system SHALL display the reclaim policy (Retain, Delete, or Recycle)

#### Scenario: Display PV storage class
- **WHEN** a user views a PersistentVolume detail page
- **THEN** the system SHALL display the storage class name if specified
- **AND** SHALL display a placeholder value if no storage class is defined

#### Scenario: Display PVC claim reference
- **WHEN** a PersistentVolume is bound to a PVC
- **THEN** the system SHALL display the claim reference as "namespace/name" format
- **WHEN** a PersistentVolume is not bound
- **THEN** the system SHALL omit the claim reference field

#### Scenario: Display PV failure reason
- **WHEN** a PersistentVolume has a reason field populated (e.g., in Failed status)
- **THEN** the system SHALL display the reason message
- **WHEN** the reason field is empty
- **THEN** the system SHALL omit the reason field

#### Scenario: Display PV volume attributes
- **WHEN** a PersistentVolume has custom volume attributes defined
- **THEN** the system SHALL display the volume attributes
- **WHEN** no volume attributes are defined
- **THEN** the system SHALL omit the volume attributes section

#### Scenario: Display PV node affinity
- **WHEN** a PersistentVolume has node affinity rules defined
- **THEN** the system SHALL display the node affinity configuration
- **WHEN** no node affinity is defined
- **THEN** the system SHALL omit the node affinity section

### Requirement: PV Detail Widget Implementation Pattern

The system SHALL implement the PersistentVolume detail widget following the existing pattern used by Services and ConfigMaps detail widgets.

#### Scenario: Widget file location
- **WHEN** implementing the PV detail functionality
- **THEN** the system SHALL create a new file at `/lib/widgets/detail_widgets/persistentvolume.dart`
- **AND** SHALL export a function `buildPersistentVolumeDetailTiles` that accepts BuildContext, IoK8sApiCoreV1PersistentVolume, and langCode parameters

#### Scenario: Integration with details_page.dart
- **WHEN** a user navigates to a PersistentVolume resource detail
- **THEN** the `buildDetailSection` method in `/lib/pages/k8s_detail/details_page.dart` SHALL have a case branch for "persistentvolumes"
- **AND** SHALL call `buildPersistentVolumeDetailTiles` to generate the appropriate tiles
- **AND** SHALL use the section title "Persistent Volumes" or localized equivalent

#### Scenario: Consistent UI styling
- **WHEN** displaying PV detail information
- **THEN** the system SHALL use the same tile styles as other resource detail pages (copyTileValue, copyTileYaml, etc.)
- **AND** SHALL apply consistent spacing and layout according to the app's design system
- **AND** SHALL support both English and Chinese languages through existing localization infrastructure

