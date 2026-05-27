import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class ContainsFilterWidget<T> extends ConsumerStatefulWidget {
  const ContainsFilterWidget({
    required this.identifier,
    required this.notifier,
    super.key,
  });
  final String identifier;
  final TableFilterNotifier<T> notifier;

  @override
  ConsumerState<ContainsFilterWidget> createState() =>
      _ContainsFilterWidgetState();
}

class _ContainsFilterWidgetState<T>
    extends ConsumerState<ContainsFilterWidget> {
  TableFilterNotifier get notifier => widget.notifier;

  @override
  void initState() {
    super.initState();
    Future(
      () {
        ref.read(transactionFilterProvider.notifier).setCheckCallback(
          widget.identifier,
          (filterValue, value) {
            return value.toString().contains(filterValue.toString());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => setState(() {
        notifier.setFilterValue(widget.identifier, value);
      }),
    );
  }
}
