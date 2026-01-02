# Design: Enhanced Onboarding Guide Implementation

## Context

K8zDev already has:
- `OnboardingGuideService` (lib/services/onboarding_guide_service.dart) - State management for guide steps
- `GuideOverlay` (lib/widgets/guide_overlay.dart) - Simple overlay without spotlight
- GoRouter-based navigation system
- Demo cluster creation flow in `ClusterHomePage`
- SQLite database via `sqflite` for persistence

The existing implementation uses a full-screen overlay with center-positioned guide cards. It lacks:
- Element-level highlighting/spotlight effects
- Navigation to specific pages
- Guide restart capability
- Completion persistence

## Goals / Non-Goals

### Goals
- Enable page jumps from guide steps to specific feature pages (Pods list, Pod details, etc.)
- Implement spotlight/highlight effects for target UI elements using `tutorial_coach_mark`
- Support step navigation (next, previous, skip, complete)
- Persist guide completion to avoid re-showing to same user
- Allow manual restart of the guide from settings

### Non-Goals
- Multi-cluster onboarding guides (only demo cluster)
- Custom animations beyond tutorial_coach_mark built-in effects
- Guide editing/creation from UI (hardcoded guide steps)
- Telemetry/analytics beyond existing AnalyticsService integration

## Decisions

### Decision 1: Use tutorial_coach_mark Package

**What**: Integrate `tutorial_coach_mark` package for interactive onboarding overlay.

**Why**:
- Mature, actively maintained Flutter package (10k+ likes on pub.dev)
- Provides built-in spotlight/highlight effects with customizable shapes
- Supports multiple targets per step
- Handles animation and positioning automatically
- Works well with GoRouter navigation
- Cross-platform support (iOS, macOS, Android, Linux, Windows)

**Alternatives considered**:
1. **Custom overlay implementation** - Rejected due to complexity in handling element positioning, animations, and edge cases
2. **Hero Animation + Lottie** - Fallback option if tutorial_coach_mark proves inadequate; good for cinematic tutorials but less interactive

### Decision 2: Guide State Persistence

**What**: Store guide completion status in SQLite database.

**Why**:
- Existing SQLite infrastructure (used for cluster credentials)
- Works across all platforms
- Allows per-user/per-device tracking
- Easy to clear for testing

**Implementation**:
```dart
// New table: onboarding_guide_state
CREATE TABLE onboarding_guide_state (
  id INTEGER PRIMARY KEY,
  guide_name TEXT UNIQUE,
  completed_at INTEGER,
  last_step TEXT,
  cluster_id TEXT
);
```

### Decision 3: Step Definition Structure

**What**: Define guide steps as a declarative data structure with route + target key pairs.

**Why**:
- Separates guide content from implementation
- Allows easy modification of guide steps
- Supports future guide editing UI if needed

**Structure**:
```dart
class GuideStepDefinition {
  final String id;
  final String routeName;       // GoRouter route name
  final Map<String, dynamic> routeParams; // Route parameters
  final String? targetKey;      // GlobalKey for element highlighting
  final String title;
  final String description;
  final String? buttonNext;
  final String? buttonSkip;
}
```

### Decision 4: Guide-Triggered Page Navigation

**What**: When user clicks "Next" in a step, trigger GoRouter navigation to the step's target route.

**Why**:
- Provides seamless flow between guide steps
- Leverages existing routing system
- Allows guide to span multiple pages

**Implementation**:
```dart
// In GuideOverlay or OnboardingGuideService
void navigateToStepStep(BuildContext context, GuideStepDefinition step) {
  context.goNamed(
    step.routeName,
    pathParameters: step.routeParams,
  );
  // After navigation, show guide overlay with spotlight
}
```

### Decision 5: Element Targeting with GlobalKeys

**What**: Use `GlobalKey` on target widgets to enable spotlight highlighting.

**Why**:
- Flutter standard for widget identification
- Allows tutorial_coach_mark to find and highlight elements
- Works across widget rebuilds

**Example**:
```dart
// In PodsPage
static const podListKey = ValueKey('pod-list-guide-target');

// In guide definition
GuideStepDefinition(
  targetKey: PodsPage.podListKey,
  ...
)
```

### Decision 6: Guide Restart from Settings

**What**: Add option in settings page to reset guide completion status.

**Why**:
- Users may want to revisit the guide
- Useful for testing and demo purposes
- Provides escape hatch for users who skipped prematurely

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| `tutorial_coach_mark` compatibility issues | Verify with example project before integration; fallback to custom implementation if needed |
| GlobalKey conflicts with existing keys | Use descriptive prefixes (`guide-target-`) and namespace guide keys |
| Performance impact from overlay on every page | Only attach guide overlay when guide is active |
| Navigation breaking when tutorial_coach_mark handles clicks | Carefully configure tap behavior; ensure tap-through for non-guide areas |

## Migration Plan

### Phase 1: Foundation
1. Add `tutorial_coach_mark` to pubspec.yaml
2. Create onboarding_guide_state database table migration
3. Define guide step data structure

### Phase 2: Core Implementation
1. Update `OnboardingGuideService` with navigation coordination
2. Create new `InteractiveGuideOverlay` using tutorial_coach_mark
3. Add GlobalKeys to target widgets

### Phase 3: Integration
1. Connect guide trigger in `ClusterHomePage` for demo cluster
2. Add guide restart option in settings
3. Handle guide completion persistence

### Phase 4: Testing
1. Unit tests for service and state management
2. BDD tests with flutter_gherkin for full user flows
3. Manual testing on target platforms

**Rollback**: Original `GuideOverlay` can remain as backup; feature can be disabled via config if issues arise.

## Open Questions

- [ ] Should guide be skippable on first run of demo cluster (current behavior: yes)?
- [ ] How many steps should the demo cluster guide have (current: 4 steps)?

## References

- tutorial_coach_mark package: https://pub.dev/packages/tutorial_coach_mark
- GoRouter documentation: https://pub.dev/packages/go_router
- Existing guide implementation: lib/services/onboarding_guide_service.dart:1
