//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAuthenticationV1TokenRequestStatus {
  /// Returns a new [IoK8sApiAuthenticationV1TokenRequestStatus] instance.
  IoK8sApiAuthenticationV1TokenRequestStatus({
    required this.expirationTimestamp,
    required this.token,
  });

  /// Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers.
  DateTime expirationTimestamp;

  /// Token is the opaque bearer token.
  String token;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAuthenticationV1TokenRequestStatus &&
    other.expirationTimestamp == expirationTimestamp &&
    other.token == token;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (expirationTimestamp.hashCode) +
    (token.hashCode);

  @override
  String toString() => 'IoK8sApiAuthenticationV1TokenRequestStatus[expirationTimestamp=$expirationTimestamp, token=$token]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'expirationTimestamp'] = this.expirationTimestamp.toUtc().toIso8601String();
      json[r'token'] = this.token;
    return json;
  }

  /// Returns a new [IoK8sApiAuthenticationV1TokenRequestStatus] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAuthenticationV1TokenRequestStatus? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAuthenticationV1TokenRequestStatus[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAuthenticationV1TokenRequestStatus[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAuthenticationV1TokenRequestStatus(
        expirationTimestamp: mapDateTime(json, r'expirationTimestamp', r'')!,
        token: mapValueOfType<String>(json, r'token')!,
      );
    }
    return null;
  }

  static List<IoK8sApiAuthenticationV1TokenRequestStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAuthenticationV1TokenRequestStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAuthenticationV1TokenRequestStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAuthenticationV1TokenRequestStatus> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAuthenticationV1TokenRequestStatus>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAuthenticationV1TokenRequestStatus.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAuthenticationV1TokenRequestStatus-objects as value to a dart map
  static Map<String, List<IoK8sApiAuthenticationV1TokenRequestStatus>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAuthenticationV1TokenRequestStatus>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAuthenticationV1TokenRequestStatus.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'expirationTimestamp',
    'token',
  };
}
