import 'package:flutter/material.dart';
import 'package:k8zdev/common/resources/resources.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/widgets/widgets.dart';

const podOkStatusList = ["Running", "Succeeded"];

class PodResources {
  String cpu;
  String memory;

  PodResources({required this.cpu, required this.memory});
}

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

PodResources? getPodResources(IoK8sApiCoreV1Pod? pod) {
  if (pod == null || pod.spec == null || pod.spec!.containers.isEmpty) {
    return null;
  }

  int cpuLimits = 0;
  int memLimits = 0;
  int cpuRequests = 0;
  int memRequests = 0;

  for (var container in pod.spec!.containers) {
    var limits = container.resources!.limits;
    if (limits.containsKey('cpu')) {
      cpuLimits += parseCpuRes(limits['cpu']!);
    }
    if (limits.containsKey('memory')) {
      memLimits += parseMemRes(limits['memory']!);
    }

    var requests = container.resources!.requests;
    if (requests.containsKey('cpu')) {
      cpuRequests += parseCpuRes(requests['cpu']!);
    }
    if (requests.containsKey('memory')) {
      memRequests += parseMemRes(requests['memory']!);
    }
  }

  return PodResources(
    cpu: '${formatCpuRes(cpuRequests)} / ${formatCpuRes(cpuLimits)}',
    memory: '${formatMemRes(memRequests)} / ${formatMemRes(memLimits)}',
  );
}
