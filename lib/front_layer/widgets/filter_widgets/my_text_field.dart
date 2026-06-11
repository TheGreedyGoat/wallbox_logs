import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    this.label,
    this.onChanged,
    this.inputFormatters,
    this.backgroundColor,
    this.foregroundColor,
    this.initialValue,
    super.key,
  });
  final String? label;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final String? initialValue;

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return InputFieldDecoration(
      backgroundColor: widget.backgroundColor,
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          label: Text(
            widget.label ?? '',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: widget.foregroundColor),
          ),
          border: OutlineInputBorder(),
          fillColor: widget.backgroundColor,
        ),
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: widget.foregroundColor),
        inputFormatters: widget.inputFormatters,
        // [
        //   FilteringTextInputFormatter.allow(RegExp(r'\d+')),
        // ],
        onChanged: widget.onChanged,
      ),
    );
  }
}
