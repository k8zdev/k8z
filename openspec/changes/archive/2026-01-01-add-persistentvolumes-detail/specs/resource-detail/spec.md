## ADDED Requirements

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