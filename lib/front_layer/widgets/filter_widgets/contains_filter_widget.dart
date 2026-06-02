import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContainsFilterWidget extends ConsumerWidget {
  ContainsFilterWidget({
    required this.identifier,
    required this.onChanged,
    super.key,
  });
  final String identifier;
  final void Function(String value) onChanged;

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (value) {
        onChanged(value.trim());
      },
    );
  }
}
