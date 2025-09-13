import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/services/demo_cluster_service.dart';
import 'package:k8zdev/services/demo_cluster_exception.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:provider/provider.dart';

class ClusterCreatePage extends StatefulWidget {
  final bool hiddenAppBar;
  const ClusterCreatePage({super.key, this.hiddenAppBar = false});

  @override
  State<ClusterCreatePage> createState() => _ClusterCreatePageState();
}

class _ClusterCreatePageState extends State<ClusterCreatePage> {
  bool _isLoadingDemo = false;

  Future<void> _loadDemoCluster() async {
    setState(() {
      _isLoadingDemo = true;
    });

    try {
      final demoCluster = await DemoClusterService.loadDemoCluster();
      
      // 设置为当前集群
      if (mounted) {
        final ccProvider = Provider.of<CurrentCluster>(context, listen: false);
        ccProvider.setCurrent(demoCluster);
      }
      
      // 显示成功消息
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        final router = GoRouter.of(context);
        final lang = S.of(context);
        
        messenger.showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: Colors.green,
            content: Text(lang.demo_cluster_loaded),
          ),
        );
        
        // 导航到集群主页
        router.pushReplacementNamed("cluster_home", extra: demoCluster);
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        final lang = S.of(context);
        
        String errorMessage;
        if (e is DemoClusterException) {
          switch (e.type) {
            case DemoClusterErrorType.networkError:
              errorMessage = lang.demo_cluster_network_error;
              break;
            case DemoClusterErrorType.decryptionError:
              errorMessage = lang.demo_cluster_decrypt_error;
              break;
            default:
              errorMessage = e.message;
          }
        } else {
          errorMessage = e.toString();
        }
        
        messenger.showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: Colors.red,
            content: Text(errorMessage),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDemo = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    AppBar? appBar;
    if (!widget.hiddenAppBar) {
      appBar = AppBar(title: Text(lang.add_cluster));
    }

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: defaultEdge,
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: ListView(
                children: ListTile.divideTiles(
                  color: Colors.black12,
                  tiles: [
                    ListTile(
                      leading: _isLoadingDemo 
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.play_circle_outline, size: 32, color: Colors.green),
                      title: Center(child: Text(lang.load_demo_cluster)),
                      subtitle: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            lang.demo_cluster_description,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      titleAlignment: ListTileTitleAlignment.center,
                      enabled: !_isLoadingDemo,
                      onTap: _isLoadingDemo ? null : _loadDemoCluster,
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_copy, size: 32),
                      title: Center(child: Text(lang.manual_load_kubeconfig)),
                      titleAlignment: ListTileTitleAlignment.center,
                      onTap: () {
                        GoRouter.of(context).pushNamed("manual_load");
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
