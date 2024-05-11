import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/resources/resources.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/kubernetes_extensions/node_metrics.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_service.dart';

const _chartLabelStyle = TextStyle(
  fontSize: 10,
  color: Colors.grey,
);

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

  @override
  String toString() =>
      'allocatable=$allocatable, usage=$usage, requests=$requests, limits=$limits';

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
  final String? nodeName;
  final K8zCluster? cluster;
  const OverviewMetric({
    super.key,
    this.nodeName,
    required this.cluster,
  });

  @override
  State<OverviewMetric> createState() => _OverviewMetricState();
}

class _OverviewMetricState extends State<OverviewMetric> {
  Future<Map<MetricType, Metric>> _fetchMetrics() async {
    // 1. fetch nodes list
    var nodesFilter = widget.nodeName == null
        ? ''
        : '?fieldSelector=metadata.name=${widget.nodeName}';
    final nodesData = await K8zService(context, cluster: widget.cluster!)
        .get('/api/v1/nodes$nodesFilter');
    if (nodesData.error.isNotEmpty) throw Exception(nodesData.error);
    final nodesList = IoK8sApiCoreV1NodeList.fromJson(nodesData.body);

    // 2. fetch pods list.
    final podsFilter = widget.nodeName == null
        ? ''
        : '?fieldSelector=spec.nodeName=${widget.nodeName}';
    // ignore: use_build_context_synchronously
    final podsData = await K8zService(context, cluster: widget.cluster!)
        .get('/api/v1/pods$podsFilter');
    if (podsData.error.isNotEmpty) throw Exception(nodesData.error);
    final podsList = IoK8sApiCoreV1PodList.fromJson(podsData.body);

    // 3. fetch node's metrics.
    // ignore: use_build_context_synchronously
    final nodeMetricsData = await K8zService(context, cluster: widget.cluster!)
        .get('/apis/metrics.k8s.io/v1beta1/nodes$nodesFilter');
    if (nodeMetricsData.error.isNotEmpty) {
      throw nodeMetricsData.error;
    }
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

    if (podsCondition && nodesCondition) {
      for (var node in nodesList.items) {
        if (node.status != null &&
            node.status!.allocatable.containsKey('cpu')) {
          cpuAllocatable += parseCpuRes(node.status!.allocatable['cpu']!);
        }
        if (node.status != null &&
            node.status!.allocatable.containsKey('memory')) {
          memoryAllocatable += parseMemRes(node.status!.allocatable['memory']!);
        }
        if (node.status != null &&
            node.status!.allocatable.containsKey('pods')) {
          podsAllocatable += parseMemRes(node.status!.allocatable['pods']!);
        }
      }

      if (nodesMetricCondition) {
        for (var usage in nodeMetricsList.items!) {
          if (usage.usage != null && usage.usage!.cpu != null) {
            cpuUsage += parseCpuRes(usage.usage!.cpu!);
          }
          if (usage.usage != null && usage.usage!.memory != null) {
            memoryUsage += parseMemRes(usage.usage!.memory!);
          }
          podsUsage += podsList.items.length;
        }
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

  Widget metricChart(Metric metric, {cpu = false}) {
    var allocatable = metric.allocatable;
    var requests =
        metric.requests > allocatable ? allocatable : metric.requests;
    var limits = metric.limits > allocatable ? allocatable : metric.limits;

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 0,
      ),
      child: RadialGauge(
        track: RadialTrack(
          start: 0,
          color: Colors.grey.shade300,
          trackStyle: const TrackStyle(showLabel: false),
          steps: allocatable ~/ 2,
          end: allocatable.toDouble(),
        ),
        valueBar: [
          RadialValueBar(
            color: Colors.redAccent,
            radialOffset: -8,
            valueBarThickness: 8,
            value: requests.toDouble(),
          ),
          RadialValueBar(
            color: Colors.amber,
            valueBarThickness: 8,
            value: metric.usage.toDouble(),
          ),
          RadialValueBar(
            color: Colors.blueAccent,
            radialOffset: 8,
            valueBarThickness: 8,
            value: limits.toDouble(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    if (widget.cluster == null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(lang.no_current_cluster),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder(
        future: _fetchMetrics(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading
            return SizedBox(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 32),
                    Text(lang.loading_metrics),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            talker.debug("snapshot error ${snapshot.error.toString()}");
            return SizedBox(
              height: 100,
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  lang.load_metrics_error(snapshot.error.toString()),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            Metric cpu = snapshot.data[MetricType.cpu];
            Metric pods = snapshot.data[MetricType.pods];
            Metric memory = snapshot.data[MetricType.memory];

            talker.debug('''
cpu metrics: $cpu
mem metrics: $memory
pods metrics: $pods
''');

            var rowList = <Widget>[
              Expanded(
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      Text(
                        '${lang.cpu}\nU:${formatCpuRes(cpu.usage)}c/R:${formatCpuRes(cpu.requests)}c/L:${formatCpuRes(cpu.limits)}c/A:${formatCpuRes(cpu.allocatable, round: 0)}c',
                        style: _chartLabelStyle,
                        textAlign: TextAlign.center,
                      ),
                      metricChart(cpu),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(children: [
                    Text(
                      '${lang.pods}\nUsage:${pods.usage}\nAllocatable:${pods.allocatable}',
                      style: _chartLabelStyle,
                      textAlign: TextAlign.center,
                    ),
                    metricChart(pods),
                  ]),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  height: 150,
                  child: Column(children: [
                    Text(
                      '${lang.memory}\nU:${formatMemRes(memory.usage)}/R:${formatMemRes(memory.requests)}/L:${formatMemRes(memory.limits)}/A:${formatMemRes(memory.allocatable)}',
                      style: _chartLabelStyle,
                      textAlign: TextAlign.center,
                    ),
                    metricChart(memory),
                  ]),
                ),
              ),
            ];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // charts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: rowList,
                  ),
                  // legends
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
