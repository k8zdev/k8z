# Design: Add PVC Resource Detail Page

## Context

The K8z application requires the ability to view details for PersistentVolumeClaim (PVC) resources. The details page framework already exists in `details_page.dart`, with support for Services, ConfigMaps, Secrets, Pods, and other workload resources. We need to extend this to support PVCs, providing users with visibility into their storage claims.

## Goals / Non-Goals

**Goals:**
- Implement PVC detail page following the existing pattern used by Services and ConfigMaps
- Display all essential PVC properties: status, capacity, access modes, storage class, volume name, volume mode, reason
- Maintain consistency with the existing UI/UX

**Non-Goals:**
- PVC modification or editing capabilities (not in scope for this change)
- Support for dynamic volume provisioning actions
- Advanced storage analytics or monitoring

## Decisions

### 1. Widget Structure

**Decision:** Create a new standalone widget file `lib/widgets/detail_widgets/pvcs.dart` with a `buildPVCDetailSectionTiles` function.

**Rationale:** This follows the established pattern in the codebase where each resource type (Services, ConfigMaps, Secrets) has its own detail widget file. This keeps the code modular and makes it easier to maintain and test.

**Alternatives considered:**
- Add PVC logic directly in `details_page.dart`: Rejected because it would make the file larger harder to maintain. The existing pattern favors separate widget files.
- Create a generic storage widget for both PV and PVC: Rejected because PV and PVC have different spec structures. Better to keep them separate for clarity.

### 2. PVC Data Source

**Decision:** Use the `IoK8sApiCoreV1PersistentVolumeClaim` auto-generated model from Kubernetes API.

**Rationale:** The project already uses auto-generated Dart models from the Kubernetes OpenAPI spec in `lib/models/kubernetes/`. This ensures type safety and compatibility with the Kubernetes API.

### 3. Display Fields

**Decision:** Display the following PVC fields:
- **Status**: Using `status.phase` (Bound, Pending, Lost, etc.)
- **Capacity**: Using `spec.resources.requests['storage']`
- **Access Modes**: Using `spec.accessModes` (ReadWriteOnce, ReadOnlyMany, ReadWriteMany)
- **Storage Class**: Using `spec.storageClassName`
- **Volume Name**: Using `spec.volumeName`
- **Volume Mode**: Using `spec.volumeMode` if present
- **Reason**: Using `status.reason` if present (useful for Pending state)

**Rationale:** These are the most relevant fields for users to understand the state and configuration of their PVCs.

### 4. Title Localization

**Decision:** Use `lang.spec` as the section title, following the pattern used by Pods, Deployments, and StatefulSets.

**Rationale:** Since PVC details are primarily spec properties, using `lang.spec` is semantically correct and consistent with similar resources.

## Risks / Trade-offs

- **Risk**: Auto-generated model changes may break the implementation if Kubernetes API changes.
  - **Mitigation**: Use stable fields (spec/status) that are part of core Kubernetes API with backward compatibility guarantees.

- **Trade-off**: Not handling error states gracefully (e.g., missing spec).
  - **Mitigation**: Follow the pattern used in existing widgets - check for null and return empty state if data is unavailable.

## Migration Plan

No migration required as this is a additive feature. The change introduces new functionality without modifying existing behavior.

## Open Questions

None. The implementation is straightforward following established patterns in the codebase.
