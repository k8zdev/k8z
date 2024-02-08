//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAutoscalingV2ExternalMetricSource {
  /// Returns a new [IoK8sApiAutoscalingV2ExternalMetricSource] instance.
  IoK8sApiAutoscalingV2ExternalMetricSource({
    required this.metric,
    required this.target,
  });

  IoK8sApiAutoscalingV2MetricIdentifier metric;

  IoK8sApiAutoscalingV2MetricTarget target;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAutoscalingV2ExternalMetricSource &&
    other.metric == metric &&
    other.target == target;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (metric.hashCode) +
    (target.hashCode);

  @override
  String toString() => 'IoK8sApiAutoscalingV2ExternalMetricSource[metric=$metric, target=$target]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'metric'] = this.metric;
      json[r'target'] = this.target;
    return json;
  }

  /// Returns a new [IoK8sApiAutoscalingV2ExternalMetricSource] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAutoscalingV2ExternalMetricSource? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAutoscalingV2ExternalMetricSource[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAutoscalingV2ExternalMetricSource[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAutoscalingV2ExternalMetricSource(
        metric: IoK8sApiAutoscalingV2MetricIdentifier.fromJson(json[r'metric'])!,
        target: IoK8sApiAutoscalingV2MetricTarget.fromJson(json[r'target'])!,
      );
    }
    return null;
  }

  static List<IoK8sApiAutoscalingV2ExternalMetricSource> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAutoscalingV2ExternalMetricSource>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAutoscalingV2ExternalMetricSource.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAutoscalingV2ExternalMetricSource> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAutoscalingV2ExternalMetricSource>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAutoscalingV2ExternalMetricSource.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAutoscalingV2ExternalMetricSource-objects as value to a dart map
  static Map<String, List<IoK8sApiAutoscalingV2ExternalMetricSource>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAutoscalingV2ExternalMetricSource>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAutoscalingV2ExternalMetricSource.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'metric',
    'target',
  };
}
