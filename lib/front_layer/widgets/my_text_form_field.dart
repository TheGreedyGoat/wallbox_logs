import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallbox_logs/front_layer/widgets/conditional_wrapper.dart';

enum InputType { text, number }

class MyTextFormField extends StatefulWidget {
  final String? initialValue;
  final String label;
  final String? Function(String? value)? customValidator;
  final void Function(String? value) onSaved;
  final bool isRequired;
  final bool expand;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  final InputType inputType;
  const MyTextFormField({
    required this.label,
    required this.onSaved,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.inputType = InputType.text,
    this.expand = false,
    this.isRequired = false,

    this.maxLength,
    this.customValidator,
    this.initialValue,
    super.key,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool get isRequired => widget.isRequired;
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return _field(context).wrapIf(
      widget.expand,
      (child) => Expanded(child: child),
    );
  }

  Widget _field(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: widget.maxLength,

        inputFormatters: _getInputFormatters(),
        decoration: InputDecoration(
          label: Text('${widget.label!}${isRequired ? '*' : ''}'),
        ),
        controller: controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onSaved: (newValue) => widget.onSaved(
          (newValue == null || newValue.isEmpty) ? null : newValue.trim(),
        ),
        validator: (value) {
          return (isRequired && (value == null || value.isEmpty))
              ? 'erforderlich'
              : (widget.customValidator != null && value != null
                    ? widget.customValidator!(value)
                    : null);
        },
      ),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.inputType) {
      case InputType.text:
        return null;
      case InputType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
    }
  }
}
