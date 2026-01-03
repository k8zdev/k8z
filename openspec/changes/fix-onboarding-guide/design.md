# Design: Onboarding Guide Fixes and Extended Flow

## Context

The onboarding guide service was introduced in the `enhance-demo-cluster-guide` change but bugs were found during testing:
- Skipping doesn't persist to database
- Back button doesn't navigate to previous page routes
- All text is hardcoded in English

The guide also needs to be more comprehensive and educational for users learning K8zDev.

## Goals / Non-Goals

**Goals:**
- Fix skip persistence bug so guides don't reappear
- Fix back navigation to actually go to previous pages
- Add full i18n support for all guide text
- Extend guide to 8 steps covering more features
- Include gesture education (swipe actions)

**Non-Goals:**
- Changing the overall overlay widget architecture (`InteractiveGuideOverlay`)
- Modifying the database schema (existing table is sufficient)
- Adding new packages or dependencies

## Decisions

### 1. Skip Persistence Strategy

**Decision**: Modify `skipGuide()` to call `OnboardingGuideDao.saveCompletion()` with a completion marker.

**Implementation**:
```dart
Future<void> skipGuide() async {
  if (!_state.isActive) return;

  talker.info('Skipping onboarding guide');

  // Save skip as completion to database
  await OnboardingGuideDao.saveCompletion(
    OnboardingGuideState.completed(
      guideName: guideName,
      clusterId: _state.demoCluster?.server,
      lastStep: _state.currentStepId, // Track where user skipped
    ),
  );

  // Log analytics event
  AnalyticsService.logEvent(eventName: 'onboarding_guide_skip', ...);

  _state = const OnboardingState();
  notifyListeners();
}
```

**Rationale**: Treating "skip" the same as "completed" for persistence purposes ensures the guide won't reappear. The `lastStep` field captures where the user stopped, which could be used for analytics or future "resume" features.

**Alternatives considered**:
- Separate `skipped_at` column in DB: Adds unnecessary schema change
- In-memory skip flag: Persists across app restarts
- `is_completed = false` with `skipped_at`: Similar complexity, more fields

### 2. Back Navigation with Route Support

**Decision**: Implement bidirectional route navigation in `landing.dart` using step definitions.

**Implementation**:
```dart
void _handlePreviousStep(BuildContext context, OnboardingGuideService guideService) async {
  final prevId = DemoClusterGuide.getPreviousStepId(guideService.currentStepId ?? '');
  final router = GoRouter.of(context);

  if (prevId != null) {
    // Get the previous step to navigate to its route
    final prevStep = DemoClusterGuide.getStepById(prevId);
    if (prevStep != null && prevStep.routeName.isNotEmpty) {
      await guideService.navigateToStep(prevId);
      _navigateToRoute(router, prevStep.routeName, prevStep.routeParams);
    }
  }
}
```

**Rationale**: The existing `_handleNextStep` already handles forward navigation. Back navigation needs the same pattern: update state then navigate. This mirrors user mental model of "going back" both in step progression AND page routing.

**Alternatives considered**:
- Only update state, let users manually navigate: Inconsistent with forward behavior
- Use browser back: Flutter web only, unreliable across platforms

### 3. i18n Architecture for Guide Text

**Decision**: Add i18n keys as a new property `l10nKey` to `GuideStepDefinition`, maintain backward compatibility with direct text.

**Implementation**:

```dart
class GuideStepDefinition {
  final String? l10nTitle;      // e.g. "guide_step_1_title"
  final String? l10nDescription; // e.g. "guide_step_1_desc"
  final String? l10nButtonNext;  // e.g. "guide_button_next"
  final String? l10nButtonSkip;  // e.g. "guide_button_skip"
  final String? l10nButtonPrev;  // e.g. "guide_button_prev"

  // Backward compatible direct text fields (deprecated for use)
  @Deprecated('Use l10nTitle instead')
  final String title;

  // Get localized title with fallback
  String getLocalizedTitle(BuildContext context) {
    return l10nTitle != null ? S.of(context).getLocalized(l10nTitle!) : title;
  }
}
```

**ARB files format**:
```json
{
  "guide_step_1_title": "Welcome to K8zDev!",
  "@guide_step_1_title": {"description": "Onboarding guide step 1 title"},
  "guide_step_1_desc": "Let's quickly explore the main features...",
  "guide_button_next": "Next",
  "guide_button_skip": "Skip",
  "guide_button_back": "Back"
}
```

**Rationale**:
- Adding new i18n keys avoids breaking existing code using direct text
- Fallback to direct text gives flexibility for dynamic/programmatic content
- Consistent with K8zDev existing i18n patterns (`S.of(context)`)

**Alternatives considered**:
- Replace all text with i18n keys (breaking): Too risky for existing code
- Use dynamic key lookups without type safety: Harder to validate
- Extract all text at runtime overhead: Unnecessary complexity

### 4. Extended Guide Step Definitions (8 Steps)

**Decision**: Define 8 steps with specific routes and target keys:

| Step | ID | Route | Route Params | Target Key | Purpose |
|------|-----|-------|--------------|-----------|---------|
| 1 | welcome | clusters | - | welcomeTargetKey | Welcome message on cluster list |
| 2 | workloadsOverview | workloads | - | workloadsTargetKey | Show workload resources |
| 3 | podListWithSwipe | pods | - | podListTargetKey | Pod list + swipe gestures explanation |
| 4 | podDetail | details | path=workloads, resource=pods, name=web-demo | podDetailTargetKey | Pod YAML, logs, terminal features |
| 5 | resourcesMenu | resources | - | resourcesTargetKey | Resources navigation overview (Config, Storage, Networking) |
| 6 | nodesListWithSwipe | nodes | - | nodesTargetKey | Nodes list + swipe gestures explanation |
| 7 | nodeDetail | node_detail | name=<dynamic-first-node> | nodeDetailTargetKey | Node monitoring features |
| 8 | completed | clusters | - | completedTargetKey | Return to cluster list + help docs mention |

**Rationale**:
- Swipe gestures are explained immediately after listing (cognitive coherence)
- Real pod/node detail pages provide context for their features
- Resources menu introduces organization before specific details
- Last step completes on cluster list page where user started
- Routes align with existing page navigation structure
- Pod name "web-demo" is fixed and expected in demo cluster
- Node name is dynamically fetched from API to work with any demo cluster configuration

**Alternatives considered**:
- Separate swipe steps without content: Users won't see what they're swiping on
- Include every resource type: Guide would be too long
- Skip pod detail: Users wouldn't understand how to access logs/YAML
- Hardcode node name: Would break if demo cluster has different node names

### 5. New GlobalKeys for Target Elements

**Decision**: Add new keys to `GuideKeys` class:

```dart
class GuideKeys {
  // Existing
  static final GlobalKey welcomeTargetKey = GlobalKey();
  static final GlobalKey podListTargetKey = GlobalKey();
  static final GlobalKey nodesTargetKey = GlobalKey();

  // New keys for extended flow
  static final GlobalKey workloadsTargetKey = GlobalKey();   // Workloads list section
  static final GlobalKey podDetailTargetKey = GlobalKey();   // Pod detail tabs/actions
  static final GlobalKey resourcesTargetKey = GlobalKey();   // Resources menu
  static final GlobalKey nodeDetailTargetKey = GlobalKey();   // Node detail sections
  static final GlobalKey completedTargetKey = GlobalKey();   // Completion message area
}
```

**Rationale**:
- Each step needs a focus point for the overlay spotlight
- Swipe gesture explanations highlight the list itself (reusing existing keys)
- Pod and node details need separate keys for their unique content
- Consistent naming with existing `xxxTargetKey` pattern

### 6. Database Schema - No Changes

**Decision**: Keep existing `onboarding_guide_state` table schema as-is.

**Rationale**: The current schema already supports everything needed:
- `completed_at INTEGER`: Can store skip timestamp
- `last_step TEXT`: Can track where user skipped
- `cluster_id TEXT`: Per-cluster skip tracking

No schema migration required.

## Risks / Trade-offs

| Risk | Mitigation |
|------|----------|
| 8 steps may feel too long | Keep descriptions concise (1-2 sentences each) |
| Users skip but want to retry later | Add "Retry Guide" in settings (calls `resetGuide()`) |
| i18n adds string duplication | Maintain clear naming convention in ARB files |
| Route navigation state drift | Always navigate AFTER state update (not before) |
| Swipe gestures hard to demonstrate | Use text description + highlight representative element |

## Migration Plan

1. **Phase 1 - Bug Fixes** (no user-facing changes except fixes):
   - Modify `skipGuide()` to persist
   - Fix back navigation
   - Test skip + back flow end-to-end

2. **Phase 2 - i18n Foundation**:
   - Add i18n keys to ARB files (English + Chinese)
   - Update `GuideStepDefinition` with `l10n*` properties
   - Migrate existing guide steps to use i18n keys
   - Run `flutter pub run intl_utils` to generate `S` class

3. **Phase 3 - Extended Flow**:
   - Add new step definitions to `DemoClusterGuide`
   - Add new `GuideKeys`
   - Attach keys to target widgets
   - Update BDD tests for new steps

4. **Phase 4 - Testing**:
   - Run all unit tests
   - Run BDD scenarios on macOS
   - Test both English and Chinese locales
   - Verify skip flow + back navigation work correctly

**Rollback**: Each phase can be independently reverted via git. No database migrations = no rollbacks needed there.

## Open Questions

1. **Should swipe gestures be visual or text-only?**
   - Current plan: text description with highlighted element
   - Follow-ups: Consider if animation library needed for demo

2. **Should the guide show up on every demo cluster or once per app?**
   - Current: Per-cluster (clusterId in DB)
   - Consider: Per-installation may be better for demo clusters

3. **How to handle route navigation conflicts?**
   - If user manually navigates while guide is active
   - Current behavior: Guide tracks step ID, may show wrong overlay
   - Decision: Accept as limitation, document in code comments
