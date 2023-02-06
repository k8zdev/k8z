//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiAuthenticationV1TokenReview {
  /// Returns a new [IoK8sApiAuthenticationV1TokenReview] instance.
  IoK8sApiAuthenticationV1TokenReview({
    this.apiVersion,
    this.kind,
    this.metadata,
    required this.spec,
    this.status,
  });

  /// APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? apiVersion;

  /// Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? kind;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IoK8sApimachineryPkgApisMetaV1ObjectMeta? metadata;

  IoK8sApiAuthenticationV1TokenReviewSpec spec;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IoK8sApiAuthenticationV1TokenReviewStatus? status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiAuthenticationV1TokenReview &&
    other.apiVersion == apiVersion &&
    other.kind == kind &&
    other.metadata == metadata &&
    other.spec == spec &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (apiVersion == null ? 0 : apiVersion!.hashCode) +
    (kind == null ? 0 : kind!.hashCode) +
    (metadata == null ? 0 : metadata!.hashCode) +
    (spec.hashCode) +
    (status == null ? 0 : status!.hashCode);

  @override
  String toString() => 'IoK8sApiAuthenticationV1TokenReview[apiVersion=$apiVersion, kind=$kind, metadata=$metadata, spec=$spec, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.apiVersion != null) {
      json[r'apiVersion'] = this.apiVersion;
    } else {
      json[r'apiVersion'] = null;
    }
    if (this.kind != null) {
      json[r'kind'] = this.kind;
    } else {
      json[r'kind'] = null;
    }
    if (this.metadata != null) {
      json[r'metadata'] = this.metadata;
    } else {
      json[r'metadata'] = null;
    }
      json[r'spec'] = this.spec;
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    return json;
  }

  /// Returns a new [IoK8sApiAuthenticationV1TokenReview] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiAuthenticationV1TokenReview? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiAuthenticationV1TokenReview[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiAuthenticationV1TokenReview[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiAuthenticationV1TokenReview(
        apiVersion: mapValueOfType<String>(json, r'apiVersion'),
        kind: mapValueOfType<String>(json, r'kind'),
        metadata: IoK8sApimachineryPkgApisMetaV1ObjectMeta.fromJson(json[r'metadata']),
        spec: IoK8sApiAuthenticationV1TokenReviewSpec.fromJson(json[r'spec'])!,
        status: IoK8sApiAuthenticationV1TokenReviewStatus.fromJson(json[r'status']),
      );
    }
    return null;
  }

  static List<IoK8sApiAuthenticationV1TokenReview> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiAuthenticationV1TokenReview>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiAuthenticationV1TokenReview.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiAuthenticationV1TokenReview> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiAuthenticationV1TokenReview>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiAuthenticationV1TokenReview.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiAuthenticationV1TokenReview-objects as value to a dart map
  static Map<String, List<IoK8sApiAuthenticationV1TokenReview>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiAuthenticationV1TokenReview>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiAuthenticationV1TokenReview.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'spec',
  };
}

