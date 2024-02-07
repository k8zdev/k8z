//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiNetworkingV1NetworkPolicySpec {
  /// Returns a new [IoK8sApiNetworkingV1NetworkPolicySpec] instance.
  IoK8sApiNetworkingV1NetworkPolicySpec({
    this.egress = const [],
    this.ingress = const [],
    required this.podSelector,
    this.policyTypes = const [],
  });

  /// List of egress rules to be applied to the selected pods. Outgoing traffic is allowed if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic matches at least one egress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy limits all outgoing traffic (and serves solely to ensure that the pods it selects are isolated by default). This field is beta-level in 1.8
  List<IoK8sApiNetworkingV1NetworkPolicyEgressRule> egress;

  /// List of ingress rules to be applied to the selected pods. Traffic is allowed to a pod if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic source is the pod's local node, OR if the traffic matches at least one ingress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy does not allow any traffic (and serves solely to ensure that the pods it selects are isolated by default)
  List<IoK8sApiNetworkingV1NetworkPolicyIngressRule> ingress;

  IoK8sApimachineryPkgApisMetaV1LabelSelector podSelector;

  /// List of rule types that the NetworkPolicy relates to. Valid options are [\"Ingress\"], [\"Egress\"], or [\"Ingress\", \"Egress\"]. If this field is not specified, it will default based on the existence of Ingress or Egress rules; policies that contain an Egress section are assumed to affect Egress, and all policies (whether or not they contain an Ingress section) are assumed to affect Ingress. If you want to write an egress-only policy, you must explicitly specify policyTypes [ \"Egress\" ]. Likewise, if you want to write a policy that specifies that no egress is allowed, you must specify a policyTypes value that include \"Egress\" (since such a policy would not include an Egress section and would otherwise default to just [ \"Ingress\" ]). This field is beta-level in 1.8
  List<String> policyTypes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiNetworkingV1NetworkPolicySpec &&
    _deepEquality.equals(other.egress, egress) &&
    _deepEquality.equals(other.ingress, ingress) &&
    other.podSelector == podSelector &&
    _deepEquality.equals(other.policyTypes, policyTypes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (egress.hashCode) +
    (ingress.hashCode) +
    (podSelector.hashCode) +
    (policyTypes.hashCode);

  @override
  String toString() => 'IoK8sApiNetworkingV1NetworkPolicySpec[egress=$egress, ingress=$ingress, podSelector=$podSelector, policyTypes=$policyTypes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'egress'] = this.egress;
      json[r'ingress'] = this.ingress;
      json[r'podSelector'] = this.podSelector;
      json[r'policyTypes'] = this.policyTypes;
    return json;
  }

  /// Returns a new [IoK8sApiNetworkingV1NetworkPolicySpec] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiNetworkingV1NetworkPolicySpec? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiNetworkingV1NetworkPolicySpec[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiNetworkingV1NetworkPolicySpec[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiNetworkingV1NetworkPolicySpec(
        egress: IoK8sApiNetworkingV1NetworkPolicyEgressRule.listFromJson(json[r'egress']),
        ingress: IoK8sApiNetworkingV1NetworkPolicyIngressRule.listFromJson(json[r'ingress']),
        podSelector: IoK8sApimachineryPkgApisMetaV1LabelSelector.fromJson(json[r'podSelector'])!,
        policyTypes: json[r'policyTypes'] is Iterable
            ? (json[r'policyTypes'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<IoK8sApiNetworkingV1NetworkPolicySpec> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiNetworkingV1NetworkPolicySpec>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiNetworkingV1NetworkPolicySpec.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiNetworkingV1NetworkPolicySpec> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiNetworkingV1NetworkPolicySpec>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiNetworkingV1NetworkPolicySpec.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiNetworkingV1NetworkPolicySpec-objects as value to a dart map
  static Map<String, List<IoK8sApiNetworkingV1NetworkPolicySpec>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiNetworkingV1NetworkPolicySpec>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiNetworkingV1NetworkPolicySpec.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'podSelector',
  };
}

