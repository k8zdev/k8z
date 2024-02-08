//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiPolicyV1PodDisruptionBudgetSpec {
  /// Returns a new [IoK8sApiPolicyV1PodDisruptionBudgetSpec] instance.
  IoK8sApiPolicyV1PodDisruptionBudgetSpec({
    this.maxUnavailable,
    this.minAvailable,
    this.selector,
  });

  /// IntOrString is a type that can hold an int32 or a string.  When used in JSON or YAML marshalling and unmarshalling, it produces or consumes the inner type.  This allows you to have, for example, a JSON field that can accept a name or number.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? maxUnavailable;

  /// IntOrString is a type that can hold an int32 or a string.  When used in JSON or YAML marshalling and unmarshalling, it produces or consumes the inner type.  This allows you to have, for example, a JSON field that can accept a name or number.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? minAvailable;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IoK8sApimachineryPkgApisMetaV1LabelSelector? selector;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiPolicyV1PodDisruptionBudgetSpec &&
    other.maxUnavailable == maxUnavailable &&
    other.minAvailable == minAvailable &&
    other.selector == selector;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (maxUnavailable == null ? 0 : maxUnavailable!.hashCode) +
    (minAvailable == null ? 0 : minAvailable!.hashCode) +
    (selector == null ? 0 : selector!.hashCode);

  @override
  String toString() => 'IoK8sApiPolicyV1PodDisruptionBudgetSpec[maxUnavailable=$maxUnavailable, minAvailable=$minAvailable, selector=$selector]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.maxUnavailable != null) {
      json[r'maxUnavailable'] = this.maxUnavailable;
    } else {
      json[r'maxUnavailable'] = null;
    }
    if (this.minAvailable != null) {
      json[r'minAvailable'] = this.minAvailable;
    } else {
      json[r'minAvailable'] = null;
    }
    if (this.selector != null) {
      json[r'selector'] = this.selector;
    } else {
      json[r'selector'] = null;
    }
    return json;
  }

  /// Returns a new [IoK8sApiPolicyV1PodDisruptionBudgetSpec] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiPolicyV1PodDisruptionBudgetSpec? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiPolicyV1PodDisruptionBudgetSpec[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiPolicyV1PodDisruptionBudgetSpec[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiPolicyV1PodDisruptionBudgetSpec(
        maxUnavailable: mapValueOfType<String>(json, r'maxUnavailable'),
        minAvailable: mapValueOfType<String>(json, r'minAvailable'),
        selector: IoK8sApimachineryPkgApisMetaV1LabelSelector.fromJson(json[r'selector']),
      );
    }
    return null;
  }

  static List<IoK8sApiPolicyV1PodDisruptionBudgetSpec> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiPolicyV1PodDisruptionBudgetSpec>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiPolicyV1PodDisruptionBudgetSpec.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiPolicyV1PodDisruptionBudgetSpec> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiPolicyV1PodDisruptionBudgetSpec>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiPolicyV1PodDisruptionBudgetSpec.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiPolicyV1PodDisruptionBudgetSpec-objects as value to a dart map
  static Map<String, List<IoK8sApiPolicyV1PodDisruptionBudgetSpec>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiPolicyV1PodDisruptionBudgetSpec>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiPolicyV1PodDisruptionBudgetSpec.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}
