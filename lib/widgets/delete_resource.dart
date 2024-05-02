import 'package:flutter/material.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class DeleteResource extends StatefulWidget {
  final String name;
  final String itemUrl;
  final String resource;
  final String namespace;
  final K8zCluster cluster;

  const DeleteResource({
    super.key,
    required this.name,
    required this.itemUrl,
    required this.resource,
    required this.namespace,
    required this.cluster,
  });

  @override
  State<DeleteResource> createState() => _DeleteResourceState();
}

class _DeleteResourceState extends State<DeleteResource> {
  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return SizedBox(
      child: SettingsList(
        contentPadding: EdgeInsets.zero,
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(title: Center(child: Text(lang.delete_resource))),
              SettingsTile(
                title: Text(lang.namespace),
                value: Text(widget.namespace, style: tileValueStyle),
              ),
              SettingsTile(
                title: Text(lang.resources),
                value: Text(widget.resource, style: tileValueStyle),
              ),
              SettingsTile(
                title: Text(lang.name),
                value: Text(widget.name, style: tileValueStyle),
              ),
              SettingsTile(
                title: Text(lang.resource_url),
                value: maxWidthText(
                  context,
                  widget.itemUrl,
                  rate: 0.6,
                  maxWidth: 400,
                  hpyhenationg: false,
                ),
              ),
              SettingsTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.cancel, color: Colors.grey),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text(
                        lang.cancel,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                      label: Text(lang.delete),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
