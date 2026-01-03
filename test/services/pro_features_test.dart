import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/pro_features.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() {
  group('ProFeatures.isPro()', () {
    test('returns false when customerInfo is null', () {
      // Act
      final isPro = ProFeatures.isPro(null);

      // Assert
      expect(isPro, false);
    });

    test('returns false when customerInfo has no active entitlements', () {
      // Arrange - Create manual test double
      final entitlementInfo = _MockEntitlementInfo(isActive: false);

      final customerInfo = _MockCustomerInfo(
        entitlements: {
          '\$rc_monthly': entitlementInfo,
        },
      );

      // Act
      final isPro = ProFeatures.isPro(customerInfo);

      // Assert
      expect(isPro, false);
    });

    test('returns true when entitlements.all has an active monthly subscription', () {
      // Arrange
      final entitlementInfo = _MockEntitlementInfo(isActive: true);

      final customerInfo = _MockCustomerInfo(
        entitlements: {
          '\$rc_monthly': entitlementInfo,
        },
      );

      // Act
      final isPro = ProFeatures.isPro(customerInfo);

      // Assert
      expect(isPro, true);
    });

    test('returns true when entitlements.all has an active annual subscription', () {
      // Arrange
      final entitlementInfo = _MockEntitlementInfo(isActive: true);

      final customerInfo = _MockCustomerInfo(
        entitlements: {
          '\$rc_annual': entitlementInfo,
        },
      );

      // Act
      final isPro = ProFeatures.isPro(customerInfo);

      // Assert
      expect(isPro, true);
    });

    test('returns true when entitlements.all has an active lifetime subscription', () {
      // Arrange
      final entitlementInfo = _MockEntitlementInfo(isActive: true);

      final customerInfo = _MockCustomerInfo(
        entitlements: {
          '\$rc_lifetime': entitlementInfo,
        },
      );

      // Act
      final isPro = ProFeatures.isPro(customerInfo);

      // Assert
      expect(isPro, true);
    });

    test('returns false when entitlements.all has an expired subscription', () {
      // Arrange
      final entitlementInfo = _MockEntitlementInfo(isActive: false);

      final customerInfo = _MockCustomerInfo(
        entitlements: {
          '\$rc_monthly': entitlementInfo,
        },
      );

      // Act
      final isPro = ProFeatures.isPro(customerInfo);

      // Assert
      expect(isPro, false);
    });
  });

  group('ProFeatures.canAddCluster()', () {
    test('allows Pro user to add cluster regardless of count', () {
      // Arrange
      const currentCount = 100;
      const isPro = true;
      const isGrandfathered = false;

      // Act
      final result = ProFeatures.canAddCluster(currentCount, isPro, isGrandfathered);

      // Assert
      expect(result.$1, true);
      expect(result.$2, null);
    });

    test('allows Free user to add cluster when count < maxFreeClusters (2)', () {
      // Arrange
      const currentCount = 1;
      const isPro = false;
      const isGrandfathered = false;

      // Act
      final result = ProFeatures.canAddCluster(currentCount, isPro, isGrandfathered);

      // Assert
      expect(result.$1, true);
      expect(result.$2, null);
    });

    test('blocks Free user from adding cluster when count == maxFreeClusters (2)', () {
      // Arrange
      const currentCount = 2;
      const isPro = false;
      const isGrandfathered = false;

      // Act
      final result = ProFeatures.canAddCluster(currentCount, isPro, isGrandfathered);

      // Assert
      expect(result.$1, false);
      expect(result.$2, isNotNull);
      expect(result.$2, contains('2 clusters'));
    });

    test('blocks Free user from adding cluster when count > maxFreeClusters (3)', () {
      // Arrange
      const currentCount = 3;
      const isPro = false;
      const isGrandfathered = false;

      // Act
      final result = ProFeatures.canAddCluster(currentCount, isPro, isGrandfathered);

      // Assert
      expect(result.$1, false);
      expect(result.$2, isNotNull);
      expect(result.$2, contains('2 clusters'));
    });

    test('allows grandfathered Free user to add cluster regardless of count', () {
      // Arrange
      const currentCount = 10;
      const isPro = false;
      const isGrandfathered = true;

      // Act
      final result = ProFeatures.canAddCluster(currentCount, isPro, isGrandfathered);

      // Assert
      expect(result.$1, true);
      expect(result.$2, null);
    });
  });

  group('ProFeatures.canUseNodeShell()', () {
    test('allows Pro user to use Node Shell', () {
      // Arrange
      const isPro = true;

      // Act
      final canUse = ProFeatures.canUseNodeShell(isPro);

      // Assert
      expect(canUse, true);
    });

    test('blocks Free user from using Node Shell', () {
      // Arrange
      const isPro = false;

      // Act
      final canUse = ProFeatures.canUseNodeShell(isPro);

      // Assert
      expect(canUse, false);
    });
  });

  group('ProFeatures.canEditYaml()', () {
    test('allows Pro user to edit YAML', () {
      // Arrange
      const isPro = true;

      // Act
      final canEdit = ProFeatures.canEditYaml(isPro);

      // Assert
      expect(canEdit, true);
    });

    test('blocks Free user from editing YAML', () {
      // Arrange
      const isPro = false;

      // Act
      final canEdit = ProFeatures.canEditYaml(isPro);

      // Assert
      expect(canEdit, false);
    });
  });

  group('ProFeatures.canSearchLogs()', () {
    test('allows Pro user to search logs', () {
      // Arrange
      const isPro = true;

      // Act
      final canSearch = ProFeatures.canSearchLogs(isPro);

      // Assert
      expect(canSearch, true);
    });

    test('blocks Free user from searching logs', () {
      // Arrange
      const isPro = false;

      // Act
      final canSearch = ProFeatures.canSearchLogs(isPro);

      // Assert
      expect(canSearch, false);
    });
  });

  group('ProFeatures.canUseCustomDashboard()', () {
    test('allows Pro user to use custom dashboard', () {
      // Arrange
      const isPro = true;

      // Act
      final canUse = ProFeatures.canUseCustomDashboard(isPro);

      // Assert
      expect(canUse, true);
    });

    test('blocks Free user from using custom dashboard', () {
      // Arrange
      const isPro = false;

      // Act
      final canUse = ProFeatures.canUseCustomDashboard(isPro);

      // Assert
      expect(canUse, false);
    });
  });

  group('ProFeatures.maxFreeClusters', () {
    test('returns 2 for max free clusters', () {
      // Act
      final maxFree = ProFeatures.maxFreeClusters;

      // Assert
      expect(maxFree, 2);
    });
  });
}

// Test double interfaces for testing without mockito
class _MockEntitlementInfo implements EntitlementInfo {
  final bool _isActive;

  _MockEntitlementInfo({required bool isActive}) : _isActive = isActive;

  @override
  bool get isActive => _isActive;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _MockEntitlementInfos implements EntitlementInfos {
  final Map<String, EntitlementInfo> _all;

  _MockEntitlementInfos(this._all);

  @override
  Map<String, EntitlementInfo> get all => _all;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _MockCustomerInfo implements CustomerInfo {
  final EntitlementInfos _entitlements;

  _MockCustomerInfo({required Map<String, EntitlementInfo> entitlements})
      : _entitlements = _MockEntitlementInfos(entitlements);

  @override
  EntitlementInfos get entitlements => _entitlements;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
