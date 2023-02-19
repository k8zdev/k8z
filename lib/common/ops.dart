import 'package:talker_flutter/talker_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsTalkerObserver extends TalkerObserver {
  CrashlyticsTalkerObserver();

  @override
  void onError(err) {
    FirebaseCrashlytics.instance.recordError(
      err.error,
      err.stackTrace,
      reason: err.message,
    );
  }

  @override
  void onException(err) {
    FirebaseCrashlytics.instance.recordError(
      err.exception,
      err.stackTrace,
      reason: err.message,
    );
  }
}

final crashlyticsTalkerObserver = CrashlyticsTalkerObserver();
final logger = TalkerLogger(
  settings: TalkerLoggerSettings(
    // Set current logging level
    level: LogLevel.debug,
  ),
);
final talker = TalkerFlutter.init(
  logger: logger,
  observer: crashlyticsTalkerObserver,
);
