import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';

class ClusterCreatePage extends StatefulWidget {
  final bool hiddenAppBar;
  const ClusterCreatePage({super.key, this.hiddenAppBar = false});

  @override
  State<ClusterCreatePage> createState() => _ClusterCreatePageState();
}

class _ClusterCreatePageState extends State<ClusterCreatePage> {
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
              height: 300,
              child: ListView(
                children: ListTile.divideTiles(
                  color: Colors.black12,
                  tiles: [
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
