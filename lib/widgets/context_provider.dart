import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/providers/current_cluster.dart';

/// 上下文提供器 Widget
/// 负责为各种 Provider 设置当前的 BuildContext，以便它们能够处理标题更新
class ContextProvider extends StatefulWidget {
  final Widget child;

  const ContextProvider({
    super.key,
    required this.child,
  });

  @override
  State<ContextProvider> createState() => _ContextProviderState();
}

class _ContextProviderState extends State<ContextProvider> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // 为各种 Provider 设置当前上下文
    _updateProviderContexts();
  }

  void _updateProviderContexts() {
    try {
      // 为语言 Provider 设置上下文
      final localeProvider = Provider.of<CurrentLocale>(context, listen: false);
      localeProvider.setCurrentContext(context);

      // 为集群 Provider 设置上下文
      final clusterProvider = Provider.of<CurrentCluster>(context, listen: false);
      clusterProvider.setCurrentContext(context);
    } catch (e) {
      debugPrint('ContextProvider: Error setting provider contexts - $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}