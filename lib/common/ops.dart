import 'package:talker_flutter/talker_flutter.dart';

final logger = TalkerLogger(
  settings: TalkerLoggerSettings(
    // Set current logging level
    level: LogLevel.debug,
  ),
);
final talker = TalkerFlutter.init(
  logger: logger,
);
