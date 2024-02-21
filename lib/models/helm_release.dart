class Release {
  final String name;
  final String namespace;
  final String revision;
  final String updated;
  final String status;
  final String chart;
  final String appVersion;
  final String? description;

  Release({
    required this.name,
    required this.namespace,
    required this.revision,
    required this.updated,
    required this.status,
    required this.chart,
    required this.appVersion,
    this.description,
  });

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      name: json['name'],
      namespace: json['namespace'],
      revision: json['revision'],
      updated: json['updated'],
      status: json['status'],
      chart: json['chart'],
      appVersion: json['appVersion'],
      description: json['description'],
    );
  }
}
