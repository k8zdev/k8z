import 'package:shared_preferences/shared_preferences.dart';

/// Tracks app usage for probabilistic Pro upgrade prompts.
///
/// Maintains a counter of how many times the app has been opened
/// and determines when to show upgrade prompts to Free users.
class AppUsageTracker {
  // SharedPreferences key for storing app open count
  static const String _appOpenCountKey = 'app_open_count';

  // Minimum app opens before prompts are shown
  static const int _minOpensBeforePrompt = 10;

  // Show prompt every Nth eligible open (3 means every 3rd open in the pattern)
  static const int _promptFrequencyDenominator = 3;

  // The remainder that makes a count eligible for showing prompt
  // We use 1 so prompts show at 10, 13, 16, 19, ... (10 % 3 == 1, 13 % 3 == 1, etc)
  static const int _promptFrequencyRemainder = 1;

  /// Increment the app open counter by 1.
  ///
  /// Call this on every app launch to track usage.
  static Future<void> incrementOpenCount(SharedPreferences prefs) async {
    try {
      final currentCount = prefs.getInt(_appOpenCountKey) ?? 0;
      await prefs.setInt(_appOpenCountKey, currentCount + 1);
    } catch (e) {
      // Silently fail - tracking should not break the app
      // Consider adding logging in production
    }
  }

  /// Get the current app open count.
  ///
  /// Returns 0 if the count has never been set.
  static int getOpenCount(SharedPreferences prefs) {
    try {
      return prefs.getInt(_appOpenCountKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if a Pro upgrade prompt should be shown.
  ///
  /// Returns true if:
  /// - User is not Pro (Free user)
  /// - App has been opened at least [_minOpensBeforePrompt] times
  /// - Current open count matches the prompt frequency pattern (count % 3 == 1)
  ///
  /// This creates a pattern where prompts show at opens: 10, 13, 16, 19, ...
  static bool shouldShowUpgradePrompt(int openCount, bool isPro) {
    // Pro users never see upgrade prompts
    if (isPro) {
      return false;
    }

    // Don't show prompts until minimum opens reached
    if (openCount < _minOpensBeforePrompt) {
      return false;
    }

    // Check if this open matches the prompt frequency pattern
    // Prompt shows when (count % 3 == 1), i.e., on every 3rd open in the sequence
    return openCount % _promptFrequencyDenominator == _promptFrequencyRemainder;
  }

  /// Reset the app open counter to 0.
  ///
  /// Call this when a user upgrades to Pro to reset tracking,
  /// or for testing purposes.
  static Future<void> resetOpenCount(SharedPreferences prefs) async {
    try {
      await prefs.setInt(_appOpenCountKey, 0);
    } catch (e) {
      // Silently fail
    }
  }
}
