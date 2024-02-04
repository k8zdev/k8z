import 'package:k8sapp/dao/dao.dart';

String clustersTable = "clusters";
String sqlCreateKubeClustersTable = '''
CREATE TABLE IF NOT EXISTS  "$clustersTable" ( 
  "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
  "name" TEXT NOT NULL,
  "server" TEXT NOT NULL,
  "certificate_authority" TEXT,
  "namespace" TEXT DEFAULT "default",
  "insecure" INTEGER NOT NULL DEFAULT 0,
  "client_key" TEXT NOT NULL,
  "client_certificate" TEXT NOT NULL,
  "createdAt" INTEGER NOT NULL DEFAULT 0,
  "deleted" INTEGER NOT NULL DEFAULT 0
)
''';

class K8zCluster {
  late int? id;
  String name;
  String server;
  String certificateAuthority;
  String namespace;
  bool insecure;
  String clientKey;
  String clientCertificate;
  int createdAt;
  bool? deleted;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'certificate_authority': certificateAuthority,
      'namespace': namespace,
      'insecure': insecure ? 1 : 0,
      'client_key': clientKey,
      'client_certificate': clientCertificate,
      'createdAt': createdAt,
    };
  }

  K8zCluster({
    this.id,
    this.deleted,
    required this.name,
    required this.server,
    required this.certificateAuthority,
    required this.namespace,
    required this.insecure,
    required this.clientKey,
    required this.clientCertificate,
    required this.createdAt,
  });

  static Future<K8zCluster> insert(K8zCluster config) async {
    try {
      config.id = await database.insert(clustersTable, config.toMap());
      return config;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Object?>> batchInsert(List<K8zCluster> clusters) async {
    try {
      var batch = database.batch();
      for (var cluster in clusters) {
        await database.insert(clustersTable, cluster.toMap());
      }
      return await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> update(K8zCluster config) async {
    return await database.update(clustersTable, config.toMap(),
        where: 'id = ?', whereArgs: [config.id]);
  }

  static Future<int> delete(K8zCluster config) async {
    return await database
        .delete(clustersTable, where: 'id = ?', whereArgs: [config.id]);
  }

  static Future<List<K8zCluster>> list() async {
    final List<Map<String, dynamic>> maps =
        await database.query(clustersTable, where: 'deleted = 0');
    return List.generate(maps.length, (i) {
      return K8zCluster(
        name: maps[i]['name'],
        server: maps[i]['server'],
        certificateAuthority: maps[i]['certificate_authority'],
        namespace: maps[i]['namespace'],
        insecure: maps[i]['insecure'] == 1,
        clientKey: maps[i]['client_key'],
        clientCertificate: maps[i]['client_certificate'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }
}
