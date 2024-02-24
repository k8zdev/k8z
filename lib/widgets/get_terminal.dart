import 'package:flutter/material.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/widgets/terminals.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class GetTerminal extends StatefulWidget {
  final String name;
  final String namespace;
  final List<String> containers;
  final K8zCluster cluster;

  const GetTerminal({
    super.key,
    required this.name,
    required this.namespace,
    required this.containers,
    required this.cluster,
  });

  @override
  State<GetTerminal> createState() => _GetTerminalState();
}

class _GetTerminalState extends State<GetTerminal> {
  String _container = '';
  String _shell = 'sh';
  bool _loading = false;
  final _terminalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _container = widget.containers[0];
  }

  Future<void> _getTerminal(BuildContext context) async {
    try {
      setState(() => _loading = true);
      final socket = IOWebSocketChannel.connect(
        "ws://127.0.0.1:29257/ws?name=${widget.name}&namespace=${widget.namespace}&container=$_container&shell=$_shell",
        headers: <String, dynamic>{
          'X-CONTEXT-NAME': widget.cluster.name,
          'X-CLUSTER-SERVER': widget.cluster.server,
          'X-CLUSTER-CA-DATA': widget.cluster.caData,
          'X-CLUSTER-INSECURE': '${widget.cluster.insecure}',
          'X-USER-CERT-DATA': widget.cluster.clientCert,
          'X-USER-KEY-DATA': widget.cluster.clientKey,
          'X-USER-TOKEN': widget.cluster.token,
          'X-USER-USERNAME': widget.cluster.username,
          'X-USER-PASSWORD': widget.cluster.password,
          'X-PROXY': "",
          'X-TIMEOUT': 3,
        },
      );

      var tp = Provider.of<TerminalProvider>(context, listen: false);
      tp.add(
        "${widget.name}/$_container",
        TerminalType.terminal,
        terminal: TerminalBackend(socket),
      );

      setState(() => _loading = false);

      if (mounted) {
        Navigator.pop(context);
        showTerminals(context);
      }
    } catch (err) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          content: Text(err.toString()),
        ),
      );
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.containers.map((value) {
      talker.warning("value: $value");
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
    talker.debug("containers: ${widget.containers}, len: ${items.length}");

    var lang = S.of(context);
    return Container(
      margin: defaultEdge,
      child: Form(
        key: _terminalFormKey,
        child: ListView(
          shrinkWrap: false,
          children: [
            Center(
              child: Text(
                Characters(widget.name)
                    .replaceAll(Characters(''), Characters('\u{200B}'))
                    .toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(lang.container),
                  DropdownButton<String>(
                    value: _container,
                    underline: Container(height: 2),
                    onChanged: (String? value) {
                      setState(() {
                        _container = value ?? '';
                      });
                    },
                    items: items,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Shell'),
                  DropdownButton(
                    value: _shell,
                    underline: Container(height: 2),
                    onChanged: (String? value) {
                      setState(() {
                        _shell = value ?? 'sh';
                      });
                    },
                    items: [
                      'sh',
                      'bash',
                      'pwsh',
                      'cmd',
                    ].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const Divider(height: 10, color: Colors.transparent),
            //
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _loading ? null : () => _getTerminal(context),
                child: Text(lang.get_terminal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
