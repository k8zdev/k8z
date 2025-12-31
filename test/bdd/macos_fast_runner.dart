import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Import all step definitions
import 'steps/given_app_has_no_clusters.dart';
import 'steps/then_should_see_cluster_in_list.dart';
import 'steps/when_load_kubeconfig.dart';

Future<void> main() async {
  // Initialize Flutter test environment
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite_common_ffi for unit testing
  sqfliteFfiInit();
  // Use in-memory database for fast tests
  databaseFactory = databaseFactoryFfi;

  // Initialize the database
  await initStore();

  final config = TestConfiguration()
    ..features = [Glob(r"test/bdd/features/**.feature")]
    ..stepDefinitions = [
      givenAppHasNoClusters(),
      whenLoadKubeconfig(),
      thenShouldSeeClusterInList(),
    ]
    // Run all scenarios except those marked as ios-critical
    ..tagExpression = "not @ios-critical"
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
    ];

  return GherkinRunner().execute(config);
}
