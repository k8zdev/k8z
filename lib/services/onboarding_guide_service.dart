import 'package:flutter/material.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/common/ops.dart';

/// Guide steps for onboarding
enum GuideStep {
  welcome,
  podList,
  podLogs,
  additionalFeatures,
  completed,
}

/// Onboarding state management
class OnboardingState {
  final bool isActive;
  final GuideStep currentStep;
  final K8zCluster? demoCluster;
  final DateTime? startTime;
  final Map<String, dynamic> analytics;

  const OnboardingState({
    this.isActive = false,
    this.currentStep = GuideStep.welcome,
    this.demoCluster,
    this.startTime,
    this.analytics = const {},
  });

  OnboardingState copyWith({
    bool? isActive,
    GuideStep? currentStep,
    K8zCluster? demoCluster,
    DateTime? startTime,
    Map<String, dynamic>? analytics,
  }) {
    return OnboardingState(
      isActive: isActive ?? this.isActive,
      currentStep: currentStep ?? this.currentStep,
      demoCluster: demoCluster ?? this.demoCluster,
      startTime: startTime ?? this.startTime,
      analytics: analytics ?? this.analytics,
    );
  }
}

/// Onboarding guide service
class OnboardingGuideService extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();
  
  OnboardingState get state => _state;
  bool get isGuideActive => _state.isActive;
  GuideStep get currentStep => _state.currentStep;

  /// Start the onboarding guide
  Future<void> startGuide(K8zCluster cluster) async {
    talker.info('Starting onboarding guide for cluster: ${cluster.name}');
    
    _state = _state.copyWith(
      isActive: true,
      currentStep: GuideStep.welcome,
      demoCluster: cluster,
      startTime: DateTime.now(),
      analytics: {
        'guide_start_time': DateTime.now().millisecondsSinceEpoch,
        'cluster_name': cluster.name,
      },
    );
    
    // Log guide start event
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_start',
      parameters: {
        'cluster_name': cluster.name,
        'cluster_is_demo': cluster.isDemo ? 'true' : 'false',
        'timestamp': _state.startTime!.millisecondsSinceEpoch,
      },
    );
    
    notifyListeners();
  }

  /// Show pod list guide
  Future<void> showPodListGuide() async {
    if (!_state.isActive || _state.currentStep != GuideStep.welcome) return;
    
    talker.info('Showing pod list guide');
    
    _state = _state.copyWith(currentStep: GuideStep.podList);
    
    // Log step completion
    _logStepComplete(GuideStep.welcome);
    
    notifyListeners();
  }

  /// Show log view guide
  Future<void> showLogViewGuide() async {
    if (!_state.isActive || _state.currentStep != GuideStep.podList) return;
    
    talker.info('Showing log view guide');
    
    _state = _state.copyWith(currentStep: GuideStep.podLogs);
    
    // Log step completion
    _logStepComplete(GuideStep.podList);
    
    notifyListeners();
  }

  /// Show additional features guide
  Future<void> showAdditionalFeaturesGuide() async {
    if (!_state.isActive || _state.currentStep != GuideStep.podLogs) return;
    
    talker.info('Showing additional features guide');
    
    _state = _state.copyWith(currentStep: GuideStep.additionalFeatures);
    
    // Log step completion
    _logStepComplete(GuideStep.podLogs);
    
    notifyListeners();
  }

  /// Complete the guide
  Future<void> completeGuide() async {
    if (!_state.isActive) return;
    
    talker.info('Completing onboarding guide');
    
    final totalTime = _state.startTime != null 
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;
    
    // Log guide completion
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_complete',
      parameters: {
        'total_time_ms': totalTime.inMilliseconds,
        'achieved_30s_goal': totalTime.inSeconds <= 30 ? 'true' : 'false',
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
        'completed_steps': _state.currentStep.index + 1,
      },
    );
    
    _state = _state.copyWith(
      isActive: false,
      currentStep: GuideStep.completed,
    );
    
    notifyListeners();
  }

  /// Skip the guide
  Future<void> skipGuide() async {
    if (!_state.isActive) return;
    
    talker.info('Skipping onboarding guide');
    
    final totalTime = _state.startTime != null 
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;
    
    // Log guide skip
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_skip',
      parameters: {
        'total_time_ms': totalTime.inMilliseconds,
        'skipped_at_step': _state.currentStep.name,
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
      },
    );
    
    _state = const OnboardingState();
    notifyListeners();
  }

  /// Move to next step
  Future<void> nextStep() async {
    switch (_state.currentStep) {
      case GuideStep.welcome:
        await showPodListGuide();
        break;
      case GuideStep.podList:
        await showLogViewGuide();
        break;
      case GuideStep.podLogs:
        await showAdditionalFeaturesGuide();
        break;
      case GuideStep.additionalFeatures:
        await completeGuide();
        break;
      case GuideStep.completed:
        // Already completed
        break;
    }
  }

  /// Log step completion
  void _logStepComplete(GuideStep step) {
    final elapsed = _state.startTime != null 
        ? DateTime.now().difference(_state.startTime!)
        : Duration.zero;
    
    AnalyticsService.logEvent(
      eventName: 'onboarding_guide_step_complete',
      parameters: {
        'step': step.name,
        'elapsed_ms': elapsed.inMilliseconds,
        'cluster_name': _state.demoCluster?.name ?? 'unknown',
      },
    );
  }

  /// Reset the guide state
  void reset() {
    _state = const OnboardingState();
    notifyListeners();
  }
}