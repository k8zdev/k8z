//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of models.k8s;

class IoK8sApiCoreV1AttachedVolume {
  /// Returns a new [IoK8sApiCoreV1AttachedVolume] instance.
  IoK8sApiCoreV1AttachedVolume({
    required this.devicePath,
    required this.name,
  });

  /// DevicePath represents the device path where the volume should be available
  String devicePath;

  /// Name of the attached volume
  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IoK8sApiCoreV1AttachedVolume &&
    other.devicePath == devicePath &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (devicePath.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'IoK8sApiCoreV1AttachedVolume[devicePath=$devicePath, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'devicePath'] = this.devicePath;
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [IoK8sApiCoreV1AttachedVolume] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IoK8sApiCoreV1AttachedVolume? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IoK8sApiCoreV1AttachedVolume[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IoK8sApiCoreV1AttachedVolume[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IoK8sApiCoreV1AttachedVolume(
        devicePath: mapValueOfType<String>(json, r'devicePath')!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<IoK8sApiCoreV1AttachedVolume> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IoK8sApiCoreV1AttachedVolume>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IoK8sApiCoreV1AttachedVolume.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IoK8sApiCoreV1AttachedVolume> mapFromJson(dynamic json) {
    final map = <String, IoK8sApiCoreV1AttachedVolume>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IoK8sApiCoreV1AttachedVolume.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IoK8sApiCoreV1AttachedVolume-objects as value to a dart map
  static Map<String, List<IoK8sApiCoreV1AttachedVolume>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IoK8sApiCoreV1AttachedVolume>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IoK8sApiCoreV1AttachedVolume.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'devicePath',
    'name',
  };
}

