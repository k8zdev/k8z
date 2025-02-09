//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAppsV1StatefulSetCondition {
  /// Returns a new [IoK8sApiAppsV1StatefulSetCondition] instance.
  IoK8sApiAppsV1StatefulSetCondition({
    this.lastTransitionTime,
    this.message,
    this.reason,
    required this.status,
    required this.type,
  });

  /// Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastTransitionTime;

  /// A human readable message indicating details about the transition.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  /// The reason for the condition's last transition.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  /// Status of the condition, one of True, False, Unknown.
  String status;

  /// Type of statefulset condition.
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAppsV1StatefulSetCondition &&
    other.lastTransitionTime == lastTransitionTime &&
    other.message == message &&
    other.reason == reason &&
    other.status == status &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (lastTransitionTime == null ? 0 : lastTransitionTime!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (status.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'IoK8sApiAppsV1StatefulSetCondition[lastTransitionTime=$lastTransitionTime, message=$message, reason=$reason, status=$status, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.lastTransitionTime != null) {
      json[r'lastTransitionTime'] = this.lastTransitionTime!.toUtc().toIso8601String();
    } else {
      json[r'lastTransitionTime'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'status'] = this.status;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [IoK8sApiAppsV1StatefulSetCondition] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAppsV1StatefulSetCondition? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAppsV1StatefulSetCondition[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAppsV1StatefulSetCondition[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAppsV1StatefulSetCondition(
        lastTransitionTime: mapDateTime(json, r'lastTransitionTime', r''),
        message: mapValueOfType<String>(json, r'message'),
        reason: mapValueOfType<String>(json, r'reason'),
        status: mapValueOfType<String>(json, r'status')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<IoK8sApiAppsV1StatefulSetCondition> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAppsV1StatefulSetCondition>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAppsV1StatefulSetCondition.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAppsV1StatefulSetCondition> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAppsV1StatefulSetCondition>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAppsV1StatefulSetCondition.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAppsV1StatefulSetCondition-objects as value to a dart map
  static Map<String, List<IoK8sApiAppsV1StatefulSetCondition>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAppsV1StatefulSetCondition>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAppsV1StatefulSetCondition.listFromJson(entry.value, growable: growable,);
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

