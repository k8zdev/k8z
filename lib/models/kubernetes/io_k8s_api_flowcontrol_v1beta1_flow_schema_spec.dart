//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiFlowcontrolV1beta1FlowSchemaSpec {
  /// Returns a new [IoK8sApiFlowcontrolV1beta1FlowSchemaSpec] instance.
  IoK8sApiFlowcontrolV1beta1FlowSchemaSpec({
    this.distinguisherMethod,
    this.matchingPrecedence,
    required this.priorityLevelConfiguration,
    this.rules = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IoK8sApiFlowcontrolV1beta1FlowDistinguisherMethod? distinguisherMethod;

  /// `matchingPrecedence` is used to choose among the FlowSchemas that match a given request. The chosen FlowSchema is among those with the numerically lowest (which we take to be logically highest) MatchingPrecedence.  Each MatchingPrecedence value must be ranged in [1,10000]. Note that if the precedence is not specified, it will be set to 1000 as default.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? matchingPrecedence;

  IoK8sApiFlowcontrolV1beta1PriorityLevelConfigurationReference priorityLevelConfiguration;

  /// `rules` describes which requests will match this flow schema. This FlowSchema matches a request if and only if at least one member of rules matches the request. if it is an empty slice, there will be no requests matching the FlowSchema.
  List<IoK8sApiFlowcontrolV1beta1PolicyRulesWithSubjects> rules;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiFlowcontrolV1beta1FlowSchemaSpec &&
    other.distinguisherMethod == distinguisherMethod &&
    other.matchingPrecedence == matchingPrecedence &&
    other.priorityLevelConfiguration == priorityLevelConfiguration &&
    _deepEquality.equals(other.rules, rules);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (distinguisherMethod == null ? 0 : distinguisherMethod!.hashCode) +
    (matchingPrecedence == null ? 0 : matchingPrecedence!.hashCode) +
    (priorityLevelConfiguration.hashCode) +
    (rules.hashCode);

  @override
  String toString() => 'IoK8sApiFlowcontrolV1beta1FlowSchemaSpec[distinguisherMethod=$distinguisherMethod, matchingPrecedence=$matchingPrecedence, priorityLevelConfiguration=$priorityLevelConfiguration, rules=$rules]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.distinguisherMethod != null) {
      json[r'distinguisherMethod'] = this.distinguisherMethod;
    } else {
      json[r'distinguisherMethod'] = null;
    }
    if (this.matchingPrecedence != null) {
      json[r'matchingPrecedence'] = this.matchingPrecedence;
    } else {
      json[r'matchingPrecedence'] = null;
    }
      json[r'priorityLevelConfiguration'] = this.priorityLevelConfiguration;
      json[r'rules'] = this.rules;
    return json;
  }

  /// Returns a new [IoK8sApiFlowcontrolV1beta1FlowSchemaSpec] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiFlowcontrolV1beta1FlowSchemaSpec? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiFlowcontrolV1beta1FlowSchemaSpec[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiFlowcontrolV1beta1FlowSchemaSpec[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiFlowcontrolV1beta1FlowSchemaSpec(
        distinguisherMethod: IoK8sApiFlowcontrolV1beta1FlowDistinguisherMethod.fromJson(json[r'distinguisherMethod']),
        matchingPrecedence: mapValueOfType<int>(json, r'matchingPrecedence'),
        priorityLevelConfiguration: IoK8sApiFlowcontrolV1beta1PriorityLevelConfigurationReference.fromJson(json[r'priorityLevelConfiguration'])!,
        rules: IoK8sApiFlowcontrolV1beta1PolicyRulesWithSubjects.listFromJson(json[r'rules']),
      );
    }
    return null;
  }

  static List<IoK8sApiFlowcontrolV1beta1FlowSchemaSpec> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiFlowcontrolV1beta1FlowSchemaSpec>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiFlowcontrolV1beta1FlowSchemaSpec.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiFlowcontrolV1beta1FlowSchemaSpec> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiFlowcontrolV1beta1FlowSchemaSpec>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiFlowcontrolV1beta1FlowSchemaSpec.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiFlowcontrolV1beta1FlowSchemaSpec-objects as value to a dart map
  static Map<String, List<IoK8sApiFlowcontrolV1beta1FlowSchemaSpec>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiFlowcontrolV1beta1FlowSchemaSpec>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiFlowcontrolV1beta1FlowSchemaSpec.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'priorityLevelConfiguration',
  };
}

