//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAuthorizationV1ResourceRule {
  /// Returns a new [IoK8sApiAuthorizationV1ResourceRule] instance.
  IoK8sApiAuthorizationV1ResourceRule({
    this.apiGroups = const [],
    this.resourceNames = const [],
    this.resources = const [],
    this.verbs = const [],
  });

  /// APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of the enumerated resources in any API group will be allowed.  \"*\" means all.
  List<String> apiGroups;

  /// ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.  \"*\" means all.
  List<String> resourceNames;

  /// Resources is a list of resources this rule applies to.  \"*\" means all in the specified apiGroups.  \"*_/foo\" represents the subresource 'foo' for all resources in the specified apiGroups.
  List<String> resources;

  /// Verb is a list of kubernetes resource API verbs, like: get, list, watch, create, update, delete, proxy.  \"*\" means all.
  List<String> verbs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAuthorizationV1ResourceRule &&
    _deepEquality.equals(other.apiGroups, apiGroups) &&
    _deepEquality.equals(other.resourceNames, resourceNames) &&
    _deepEquality.equals(other.resources, resources) &&
    _deepEquality.equals(other.verbs, verbs);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (apiGroups.hashCode) +
    (resourceNames.hashCode) +
    (resources.hashCode) +
    (verbs.hashCode);

  @override
  String toString() => 'IoK8sApiAuthorizationV1ResourceRule[apiGroups=$apiGroups, resourceNames=$resourceNames, resources=$resources, verbs=$verbs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'apiGroups'] = this.apiGroups;
      json[r'resourceNames'] = this.resourceNames;
      json[r'resources'] = this.resources;
      json[r'verbs'] = this.verbs;
    return json;
  }

  /// Returns a new [IoK8sApiAuthorizationV1ResourceRule] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAuthorizationV1ResourceRule? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAuthorizationV1ResourceRule[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAuthorizationV1ResourceRule[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAuthorizationV1ResourceRule(
        apiGroups: json[r'apiGroups'] is Iterable
            ? (json[r'apiGroups'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        resourceNames: json[r'resourceNames'] is Iterable
            ? (json[r'resourceNames'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        resources: json[r'resources'] is Iterable
            ? (json[r'resources'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        verbs: json[r'verbs'] is Iterable
            ? (json[r'verbs'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<IoK8sApiAuthorizationV1ResourceRule> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAuthorizationV1ResourceRule>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAuthorizationV1ResourceRule.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAuthorizationV1ResourceRule> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAuthorizationV1ResourceRule>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAuthorizationV1ResourceRule.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAuthorizationV1ResourceRule-objects as value to a dart map
  static Map<String, List<IoK8sApiAuthorizationV1ResourceRule>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAuthorizationV1ResourceRule>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAuthorizationV1ResourceRule.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'verbs',
  };
}

