import 'package:flutter/material.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:xterm/xterm.dart';

class VirtualKeyboardView extends StatelessWidget {
  const VirtualKeyboardView(this.keyboard, this.terminal, {super.key});

  final VirtualKeyboard keyboard;
  final Terminal terminal;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: keyboard,
      builder: (context, child) => ToggleButtons(
        isSelected: [
          keyboard.ctrl,
          keyboard.alt,
          keyboard.shift,
          false,
          false,
          false,
          false,
          false
        ],
        onPressed: (index) {
          switch (index) {
            case 0:
              keyboard.ctrl = !keyboard.ctrl;
              break;
            case 1:
              keyboard.alt = !keyboard.alt;
              break;
            case 2:
              keyboard.shift = !keyboard.shift;
              break;
            case 3:
              keyboard.ctrl = false;
              keyboard.alt = false;
              keyboard.shift = false;
              terminal.keyInput(TerminalKey.backspace);
              break;
            case 4:
              keyboard.ctrl = false;
              keyboard.alt = false;
              keyboard.shift = false;
              terminal.keyInput(TerminalKey.arrowLeft);
              break;
            case 5:
              keyboard.ctrl = false;
              keyboard.alt = false;
              keyboard.shift = false;
              terminal.keyInput(TerminalKey.arrowUp);
              break;
            case 6:
              keyboard.ctrl = false;
              keyboard.alt = false;
              keyboard.shift = false;
              terminal.keyInput(TerminalKey.arrowDown);
              break;
            case 7:
              keyboard.ctrl = false;
              keyboard.alt = false;
              keyboard.shift = false;
              terminal.keyInput(TerminalKey.arrowRight);
              break;
          }
        },
        children: const [
          Text('Ctrl'),
          Text('Alt'),
          Text('Shift'),
          Text('Delete'),
          Text('←'),
          Text('↑'),
          Text('↓'),
          Text('→'),
        ],
      ),
    );
  }
}

class VirtualKeyboard extends TerminalInputHandler with ChangeNotifier {
  final TerminalInputHandler inputHandler;

  VirtualKeyboard(this.inputHandler);

  bool _ctrl = false;

  bool get ctrl => _ctrl;

  set ctrl(bool value) {
    if (_ctrl != value) {
      _ctrl = value;
      notifyListeners();
    }
  }

  bool _shift = false;

  bool get shift => _shift;

  set shift(bool value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  bool _alt = false;

  bool get alt => _alt;

  set alt(bool value) {
    if (_alt != value) {
      _alt = value;
      notifyListeners();
    }
  }

  @override
  String? call(TerminalKeyboardEvent event) {
    talker.warning(
        "key: ${event.key.toString()} ${event.state}, ctrl: ${event.ctrl}, shift: ${event.shift}, alt: ${event.alt}");
    return inputHandler.call(event.copyWith(
      ctrl: event.ctrl || _ctrl,
      shift: event.shift || _shift,
      alt: event.alt || _alt,
    ));
  }
}
