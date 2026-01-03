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

  // Nodes step - highlights nodes list
  static final GlobalKey nodesTargetKey = GlobalKey();

  // Workloads step - highlights workloads list section
  static final GlobalKey workloadsTargetKey = GlobalKey();

  // Pod Detail step - highlights pod detail tabs/actions
  static final GlobalKey podDetailTargetKey = GlobalKey();

  // Resources step - highlights resources menu
  static final GlobalKey resourcesTargetKey = GlobalKey();

  // Node Detail step - highlights node detail sections
  static final GlobalKey nodeDetailTargetKey = GlobalKey();

  // Completed step - highlights completion message area
  static final GlobalKey completedTargetKey = GlobalKey();
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
      case DemoClusterGuide.nodesTargetKey:
        return GuideKeys.nodesTargetKey;
      case DemoClusterGuide.completedTargetKey:
        return GuideKeys.completedTargetKey;
      case DemoClusterGuide.workloadsTargetKey:
        return GuideKeys.workloadsTargetKey;
      case DemoClusterGuide.podDetailTargetKey:
        return GuideKeys.podDetailTargetKey;
      case DemoClusterGuide.resourcesTargetKey:
        return GuideKeys.resourcesTargetKey;
      case DemoClusterGuide.nodeDetailTargetKey:
        return GuideKeys.nodeDetailTargetKey;
      default:
        return null;
    }
  }

  /// Get all guide keys as a map for easy lookup
  static Map<String, GlobalKey> getAllKeys() {
    return {
      DemoClusterGuide.welcomeTargetKey: GuideKeys.welcomeTargetKey,
      DemoClusterGuide.podListTargetKey: GuideKeys.podListTargetKey,
      DemoClusterGuide.nodesTargetKey: GuideKeys.nodesTargetKey,
      DemoClusterGuide.completedTargetKey: GuideKeys.completedTargetKey,
      DemoClusterGuide.workloadsTargetKey: GuideKeys.workloadsTargetKey,
      DemoClusterGuide.podDetailTargetKey: GuideKeys.podDetailTargetKey,
      DemoClusterGuide.resourcesTargetKey: GuideKeys.resourcesTargetKey,
      DemoClusterGuide.nodeDetailTargetKey: GuideKeys.nodeDetailTargetKey,
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
