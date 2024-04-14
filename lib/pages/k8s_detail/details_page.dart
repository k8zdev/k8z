import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/models/models.dart';
import 'package:k8zdev/providers/current_cluster.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/modal.dart';
import 'package:kubeconfig/kubeconfig.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:simple_tags/simple_tags.dart';

enum Actions {
  delete,
  more,
  scale,
  restart,
  yaml,
}

mapAtcions(String resource) {
  switch (resource) {
    // case "helm_releases":
    // case "endpoints":
    // case "ingresses":
    // case "services":
    // case "configmaps":
    // case "secrets":
    // case "serviceaccounts":
    // case "crds":
    // case "events":
    // case "namespaces":
    // case "nodes":
    // case "pvcs":
    // case "pvs":
    // case "storageclass":
    case "daemonsets":
      return [Actions.delete, Actions.scale, Actions.yaml];
    case "deployments":
      return [Actions.delete, Actions.scale, Actions.yaml];
    // case "pods":
    case "statefulsets":
      return [Actions.delete, Actions.scale, Actions.yaml];
    default:
      return [Actions.delete, Actions.yaml];
  }
}

class ResourceDetailsPage extends StatefulWidget {
  // /apis/apps/v1/namespaces/example_ns/deployments/app-10010
  final String title;
  final String path; // e.g. /apis/apps/v1/
  final String? namespace; // e.g. example_ns
  final String resource; // e.g. deployments
  final String name; // e.g. app-10010
  const ResourceDetailsPage({
    super.key,
    this.title = "-",
    required this.path,
    this.namespace,
    required this.resource,
    required this.name,
  });

  @override
  State<ResourceDetailsPage> createState() => _ResourceDetailsPageState();
}

class _ResourceDetailsPageState extends State<ResourceDetailsPage> {
  late String langCode;
  late K8zCluster? cluster;
  late String itemUrl;
  late Future<JsonReturn> _futureFetchItem;

  @override
  void initState() {
    cluster = Provider.of<CurrentCluster>(context, listen: false).current;
    langCode = Provider.of<CurrentLocale>(context, listen: false)
            .locale
            ?.languageCode ??
        "en";
    itemUrl = widget.namespace.isNullOrEmpty
        ? '${widget.path}/${widget.resource}/${widget.name}'
        : '${widget.path}/namespaces/${widget.namespace}/${widget.resource}/${widget.name}';
    talker.debug("item url: $itemUrl");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _futureFetchItem = _fetchItem();
    });
  }

  leadingText(String label) {
    late double len;
    switch (langCode) {
      case "zh":
        len = 32;
      default:
        len = 52;
    }
    return SizedBox(
      width: len,
      child: AutoHyphenatingText(
        label,
      ),
    );
  }

  Widget scaleWidget(int replicas) {
    var except = replicas;
    final lang = S.of(context);
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Column(
          children: [
            NumberPicker(
              value: except,
              minValue: 0,
              maxValue: 200,
              step: 1,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: (value) => setState(() => except = value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),

            const Divider(height: 20, color: Colors.transparent),

            // buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.exposure_zero),
                  onPressed: () => setState(() {
                    except = 0;
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = except - 1;
                    except = newValue.clamp(0, 200);
                  }),
                ),
                Text(lang.scale_to(except)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = except + 1;
                    except = newValue.clamp(0, 200);
                  }),
                ),
              ],
            ),

            // apply
            const Divider(height: 20, color: Colors.transparent),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.done),
                label: Text(lang.apply),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> getActions(S lang, List<Actions>? actions, JsonReturn resp) {
    final map = {
      Actions.yaml: TextButton(
        onPressed: () {
          GoRouter.of(context).pushNamed(
            "details_yaml",
            extra: resp,
            pathParameters: {
              "file": "${widget.namespace}_${widget.resource}_${widget.name}",
              "itemUrl": itemUrl,
            },
          );
        },
        child: const Column(
          children: [
            Icon(Icons.edit_note),
            Text("Yaml"),
          ],
        ),
      ),
      Actions.restart: const TextButton(
        onPressed: null,
        child: Column(
          children: [
            Icon(Icons.restart_alt),
            Text("Restart"),
          ],
        ),
      ),
      Actions.delete: const TextButton(
        onPressed: null,
        child: Column(
          children: [
            Icon(Icons.delete),
            Text("Delete"),
          ],
        ),
      ),
      Actions.scale: TextButton(
        onPressed: () {
          showModal(
            context,
            scaleWidget(resp.body["spec"]["replicas"]),
            minHeight: 200,
          );
        },
        child: Column(
          children: [
            const Icon(Icons.add_circle_sharp),
            Text(lang.scale),
          ],
        ),
      ),
      Actions.more: TextButton(
        onPressed: null,
        child: Column(
          children: [
            const Icon(Icons.more_horiz),
            Text(lang.more),
          ],
        ),
      ),
    };
    List<Widget> list = [];

    actions?.forEach((action) {
      list.add(map[action] ?? Container());
    });

    return list;
  }

  Future<JsonReturn> _fetchItem() async {
    if (!mounted) {
      talker.error("null mounted");
      return JsonReturn(body: {}, error: "", duration: Duration.zero);
    }

    if (cluster == null) {
      talker.error("null cluster");
      return JsonReturn(body: {}, error: "", duration: Duration.zero);
    }

    return await K8zService(context, cluster: cluster!).get(itemUrl);
  }

  tags(List<String> list) {
    return SimpleTags(
      content: list,
      wrapSpacing: 1,
      wrapRunSpacing: 1,
      tagContainerMargin: const EdgeInsets.only(top: 6, left: 3),
      tagContainerPadding:
          const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      tagTextStyle: const TextStyle(
        color: Colors.green,
        fontSize: 11,
      ),
      // tagIcon: Icon(
      //   Icons.copy_outlined,
      //   size: 12,
      //   color: Colors.green,
      // ),
      tagContainerDecoration: BoxDecoration(
        color: Colors.green.withOpacity(.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(11),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(139, 139, 142, 0.16),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1.75, 3.5), // c
          )
        ],
      ),
    );
  }

  buildMetaSection(S lang, IoK8sApimachineryPkgApisMetaV1ObjectMeta metadata,
      JsonReturn resp) {
    final labels = metadata.labels.entries.mapIndexed((index, element) {
      return "${element.key}=${element.value}";
    }).toList();
    labels.sort((a, b) => a.length.compareTo(b.length));

    final annotations =
        metadata.annotations.entries.mapIndexed((index, element) {
      return "${element.key}=${element.value}";
    }).toList();
    annotations.sort((a, b) => a.length.compareTo(b.length));

    return SettingsSection(
      title: Text(lang.metadata),
      tiles: [
        SettingsTile(
          title: CustomSettingsTile(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getActions(lang, mapAtcions(widget.resource), resp),
            ),
          ),
        ),
        SettingsTile(
          leading: leadingText(lang.name),
          title: Text(metadata.name ?? ""),
        ),
        if (!metadata.namespace.isNullOrEmpty)
          SettingsTile(
            leading: leadingText(lang.namespace),
            title: Text(metadata.namespace ?? ""),
          ),
        SettingsTile(
          leading: leadingText(lang.labels),
          title: tags(labels),
        ),
        SettingsTile(
          leading: leadingText(lang.annotations),
          title: tags(annotations),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title != ""
            ? widget.title
            : "${widget.resource}/${widget.name}"),
      ),
      body: Container(
        margin: bottomEdge,
        child: FutureBuilder(
          future: _futureFetchItem,
          builder: (BuildContext context, AsyncSnapshot<JsonReturn> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final data = snapshot.data;
                talker.debug(
                    "error: ${data?.error}, item data size: ${data?.body.length}");
                final metadata =
                    IoK8sApimachineryPkgApisMetaV1ObjectMeta.fromJson(
                        data!.body["metadata"]);
                talker.debug("metadata: ${metadata?.annotations}");

                if (!data.error.isNullOrEmpty) {
                  return Center(
                    child: Text(data.error),
                  );
                }
                return SettingsList(
                  sections: [
                    buildMetaSection(lang, metadata!, data),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
