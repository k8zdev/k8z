import 'package:flutter/material.dart';
import 'package:k8zdev/models/guide_step_definition.dart';

/// Global keys for onboarding guide target elements
///
/// Use these keys to attach to widgets that should be highlighted
/// during the onboarding guide. The keys are organized by the
/// guide step they belong to.
class GuideKeys {
  GuideKeys._();

  // Demo Cluster Guide GlobalKeys

  // Welcome step - highlights cluster home intro
  static final GlobalKey welcomeTargetKey = GlobalKey();

  // Pod List step - highlights pod list container
  static final GlobalKey podListTargetKey = GlobalKey();

  // Pod Logs step - highlights logs button or logs container
  static final GlobalKey podLogsTargetKey = GlobalKey();

  // Additional Features step - highlights workloads menu or features button
  static final GlobalKey additionalFeaturesTargetKey = GlobalKey();
}

/// Helper class to expose guide keys by their target key string identifiers
///
/// This allows the InteractiveGuideOverlay to find the correct
/// GlobalKey for each guide step by using the targetKey string.
class GuideKeyRegistry {
  GuideKeyRegistry._();

  /// Get GlobalKey by target key string identifier
  static GlobalKey? getKey(String targetKey) {
    switch (targetKey) {
      case DemoClusterGuide.welcomeTargetKey:
        return GuideKeys.welcomeTargetKey;
      case DemoClusterGuide.podListTargetKey:
        return GuideKeys.podListTargetKey;
      case DemoClusterGuide.podLogsTargetKey:
        return GuideKeys.podLogsTargetKey;
      case DemoClusterGuide.additionalFeaturesTargetKey:
        return GuideKeys.additionalFeaturesTargetKey;
      default:
        return null;
    }
  }

  /// Get all guide keys as a map for easy lookup
  static Map<String, GlobalKey> getAllKeys() {
    return {
      DemoClusterGuide.welcomeTargetKey: GuideKeys.welcomeTargetKey,
      DemoClusterGuide.podListTargetKey: GuideKeys.podListTargetKey,
      DemoClusterGuide.podLogsTargetKey: GuideKeys.podLogsTargetKey,
      DemoClusterGuide.additionalFeaturesTargetKey:
          GuideKeys.additionalFeaturesTargetKey,
    };
  }
}

/// Extension to easily wrap widgets with guide keys
extension GuideKeyWidgetExtension on Widget {
  /// Wrap this widget with a Key that matches a guide target
  Widget withGuideKey(String targetKey) {
    final key = GuideKeyRegistry.getKey(targetKey);
    if (key != null) {
      return KeyedSubtree(
        key: key,
        child: this,
      );
    }
    return this;
  }
}
