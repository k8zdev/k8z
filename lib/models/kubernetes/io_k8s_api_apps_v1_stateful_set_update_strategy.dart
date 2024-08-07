//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAppsV1StatefulSetUpdateStrategy {
  /// Returns a new [IoK8sApiAppsV1StatefulSetUpdateStrategy] instance.
  IoK8sApiAppsV1StatefulSetUpdateStrategy({
    this.rollingUpdate,
    this.type,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IoK8sApiAppsV1RollingUpdateStatefulSetStrategy? rollingUpdate;

  /// Type indicates the type of the StatefulSetUpdateStrategy. Default is RollingUpdate.  
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAppsV1StatefulSetUpdateStrategy &&
    other.rollingUpdate == rollingUpdate &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (rollingUpdate == null ? 0 : rollingUpdate!.hashCode) +
    (type == null ? 0 : type!.hashCode);

  @override
  String toString() => 'IoK8sApiAppsV1StatefulSetUpdateStrategy[rollingUpdate=$rollingUpdate, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.rollingUpdate != null) {
      json[r'rollingUpdate'] = this.rollingUpdate;
    } else {
      json[r'rollingUpdate'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    return json;
  }

  /// Returns a new [IoK8sApiAppsV1StatefulSetUpdateStrategy] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAppsV1StatefulSetUpdateStrategy? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAppsV1StatefulSetUpdateStrategy[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAppsV1StatefulSetUpdateStrategy[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAppsV1StatefulSetUpdateStrategy(
        rollingUpdate: IoK8sApiAppsV1RollingUpdateStatefulSetStrategy.fromJson(json[r'rollingUpdate']),
        type: mapValueOfType<String>(json, r'type'),
      );
    }
    return null;
  }

  static List<IoK8sApiAppsV1StatefulSetUpdateStrategy> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAppsV1StatefulSetUpdateStrategy>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAppsV1StatefulSetUpdateStrategy.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAppsV1StatefulSetUpdateStrategy> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAppsV1StatefulSetUpdateStrategy>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAppsV1StatefulSetUpdateStrategy.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAppsV1StatefulSetUpdateStrategy-objects as value to a dart map
  static Map<String, List<IoK8sApiAppsV1StatefulSetUpdateStrategy>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAppsV1StatefulSetUpdateStrategy>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAppsV1StatefulSetUpdateStrategy.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

