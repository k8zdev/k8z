import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

late Vault vault;
late Store store;

Future<void> initStash() async {
  var databasesPath = await getDatabasesPath();
  var file = File(join(databasesPath, 'vault.db'));
  final store = await newSqliteLocalVaultStore(file: file);
  vault = await store.vault(name: "k8z.config");
}

vset(String key, dynamic value) {
  Future.delayed(Duration.zero, () async {
    await vault.put(key, value);
  });
}

vget<T>(String key) async {
  T? value = await vault.get(key);
  return value;
}
