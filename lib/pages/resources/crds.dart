import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class CrdsPage extends StatefulWidget {
  final K8zCluster cluster;
  const CrdsPage({super.key, required this.cluster});

  @override
  State<CrdsPage> createState() => _CrdsPageState();
}

class _CrdsPageState extends State<CrdsPage> {
  AbstractSettingsSection buildCrdsList(S lang) {
    return CustomSettingsSection(
      child: FutureBuilder(
        future: () async {
          // await Future.delayed(const Duration(seconds: 1));
          return await K8zService(cluster: widget.cluster).get(
              "/apis/apiextensions.k8s.io/v1/customresourcedefinitions?limit=500");
        }(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var list = [];
          String totals = "";
          Widget title = const Text("");
          Widget trailing = Text(lang.age);

          if (snapshot.connectionState == ConnectionState.waiting) {
            trailing = smallProgressIndicator;
          } else if (snapshot.hasError) {
            talker.error(
              "request events faild, error: ${snapshot.error.toString()}",
            );
            trailing = Tooltip(
              message: snapshot.error.toString(),
              child: Text(lang.error),
            );
          } else {
            final crdsList =
                IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionList
                    .fromJson(snapshot.data.body);

            var crdsItems = crdsList?.items;

            totals = lang.items_number(crdsItems?.length ?? 0);

            if (crdsItems != null) {
              crdsItems.sort(
                (a, b) {
                  if (a.metadata?.creationTimestamp != null &&
                      b.metadata?.creationTimestamp != null) {
                    return b.metadata!.creationTimestamp!
                        .compareTo(a.metadata!.creationTimestamp!);
                  }
                  return 0;
                },
              );
            }
            list = crdsItems?.mapIndexed(
                  (index, crd) {
                    var metadata = crd.metadata;
                    var now = DateTime.now();
                    var creation = metadata?.creationTimestamp ?? now;
                    var age = now.difference(creation).pretty;

                    var spec = crd.spec;
                    var names = spec.names;
                    var shortNames = names.shortNames.join(",");
                    var text = lang.crds_text(
                      metadata?.name ?? "",
                      names.kind,
                      spec.scope,
                      shortNames,
                    );

                    return SettingsTile(
                      title: Text(text, style: smallTextStyle),
                      trailing: Row(
                        children: [
                          Text(age),
                        ],
                      ),
                    );
                  },
                ).toList() ??
                [];
          }

          talker.debug("list ${list.length}");

          return SettingsSection(
            title: Text(lang.crds + totals),
            tiles: [
              SettingsTile.navigation(
                title: title,
                trailing: trailing,
              ),
              ...list,
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.crds)),
      body: Container(
        margin: bottomEdge,
        child: SettingsList(sections: [buildCrdsList(lang)]),
      ),
    );
  }
}
