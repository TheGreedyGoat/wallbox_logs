import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class ContainsFilterWidget<T> extends ConsumerStatefulWidget {
  ContainsFilterWidget({
    required this.identifier,
    required this.provider,

    this.invertFilter = false,
    super.key,
  });
  final int identifier;
  final NotifierProvider<TableFilterNotifier, DataFilterState> provider;
  final bool invertFilter;

  @override
  ConsumerState<ContainsFilterWidget> createState() =>
      _ContainsFilterWidgetState();
}

class _ContainsFilterWidgetState<T>
    extends ConsumerState<ContainsFilterWidget> {
  NotifierProvider<TableFilterNotifier, DataFilterState> get provider =>
      widget.provider;

  @override
  void initState() {
    super.initState();

    Future(
      () {
        ref
            .read(provider.notifier)
            .setFilterInversion(widget.identifier, widget.invertFilter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      // label: 'Filtern',
      onChanged: (value) => setState(() {
        print('changed');
        ref
            .read(provider.notifier)
            .setFilterValue(widget.identifier, value.isEmpty ? null : value);
      }),
    );
  }
}
