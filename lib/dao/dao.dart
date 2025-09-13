import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database database;

Future<String> dbpath() async {
  var databasesPath = await getDatabasesPath();
  return join(databasesPath, 'k8z.db');
}

Future<void> initStore() async {
  database = await openDatabase(
    await dbpath(),
    onCreate: (db, version) async {
      talker.log("onCreate, version: $version");
      var batch = db.batch();
      batch.execute(sqlCreateKubeClustersTable);

      await batch.commit();
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      talker.log("onUpgrade, old=$oldVersion, new: $newVersion");
      if (oldVersion == 1 && newVersion == 2) {
        await up1to2(db);
      }
    },
    onDowngrade: (db, oldVersion, newVersion) {
      talker.log("onDowngrade, old=$oldVersion, new: $newVersion");
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );
}

Future<void> up1to2(Database db) async {
  talker.log("Upgrading database from version 1 to 2");
  
  var batch = db.batch();
  
  // Add is_demo column with default value 0 (false)
  batch.execute('ALTER TABLE "$clustersTable" ADD COLUMN "is_demo" INTEGER NOT NULL DEFAULT 0');
  
  // Add is_readonly column with default value 0 (false)
  batch.execute('ALTER TABLE "$clustersTable" ADD COLUMN "is_readonly" INTEGER NOT NULL DEFAULT 0');
  
  await batch.commit();
  
  talker.log("Database upgrade from version 1 to 2 completed");
}

Future<void> flushdb() async {
  var oldpath = await dbpath();
  try {
    await deleteDatabase(oldpath);
    await initStore();
  } on Exception {
    rethrow;
  }
}
