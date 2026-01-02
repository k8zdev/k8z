import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:sqflite/sqflite.dart';

/// Check if database is available
bool _isDatabaseAvailable() {
  try {
    // Access a property of database to check if it's initialized
    return database.isOpen;
  } catch (e) {
    return false;
  }
}

/// Table name for onboarding guide state
String onboardingGuideStateTable = "onboarding_guide_state";

/// SQL to create the onboarding guide state table
String sqlCreateOnboardingGuideStateTable = '''
CREATE TABLE IF NOT EXISTS "$onboardingGuideStateTable" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  guide_name TEXT UNIQUE NOT NULL,
  completed_at INTEGER,
  last_step TEXT,
  cluster_id TEXT
)
''';

/// Onboarding guide state data model
class OnboardingGuideState {
  final int? id;
  final String guideName;
  final int? completedAt;
  final String? lastStep;
  final String? clusterId;

  OnboardingGuideState({
    this.id,
    required this.guideName,
    this.completedAt,
    this.lastStep,
    this.clusterId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'guide_name': guideName,
      'completed_at': completedAt,
      'last_step': lastStep,
      'cluster_id': clusterId,
    };
  }

  factory OnboardingGuideState.fromJson(Map<String, dynamic> json) {
    return OnboardingGuideState(
      id: json['id'],
      guideName: json['guide_name'],
      completedAt: json['completed_at'],
      lastStep: json['last_step'],
      clusterId: json['cluster_id'],
    );
  }

  /// Factory to create completion state
  factory OnboardingGuideState.completed({
    required String guideName,
    String? clusterId,
    String? lastStep,
  }) {
    return OnboardingGuideState(
      guideName: guideName,
      completedAt: DateTime.now().millisecondsSinceEpoch,
      clusterId: clusterId,
      lastStep: lastStep,
    );
  }

  /// Factory to create a state without completion
  factory OnboardingGuideState.incomplete({
    required String guideName,
    String? clusterId,
    String? lastStep,
  }) {
    return OnboardingGuideState(
      guideName: guideName,
      completedAt: null,
      clusterId: clusterId,
      lastStep: lastStep,
    );
  }

  /// Check if the guide is completed
  bool get isCompleted => completedAt != null;

  /// Get the completion time as DateTime
  DateTime? get completedTime {
    if (completedAt == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(completedAt!);
  }
}

/// Data access object for onboarding guide state
class OnboardingGuideDao {
  /// Insert or update a guide state
  static Future<void> saveCompletion(OnboardingGuideState state) async {
    try {
      if (!_isDatabaseAvailable()) {
        talker.warning('Database not available, skipping guide state save');
        return;
      }
      await database.insert(
        onboardingGuideStateTable,
        state.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      talker.error('Failed to save onboarding guide state: $e');
      rethrow;
    }
  }

  /// Check if a guide is completed for the given guide name
  static Future<bool> isGuideCompleted(String guideName, {String? clusterId}) async {
    try {
      if (!_isDatabaseAvailable()) {
        return false;
      }
      final results = await database.query(
        onboardingGuideStateTable,
        where: 'guide_name = ?',
        whereArgs: [guideName],
      );

      if (results.isEmpty) {
        return false;
      }

      final state = OnboardingGuideState.fromJson(results.first);

      // If clusterId is provided, also check if it matches
      if (clusterId != null) {
        return state.clusterId == clusterId && state.isCompleted;
      }

      return state.isCompleted;
    } catch (e) {
      talker.error('Failed to check guide completion: $e');
      return false;
    }
  }

  /// Get the current state for a guide
  static Future<OnboardingGuideState?> getGuideState(String guideName) async {
    try {
      if (!_isDatabaseAvailable()) {
        return null;
      }
      final results = await database.query(
        onboardingGuideStateTable,
        where: 'guide_name = ?',
        whereArgs: [guideName],
      );

      if (results.isEmpty) {
        return null;
      }

      return OnboardingGuideState.fromJson(results.first);
    } catch (e) {
      talker.error('Failed to get guide state: $e');
      return null;
    }
  }

  /// Reset (delete) guide completion status
  static Future<void> resetGuide(String guideName) async {
    try {
      if (!_isDatabaseAvailable()) {
        return;
      }
      await database.delete(
        onboardingGuideStateTable,
        where: 'guide_name = ?',
        whereArgs: [guideName],
      );
    } catch (e) {
      talker.error('Failed to reset guide: $e');
      rethrow;
    }
  }

  /// Delete all guide states (for testing/factory reset)
  static Future<void> deleteAll() async {
    try {
      if (!_isDatabaseAvailable()) {
        return;
      }
      await database.delete(onboardingGuideStateTable);
    } catch (e) {
      talker.error('Failed to delete all guide states: $e');
      rethrow;
    }
  }

  /// List all guide states
  static Future<List<OnboardingGuideState>> listAll() async {
    try {
      if (!_isDatabaseAvailable()) {
        return [];
      }
      final List<Map<String, dynamic>> maps =
          await database.query(onboardingGuideStateTable);
      return List.generate(maps.length, (i) {
        return OnboardingGuideState.fromJson(maps[i]);
      });
    } catch (e) {
      talker.error('Failed to list guide states: $e');
      return [];
    }
  }

  /// Update last step for a guide
  static Future<void> updateLastStep(
    String guideName,
    String lastStep, {
    String? clusterId,
  }) async {
    try {
      if (!_isDatabaseAvailable()) {
        return;
      }
      final existingState = await getGuideState(guideName);

      if (existingState != null) {
        await database.update(
          onboardingGuideStateTable,
          {'last_step': lastStep, if (clusterId != null) 'cluster_id': clusterId},
          where: 'guide_name = ?',
          whereArgs: [guideName],
        );
      } else {
        // Create new state with last step but not completed
        await saveCompletion(
          OnboardingGuideState.incomplete(
            guideName: guideName,
            clusterId: clusterId,
            lastStep: lastStep,
          ),
        );
      }
    } catch (e) {
      talker.error('Failed to update last step: $e');
      rethrow;
    }
  }
}
