import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final ThemeData theme = Theme.of(this);
    return theme.brightness == Brightness.dark;
  }
}

double availableHeight(BuildContext context, double offset) {
  // 获取设备可用空间的高度
  final deviceHeight = MediaQuery.of(context).size.height;
  var height = deviceHeight - offset;
  return height;
}

const k8sNodeLabelPrefix = "node-role.kubernetes.io/";
String nodeRoles(Map<String, String> labels) {
  var roles = [];

  labels.forEach((key, value) {
    if (key.startsWith(k8sNodeLabelPrefix) && value.toLowerCase() == "true") {
      roles.add(key.replaceAll(k8sNodeLabelPrefix, ""));
    }
  });
  if (roles.isEmpty) {
    roles.add("<none>");
  }

  return roles.join(",");
}

extension PrettyFormat on Duration {
  String get pretty {
    var stop = false;
    var components = <String>[];

    var days = this.inDays;
    if (days != 0) {
      stop = true;
      components.add('${days}d');
    }
    var hours = this.inHours % 24;
    if (hours != 0 && !stop) {
      stop = true;
      components.add('${hours}h');
    }
    var minutes = this.inMinutes % 60;
    if (minutes != 0 && !stop) {
      stop = true;
      components.add('${minutes}m');
    }

    var seconds = this.inSeconds % 60;
    if ((components.isEmpty || seconds != 0) && !stop) {
      components.add('$seconds s');
    }
    return components.join();
  }
}

const podOkStatusList = ["Running", "Succeeded"];

bool isOkStatus(String status) {
  return podOkStatusList.contains(status);
}
