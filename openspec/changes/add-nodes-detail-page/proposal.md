# Change: Add Nodes Resource Detail Page

## Why
Users need to view detailed information about Kubernetes Nodes including operating system, architecture, kernel version, container runtime, IP addresses, capacity, and conditions. Currently, when clicking on a Node resource, the detail page shows "Building..." instead of displaying Node-specific information.

## What Changes
- Add `buildNodeDetailSectionTiles` widget builder in `lib/widgets/detail_widgets/node.dart`
- Add "nodes" case in `buildDetailSection` method of `lib/pages/k8s_detail/details_page.dart`
- Display key Node information:
  - Operating System (from `status.nodeInfo.osImage`)
  - Architecture (from `status.nodeInfo.architecture`)
  - Kernel Version (from `status.nodeInfo.kernelVersion`)
  - Container Runtime Version (from `status.nodeInfo.containerRuntimeVersion`)
  - IP Addresses (from `status.addresses`)
  - Node Capacity (from `status.capacity`)
  - Node Conditions (from `status.conditions`)
  - Pod CIDR (from `spec.podCIDR`)
  - Unschedulable status (from `spec.unschedulable`)

## Impact
- Affected code:
  - `/lib/pages/k8s_detail/details_page.dart` - Add nodes case in buildDetailSection
  - `/lib/widgets/detail_widgets/node.dart` - Create new file for Node detail widgets
- No breaking changes - this is a new feature addition
- UI consistency maintained by following existing pattern (services, configmaps)