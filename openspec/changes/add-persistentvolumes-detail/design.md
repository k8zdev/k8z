## Context

PersistentVolume (PV) is a core Kubernetes storage resource that represents a storage resource in the cluster. Users need to inspect PV details to:
- Understand why a PVC cannot bind to a PV
- Verify PV capacity and access modes match PVC requirements
- Troubleshoot Failed or Released PV states
- Manage storage lifecycle (reclaim policy decisions)

The existing k8z app already handles detail views for Services, ConfigMaps, Secrets, Pods, and other resources. We need to follow the same pattern.

## Goals / Non-Goals

### Goals
- Display all critical PV information in a user-friendly format
- Maintain consistency with existing resource detail pages
- Handle all PV status states (Available, Bound, Released, Failed)
- Display optional fields (node affinity, volume attributes) when present
- Support both Chinese and English localization

### Non-Goals
- PV editing/patching (view-only for this feature)
- PVC navigation from PV details (can be added later)
- PV creation/deletion (follows existing patterns)

## Decisions

### Widget Location and Naming
**Decision**: Create `/lib/widgets/detail_widgets/persistentvolume.dart` with function `buildPersistentVolumeDetailTiles`

**Rationale**:
- Follows existing pattern (services.dart, configmap.dart, secret.dart)
- Function name follows convention: `build{Resource}DetailTiles`
- Co-locates detail widgets with other resource-specific widgets

### Display Order
**Decision**: Display PV information in priority order:
1. Status (with color coding)
2. Capacity
3. Access Modes
4. Reclaim Policy
5. Storage Class
6. Claim (if bound)
7. Reason
8. Volume Attributes (if present)
9. Node Affinity (if present)

**Rationale**:
- Most critical information (status, capacity, access modes) first
- Follows Kubernetes spec/status separation
- Optional fields at the bottom

### Status Display
**Decision**: Use color-coded status tiles similar to pods:
- Available: blue/green (ready to be claimed)
- Bound: green (healthy, in use)
- Released: orange (released but not reclaimed)
- Failed: red (error state)

**Rationale**:
- Consistent with pod status colors
- Quick visual feedback for health assessment
- Standard UI convention for status indicators

### Capacity Format
**Decision**: Display raw capacity as-is from spec.capacity.storage

**Rationale**:
- Kubernetes API already provides human-readable format (e.g., "10Gi")
- Avoids conversion errors
- Simpler implementation

### Claim Reference Display
**Decision**: Display as "namespace/name" format when bound, omit when not bound

**Rationale**:
- Namespace-scoped resources need namespace context
- Follows existing patterns in K8s UIs
- Differentiates between multiple PVCs with same name

### Localization
**Decision**: Add localization keys to `lib/generated/l10n.dart`:
- persistent_volume (section title)
- persistent_volume_status
- persistent_volume_capacity
- persistent_volume_access_modes
- persistent_volume_reclaim_policy
- persistent_volume_storage_class
- persistent_volume_claim
- persistent_volume_reason
- persistent_volume_volume_attributes
- persistent_volume_node_affinity

**Rationale**:
- Project uses bilingual support (English/Chinese)
- Follows existing localization pattern
- Enables future translations

### Storage Class Handling
**Decision**: Display spec.storageClassName, use generic value if null (e.g., "default" or "-")

**Rationale**:
- Not all PVs have storage class specified
- Helpful to know if PV uses default provisioning vs static provisioning

### Node Affinity Display
**Decision**: Display spec.nodeAffinity in YAML format using existing `copyTileYaml`

**Rationale**:
- Node affinity can be complex (multiple terms, expressions)
- YAML display preserves structure and readability
- Reuses existing utility function

## Alternatives Considered

### Alternative 1: Combine with PVC Detail View
Rejected because:
- PV and PVC are separate resources with different specs
- Users may need PV details without PVC context
- Simpler to implement separate handlers

### Alternative 2: Use generic detail widget for all resources
Rejected because:
- Different resources have very different display needs
- Would require complex mapping logic
- Less maintainable

### Alternative 3: Inline PV details in a single widget file
Rejected because:
- Would grow details_page.dart significantly
- Harder to test in isolation
- Violates single responsibility principle

## Risks / Trade-offs

### Risk: Missing optional fields in K8s model
**Mitigation**: Use null-safe operators throughout the widget. Test with PVs in different states.

### Risk: Very large node affinity expressions
**Mitigation**: Use expandable modal display (existing pattern) or YAML view. For now, YAML tile is sufficient.

### Trade-off: Not adding PVC navigation from PV
**Reasoning**: Bidirectional navigation adds complexity. Can be added in a follow-up feature. Priority is basic detail view.

## Migration Plan

No migration needed - this is a new feature.

Steps:
1. Implement widget and add case branch
2. Test with demo cluster and real cluster
3. Verify no regression in existing detail views
4. Deploy to main branch after approval

## Open Questions

None identified. The feature is well-scoped and follows existing patterns.