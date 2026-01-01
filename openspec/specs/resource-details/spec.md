# resource-details Specification

## Purpose
TBD - created by archiving change add-crd-resource-details. Update Purpose after archive.
## Requirements
### Requirement: CRD Resource Details Display
The K8z application SHALL display detailed information for Custom Resource Definitions (CRDs) when a user clicks on a CRD resource from the resources list.

#### Scenario: User views CRD details page
- **WHEN** a user navigates to the details page of a CRD resource
- **THEN** the application SHALL display the specification section with the following fields:
  - Group: The API group of the CRD
  - Version: The version of the CRD
  - Kind: The kind name
  - Scope: Namespaced or Cluster scope
  - Names: Plural, singular, and categories
  - Short Names: Abbreviated names for the resource type
  - Storage Version: The version used for storage
- **AND** the display SHALL follow the same UI pattern as other resource details (e.g., services, configmaps)
- **AND** the section title SHALL be set appropriately for the CRD resource type
- **AND** the implementation SHALL be located in `./lib/widgets/detail_widgets/crd.dart`

#### Scenario: Application falls back to placeholder for unsupported resources
- **WHEN** a user navigates to a resource details page that does not have a specific implementation
- **THEN** the application SHALL display a "Building" placeholder message in the detail section
- **AND** the metadata section SHALL still display correctly

