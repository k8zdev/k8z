import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart' as xterm;
import 'package:web_socket_channel/io.dart';
import 'package:xterm/core.dart' as xtermcore;

class TerminalProvider with ChangeNotifier {
  final List<Terminal> _terminals = [];

  List<Terminal> get terminals => _terminals;

  void add(
    String name,
    TerminalType type, {
    List<dynamic>? logs,
    StreamBackend? stream,
    TerminalBackend? terminal,
  }) {
    _terminals.add(Terminal(
      name: name,
      type: type,
      logs: logs,
      stream: stream,
      terminal: terminal,
    ));
    notifyListeners();
  }

  void rm(int idx) {
    final t = _terminals[idx];
    if (t.stream != null) {
      t.stream?.terminate();
    }
    if (t.terminal != null) {
      t.terminal?.terminate();
    }
    _terminals.removeAt(idx);
    notifyListeners();
  }
}

enum TerminalType {
  logs,
  stream,
  terminal,
}

class Terminal {
  String name;
  TerminalType type;
  List<dynamic>? logs;
  StreamBackend? stream;
  TerminalBackend? terminal;

  Terminal({
    required this.name,
    required this.type,
    this.logs,
    this.stream,
    this.terminal,
  });
}

class TerminalData {
  String op;
  String data;
  int rows;
  int cols;

  TerminalData({
    required this.op,
    required this.data,
    required this.rows,
    required this.cols,
  });

  factory TerminalData.fromJson(Map<String, dynamic> json) {
    return TerminalData(
      op: json["Op"],
      data: json["Data"],
      rows: json["Rows"],
      cols: json["Cols"],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "Op": op,
      "Data": data,
      "Rows": rows,
      "Cols": cols,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class StreamBackend {
  late xterm.Terminal terminal;
  late IOWebSocketChannel socket;

  StreamBackend(IOWebSocketChannel sc) {
    socket = sc;
    terminal = xterm.Terminal(
      maxLines: 10000,
      platform: Platform.isAndroid
          ? xtermcore.TerminalTargetPlatform.android
          : Platform.isIOS
              ? xtermcore.TerminalTargetPlatform.ios
              : Platform.isMacOS
                  ? xtermcore.TerminalTargetPlatform.macos
                  : Platform.isLinux
                      ? xtermcore.TerminalTargetPlatform.linux
                      : Platform.isWindows
                          ? xtermcore.TerminalTargetPlatform.windows
                          : xtermcore.TerminalTargetPlatform.unknown,
    );

    socket.stream.listen(
      (data) {
        terminal.write('$data\n\r\n\r');
      },
      onError: (error) {
        terminal.write('Error: $error');
      },
      onDone: () {
        terminal.write('The process exited');
      },
    );
  }

  void terminate() {
    socket.sink.close();
  }
}

class TerminalBackend {
  late xterm.Terminal terminal;
  late IOWebSocketChannel socket;

  TerminalBackend(IOWebSocketChannel sc) {
    socket = sc;
    terminal = xterm.Terminal(
      maxLines: 10000,
      platform: Platform.isAndroid
          ? xtermcore.TerminalTargetPlatform.android
          : Platform.isIOS
              ? xtermcore.TerminalTargetPlatform.ios
              : Platform.isMacOS
                  ? xtermcore.TerminalTargetPlatform.macos
                  : Platform.isLinux
                      ? xtermcore.TerminalTargetPlatform.linux
                      : Platform.isWindows
                          ? xtermcore.TerminalTargetPlatform.windows
                          : xtermcore.TerminalTargetPlatform.unknown,
    );

    socket.stream.listen(
      (event) {
        final parsedData = TerminalData.fromJson(json.decode(event));
        terminal.write(parsedData.data);
      },
      onError: (error) {
        terminal.write('Error: $error');
      },
      onDone: () {
        terminal.write('The process exited');
      },
    );

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      socket.sink.add(
        TerminalData(
          op: 'resize',
          data: '',
          rows: height,
          cols: width,
        ).toString(),
      );
    };

    terminal.onOutput = (data) {
      socket.sink.add(
        TerminalData(
          op: 'stdin',
          data: data,
          rows: 0,
          cols: 0,
        ).toString(),
      );
    };
  }

  void terminate() {
    socket.sink.close();
  }
}
