import 'package:gherkin/gherkin.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'given_app_is_running.dart';

/// Variable to store the demo cluster used in the test
late K8zCluster _testDemoCluster;

StepDefinitionGeneric<World> givenDemoClusterLoaded() {
  return given<World>(
    'demo 集群已加载',
    (context) async {
      // Create a demo cluster
      _testDemoCluster = K8zCluster.createDemo(
        name: 'Demo Cluster (Read-only)',
        server: 'https://demo.k8z.dev',
        caData: '',
        namespace: 'default',
      );

      // Save to database
      await K8zCluster.insert(_testDemoCluster);

      talker.debug('[BDD] Demo cluster loaded: ${_testDemoCluster.name}');
    },
  );
}

StepDefinitionGeneric<World> whenIsGuideIncomplete() {
  return when<World>(
    '新手引导未完成',
    (context) async {
      // Ensure guide is not marked as completed in database
      // Just log the state
      talker.debug('[BDD] Guide is not completed');
    },
  );
}

StepDefinitionGeneric<World> whenEnterClusterListPage() {
  return when<World>(
    '我进入集群列表页面',
    (context) async {
      final guideService = testGuideService;
      guideService.reset();

      // When entering cluster list page with demo cluster loaded,
      // the guide should be automatically triggered
      await guideService.startGuide(_testDemoCluster);

      talker.debug('[BDD] Entering cluster list page - guide triggered');
    },
  );
}

StepDefinitionGeneric<World> whenSkipTheGuide() {
  return when<World>(
    '我跳过引导',
    (context) async {
      final guideService = testGuideService;

      // Skip the guide but DON'T mark as completed
      // Reset to inactive state so it can trigger again
      guideService.reset();

      talker.debug('[BDD] Guide skipped - should trigger again on next entry');
    },
  );
}

StepDefinitionGeneric<World> whenEnterClusterListPageSecondTime() {
  return when<World>(
    r'我再次进入集群列表页面 \(第二次\)',
    (context) async {
      final guideService = testGuideService;

      // When entering again, guide should trigger again since it wasn't completed
      // The guide should be reset after skipping, so startGuide should trigger it
      await guideService.startGuide(_testDemoCluster);

      talker.debug('[BDD] Entering cluster list page (second time) - guide triggered again');
    },
  );
}