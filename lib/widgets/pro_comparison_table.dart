import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';

/// Pro comparison table widget comparing Free vs Pro tiers.
///
/// Features:
/// - Side-by-side Free vs Pro comparison
/// - Checkmark/cross indicators for features
/// - Highlight Pro column with accent color
/// - Responsive design
class ProComparisonTable extends StatelessWidget {
  const ProComparisonTable({super.key});

  /// List of comparison features with their availability in each tier
  List<Map<String, dynamic>> get _features => [
        {
          'feature': 'Unlimited Clusters',
          'langKey': 'comparisonFeatureUnlimitedClusters',
          'free': false,
          'pro': true,
          'icon': Icons.cloud,
        },
        {
          'feature': 'Node Shell Access',
          'langKey': 'comparisonFeatureNodeShell',
          'free': false,
          'pro': true,
          'icon': Icons.terminal,
        },
        {
          'feature': 'YAML Edit & Apply',
          'langKey': 'comparisonFeatureYamlEdit',
          'free': false,
          'pro': true,
          'icon': Icons.code,
        },
        {
          'feature': 'Basic Cluster Monitoring',
          'langKey': 'comparisonFeatureMonitoring',
          'free': true,
          'pro': true,
          'icon': Icons.monitor_heart,
        },
        {
          'feature': 'View Workloads',
          'langKey': 'comparisonFeatureViewWorkloads',
          'free': true,
          'pro': true,
          'icon': Icons.workspaces,
        },
      ];

  Widget _buildIcon(BuildContext context, bool available) {
    if (available) {
      return Icon(
        Icons.check_circle,
        color: Colors.green.shade500,
        size: 24,
      );
    } else {
      return Icon(
        Icons.cancel,
        color: Colors.grey.shade400,
        size: 24,
      );
    }
  }

  String _getFeatureText(S lang, Map<String, dynamic> feature) {
    // Try to get localized text using langKey, fallback to English feature name
    final langKey = feature['langKey'];
    if (langKey != null) {
      // Use reflection to get the localized string
      switch (langKey) {
        case 'comparisonFeatureUnlimitedClusters':
          return lang.comparisonFeatureUnlimitedClusters;
        case 'comparisonFeatureNodeShell':
          return lang.comparisonFeatureNodeShell;
        case 'comparisonFeatureYamlEdit':
          return lang.comparisonFeatureYamlEdit;
        case 'comparisonFeatureMonitoring':
          return lang.comparisonFeatureMonitoring;
        case 'comparisonFeatureViewWorkloads':
          return lang.comparisonFeatureViewWorkloads;
      }
    }
    return feature['feature'];
  }

  Widget _buildRow(
    BuildContext context,
    S lang,
    Map<String, dynamic> feature,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Feature icon
          Container(
            width: 32,
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              feature['icon'],
              size: 20,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          // Feature name
          Expanded(
            flex: 2,
            child: Text(
              _getFeatureText(lang, feature),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Free column
          Expanded(
            child: Center(
              child: _buildIcon(context, feature['free']),
            ),
          ),
          // Pro column (highlighted)
          Container(
            width: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.transparent,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _buildIcon(context, feature['pro']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade900.withOpacity(0.5)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Spacer(flex: 2),
              Expanded(
                child: Center(
                  child: Text(
                    lang.proFree,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      lang.proPro,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),

          // Feature rows
          ..._features.map((feature) => _buildRow(context, lang, feature)),
        ],
      ),
    );
  }
}
