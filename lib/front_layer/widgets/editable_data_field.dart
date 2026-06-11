// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/my_text_field.dart';
import 'package:wallbox_logs/front_layer/widgets/labeled_field.dart';

class EditableDataField extends StatefulWidget {
  const EditableDataField({
    required this.label,
    required this.initialValue,
    this.unit,
    required this.onSaved,
    this.inputFormatters,
    super.key,
  });
  final String label;
  final String initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final String? unit;
  final void Function(String value) onSaved;
  @override
  State<EditableDataField> createState() => _EditableDataFieldState();
}

class _EditableDataFieldState extends State<EditableDataField> {
  bool edit = false;
  String get initialValue => widget.initialValue;

  late String value;
  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      height: 50,
      widthLeft: 150,
      widthPerChild: 200,
      widthRight: 50 * (edit ? 2 : 1),
      label: widget.label,

      surfaceColor: Theme.of(context).colorScheme.primary,
      borderColor: Theme.of(context).colorScheme.onPrimary,
      children: [
        Center(
          child: edit
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: MyTextField(
                          initialValue: widget.initialValue,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          inputFormatters: widget.inputFormatters,
                          onChanged: (p0) {
                            setState(() {
                              value = p0;
                            });
                          },
                        ),
                      ),

                      if (widget.unit != null)
                        Text(
                          widget.unit!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                        ),
                    ],
                  ),
                )
              : Text(
                  '${widget.initialValue} ${widget.unit ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
        ),
      ],
      right: edit
          ? Row(
              children: [
                IconButton.filled(
                  onPressed: () {
                    setState(() {
                      edit = false;
                    });
                  },
                  icon: Icon(Icons.cancel_sharp),
                ),
                IconButton.filled(
                  onPressed: () {
                    widget.onSaved(value);
                    setState(() {
                      edit = false;
                    });
                  },
                  icon: Icon(Icons.save_sharp),
                ),
              ],
            )
          : IconButton.filled(
              onPressed: () {
                setState(() {
                  edit = true;
                });
              },
              icon: Icon(Icons.edit),
              iconSize: 20,
            ),
    );
  }
}
