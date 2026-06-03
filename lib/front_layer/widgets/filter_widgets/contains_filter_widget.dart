import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';

class ContainsFilterWidget extends ConsumerWidget {
  ContainsFilterWidget({
    required this.identifier,
    required this.onChanged,
    super.key,
  });
  final String identifier;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputFieldDecoration(
      child: TextField(
        decoration: InputDecoration(
          hint: Text('Filter'),
          // label: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text('Filter'),
          // ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        onChanged: (value) {
          onChanged(value.trim());
        },
      ),
    );
  }
}
