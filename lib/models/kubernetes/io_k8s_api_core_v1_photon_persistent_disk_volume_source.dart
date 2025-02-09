//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1PhotonPersistentDiskVolumeSource {
  /// Returns a new [IoK8sApiCoreV1PhotonPersistentDiskVolumeSource] instance.
  IoK8sApiCoreV1PhotonPersistentDiskVolumeSource({
    this.fsType,
    required this.pdID,
  });

  /// fsType is the filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fsType;

  /// pdID is the ID that identifies Photon Controller persistent disk
  String pdID;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1PhotonPersistentDiskVolumeSource &&
    other.fsType == fsType &&
    other.pdID == pdID;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fsType == null ? 0 : fsType!.hashCode) +
    (pdID.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1PhotonPersistentDiskVolumeSource[fsType=$fsType, pdID=$pdID]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fsType != null) {
      json[r'fsType'] = this.fsType;
    } else {
      json[r'fsType'] = null;
    }
      json[r'pdID'] = this.pdID;
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1PhotonPersistentDiskVolumeSource] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1PhotonPersistentDiskVolumeSource? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1PhotonPersistentDiskVolumeSource[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1PhotonPersistentDiskVolumeSource[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1PhotonPersistentDiskVolumeSource(
        fsType: mapValueOfType<String>(json, r'fsType'),
        pdID: mapValueOfType<String>(json, r'pdID')!,
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1PhotonPersistentDiskVolumeSource> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1PhotonPersistentDiskVolumeSource>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1PhotonPersistentDiskVolumeSource.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1PhotonPersistentDiskVolumeSource> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1PhotonPersistentDiskVolumeSource>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1PhotonPersistentDiskVolumeSource.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1PhotonPersistentDiskVolumeSource-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1PhotonPersistentDiskVolumeSource>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1PhotonPersistentDiskVolumeSource>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1PhotonPersistentDiskVolumeSource.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'pdID',
  };
}

