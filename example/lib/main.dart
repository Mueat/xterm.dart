import 'package:flutter/material.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xterm.dart demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Terminal terminal;

  @override
  void initState() {
    super.initState();
    terminal = Terminal(
      onInput: onInput,
      maxLines: 10000,
    );
    terminal.write('xterm.dart demo');
    terminal.write('\r\n');
    terminal.write('\$ ');
  }

  void onInput(String input) {
    // in a "real" terminal emulation you would connect onInput to the backend
    // (like a pty or ssh connection) that then handles the changes in the
    // terminal.
    // As we don't have a connected backend here we simulate the changes by
    // directly writing to the terminal.
    if (input == '\r') {
      terminal.write('\r\n');
      terminal.write('\$ ');
    } else if (input.codeUnitAt(0) == 127) {
      terminal.buffer.eraseCharacters(1);
      terminal.buffer.backspace();
      terminal.refresh();
    } else {
      terminal.write(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TerminalView(terminal: terminal),
      ),
    );
  }
}
