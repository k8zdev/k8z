const _cpuUnitMap = {
  'n': 1,
  'u': 1000,
  'm': 1000 * 1000,
  '': 1000 * 1000 * 1000,
};
const _memUnitMap = {
  'K': 1024,
  'ki': 1024,
  'Ki': 1024,
  'M': 1024 * 1024,
  'mi': 1024 * 1024,
  'Mi': 1024 * 1024,
  'G': 1024 * 1024 * 1024,
  'gi': 1024 * 1024 * 1024,
  'Gi': 1024 * 1024 * 1024,
};

int _parseRes(String raw, Map<String, int> maps) {
  if (raw == '') {
    return 0;
  }

  for (var map in maps.entries) {
    if (raw.endsWith(map.key)) {
      var num = raw.substring(0, raw.length - map.key.length);
      return double.parse(num).toInt() * map.value;
    }
  }
  return double.parse(raw).toInt();
}

/// [parseCpuRes] converts cpu [raw] resource [String] to [int].
/// int(1) means the smallest unit for CPU `n`.
/// k8s doc: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes
/// These CPU resources are managed by the kube-scheduler using the Linux CFS: https://en.wikipedia.org/wiki/Completely_Fair_Scheduler
///
///
int parseCpuRes(String raw) {
  return _parseRes(raw, _cpuUnitMap);
}

/// [parseMemRes] converts mem [raw] resource [String] to [int].
/// int(1) means the smallest unit for Mem `byte`.
///
/// > Pay attention to the case of the suffixes. If you request 400m of memory, this is a request for 0.4 bytes. Someone who types that probably meant to ask for 400 mebibytes (400Mi) or 400 megabytes (400M).
int parseMemRes(String raw) {
  return _parseRes(raw, _memUnitMap);
}

String formatCpuRes(int raw, {round = 2}) {
  return (raw / 1e9.toInt()).toStringAsFixed(round);
}

const _memUnit = 1024;
String formatMemRes(int raw, {round = 2}) {
  if (raw < _memUnit) {
    return '$raw';
  }

  if (raw < _memUnit * _memUnit && raw % _memUnit == 0) {
    return '${(raw / _memUnit).toStringAsFixed(round)}Ki';
  }

  if (raw < _memUnit * _memUnit) {
    return '${(raw / _memUnit).toStringAsFixed(round)}Ki';
  }

  if (raw < _memUnit * _memUnit * _memUnit && raw % _memUnit == 0) {
    return '${(raw / (_memUnit * _memUnit)).toStringAsFixed(round)}Mi';
  }

  if (raw < _memUnit * _memUnit * _memUnit * _memUnit && raw % _memUnit == 0) {
    return '${(raw / (_memUnit * _memUnit * _memUnit)).toStringAsFixed(round)}Gi';
  }

  return '${(raw / _memUnit / _memUnit / _memUnit / _memUnit).toStringAsFixed(round)}Ti';
}
