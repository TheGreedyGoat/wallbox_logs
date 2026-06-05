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
    super.key,
  });
  final String? label;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<MyTextField> createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return InputFieldDecoration(
      backgroundColor: widget.backgroundColor,
      child: TextField(
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
