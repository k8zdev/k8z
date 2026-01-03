import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:settings_ui/settings_ui.dart';

/// Create a Pro settings tile widget for the Settings page.
///
/// Features:
/// - Premium badge with star icon
/// - Subscription status display (Free/Pro)
/// - Amber color scheme styling
/// - Navigates to App Store paywall on tap
///
/// [isPro] - Current subscription status (true for Pro, false for Free)
SettingsTile ProSettingsTile({bool isPro = false}) {
  return SettingsTile.navigation(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isPro ? Icons.workspace_premium : Icons.star_border,
        color: Colors.amber.shade700,
        size: 24,
      ),
    ),
    title: Row(
      children: [
        Builder(
          builder: (context) {
            final lang = S.of(context);
            return Text(
              lang.proSettingsTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade700,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Builder(
          builder: (context) {
            final lang = S.of(context);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPro ? Colors.amber.shade700 : Colors.amber.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPro ? lang.proPro : lang.proFree,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isPro ? Colors.white : Colors.amber.shade900,
                ),
              ),
            );
          },
        ),
      ],
    ),
    value: Builder(
      builder: (context) {
        final lang = S.of(context);
        final theme = Theme.of(context);
        return Text(
          lang.proUnlockNow,
          style: TextStyle(
            fontSize: 14,
            color: isPro
                ? Colors.amber.shade700
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        );
      },
    ),
    onPressed: (context) {
      GoRouter.of(context).pushNamed("appstore");
    },
  );
}
