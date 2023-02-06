#!/bin/bash

set -x

K8SMODELPATH=${1:-lib/models/kubernetes}

echo "model path: ${K8SMODELPATH}\n"

rm -fr ${K8SMODELPATH}/io_*.dart && cp tmp/lib/model/io_* ${K8SMODELPATH}
find ${K8SMODELPATH} -type f -name 'io_*' -exec sed -i '' 's/openapi\.api/models\.k8s/g' {} +
find "$K8SMODELPATH" -type f -name 'io_*.dart' -exec sh -c 'echo "part '\''kubernetes/$(echo "{}" | sed -e "s|^'$K8SMODELPATH'/||")'\'';"' \; >>lib/models/models.dart
sed -i '' 's/enum_\:.*/enum_\: const \[\],/' $K8SMODELPATH/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_json_schema_props.dart
sed -i '' 's/Map<String, List<String>> extra;/Map<String, List<dynamic>>? extra;/g' $K8SMODELPATH/io_*auth*.dart
sed -i '' 's/Map<String, List<String>> extra;/Map<String, List<dynamic>>? extra;/g' $K8SMODELPATH/io_*cert*.dart
sed -i '' 's/DateTime.mapFromJson.*/mapValueOfType<Map<String, DateTime>>(json, r'\''disruptedPods'\'') ?? const {}\,/g' ${K8SMODELPATH}/io_k8s_api_policy_v1_pod_disruption_budget_status.dart
