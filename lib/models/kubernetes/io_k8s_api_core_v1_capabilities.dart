//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1Capabilities {
  /// Returns a new [IoK8sApiCoreV1Capabilities] instance.
  IoK8sApiCoreV1Capabilities({
    this.add = const [],
    this.drop = const [],
  });

  /// Added capabilities
  List<String> add;

  /// Removed capabilities
  List<String> drop;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1Capabilities &&
    _deepEquality.equals(other.add, add) &&
    _deepEquality.equals(other.drop, drop);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (add.hashCode) +
    (drop.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1Capabilities[add=$add, drop=$drop]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'add'] = this.add;
      json[r'drop'] = this.drop;
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1Capabilities] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1Capabilities? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1Capabilities[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1Capabilities[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1Capabilities(
        add: json[r'add'] is Iterable
            ? (json[r'add'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        drop: json[r'drop'] is Iterable
            ? (json[r'drop'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1Capabilities> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1Capabilities>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1Capabilities.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1Capabilities> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1Capabilities>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1Capabilities.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1Capabilities-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1Capabilities>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1Capabilities>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1Capabilities.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

