import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:provider/provider.dart';
import 'package:xterm/ui.dart' as xtermui;
import 'package:xterm/xterm.dart' as xterm;

Widget floatingActionButton(BuildContext context) {
  return FloatingActionButton.small(
    onPressed: () => showTerminals(context),
    backgroundColor: Colors.teal,
    child: const Icon(Icons.terminal),
  );
}

void showTerminals(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    showDragHandle: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return const TerminalPanel();
    },
  );
}

class TerminalPanel extends StatefulWidget {
  const TerminalPanel({super.key});

  @override
  State<TerminalPanel> createState() => _TerminalPanelState();
}

class _TerminalPanelState extends State<TerminalPanel> {
  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final terms = Provider.of<TerminalProvider>(context, listen: true);

    MediaQuery.of(context).size.height * (isKeyboardVisible ? 1 : 0.8);

    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          Flexible(
            child: DefaultTabController(
              length: terms.terminals.length,
              child: Column(
                children: [
                  // info
                  Container(
                    padding: defaultEdge,
                    child: Row(
                      children: [
                        const Icon(Icons.terminal),
                        Text(lang.terminals_opened(terms.terminals.length))
                      ],
                    ),
                  ),
                  // tabbar
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(3),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black54,
                      indicatorColor: Colors.black87,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: terms.terminals.asMap().entries.mapIndexed(
                        (idx, terminal) {
                          return Tab(
                            child: GestureDetector(
                              onDoubleTap: () {
                                terms.rm(terminal.key);
                                if (terms.terminals.isEmpty) {
                                  context.pop();
                                }
                              },
                              child: Text(
                                terminal.value.name,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  const Divider(height: 10),
                  // panel
                  Expanded(
                    child: TabBarView(
                      children: terms.terminals.asMap().entries.mapIndexed(
                        (index, terminal) {
                          if (terminal.value.terminal != null &&
                              terminal.value.type == TerminalType.terminal) {
                            return xtermui.TerminalView(
                              terminal.value.terminal!.terminal,
                              textStyle: xterm.TerminalStyle(
                                fontSize: 14,
                                fontFamily: getMonospaceFontFamily(),
                              ),
                            );
                          }
                          return Container();
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
