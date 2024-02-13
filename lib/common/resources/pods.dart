// String getStatusText(IoK8sApiCoreV1Pod? pod) {

import 'package:flutter/material.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/widgets/widgets.dart';

const podOkStatusList = ["Running", "Succeeded"];

/// [getPodStatus] returns pod status string and icon from [pod].
(String status, Widget icon) getPodStatus(IoK8sApiCoreV1Pod? pod) {
  if (pod == null) {
    return ("-", quizIcon);
  }

  final phase = pod.status?.phase ?? 'Unknown';
  var reason = pod.status?.reason ?? '';

  for (var cs in pod.status!.containerStatuses) {
    if (cs.state?.waiting != null) {
      reason = cs.state?.waiting?.reason ?? '';
      break;
    }

    if (cs.state?.terminated != null) {
      reason = cs.state?.terminated?.reason ?? '';
      break;
    }
  }

  reason = (reason != '') ? reason : phase;
  return (reason, podOkStatusList.contains(reason) ? runningIcon : errorIcon);
}

/// [getRestarts] return restarts count number for a [pod].
/// The number is sum of all init containers and containers.
int getRestarts(IoK8sApiCoreV1Pod? pod) {
  final cs = pod?.status?.containerStatuses;
  final count = cs != null && cs.isNotEmpty
      ? cs
          .map((status) => status.restartCount)
          .reduce((count1, count2) => count1 + count2)
      : 0;
  final ics = pod?.status?.initContainerStatuses;
  final initCount = ics != null && ics.isNotEmpty
      ? ics
          .map((status) => status.restartCount)
          .reduce((count1, count2) => count1 + count2)
      : 0;

  return count + initCount;
}
