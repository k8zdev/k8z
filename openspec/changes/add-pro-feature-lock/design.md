# Design: Pro Feature Lockdown System

## Context

The k8z app currently uses RevenueCat SDK for in-app purchases with monthly, annual, and lifetime subscription options. However, all features are freely accessible, and the only monetization point is a "sponsor me" button in Settings, which has resulted in negligible conversion rates.

The goal is to implement a Freemium model where users can experience core value for free but must upgrade to Pro for advanced features.

## Goals / Non-Goals

**Goals:**
- Feature lockdown based on RevenueCat subscription status
- Clear differentiation between Free and Pro features
- Non-intrusive upgrade prompts (Option C: tap to upgrade)
- Grandfather clause for users who already have more than 2 clusters
- Emergency operations remain freely accessible

**Non-Goals:**
- Implementing free trial in code (handled in RevenueCat console)
- Changing paywall page UI/design (out of scope for this change)
- Implementing terminal concurrent session limit (deferred)
- Cloud-based plugin marketplace (future work)

## Decisions

### Decision 1: Feature Classification into Free vs Pro

Emergency operations are free; advanced features are Pro:

| Category | Free | Pro |
|----------|------|-----|
| **Cluster Management** | View clusters, up to 2 clusters | Unlimited clusters |
| **Pod Operations** | All pod operations (view, delete, scale) | - |
| **Terminal Access** | Pod Shell (for emergency debugging) | Node Shell |
| **Resource Operations** | Delete, Scale | YAML Edit + Apply |
| **Logs** | Real-time log viewing | Historical log search |
| **Monitoring** | Resource browsing, real-time metrics | Custom dashboard |

**Rationale:** Emergency operations (Delete, Scale, Pod Shell) are critical for on-call scenarios. Making them free ensures users don't abandon the app in emergencies. Advanced features (YAML editing, Node Shell) are for power users who derive more value and are more willing to pay.

### Decision 2: Grandfather Clause for Existing Clusters

Existing clusters (>2) remain accessible. Only NEW cluster additions are restricted by the 2-cluster limit.

**Rationale:** Penalizing existing users by limiting access to clusters they already configured would cause frustration and abandonment. The grandfather clause maintains trust while still creating upgrade friction for new additions.

**Implementation:**
1. Store a `isGrandfathered` flag on cluster records upgraded before the limit enforcement
2. OR: Store a `limitEnforcementVersion` in app preferences; clusters added before this version are grandfathered

### Decision 3: UI Behavior for Locked Features (Option C)

Locked features are visible (with lock badge) but trigger an upgrade dialog when tapped.

**Alternatives considered:**
- Option A (Hide): Pros: clean UI; Cons: users don't know features exist
- Option B (Grayed out): Pros: visible; Cons: unclear how to enable
- Option C (Tap to upgrade) ← Chosen

**Rationale for Option C:** Users discover features when they need them. Tapping a locked feature at that moment is the highest-intent conversion opportunity. This aligns with monetization best practices (Termius, ServerCat use this pattern).

### Decision 4: Pro Verification Using RevenueCat

Pro status is determined by RevenueCat `CustomerInfo.entitlements.all` containing at least one active entitlement.

**Entitlement identifiers** (from existing code):
- `$rc_lifetime`: Lifetime subscription
- `$rc_monthly`: Monthly subscription
- `$rc_annual`: Annual subscription

**Code pattern:**
```dart
bool isPro = customerInfo?.entitlements.all.values.any((e) => e.isActive) ?? false;
```

### Decision 5: App Open Counter and Probabilistic Upgrade Prompt

Track app open count and show Pro upgrade dialog probabilistically for engaged users (starting at open 10, then every 3rd open: 10, 13, 16, ...).

**Logic:**
1. Increment app open counter on each app launch
2. Only show upgrade dialog to Free users (not Pro users)
3. Show on opens where count >= 10 AND count % 3 == 1 (e.g., opens 10, 13, 16, 19, ...)
4. Skip dialog if user recently dismissed it (optional cooldown)

**Rationale:**
- Probabilistic prompts avoid nagging users on every launch
- 10-opening threshold ensures only engaged users see the prompt
- Every 3rd eligible open provides frequency (~33%) without being overwhelming
- Creates additional discovery channel beyond feature-lock prompts

**Storage:** Use SharedPreferences or SQLite to store `appOpenCount`.

**Prompt schedule:**
| Open Count | Show Dialog? |
|-------------|--------------|
| 1-9 | No |
| 10 | Yes ✅ |
| 11 | No |
| 12 | No |
| 13 | Yes ✅ |
| 14 | No |
| 15 | No |
| 16 | Yes ✅ |
| 17 | No |
| 18 | No |
| 19 | Yes ✅ |
| ... | Yes every 3rd (10, 13, 16, 19...) |

### Decision 6: Service Layer Architecture

Create a centralized `ProFeatures` service that encapsulates all Pro-gate logic.

**Benefits:**
- Single source of truth for feature gating
- Easy to test and maintain
- Consistent upgrade prompts across the app

**Structure:**
```dart
class ProFeatures {
  static const int maxFreeClusters = 2;
  static bool isPro(CustomerInfo? customerInfo) { ... }
  static (bool, String?) canAddCluster(int count, bool isPro) { ... }
  static Future<bool> showUpgradeDialog(BuildContext context, String feature) { ... }
}
```

## Risks / Trade-offs

### Risk: Free users may uninstall when hitting the 2-cluster limit

**Mitigation:**
- The limit is reasonable for personal use (dev cluster + production cluster)
- Upgrade prompt clearly articulates value: "unlock unlimited clusters for managing test, staging, and production environments"

### Risk: Too many locked features frustrate users

**Mitigation:**
- Only lock genuinely advanced/differentiated features
- Keep all emergency operations free
- Show Pro features visible but locked (not hidden)

### Risk: Grandfather clause complexity

**Mitigation:**
- Use simple version-based grandfathering flag in preferences
- No complex per-cluster state management

## Migration Plan

### For existing users with >2 clusters:
1. Set a grandfathering flag in app preferences on first launch after this change
2. Clusters added before the update remain accessible
3. Only cluster additions after the update count against the limit

### For existing Pro subscribers:
- No migration needed; subscription already active with RevenueCat

### For new users:
- Standard 2-cluster limit applies from first use

## Open Questions

- [ ] Should demo cluster count against the 2-cluster limit? (Suggestion: No, demo should be separate)
- [ ] What exact RevenueCat entitlement names are configured in the console? (Current code uses `$rc_lifetime`, `$rc_monthly`, `$rc_annual`)
- [ ] Should there be a cooldown period for the probabilistic upgrade prompt after user dismissal? (e.g., don't show if dismissed in last 3 opens)
- [ ] Reset app open counter when user upgrades to Pro? (Suggested: Yes, to clean up state)
