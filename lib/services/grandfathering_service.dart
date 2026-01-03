import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing grandfathering of existing users.
///
/// Grandfathering allows users who already have more than 2 clusters
/// before the Pro feature lock to continue using all their clusters
/// without being locked out.
class GrandfatheringService {
  // SharedPreferences key for storing grandfathering flag
  static const String _grandfatheredKey = 'is_grandfathered';

  // Minimum cluster count to qualify for grandfathering
  static const int _grandfatheringThreshold = 2;

  /// Check if the user is grandfathered.
  ///
  /// Returns true if the user was grandfathered before the Pro lock.
  /// Returns false if the flag has never been set or is explicitly false.
  static bool isGrandfathered(SharedPreferences prefs) {
    try {
      return prefs.getBool(_grandfatheredKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set the grandfathering flag to true.
  ///
  /// Call this when determining that a user should be grandfathered
  /// (e.g., on first launch if cluster count >= threshold).
  static Future<void> setGrandfathered(SharedPreferences prefs) async {
    try {
      await prefs.setBool(_grandfatheredKey, true);
    } catch (e) {
      // Silently fail - grandfathering should not break the app
    }
  }

  /// Check and set grandfathering based on cluster count.
  ///
  /// Sets the grandfathering flag to true if:
  /// - The flag has never been set (user hasn't been checked before)
  /// - The cluster count is >= 2
  ///
  /// This ensures users with existing clusters are grandfathered on first launch.
  static Future<void> checkAndSetGrandfathering(
    SharedPreferences prefs,
    int clusterCount,
  ) async {
    try {
      // Only check if not already evaluated
      if (prefs.getBool(_grandfatheredKey) == null) {
        if (clusterCount >= _grandfatheringThreshold) {
          await setGrandfathered(prefs);
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Reset the grandfathering flag.
  ///
  /// Removes the flag entirely, which will cause the user to be
  /// re-evaluated on next call to checkAndSetGrandfathering.
  static Future<void> resetGrandfathering(SharedPreferences prefs) async {
    try {
      await prefs.remove(_grandfatheredKey);
    } catch (e) {
      // Silently fail
    }
  }
}
