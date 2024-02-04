import 'package:k8sapp/common/ops.dart';
import 'package:k8sapp/dao/kube.dart';
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
    onUpgrade: (db, oldVersion, newVersion) {
      talker.log("onUpgrade, old=$oldVersion, new: $newVersion");
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
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
