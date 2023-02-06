//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1ServiceAccount {
  /// Returns a new [IoK8sApiCoreV1ServiceAccount] instance.
  IoK8sApiCoreV1ServiceAccount({
    this.apiVersion,
    this.automountServiceAccountToken,
    this.imagePullSecrets = const [],
    this.kind,
    this.metadata,
    this.secrets = const [],
  });

  /// APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? apiVersion;

  /// AutomountServiceAccountToken indicates whether pods running as this service account should have an API token automatically mounted. Can be overridden at the pod level.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? automountServiceAccountToken;

  /// ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount. ImagePullSecrets are distinct from Secrets because Secrets can be mounted in the pod, but ImagePullSecrets are only accessed by the kubelet. More info: https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
  List<IoK8sApiCoreV1LocalObjectReference> imagePullSecrets;

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

  /// Secrets is a list of the secrets in the same namespace that pods running using this ServiceAccount are allowed to use. Pods are only limited to this list if this service account has a \"kubernetes.io/enforce-mountable-secrets\" annotation set to \"true\". This field should not be used to find auto-generated service account token secrets for use outside of pods. Instead, tokens can be requested directly using the TokenRequest API, or service account token secrets can be manually created. More info: https://kubernetes.io/docs/concepts/configuration/secret
  List<IoK8sApiCoreV1ObjectReference> secrets;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1ServiceAccount &&
    other.apiVersion == apiVersion &&
    other.automountServiceAccountToken == automountServiceAccountToken &&
    _deepEquality.equals(other.imagePullSecrets, imagePullSecrets) &&
    other.kind == kind &&
    other.metadata == metadata &&
    _deepEquality.equals(other.secrets, secrets);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (apiVersion == null ? 0 : apiVersion!.hashCode) +
    (automountServiceAccountToken == null ? 0 : automountServiceAccountToken!.hashCode) +
    (imagePullSecrets.hashCode) +
    (kind == null ? 0 : kind!.hashCode) +
    (metadata == null ? 0 : metadata!.hashCode) +
    (secrets.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1ServiceAccount[apiVersion=$apiVersion, automountServiceAccountToken=$automountServiceAccountToken, imagePullSecrets=$imagePullSecrets, kind=$kind, metadata=$metadata, secrets=$secrets]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.apiVersion != null) {
      json[r'apiVersion'] = this.apiVersion;
    } else {
      json[r'apiVersion'] = null;
    }
    if (this.automountServiceAccountToken != null) {
      json[r'automountServiceAccountToken'] = this.automountServiceAccountToken;
    } else {
      json[r'automountServiceAccountToken'] = null;
    }
      json[r'imagePullSecrets'] = this.imagePullSecrets;
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
      json[r'secrets'] = this.secrets;
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1ServiceAccount] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1ServiceAccount? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1ServiceAccount[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1ServiceAccount[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1ServiceAccount(
        apiVersion: mapValueOfType<String>(json, r'apiVersion'),
        automountServiceAccountToken: mapValueOfType<bool>(json, r'automountServiceAccountToken'),
        imagePullSecrets: IoK8sApiCoreV1LocalObjectReference.listFromJson(json[r'imagePullSecrets']),
        kind: mapValueOfType<String>(json, r'kind'),
        metadata: IoK8sApimachineryPkgApisMetaV1ObjectMeta.fromJson(json[r'metadata']),
        secrets: IoK8sApiCoreV1ObjectReference.listFromJson(json[r'secrets']),
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1ServiceAccount> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1ServiceAccount>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1ServiceAccount.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1ServiceAccount> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1ServiceAccount>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1ServiceAccount.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1ServiceAccount-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1ServiceAccount>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1ServiceAccount>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1ServiceAccount.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

