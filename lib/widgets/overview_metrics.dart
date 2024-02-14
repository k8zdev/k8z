import 'dart:html';

import 'package:flutter/material.dart';
import 'package:k8sapp/common/resources/resources.dart';
import 'package:k8sapp/dao/kube.dart';
import 'package:k8sapp/models/kubernetes_extensions/node_metrics.dart';
import 'package:k8sapp/models/models.dart';
import 'package:k8sapp/services/k8z_service.dart';

/// [MetricType] defines type of metrics that we want to show.
/// Current support: [cpu],[memory],[pods].
enum MetricType {
  cpu,
  memory,
  pods,
}

class Metric {
  int allocatable;
  int usage;
  int requests;
  int limits;

  static final zero = Metric(allocatable: 0, usage: 0, requests: 0, limits: 0);

  Metric({
    required this.allocatable,
    required this.usage,
    required this.requests,
    required this.limits,
  });
}

/// The [OverviewMetric] widget be used to show CPU, Memory, Pods metrics.
/// It can be used to show overview metrics of whole cluster or a single node.
/// If [nodeName] is empty, will show whole cluster.
class OverviewMetric extends StatefulWidget {
  final MetricType type;
  final String? nodeName;
  final K8zCluster cluster;
  const OverviewMetric({
    super.key,
    required this.type,
    this.nodeName,
    required this.cluster,
  });

  @override
  State<OverviewMetric> createState() => _OverviewMetricState();
}

class _OverviewMetricState extends State<OverviewMetric> {
  late Future<Map<MetricType, Metric>> _futureFetchMetrics;

  Future<Map<MetricType, Metric>> _fetchMetrics() async {
    // 1. fetch nodes list
    var nodesFilter = widget.nodeName == null
        ? ''
        : '?fieldSelector=metadata.name=${widget.nodeName}';
    final nodesData = await K8zService(cluster: widget.cluster)
        .get('/api/v1/nodes$nodesFilter');
    final nodesList = IoK8sApiCoreV1NodeList.fromJson(nodesData.body);

    // 2. fetch pods list.
    final podsFilter = widget.nodeName == null
        ? ''
        : '?fieldSelector=spec.nodeName=${widget.nodeName}';
    final podsData = await K8zService(cluster: widget.cluster)
        .get('/api/v1/pods$podsFilter');
    final podsList = IoK8sApiCoreV1PodList.fromJson(podsData.body);

    // 3. fetch node's metrics.
    final nodeMetricsData = await K8zService(cluster: widget.cluster)
        .get('/apis/metrics.k8s.io/v1beta1/nodes$NodeFilter');
    final nodeMetricsList =
        ApisMetricsV1beta1NodeMetricsList.fromJson(nodeMetricsData.body);

    int cpuAllocatable = 0;
    int cpuUsage = 0;
    int cpuRequests = 0;
    int cpuLimits = 0;

    int memoryAllocatable = 0;
    int memoryUsage = 0;
    int memoryRequests = 0;
    int memoryLimits = 0;

    int podsAllocatable = 0;
    int podsUsage = 0;

    bool podsCondition = podsList != null;
    bool nodesCondition = nodesList != null;
    bool nodesMetricCondition = nodeMetricsList.items != null;

    if (podsCondition && nodesCondition && nodesMetricCondition) {
      for (var node in nodesList.items) {
        if (node.status != null &&
            node.status!.allocatable.containsKey('cpu')) {
          cpuAllocatable += parseCpuRes(node.status!.allocatable['cpu']!);
        }
        if (node.status != null &&
            node.status!.allocatable.containsKey('memory')) {
          memoryAllocatable += parseCpuRes(node.status!.allocatable['memory']!);
        }
        if (node.status != null &&
            node.status!.allocatable.containsKey('pods')) {
          podsAllocatable += parseCpuRes(node.status!.allocatable['pods']!);
        }
      }

      for (var usage in nodeMetricsList.items!) {
        if (usage.usage != null && usage.usage!.cpu != null) {
          cpuUsage += parseCpuRes(usage.usage!.cpu!);
        }
        if (usage.usage != null && usage.usage!.memory != null) {
          memoryUsage += parseMemRes(usage.usage!.memory!);
        }
        podsUsage += podsList.items.length;
      }

      for (var pod in podsList.items) {
        if (pod.spec != null) {
          for (var container in pod.spec!.containers) {
            var ress = container.resources;
            if (ress != null && ress.requests.containsKey('cpu')) {
              cpuRequests += parseCpuRes(ress.requests['cpu']!);
            }
            if (ress != null && ress.requests.containsKey('memory')) {
              memoryRequests += parseMemRes(ress.requests['memory']!);
            }

            if (ress != null && ress.limits.containsKey('cpu')) {
              cpuLimits += parseCpuRes(ress.limits['cpu']!);
            }
            if (ress != null && ress.limits.containsKey('memory')) {
              memoryLimits += parseMemRes(ress.limits['memory']!);
            }
          }
        }
      }
    }

    return {
      MetricType.cpu: Metric(
        allocatable: cpuAllocatable,
        usage: cpuUsage,
        limits: cpuLimits,
        requests: cpuRequests,
      ),
      MetricType.memory: Metric(
        allocatable: memoryAllocatable,
        usage: memoryUsage,
        limits: memoryLimits,
        requests: memoryRequests,
      ),
      MetricType.pods: Metric(
        allocatable: podsAllocatable,
        usage: podsUsage,
        limits: 0,
        requests: 0,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
