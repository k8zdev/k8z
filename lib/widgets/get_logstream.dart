import 'package:flutter/material.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/terminals.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

const Map<String, int> sinceMap = {
  '5 Minutes': 300,
  '15 Minutes': 900,
  '30 Minutes': 1800,
  '1 Hour': 3600,
  '3 Hours': 10800,
  '6 Hours': 21600,
  '12 Hours': 43200,
  '1 Day': 86400,
  '2 Days': 172800,
  '1 Week': 604800,
  '2 Weeks': 1209600,
  '1 Month': 2592000,
};

class GetLogstream extends StatefulWidget {
  final String name;
  final String namespace;
  final List<String> containers;
  final K8zCluster cluster;

  const GetLogstream({
    super.key,
    required this.name,
    required this.namespace,
    required this.containers,
    required this.cluster,
  });

  @override
  State<GetLogstream> createState() => _GetLogstreamState();
}

class _GetLogstreamState extends State<GetLogstream> {
  int _tail = 100;
  bool _loading = false;
  String _container = '';
  String _since = '5 Minutes';
  final _terminalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _container = widget.containers[0];
  }

  Future<void> _getTerminal(BuildContext context) async {
    try {
      setState(() => _loading = true);
      // check local server is started
      final isStared = await K8zService.isStarted();
      // start local server if not started
      if (!isStared) {
        try {
          await K8zNative.startLocalServer();
        } catch (err) {
          talker.error("start local server failed, error: $err");
          rethrow;
        }
      }

      final socket = IOWebSocketChannel.connect(
        "ws://localhost:29257/stream?name=${widget.name}&namespace=${widget.namespace}&container=$_container&since=${sinceMap[_since]}&tail=$_tail",
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

      // ignore: use_build_context_synchronously
      var tp = Provider.of<TerminalProvider>(context, listen: false);
      tp.add(
        "${widget.name}/$_container",
        TerminalType.stream,
        stream: StreamBackend(socket),
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
                  Text(lang.since),
                  DropdownButton(
                    value: _since,
                    underline: Container(height: 2),
                    onChanged: (String? value) {
                      setState(() {
                        _since = value ?? '5 Minutes';
                      });
                    },
                    items: sinceMap.entries.map((value) {
                      return DropdownMenuItem(
                        value: value.key,
                        child: Text(value.key),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            //
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(lang.tail_lines),
                  DropdownButton(
                      value: _tail,
                      underline: Container(height: 2),
                      onChanged: (int? value) {
                        setState(() {
                          _tail = value ?? 100;
                        });
                      },
                      items: [
                        100,
                        300,
                        500,
                        700,
                        900,
                        1000,
                      ].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList()),
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
