import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class NumberRangeFilterWidget<T> extends ConsumerStatefulWidget {
  const NumberRangeFilterWidget({
    required this.identifier,
    required this.notifier,

    super.key,
  });

  final String identifier;
  final TableFilterNotifier<T> notifier;

  static const fromIDExt = 'from';
  static const toIDExt = 'to';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NumberRangeFilterWidgetState();
}

class _NumberRangeFilterWidgetState
    extends ConsumerState<NumberRangeFilterWidget> {
  TableFilterNotifier get notifier => widget.notifier;
  String get fromID =>
      '${widget.identifier}.${NumberRangeFilterWidget.fromIDExt}';
  String get toID => '${widget.identifier}.${NumberRangeFilterWidget.toIDExt}';

  @override
  void initState() {
    super.initState();
    Future(
      () {
        notifier.setCheckCallback(
          fromID,
          (filterValue, value) {
            return !(filterValue is num) ||
                !(value is num) ||
                value.toDouble() >= filterValue.toDouble();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: MyTextFormField(
            label: 'von',
            onSaved: (value) {
              setState(() {
                notifier.setFilterValue(fromID, int.tryParse(value ?? ''));
              });
            },
          ),
        ),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 80,
          child: MyTextFormField(
            label: 'bis',
            onSaved: (value) {
              setState(() {
                notifier.setFilterValue(toID, int.tryParse(value ?? ''));
              });
            },
          ),
        ),
      ],
    );
  }
}
