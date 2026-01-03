import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/services/app_usage_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SharedPreferences])
import 'app_usage_tracker_test.mocks.dart';

void main() {
  group('AppUsageTracker', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
    });

    group('incrementOpenCount()', () {
      test('increments from 0 to 1', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenReturn(null);
        when(mockSharedPreferences.setInt('app_open_count', any)).thenAnswer((_) async => true);

        // Act
        AppUsageTracker.incrementOpenCount(mockSharedPreferences);

        // Assert
        verify(mockSharedPreferences.setInt('app_open_count', 1)).called(1);
      });

      test('increments from existing count', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenReturn(5);
        when(mockSharedPreferences.setInt('app_open_count', any)).thenAnswer((_) async => true);

        // Act
        AppUsageTracker.incrementOpenCount(mockSharedPreferences);

        // Assert
        verify(mockSharedPreferences.setInt('app_open_count', 6)).called(1);
      });

      test('handles increment errors gracefully', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenReturn(null);
        when(mockSharedPreferences.setInt('app_open_count', any)).thenThrow(Exception('Storage error'));

        // Act & Assert - should not throw
        expect(
          () => AppUsageTracker.incrementOpenCount(mockSharedPreferences),
          returnsNormally,
        );
      });
    });

    group('getOpenCount()', () {
      test('returns 0 when count does not exist', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenReturn(null);

        // Act
        final count = AppUsageTracker.getOpenCount(mockSharedPreferences);

        // Assert
        expect(count, 0);
      });

      test('returns the stored count', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenReturn(10);

        // Act
        final count = AppUsageTracker.getOpenCount(mockSharedPreferences);

        // Assert
        expect(count, 10);
      });

      test('handles read errors gracefully', () {
        // Arrange
        when(mockSharedPreferences.getInt('app_open_count')).thenThrow(Exception('Read error'));

        // Act
        final count = AppUsageTracker.getOpenCount(mockSharedPreferences);

        // Assert
        expect(count, 0);
      });
    });

    group('shouldShowUpgradePrompt()', () {
      test('returns false for Pro users regardless of count', () {
        // Test with various open counts
        for (final count in [0, 1, 5, 10, 13, 20, 100]) {
          expect(
            AppUsageTracker.shouldShowUpgradePrompt(count, true),
            false,
            reason: 'Pro user should not see prompt at count $count',
          );
        }
      });

      test('returns false for Free users with count < 10', () {
        for (final count in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
          expect(
            AppUsageTracker.shouldShowUpgradePrompt(count, false),
            false,
            reason: 'Free user should not see prompt at count $count',
          );
        }
      });

      test('returns true for Free users at count 10 (first eligible)', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(10, false),
          true,
          reason: 'Free user should see prompt at count 10 (10 % 3 == 1)',
        );
      });

      test('returns false for Free users at count 11', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(11, false),
          false,
          reason: 'Free user should not see prompt at count 11 (11 % 3 == 2)',
        );
      });

      test('returns false for Free users at count 12', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(12, false),
          false,
          reason: 'Free user should not see prompt at count 12 (12 % 3 == 0)',
        );
      });

      test('returns true for Free users at count 13 (second eligible)', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(13, false),
          true,
          reason: 'Free user should see prompt at count 13 (13 % 3 == 1)',
        );
      });

      test('returns true for Free users at count 16 (third eligible)', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(16, false),
          true,
          reason: 'Free user should see prompt at count 16 (16 % 3 == 1)',
        );
      });

      test('returns true for Free users at count 19 (fourth eligible)', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(19, false),
          true,
          reason: 'Free user should see prompt at count 19 (19 % 3 == 1)',
        );
      });

      test('returns false for Free users at count 14', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(14, false),
          false,
          reason: 'Free user should not see prompt at count 14 (14 % 3 == 2)',
        );
      });

      test('returns false for Free users at count 15', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(15, false),
          false,
          reason: 'Free user should not see prompt at count 15 (15 % 3 == 0)',
        );
      });

      test('returns true for Free users at count 22 (following pattern)', () {
        expect(
          AppUsageTracker.shouldShowUpgradePrompt(22, false),
          true,
          reason: 'Free user should see prompt at count 22 (22 % 3 == 1)',
        );
      });

      test('verifies the modulo pattern: count % 3 == 1 for eligible counts', () {
        final eligibleCounts = [10, 13, 16, 19, 22, 25, 28, 31];
        for (final count in eligibleCounts) {
          final remainder = count % 3;
          expect(
            remainder,
            1,
            reason: 'Count $count should have remainder 1',
          );
          expect(
            AppUsageTracker.shouldShowUpgradePrompt(count, false),
            true,
            reason: 'Free user should see prompt at count $count',
          );
        }
      });
    });

    group('resetOpenCount()', () {
      test('resets count to 0', () async {
        // Arrange
        when(mockSharedPreferences.setInt('app_open_count', 0)).thenAnswer((_) async => true);

        // Act
        await AppUsageTracker.resetOpenCount(mockSharedPreferences);

        // Assert
        verify(mockSharedPreferences.setInt('app_open_count', 0)).called(1);
      });

      test('handles reset errors gracefully', () async {
        // Arrange
        when(mockSharedPreferences.setInt('app_open_count', 0)).thenThrow(Exception('Storage error'));

        // Act & Assert - should not throw
        expect(
          () => AppUsageTracker.resetOpenCount(mockSharedPreferences),
          returnsNormally,
        );
      });
    });

    group('Integration test - full flow', () {
      test('counts increments and prompt logic work together', () {
        // Free user flow
        expect(AppUsageTracker.shouldShowUpgradePrompt(0, false), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(9, false), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(10, false), true);
        expect(AppUsageTracker.shouldShowUpgradePrompt(11, false), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(12, false), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(13, false), true);

        // Pro user flow
        expect(AppUsageTracker.shouldShowUpgradePrompt(0, true), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(10, true), false);
        expect(AppUsageTracker.shouldShowUpgradePrompt(100, true), false);
      });
    });
  });
}
