import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/services/app_usage_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Step definitions for probabilistic upgrade prompt scenarios
///
/// These steps verify the logic for when to show Pro upgrade prompts
/// to Free users based on app usage patterns.
///
/// Prompt logic:
/// - Prompts start showing after 10 app opens
/// - Prompts show on a pattern: every 3rd open (10, 13, 16, 19, ...)
/// - Pro users never see upgrade prompts

// Use SharedPreferences to track user type during tests
const String _isProUserKey = 'test_is_pro_user';

// Probabilistic prompt specific steps

StepDefinitionGeneric<World> givenOpenCountIs(int count) {
  return given1<int, World>(
    '这是第{int}次打开应用',
    (int count, context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_open_count', count);
    },
  );
}

StepDefinitionGeneric<World> givenOpenCountCurrentValue(int count) {
  return given1<int, World>(
    '应用打开计数器当前值为{int}',
    (int count, context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_open_count', count);
    },
  );
}

StepDefinitionGeneric<World> givenOpenCountIsSimple(int count) {
  return given1<int, World>(
    '应用打开计数器为{int}',
    (int count, context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_open_count', count);
    },
  );
}

/// Track user type using SharedPreferences
StepDefinitionGeneric<World> givenUserIsFree() {
  return given<World>(
    '用户是Free用户',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isProUserKey, false);
    },
  );
}

StepDefinitionGeneric<World> givenUserIsPro() {
  return given<World>(
    '用户是Pro用户',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isProUserKey, true);
    },
  );
}

StepDefinitionGeneric<World> whenAppStartup() {
  return when<World>(
    '应用启动时',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('app_open_count') ?? 0;
      await prefs.setInt('app_open_count', currentCount + 1);
    },
  );
}

StepDefinitionGeneric<World> whenCheckIfShouldShowPrompt() {
  return when<World>(
    '检查是否应该显示提示',
    (context) async {
      // Just a placeholder - actual verification happens in then steps
    },
  );
}

StepDefinitionGeneric<World> thenShouldNotShowUpgradedDialog() {
  return then<World>(
    '不应该显示Pro升级对话框',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final openCount = prefs.getInt('app_open_count') ?? 0;
      final isPro = prefs.getBool(_isProUserKey) ?? false;
      final shouldShow = AppUsageTracker.shouldShowUpgradePrompt(openCount, isPro);
      context.expect(shouldShow, isFalse);
    },
  );
}

StepDefinitionGeneric<World> thenShouldShowUpgradeDialog() {
  return then<World>(
    '应该显示Pro升级对话框',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final openCount = prefs.getInt('app_open_count') ?? 0;
      final isPro = prefs.getBool(_isProUserKey) ?? false;
      final shouldShow = AppUsageTracker.shouldShowUpgradePrompt(openCount, isPro);
      context.expect(shouldShow, isTrue);
    },
  );
}

StepDefinitionGeneric<World> thenShouldReturnTrue() {
  return then<World>(
    '应该返回true',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final openCount = prefs.getInt('app_open_count') ?? 0;
      final isPro = prefs.getBool(_isProUserKey) ?? false;
      final shouldShow = AppUsageTracker.shouldShowUpgradePrompt(openCount, isPro);
      context.expect(shouldShow, isTrue);
    },
  );
}

StepDefinitionGeneric<World> thenShouldReturnFalse() {
  return then<World>(
    '应该返回false',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final openCount = prefs.getInt('app_open_count') ?? 0;
      final isPro = prefs.getBool(_isProUserKey) ?? false;
      final shouldShow = AppUsageTracker.shouldShowUpgradePrompt(openCount, isPro);
      context.expect(shouldShow, isFalse);
    },
  );
}

StepDefinitionGeneric<World> thenOpenCountBecomes(int expectedCount) {
  return then1<int, World>(
    '应用打开计数器应该变为{int}',
    (int expectedCount, context) async {
      final prefs = await SharedPreferences.getInstance();
      final actualCount = prefs.getInt('app_open_count') ?? 0;
      context.expect(actualCount, expectedCount);
    },
  );
}

StepDefinitionGeneric<World> whenAppInitComplete() {
  return when<World>(
    '应用初始化完成',
    (context) async {
      // App initialization complete - placeholder for when step
      // The actual check happens in the then steps
    },
  );
}

StepDefinitionGeneric<World> whenUserClosesUpgradeDialog() {
  return when<World>(
    '用户关闭了升级对话框',
    (context) async {
      // User closes upgrade dialog - just a placeholder
      // The open count doesn't change when dialog is dismissed
    },
  );
}

StepDefinitionGeneric<World> whenNextAppOpen() {
  return when<World>(
    '下一次打开应用时',
    (context) async {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('app_open_count') ?? 0;
      await prefs.setInt('app_open_count', currentCount + 1);
    },
  );
}
