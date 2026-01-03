import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';

/// Pro upgrade dialog that appears when Free users try to access Pro features.
///
/// Displays:
/// - Lock icon and "k8z Pro" title
/// - Feature description explaining why upgrade is needed
/// - 6 Pro benefits list
/// - "Cancel" and "View Pro Plans" buttons
class ProUpgradeDialog extends StatelessWidget {
  /// Name of the locked feature (e.g., "Node Shell", "YAML Edit")
  final String featureName;

  const ProUpgradeDialog({
    super.key,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock,
          size: 32,
          color: Colors.amber.shade700,
        ),
      ),
      title: Text(
        lang.proDialogTitle,
        style: kTitleTextStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature description
            Text(
              lang.proDialogFeatureLocked(featureName),
              style: kDescriptionTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Pro benefits list
            Text(
              lang.proDialogBenefitsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildBenefitsList(lang),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            lang.proDialogCancel,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.push('/paywall/appstore');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            lang.proDialogViewPlans,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  List<Widget> _buildBenefitsList(S lang) {
    final benefits = [
      lang.proBenefitUnlimitedClusters,
      lang.proBenefitNodeShell,
      lang.proBenefitYamlEdit,
      lang.proBenefitLogSearch,
      lang.proBenefitCustomDashboard,
      lang.proBenefitSupport,
    ];

    return benefits.map(
      (benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 20,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  benefit,
                  style: kDescriptionTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  /// Show the Pro upgrade dialog.
  ///
  /// Returns true if user dismissed, false if user navigated to paywall
  /// (actually just shows dialog and lets user action determine flow).
  static Future<void> show(BuildContext context, {required String featureName}) {
    return showDialog<void>(
      context: context,
      builder: (context) => ProUpgradeDialog(featureName: featureName),
    );
  }
}
