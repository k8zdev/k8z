//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1Toleration {
  /// Returns a new [IoK8sApiCoreV1Toleration] instance.
  IoK8sApiCoreV1Toleration({
    this.effect,
    this.key,
    this.operator_,
    this.tolerationSeconds,
    this.value,
  });

  /// Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.  
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? effect;

  /// Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  /// Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category.  
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? operator_;

  /// TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? tolerationSeconds;

  /// Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1Toleration &&
    other.effect == effect &&
    other.key == key &&
    other.operator_ == operator_ &&
    other.tolerationSeconds == tolerationSeconds &&
    other.value == value;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (effect == null ? 0 : effect!.hashCode) +
    (key == null ? 0 : key!.hashCode) +
    (operator_ == null ? 0 : operator_!.hashCode) +
    (tolerationSeconds == null ? 0 : tolerationSeconds!.hashCode) +
    (value == null ? 0 : value!.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1Toleration[effect=$effect, key=$key, operator_=$operator_, tolerationSeconds=$tolerationSeconds, value=$value]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.effect != null) {
      json[r'effect'] = this.effect;
    } else {
      json[r'effect'] = null;
    }
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.operator_ != null) {
      json[r'operator'] = this.operator_;
    } else {
      json[r'operator'] = null;
    }
    if (this.tolerationSeconds != null) {
      json[r'tolerationSeconds'] = this.tolerationSeconds;
    } else {
      json[r'tolerationSeconds'] = null;
    }
    if (this.value != null) {
      json[r'value'] = this.value;
    } else {
      json[r'value'] = null;
    }
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1Toleration] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1Toleration? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1Toleration[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1Toleration[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1Toleration(
        effect: mapValueOfType<String>(json, r'effect'),
        key: mapValueOfType<String>(json, r'key'),
        operator_: mapValueOfType<String>(json, r'operator'),
        tolerationSeconds: mapValueOfType<int>(json, r'tolerationSeconds'),
        value: mapValueOfType<String>(json, r'value'),
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1Toleration> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1Toleration>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1Toleration.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1Toleration> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1Toleration>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1Toleration.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1Toleration-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1Toleration>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1Toleration>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1Toleration.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

