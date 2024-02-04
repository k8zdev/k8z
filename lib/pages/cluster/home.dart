import 'package:flutter/material.dart';
import 'package:k8sapp/dao/kube.dart';

class ClusterHomePage extends StatefulWidget {
  final K8zCluster cluster;
  const ClusterHomePage({super.key, required this.cluster});

  @override
  State<ClusterHomePage> createState() => _ClusterHomePageState();
}

class _ClusterHomePageState extends State<ClusterHomePage> {
  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(title: Text(widget.cluster.name));

    return Scaffold(
      appBar: appbar,
      body: Container(),
    );
  }
}
