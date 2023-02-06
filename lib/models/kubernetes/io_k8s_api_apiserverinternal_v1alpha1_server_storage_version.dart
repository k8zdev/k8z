//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiApiserverinternalV1alpha1ServerStorageVersion {
  /// Returns a new [IoK8sApiApiserverinternalV1alpha1ServerStorageVersion] instance.
  IoK8sApiApiserverinternalV1alpha1ServerStorageVersion({
    this.apiServerID,
    this.decodableVersions = const [],
    this.encodingVersion,
  });

  /// The ID of the reporting API server.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? apiServerID;

  /// The API server can decode objects encoded in these versions. The encodingVersion must be included in the decodableVersions.
  List<String> decodableVersions;

  /// The API server encodes the object to this version when persisting it in the backend (e.g., etcd).
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? encodingVersion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiApiserverinternalV1alpha1ServerStorageVersion &&
    other.apiServerID == apiServerID &&
    _deepEquality.equals(other.decodableVersions, decodableVersions) &&
    other.encodingVersion == encodingVersion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (apiServerID == null ? 0 : apiServerID!.hashCode) +
    (decodableVersions.hashCode) +
    (encodingVersion == null ? 0 : encodingVersion!.hashCode);

  @override
  String toString() => 'IoK8sApiApiserverinternalV1alpha1ServerStorageVersion[apiServerID=$apiServerID, decodableVersions=$decodableVersions, encodingVersion=$encodingVersion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.apiServerID != null) {
      json[r'apiServerID'] = this.apiServerID;
    } else {
      json[r'apiServerID'] = null;
    }
      json[r'decodableVersions'] = this.decodableVersions;
    if (this.encodingVersion != null) {
      json[r'encodingVersion'] = this.encodingVersion;
    } else {
      json[r'encodingVersion'] = null;
    }
    return json;
  }

  /// Returns a new [IoK8sApiApiserverinternalV1alpha1ServerStorageVersion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiApiserverinternalV1alpha1ServerStorageVersion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiApiserverinternalV1alpha1ServerStorageVersion[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiApiserverinternalV1alpha1ServerStorageVersion[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiApiserverinternalV1alpha1ServerStorageVersion(
        apiServerID: mapValueOfType<String>(json, r'apiServerID'),
        decodableVersions: json[r'decodableVersions'] is Iterable
            ? (json[r'decodableVersions'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        encodingVersion: mapValueOfType<String>(json, r'encodingVersion'),
      );
    }
    return null;
  }

  static List<IoK8sApiApiserverinternalV1alpha1ServerStorageVersion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiApiserverinternalV1alpha1ServerStorageVersion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiApiserverinternalV1alpha1ServerStorageVersion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiApiserverinternalV1alpha1ServerStorageVersion> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiApiserverinternalV1alpha1ServerStorageVersion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiApiserverinternalV1alpha1ServerStorageVersion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiApiserverinternalV1alpha1ServerStorageVersion-objects as value to a dart map
  static Map<String, List<IoK8sApiApiserverinternalV1alpha1ServerStorageVersion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiApiserverinternalV1alpha1ServerStorageVersion>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiApiserverinternalV1alpha1ServerStorageVersion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

