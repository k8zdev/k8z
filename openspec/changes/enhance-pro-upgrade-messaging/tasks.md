# Implementation Tasks

## Phase 1: Localization Updates

- [x] Add new Pro marketing strings to `lib/l10n/intl_en.arb`:
  - [x] `proUnlockTitle`: "Unlock Pro"
  - [x] `proHeadline`: "Unlock Full Power of Kubernetes Management"
  - [x] `proDescription`: "Manage unlimited clusters, access advanced features, and get priority support"
  - [x] `proBestValue`: "Best Value"
  - [x] `proUnlockNow`: "Unlock Pro Now"

- [x] Add new Pro marketing strings to `lib/l10n/intl_zh_CN.arb`:
  - [x] `proUnlockTitle`: "解锁 Pro"
  - [x] `proHeadline`: "解锁 Kubernetes 管理的完整能力"
  - [x] `proDescription`: "管理无限集群、访问高级功能、获得优先支持"
  - [x] `proBestValue`: "超值之选"
  - [x] `proUnlockNow`: "立即解锁 Pro"

- [x] Run `flutter pub run intl_utils:generate` to regenerate translation files

## Phase 2: Settings Page Restructuring

- [x] Create `lib/widgets/pro_settings_tile.dart`:
  - [x] New `ProSettingsTile` widget with premium badge
  - [x] Display subscription status (Free/Pro) with icon
  - [x] Amber/Pro color scheme styling
  - [x] Navigation to App Store paywall

- [x] Update `lib/pages/settings.dart`:
  - [x] Add "Pro" section at top of SettingsList (before Appearance)
  - [x] Insert `ProSettingsTile` in Pro section
  - [x] Remove "Sponsor me" tile from Support section
  - [x] Verify Settings sections order: Pro → Appearance → General → Support → Debug

## Phase 3: App Store Paywall Redesign

- [x] Create `lib/widgets/pro_feature_card.dart`:
  - [x] Card widget for single Pro benefit
  - [x] Icon + title + description layout
  - [x] Consistent styling across cards

- [x] Create `lib/widgets/pro_features_list.dart`:
  - [x] Grid or list widget displaying 3 Pro benefits:
    - [x] Unlimited clusters (无限制集群访问)
    - [x] Node Shell access (节点 Shell 访问)
    - [x] YAML editing (YAML 编辑和应用)
  - [x] Uses `ProFeatureCard` for each feature
  - [x] Responsive layout (mobile/desktop)

- [x] Create `lib/widgets/pro_comparison_table.dart`:
  - [x] Free vs Pro side-by-side comparison
  - [x] Checkmark/cross indicators for features
  - [x] Highlight Pro column with background color

- [x] Redesign `lib/pages/paywalls/appstore_sponsors.dart`:
  - [x] Add hero section with `proHeadline` and `proDescription`
  - [x] Insert `ProFeaturesList` widget after hero
  - [x] Add `ProComparisonTable` widget
  - [x] Update product selection: highlight annual as "Best Value"
  - [x] Change button text to `proUnlockNow`
  - [x] Keep developer story section (optional, below comparison)
  - [x] Preserve EULA, privacy, restore purchases functionality

## Phase 4: Styling and Polish

- [x] Pro settings tile styling:
  - [x] Badge/star icon for upgrade entry
  - [x] Amber color scheme consistency
  - [x] Proper padding and spacing

- [x] Paywall styling:
  - [x] Premium look with consistent spacing
  - [x] "Best Value" badge on annual plan
  - [x] Visual hierarchy: headline → features → comparison → pricing → CTA
  - [x] Dark mode compatibility

## Phase 5: Testing

- [ ] Manual testing:
  - [ ] Verify Settings page has Pro section at top
  - [ ] Click Pro entry navigates to paywall
  - [ ] Paywall displays all 3 Pro benefits
  - [ ] Comparison table renders correctly
  - [ ] Annual plan shows "Best Value" badge
  - [ ] Purchase flow works end-to-end
  - [ ] Test in both light and dark mode
  - [ ] Test on mobile layout and desktop

- [ ] Localization testing:
  - [ ] Verify English strings display correctly
  - [ ] Verify Chinese strings display correctly
  - [ ] Test language switching

- [ ] Regression testing:
  - [ ] Ensure Pro features still work correctly (ProFeatures service)
  - [ ] Verify RevenueCat purchase flow unchanged
  - [ ] Test Pro upgrade dialog for locked features

## Phase 6: Documentation

- [ ] Update project documentation (if needed for Pro features)
- [ ] Add screenshot reference for new Settings layout
- [ ] Add screenshot reference for redesigned paywall

## Dependencies

- **Phase 1** must complete before **Phase 3** (new strings needed in paywall)
- **Phase 2** and **Phase 3** can be done in parallel after **Phase 1**
- **Phase 4** depends on **Phase 2** and **Phase 3**
- **Phase 5** depends on all previous phases

## Estimated Tasks

- Total: ~25 tasks
- Critical path (must be sequential): Localization → Settings → Paywall → Styling → Testing
