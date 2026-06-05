import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/my_text_field.dart';

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
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: MyTextField(
              onChanged: onFromChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}|^$')),
              ],
            ),
          ),
          // SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: MyTextField(
              onChanged: onToChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}|^$'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
