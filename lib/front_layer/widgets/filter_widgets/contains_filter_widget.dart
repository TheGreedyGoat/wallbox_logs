import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class ContainsFilterWidget<T> extends ConsumerStatefulWidget {
  ContainsFilterWidget({
    required this.identifier,
    required this.provider,
    required this.onChanged,
    this.invertFilter = false,
    super.key,
  });
  final int identifier;
  final NotifierProvider<TableFilterNotifier, TransactionFilterTableState>
  provider;
  final bool invertFilter;
  final void Function(String value)? onChanged;

  @override
  ConsumerState<ContainsFilterWidget> createState() =>
      _ContainsFilterWidgetState();
}

class _ContainsFilterWidgetState<T>
    extends ConsumerState<ContainsFilterWidget> {
  NotifierProvider<TableFilterNotifier, TransactionFilterTableState>
  get provider => widget.provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
    );
  }
}
