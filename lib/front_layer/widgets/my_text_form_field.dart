import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_input_formatter/text_input_formatter.dart';
import 'package:wallbox_logs/front_layer/widgets/conditional_wrapper.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';

/// presets for the FormField
enum InputType {
  /// plain text
  text,

  /// integers only
  integer,

  // double
  double,
}

/// a custom wrapper for a TextFormField to keep a coherent style etc.
class MyTextFormField extends StatefulWidget {
  /// The TextFormFields initialValue
  final String? initialValue;

  /// The TextFormFields label
  final String label;

  final bool markEdited;

  /// set to add additional validation logic.
  /// => should return null if value is valid, else an error message
  final String? Function(String? value)? customValidator;

  /// set to add additional logic when saving the form.
  final void Function(String? value) onSaved;

  /// if set to true, the field cannot contain null or an empy String on submitting the form
  final bool isRequired;

  /// set to true to wrap the Field in an expanded-Widget
  final bool wrapWithExpanded;

  /// optionally set a maximum number of characters in this field
  final int? characterLimit;

  /// tracks changes in the field
  final TextEditingController? controller;

  /// an optional [FocusNode] object. Needed if the Textformfield is used within a TypeAheadString
  final FocusNode? focusNode;

  /// if true, the field will be focused initially
  final bool autofocus;

  /// preset
  final InputType inputType;

  /// a custom wrapper for a TextFormField to keep a coherent style etc.
  const MyTextFormField({
    required this.label,
    required this.onSaved,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.inputType = InputType.text,
    this.wrapWithExpanded = false,
    this.isRequired = false,

    this.characterLimit,
    this.markEdited = true,
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
  late final TextInputFormatter? _formatter;
  bool hasChanged = false;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _formatter = _getInputFormatter();

    print('initial: ${widget.initialValue}');
  }

  @override
  Widget build(BuildContext context) {
    return _field(context).wrapIf(
      widget.wrapWithExpanded,
      (child) => Expanded(child: child),
    );
  }

  Widget _field(BuildContext context) {
    return InputFieldDecoration(
      markEdited: widget.markEdited,
      hasChanged: hasChanged,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: TextFormField(
          maxLength: widget.characterLimit,

          inputFormatters: _formatter != null ? [_formatter] : null,
          decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            label: Text(
              '${widget.label}${isRequired ? '*' : ''}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          controller: controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onChanged: (value) {
            setState(() {
              hasChanged = true;
            });
          },
          onSaved: (newValue) {
            widget.onSaved(
              (newValue == null || newValue.isEmpty) ? null : newValue.trim(),
            );
            setState(() {
              hasChanged = false;
            });
          },
          validator: (value) {
            return (isRequired && (value == null || value.isEmpty))
                ? 'erforderlich'
                : (widget.customValidator != null && value != null
                      ? widget.customValidator!(value)
                      : null);
          },
        ),
      ),
    );
  }

  TextInputFormatter? _getInputFormatter() {
    switch (widget.inputType) {
      case InputType.text:
        return null;
      case InputType.integer:
        return FilteringTextInputFormatter.digitsOnly;
      case InputType.double:
        return NumericFormatter(
          allowFraction: true,
          fractionDigits: 2,
          thousandSeparator: ' ',
        );
    }
  }
}
