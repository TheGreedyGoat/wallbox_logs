import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberRangeFilterWidget extends ConsumerWidget {
  NumberRangeFilterWidget({
    super.key,
    this.onFromChanged,
    this.onToChanged,
  });

  final void Function(String value)? onFromChanged;
  final void Function(String value)? onToChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}|^$'),
                ),
              ],
              onChanged: onFromChanged,
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}|^$'),
                ),
              ],
              onChanged: onToChanged,
            ),
          ),
        ],
      ),
    );
  }
}
