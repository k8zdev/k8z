import 'package:flutter/material.dart';
import 'package:k8zdev/common/helpers.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/common/types.dart';
import 'package:k8zdev/dao/kube.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:k8zdev/services/k8z_native.dart';
import 'package:k8zdev/services/k8z_service.dart';
import 'package:k8zdev/widgets/terminals.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class GetTerminal extends StatefulWidget {
  final String name;
  final String namespace;
  final List<String> containers;
  final K8zCluster cluster;
  final String nodeName;
  final String workingDir;
  final ShellType shellType;
  final List<String> startCmd;
  final Map<String, dynamic> extraHeaders;

  /// Create a [GetTerminal] widget.
  /// ## examle:
  /// ### nodeshell:
  /// ```dart
  /// GetTerminal(
  ///   name: "k8z-node-shell-${nodeName}",
  ///   namespace: "",
  ///   containers: [nodeName],
  ///   cluster: cluster,
  ///   nodeName: nodeName,
  ///   shellType: ShellType.node,
  ///   startCmd: const ["sleep", "604800"], // 7 days
  /// ),
  /// ```
  /// ### debugshell:
  /// ```dart
  /// GetTerminal(
  ///   name: "k8z-debug-${sid()}",
  ///   namespace: "k8z-debug",
  ///   containers: ["k8z-debug-${sid()}"],
  ///   cluster: cluster,
  ///   shellType: ShellType.debug,
  ///   startCmd: const ["sleep", "604800"], // 7 days
  /// ),
  /// ```
  ///
  const GetTerminal({
    super.key,
    required this.name,
    required this.namespace,
    required this.containers,
    required this.cluster,
    this.nodeName = "",
    this.workingDir = "",
    this.shellType = ShellType.pod,
    this.startCmd = const ["sleep", "604800"], // 7 days
    this.extraHeaders = const {},
  });

  @override
  State<GetTerminal> createState() => _GetTerminalState();
}

class _GetTerminalState extends State<GetTerminal> {
  String _container = '';
  String _shell = 'zsh';
  bool _loading = false;
  String _image = "busybox";
  final _terminalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    switch (widget.shellType) {
      case ShellType.debug:
        _shell = 'sh';
        _image = "alpine:3.14.2";
        _container = 'k8z-debug-${sid()}';
        break;
      case ShellType.node:
        _shell = 'bash';
        _image = "alpine:3.14.2";
        _container = widget.nodeName;
        break;
      default:
        _shell = 'zsh';
        _image = "alpine:3.14.2";
        _container = widget.containers[0];
    }
  }

  Future<void> _getTerminal(BuildContext context) async {
    logEvent("getTerminal", parameters: {"type": widget.shellType.name});
    var timeout = Provider.of<TimeoutProvider>(context, listen: false);
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

      var headers = <String, dynamic>{
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
        'X-IMAGE': _image,
        'X-TIMEOUT': timeout.timeout,
        'X-START-CMD': widget.startCmd,
        "X-WORKING-DIR": widget.workingDir,
        "X-SHELL-TYPE": widget.shellType.name,
      };

      headers.addAll(widget.extraHeaders);

      final socket = IOWebSocketChannel.connect(
        "ws://127.0.0.1:29257/shell?name=${widget.name}&namespace=${widget.namespace}&container=$_container&shell=$_shell",
        headers: headers,
      );

      // ignore: use_build_context_synchronously
      var tp = Provider.of<TerminalProvider>(context, listen: false);
      tp.add(
        "${widget.name}/$_container",
        TerminalType.terminal,
        terminal: TerminalBackend(socket),
      );

      setState(() => _loading = false);

      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
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
    talker.debug(
        "containers: ${widget.containers}, nodeName: ${widget.nodeName}, shellType: ${widget.shellType}");

    switch (widget.shellType) {
      case ShellType.debug:
        return _debugShellForm(context);
      case ShellType.node:
        return _nodeShellForm(context);
      default:
        return _podShellForm(context);
    }
  }

  Widget _nodeShellForm(BuildContext context) {
    final lang = S.of(context);
    return Container(
      margin: defaultEdge,
      child: Form(
        child: ListView(
          shrinkWrap: false,
          children: [
            Center(
              child: Text(
                lang.start_debug,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Center(
              child: Text(lang.start_debug_desc, style: smallTextStyle),
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

  Widget _debugShellForm(BuildContext context) {
    final lang = S.of(context);
    return Container(
      margin: defaultEdge,
      child: Form(
        child: ListView(
          shrinkWrap: false,
          children: [
            Center(
              child: Text(
                lang.start_debug,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Center(
              child: Text(lang.start_debug_desc, style: smallTextStyle),
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

  Widget _podShellForm(BuildContext context) {
    final lang = S.of(context);
    final items = widget.containers.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
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
                      'zsh',
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
