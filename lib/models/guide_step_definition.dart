/// Guide step definition model for interactive onboarding guides.
///
/// Each step in an onboarding guide is defined by this model, which includes
/// routing information, target widget keys for highlighting, and content.
///
/// Example:
/// ```dart
/// const step = GuideStepDefinition(
///   id: 'podList',
///   routeName: 'pods',
///   targetKey: 'guide-target-pod-list',
///   title: 'View Pods',
///   description: 'Here you can see all pods in your cluster.',
/// );
/// ```
class GuideStepDefinition {
  /// Unique identifier for this step
  final String id;

  /// GoRouter route name to navigate to when this step is shown
  final String routeName;

  /// Additional route parameters for navigation
  final Map<String, dynamic> routeParams;

  /// GlobalKey of the target widget to highlight with spotlight effect
  /// Uses ValueKey or similar, stored as string identifier
  final String? targetKey;

  /// Title displayed on the guide card
  final String title;

  /// Description/content displayed on the guide card
  final String description;

  /// Label for the next button (defaults to "Next" if null)
  final String? buttonNext;

  /// Label for the skip button (defaults to "Skip" if null)
  final String? buttonSkip;

  /// Label for the previous button (defaults to "Previous" if null)
  final String? buttonPrevious;

  const GuideStepDefinition({
    required this.id,
    required this.routeName,
    this.routeParams = const {},
    this.targetKey,
    required this.title,
    required this.description,
    this.buttonNext,
    this.buttonSkip,
    this.buttonPrevious,
  });

  /// Creates a copy of this step with modified fields
  GuideStepDefinition copyWith({
    String? id,
    String? routeName,
    Map<String, dynamic>? routeParams,
    String? targetKey,
    String? title,
    String? description,
    String? buttonNext,
    String? buttonSkip,
    String? buttonPrevious,
  }) {
    return GuideStepDefinition(
      id: id ?? this.id,
      routeName: routeName ?? this.routeName,
      routeParams: routeParams ?? this.routeParams,
      targetKey: targetKey ?? this.targetKey,
      title: title ?? this.title,
      description: description ?? this.description,
      buttonNext: buttonNext ?? this.buttonNext,
      buttonSkip: buttonSkip ?? this.buttonSkip,
      buttonPrevious: buttonPrevious ?? this.buttonPrevious,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideStepDefinition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GuideStepDefinition{id: $id, routeName: $routeName, '
        'title: $title, targetKey: $targetKey}';
  }

  /// Convert to JSON for storage or serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeName': routeName,
      'routeParams': routeParams,
      'targetKey': targetKey,
      'title': title,
      'description': description,
      'buttonNext': buttonNext,
      'buttonSkip': buttonSkip,
      'buttonPrevious': buttonPrevious,
    };
  }

  /// Create from JSON
  factory GuideStepDefinition.fromJson(Map<String, dynamic> json) {
    return GuideStepDefinition(
      id: json['id'] as String,
      routeName: json['routeName'] as String,
      routeParams:
          (json['routeParams'] as Map<String, dynamic>?) ?? const {},
      targetKey: json['targetKey'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      buttonNext: json['buttonNext'] as String?,
      buttonSkip: json['buttonSkip'] as String?,
      buttonPrevious: json['buttonPrevious'] as String?,
    );
  }
}

/// Demo cluster onboarding guide steps
///
/// This class defines the complete onboarding flow for the demo cluster,
/// including all steps, routes, and target element keys for highlighting.
class DemoClusterGuide {
  // Guide name used for persistence
  static const String guideName = 'demo_cluster_onboarding';

  // Step IDs for easy reference
  static const String welcomeStepId = 'welcome';
  static const String podListStepId = 'podList';
  static const String nodesStepId = 'nodes';
  static const String completedStepId = 'completed';

  // Target element key identifiers
  static const String welcomeTargetKey = 'guide-target-welcome';
  static const String podListTargetKey = 'guide-target-pod-list';
  static const String nodesTargetKey = 'guide-target-nodes';
  static const String completedTargetKey = 'guide-target-completed';

  /// Get all guide steps for demo cluster onboarding
  static List<GuideStepDefinition> getSteps() {
    return const [
      GuideStepDefinition(
        id: welcomeStepId,
        routeName: 'cluster_home',
        title: 'Welcome to K8zDev!',
        description: 'Let\'s quickly explore the main features. '
            'This is a demo cluster where you can safely explore.',
        buttonNext: 'Let\'s Start',
        buttonSkip: 'Skip Guide',
      ),
      GuideStepDefinition(
        id: podListStepId,
        routeName: 'pods',
        targetKey: podListTargetKey,
        title: 'View Pods',
        description: 'Here you can see all pods in your cluster. '
            'Pod is the smallest deployable unit in Kubernetes. '
            'Click any pod to view details, logs, and even open a terminal.',
        buttonNext: 'Next',
        buttonPrevious: 'Back',
      ),
      GuideStepDefinition(
        id: nodesStepId,
        routeName: 'nodes',
        targetKey: nodesTargetKey,
        title: 'View Nodes',
        description: 'Here you can see all nodes in your cluster. '
            'Nodes are the worker machines where your workloads run. '
            'Monitor node status and resource usage.',
        buttonNext: 'Complete',
        buttonPrevious: 'Back',
      ),
    ];
  }

  /// Get step by ID
  static GuideStepDefinition? getStepById(String id) {
    final steps = getSteps();
    for (final step in steps) {
      if (step.id == id) {
        return step;
      }
    }
    return null;
  }

  /// Get next step ID
  static String? getNextStepId(String currentId) {
    final steps = getSteps();
    for (int i = 0; i < steps.length - 1; i++) {
      if (steps[i].id == currentId) {
        return steps[i + 1].id;
      }
    }
    return null;
  }

  /// Get previous step ID
  static String? getPreviousStepId(String currentId) {
    final steps = getSteps();
    for (int i = 1; i < steps.length; i++) {
      if (steps[i].id == currentId) {
        return steps[i - 1].id;
      }
    }
    return null;
  }

  /// Get step index by ID
  static int getStepIndex(String id) {
    final steps = getSteps();
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  /// Check if step is the first step
  static bool isFirstStep(String id) {
    return getStepIndex(id) == 0;
  }

  /// Check if step is the last step
  static bool isLastStep(String id) {
    final steps = getSteps();
    return getStepIndex(id) == steps.length - 1;
  }
}
