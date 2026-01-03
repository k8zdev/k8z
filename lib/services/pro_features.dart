import 'package:purchases_flutter/purchases_flutter.dart';

/// Pro feature gating service that checks RevenueCat subscription status
/// and provides centralized access control for all Pro features.
class ProFeatures {
  /// Maximum number of clusters allowed for free users
  static const int maxFreeClusters = 2;

  /// Entitlement identifiers for RevenueCat subscriptions
  static const String entitlementMonthly = '\$rc_monthly';
  static const String entitlementAnnual = '\$rc_annual';
  static const String entitlementLifetime = '\$rc_lifetime';

  /// Check if the user has an active Pro subscription.
  ///
  /// Returns true if [customerInfo] contains at least one active entitlement,
  /// false otherwise or if customerInfo is null.
  static bool isPro(CustomerInfo? customerInfo) {
    if (customerInfo == null) {
      return false;
    }

    return customerInfo.entitlements.all.values.any(
      (entitlement) => entitlement.isActive,
    );
  }

  /// Check if a Free user can add a new cluster.
  ///
  /// Returns a tuple (bool, String?) where:
  /// - bool: true if cluster can be added, false otherwise
  /// - String?: error message if cluster cannot be added, null otherwise
  ///
  /// Rules:
  /// - Pro users: unlimited clusters
  /// - Grandfathered Free users: exempt from limit
  /// - Free users: up to [maxFreeClusters] clusters
  static (bool, String?) canAddCluster(
    int currentCount,
    bool isPro,
    bool isGrandfathered,
  ) {
    // Pro users have unlimited clusters
    if (isPro) {
      return (true, null);
    }

    // Grandfathered users are exempt from the limit
    if (isGrandfathered) {
      return (true, null);
    }

    // Free users limited to maxFreeClusters
    if (currentCount >= maxFreeClusters) {
      return (
        false,
        'Free users can manage up to $maxFreeClusters clusters. '
        'Upgrade to Pro for unlimited clusters.',
      );
    }

    return (true, null);
  }

  /// Check if user can use Node Shell (Pro-only feature).
  static bool canUseNodeShell(bool isPro) {
    return isPro;
  }

  /// Check if user can edit YAML and apply changes (Pro-only feature).
  static bool canEditYaml(bool isPro) {
    return isPro;
  }

  /// Check if user can search logs (Pro-only feature).
  static bool canSearchLogs(bool isPro) {
    return isPro;
  }

  /// Check if user can use custom dashboard (Pro-only feature).
  static bool canUseCustomDashboard(bool isPro) {
    return isPro;
  }
}
