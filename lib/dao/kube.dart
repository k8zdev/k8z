import 'package:k8zdev/dao/dao.dart';

String clustersTable = "clusters";
String sqlCreateKubeClustersTable = '''
CREATE TABLE IF NOT EXISTS  "$clustersTable" ( 
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "server" TEXT NOT NULL,
  "ca" TEXT TEXT NOT NULL,
  "namespace" TEXT DEFAULT "default",
  "insecure" INTEGER NOT NULL DEFAULT 0,
  "client_key" TEXT NOT NULL DEFAULT "",
  "client_cert" TEXT NOT NULL DEFAULT "",
  "username" TEXT NOT NULL  DEFAULT "",
  "password" TEXT NOT NULL DEFAULT "",
  "token" TEXT NOT NULL DEFAULT "",
  "created_at" INTEGER NOT NULL DEFAULT 0,
  "deleted" INTEGER NOT NULL DEFAULT 0,
  "is_demo" INTEGER NOT NULL DEFAULT 0,
  "is_readonly" INTEGER NOT NULL DEFAULT 0
)
''';

class K8zCluster {
  late int? id;
  String name;
  String server;
  String caData;
  String namespace;
  bool insecure;
  String clientKey;
  String clientCert;
  String username;
  String password;
  String token;
  int createdAt;
  bool? deleted;
  bool isDemo;
  bool isReadOnly;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'ca': caData,
      'namespace': namespace,
      'insecure': insecure ? 1 : 0,
      'client_key': clientKey,
      'client_cert': clientCert,
      'username': username,
      'password': password,
      'token': token,
      'created_at': createdAt,
      'is_demo': isDemo ? 1 : 0,
      'is_readonly': isReadOnly ? 1 : 0,
    };
  }

  K8zCluster.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        server = json["server"],
        caData = json["ca"],
        namespace = json["namespace"],
        insecure = json["insecure"] == 1,
        clientKey = json["client_key"],
        clientCert = json["client_cert"],
        password = json["password"],
        username = json["username"],
        token = json["token"],
        createdAt = json["created_at"],
        isDemo = json["is_demo"] == 1 || (json["name"] as String?)?.contains("Demo") == true,
        isReadOnly = json["is_readonly"] == 1 || json["name"] == "Demo Cluster (Read-only)";

  K8zCluster({
    this.id,
    this.deleted,
    required this.name,
    required this.server,
    required this.caData,
    required this.namespace,
    required this.insecure,
    required this.clientKey,
    required this.clientCert,
    required this.username,
    required this.password,
    required this.token,
    required this.createdAt,
    this.isDemo = false,
    this.isReadOnly = false,
  });

  static Future<K8zCluster> insert(K8zCluster config) async {
    try {
      config.id = await database.insert(clustersTable, config.toJson());
      return config;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Object?>> batchInsert(List<K8zCluster> clusters) async {
    try {
      var batch = database.batch();
      for (var cluster in clusters) {
        await database.insert(clustersTable, cluster.toJson());
      }
      return await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> update(K8zCluster config) async {
    return await database.update(clustersTable, config.toJson(),
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
      final name = maps[i]['name'] as String?;
      return K8zCluster(
        id: maps[i]['id'],
        name: name ?? '',
        server: maps[i]['server'],
        caData: maps[i]['ca'],
        namespace: maps[i]['namespace'],
        insecure: maps[i]['insecure'] == 1,
        clientKey: maps[i]['client_key'],
        clientCert: maps[i]['client_cert'],
        username: maps[i]['username'],
        password: maps[i]['password'],
        token: maps[i]['token'],
        createdAt: maps[i]['created_at'],
        isDemo: maps[i]['is_demo'] == 1 || (name?.contains("Demo") == true),
        isReadOnly: maps[i]['is_readonly'] == 1 || name == "Demo Cluster (Read-only)",
      );
    });
  }

  /// 创建演示集群的工厂方法
  factory K8zCluster.createDemo({
    required String name,
    required String server,
    required String caData,
    String namespace = 'default',
    String clientKey = '',
    String clientCert = '',
    String username = '',
    String password = '',
    String token = '',
  }) {
    return K8zCluster(
      name: name,
      server: server,
      caData: caData,
      namespace: namespace,
      insecure: false,
      clientKey: clientKey,
      clientCert: clientCert,
      username: username,
      password: password,
      token: token,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      isDemo: true,
      isReadOnly: true,
    );
  }
}
