# Change: Enhance Pro Upgrade Messaging

## Why

The Pro upgrade entry point ("Sponsor me") is buried in the Support section at the bottom of Settings, making it hard for users to discover upgrade options. The current App Store paywall is basic and lacks compelling value proposition presentation, which reduces conversion rates.

## What Changes

- Move Pro upgrade entry from "Support" section to dedicated "Pro" section at the top of Settings page
- Redesign App Store paywall with hero section, feature cards (3 Pro benefits), comparison table, and highlighted annual plan
- Add marketing-focused localization strings ("Unlock Pro", "Unlock Full Power of Kubernetes Management", "Best Value", etc.)
- Create Pro settings tile widget with premium badge and subscription status display
- Update call-to-action button from "Sponsor me" to "Unlock Pro Now"

**Pro Features (3 total)**:
- Unlimited clusters (无限制集群访问)
- Node Shell access (节点 Shell 访问)
- YAML editing and apply (YAML 编辑和应用)

## Impact

- Affected specs:
  - **settings-pro-entry** (NEW) - Pro settings section requirements
  - **appstore-paywall-redesign** (NEW) - Paywall UI redesign requirements
- Affected code:
  - `lib/pages/settings.dart` - Add Pro section, remove sponsor from Support
  - `lib/pages/paywalls/appstore_sponsors.dart` - Complete UI redesign
  - `lib/l10n/intl_en.arb` and `intl_zh_CN.arb` - Add Pro marketing strings
  - New widgets: `lib/widgets/pro_settings_tile.dart`, `pro_feature_card.dart`, `pro_features_list.dart`, `pro_comparison_table.dart`
