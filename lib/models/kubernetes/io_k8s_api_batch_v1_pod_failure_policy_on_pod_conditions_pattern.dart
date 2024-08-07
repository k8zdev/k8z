//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern {
  /// Returns a new [IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern] instance.
  IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern({
    required this.status,
    required this.type,
  });

  /// Specifies the required Pod condition status. To match a pod condition it is required that the specified status equals the pod condition status. Defaults to True.
  String status;

  /// Specifies the required Pod condition type. To match a pod condition it is required that specified type equals the pod condition type.
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern &&
    other.status == status &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern[status=$status, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'status'] = this.status;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern(
        status: mapValueOfType<String>(json, r'status')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern-objects as value to a dart map
  static Map<String, List<IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiBatchV1PodFailurePolicyOnPodConditionsPattern.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
    'type',
  };
}

