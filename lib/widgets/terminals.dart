import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:k8zdev/common/styles.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/terminals.dart';
import 'package:k8zdev/services/analytics_service.dart';
import 'package:k8zdev/widgets/virtual_keyboard.dart';
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
  AnalyticsService.logEvent(
    eventName: 'terminals_show',
  );
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

    final size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final height = size.height * (isKeyboardVisible ? 1 : 0.85);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        minHeight: 400,
        minWidth: width,
        maxHeight: height,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          // panels
          Flexible(
            child: DefaultTabController(
              length: terms.terminals.length,
              child: Column(
                children: [
                  // tabbar
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
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
                                  Navigator.pop(context);
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

                  //

                  // panel
                  Expanded(
                    child: TabBarView(
                      children: terms.terminals
                          .asMap()
                          .entries
                          .mapIndexed((idx, terminal) {
                        if (terminal.value.terminal != null) {
                          if (terminal.value.type == TerminalType.terminal) {
                            final keyboardView = VirtualKeyboardView(
                                terms.terminals[idx].terminal!.keyboard,
                                terminal.value.terminal!.terminal);
                            final terminalView = xtermui.TerminalView(
                              terminal.value.terminal!.terminal,
                              textStyle: xterm.TerminalStyle(
                                fontSize: 14,
                                height: 1.2,
                                fontFamily: getMonospaceFontFamily(),
                              ),
                              deleteDetection: true,
                            );
                            return Container(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  keyboardView,
                                  Expanded(child: terminalView)
                                ],
                              ),
                            );
                          }
                        }
                        if (terminal.value.type == TerminalType.stream) {
                          return Center(
                            child: xtermui.TerminalView(
                              terminal.value.stream!.terminal,
                              textStyle: xterm.TerminalStyle(
                                fontSize: 14,
                                fontFamily: getMonospaceFontFamily(),
                              ),
                              readOnly: true,
                            ),
                          );
                        }
                        return Center(
                          child: Text(terminal.value.name),
                        );
                      }).toList(),
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
