//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiNetworkingV1NetworkPolicyStatus {
  /// Returns a new [IoK8sApiNetworkingV1NetworkPolicyStatus] instance.
  IoK8sApiNetworkingV1NetworkPolicyStatus({
    this.conditions = const [],
  });

  /// Conditions holds an array of metav1.Condition that describe the state of the NetworkPolicy. Current service state
  List<IoK8sApimachineryPkgApisMetaV1Condition> conditions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiNetworkingV1NetworkPolicyStatus &&
    _deepEquality.equals(other.conditions, conditions);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conditions.hashCode);

  @override
  String toString() => 'IoK8sApiNetworkingV1NetworkPolicyStatus[conditions=$conditions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conditions'] = this.conditions;
    return json;
  }

  /// Returns a new [IoK8sApiNetworkingV1NetworkPolicyStatus] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiNetworkingV1NetworkPolicyStatus? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiNetworkingV1NetworkPolicyStatus[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiNetworkingV1NetworkPolicyStatus[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiNetworkingV1NetworkPolicyStatus(
        conditions: IoK8sApimachineryPkgApisMetaV1Condition.listFromJson(json[r'conditions']),
      );
    }
    return null;
  }

  static List<IoK8sApiNetworkingV1NetworkPolicyStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiNetworkingV1NetworkPolicyStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiNetworkingV1NetworkPolicyStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiNetworkingV1NetworkPolicyStatus> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiNetworkingV1NetworkPolicyStatus>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiNetworkingV1NetworkPolicyStatus.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiNetworkingV1NetworkPolicyStatus-objects as value to a dart map
  static Map<String, List<IoK8sApiNetworkingV1NetworkPolicyStatus>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiNetworkingV1NetworkPolicyStatus>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiNetworkingV1NetworkPolicyStatus.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}
