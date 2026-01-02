# Change: Add Pro Feature Lockdown

## Why

The current "sponsor me" monetization model in k8z has negligible conversion because all features are available for free, and the sponsor button is hidden in settings. Users have no incentive to pay since they receive no additional value. To improve monetization, we need to implement a Freemium model with clear feature differentiation that drives users toward Pro subscriptions through value-gated features.

## What Changes

- Implement Pro feature lockdown service (`lib/services/pro_features.dart`) that checks RevenueCat subscription status
- Add cluster count limitation: Free users can manage up to 2 clusters, Pro users get unlimited clusters
- Add grandfather clause: Existing clusters (>2) remain accessible, only new additions are restricted
- Lock Node Shell access behind Pro (Pod terminal remains free for emergency debugging)
- Lock advanced features behind Pro: YAML editing/Apply, log search, custom dashboard
- Create Pro upgrade dialog component that triggers when locked features are accessed
- Implement upgrade tips in UI: Show locked features, trigger upgrade dialog on tap
- Add app open counter and probabilistic Pro upgrade prompt (shows after 10+ opens with `count % 3 == 0` probability)
- Update RevenueCatCustomer provider to add convenient `isPro` getter method

## Impact

- **Affected specs**: `pro-features` (new capability) - defines Pro feature gating system
- **Affected code**:
  - `lib/services/pro_features.dart` - new service for Pro feature checks
  - `lib/providers/revenuecat_customer.dart` - add isPro getter
  - `lib/widgets/pro_upgrade_dialog.dart` - new upgrade dialog component
  - `lib/pages/clusters/add_cluster_page.dart` - enforce cluster count limit
  - `lib/pages/terminal/terminal_manager.dart` - manage terminal sessions (if implementing concurrent limit later)
  - Various detail pages - add Pro badge to locked features (Node Shell, YAML Edit, etc.)
