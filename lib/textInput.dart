import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textInput extends StatefulWidget {
  final void Function(String) updateFunction;
  final String textLabel;

  const textInput(
      {super.key, required this.updateFunction, required this.textLabel});

  @override
  State<StatefulWidget> createState() {
    return _textInput();
  }
}

class _textInput extends State<textInput> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(labelText: widget.textLabel),
        controller: textController,
        onChanged: widget.updateFunction);
  }
}
