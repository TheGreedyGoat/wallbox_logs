import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class NumberRangeFilterWidget extends ConsumerStatefulWidget {
  const NumberRangeFilterWidget({
    super.key,
    required this.onFromChanged,
    required this.onToChanged,
  });

  final void Function(String? value) onFromChanged;
  final void Function(String? value) onToChanged;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NumberRangeFilterWidgetState();
}

class _NumberRangeFilterWidgetState
    extends ConsumerState<NumberRangeFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 35,
            child: TextField(
              decoration: InputDecoration(label: Text('von')),
              onChanged: (value) {
                widget.onFromChanged(value);
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 35,
            child: TextField(
              decoration: InputDecoration(label: Text('bis')),
              onChanged: (value) {
                widget.onToChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
