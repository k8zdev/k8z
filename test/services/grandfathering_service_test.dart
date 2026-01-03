import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:k8zdev/services/grandfathering_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
import 'grandfathering_service_test.mocks.dart';

void main() {
  group('GrandfatheringService', () {
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
    });

    group('isGrandfathered()', () {
      test('returns false when flag has never been set', () {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(null);

        // Act
        final result = GrandfatheringService.isGrandfathered(mockPrefs);

        // Assert
        expect(result, false);
      });

      test('returns true when flag is set to true', () {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(true);

        // Act
        final result = GrandfatheringService.isGrandfathered(mockPrefs);

        // Assert
        expect(result, true);
      });

      test('returns false when flag is set to false', () {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(false);

        // Act
        final result = GrandfatheringService.isGrandfathered(mockPrefs);

        // Assert
        expect(result, false);
      });

      test('handles read errors gracefully', () {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenThrow(Exception('Read error'));

        // Act
        final result = GrandfatheringService.isGrandfathered(mockPrefs);

        // Assert
        expect(result, false);
      });
    });

    group('setGrandfathered()', () {
      test('sets grandfathering flag to true', () async {
        // Arrange
        when(mockPrefs.setBool('is_grandfathered', true)).thenAnswer((_) async => true);

        // Act
        await GrandfatheringService.setGrandfathered(mockPrefs);

        // Assert
        verify(mockPrefs.setBool('is_grandfathered', true)).called(1);
      });

      test('handles set errors gracefully', () async {
        // Arrange
        when(mockPrefs.setBool('is_grandfathered', true))
            .thenThrow(Exception('Storage error'));

        // Act & Assert - should not throw
        expect(
          () => GrandfatheringService.setGrandfathered(mockPrefs),
          returnsNormally,
        );
      });
    });

    group('checkAndSetGrandfathering()', () {
      test('sets grandfathering true when cluster count > 2 and not already grandfathered', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(null);
        when(mockPrefs.setBool('is_grandfathered', true)).thenAnswer((_) async => true);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 5);

        // Assert
        verify(mockPrefs.setBool('is_grandfathered', true)).called(1);
      });

      test('sets grandfathering true when cluster count >= 2 and not already grandfathered', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(null);
        when(mockPrefs.setBool('is_grandfathered', true)).thenAnswer((_) async => true);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 2);

        // Assert
        verify(mockPrefs.setBool('is_grandfathered', true)).called(1);
      });

      test('does not set grandfathering when cluster count < 2', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(null);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 1);

        // Assert
        verifyNever(mockPrefs.setBool('is_grandfathered', true));
      });

      test('does not change existing grandfathering true flag', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(true);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 3);

        // Assert
        verifyNever(mockPrefs.setBool('is_grandfathered', true));
      });

      test('does not change existing grandfathering false flag', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(false);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 3);

        // Assert
        verifyNever(mockPrefs.setBool('is_grandfathered', true));
      });

      test('handles cluster count of 0 correctly', () async {
        // Arrange
        when(mockPrefs.getBool('is_grandfathered')).thenReturn(null);

        // Act
        await GrandfatheringService.checkAndSetGrandfathering(mockPrefs, 0);

        // Assert
        verifyNever(mockPrefs.setBool('is_grandfathered', true));
      });
    });

    group('resetGrandfathering()', () {
      test('removes grandfathering flag', () async {
        // Arrange
        when(mockPrefs.remove('is_grandfathered')).thenAnswer((_) async => true);

        // Act
        await GrandfatheringService.resetGrandfathering(mockPrefs);

        // Assert
        verify(mockPrefs.remove('is_grandfathered')).called(1);
      });

      test('handles reset errors gracefully', () async {
        // Arrange
        when(mockPrefs.remove('is_grandfathered'))
            .thenThrow(Exception('Storage error'));

        // Act & Assert - should not throw
        expect(
          () => GrandfatheringService.resetGrandfathering(mockPrefs),
          returnsNormally,
        );
      });
    });
  });
}
