//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1NodeSelectorRequirement {
  /// Returns a new [IoK8sApiCoreV1NodeSelectorRequirement] instance.
  IoK8sApiCoreV1NodeSelectorRequirement({
    required this.key,
    required this.operator_,
    this.values = const [],
  });

  /// The label key that the selector applies to.
  String key;

  /// Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.  
  String operator_;

  /// An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
  List<String> values;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1NodeSelectorRequirement &&
    other.key == key &&
    other.operator_ == operator_ &&
    _deepEquality.equals(other.values, values);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (operator_.hashCode) +
    (values.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1NodeSelectorRequirement[key=$key, operator_=$operator_, values=$values]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'operator'] = this.operator_;
      json[r'values'] = this.values;
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1NodeSelectorRequirement] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1NodeSelectorRequirement? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1NodeSelectorRequirement[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1NodeSelectorRequirement[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1NodeSelectorRequirement(
        key: mapValueOfType<String>(json, r'key')!,
        operator_: mapValueOfType<String>(json, r'operator')!,
        values: json[r'values'] is Iterable
            ? (json[r'values'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1NodeSelectorRequirement> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1NodeSelectorRequirement>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1NodeSelectorRequirement.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1NodeSelectorRequirement> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1NodeSelectorRequirement>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1NodeSelectorRequirement.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1NodeSelectorRequirement-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1NodeSelectorRequirement>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1NodeSelectorRequirement>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1NodeSelectorRequirement.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'operator',
  };
}

