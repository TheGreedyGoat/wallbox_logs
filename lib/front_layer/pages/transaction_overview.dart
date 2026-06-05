import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/contains_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/number_range_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table_v2.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

class TransactionOverview extends ConsumerWidget {
  const TransactionOverview({super.key});

  final List<String> headers = const [
    'Tag-ID',
    'Name',
    'Datum',
    'Verbrauch',
    'Kosten',
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionFilterProvider);

    return Container(
      child: Form(
        child: FilterableTableV2(
          onSortChanged: (index, invert) {
            print(
              'TransactionOverview tries setting filter for ${[headers[index]]}. Inversion: $invert',
            );
            ref
                .read(transactionFilterProvider.notifier)
                .setSorting(index, invert);
          },
          onFilterRefresh: ref.read(transactionFilterProvider.notifier).clear,
          headers: headers,
          data: state.getFilteredForDisplay(),
          filterWidgets: [
            // Tag-ID
            ContainsFilterWidget(
              identifier: headers[0],
              onChanged: (value) => ref
                  .read(transactionFilterProvider.notifier)
                  .setIDFilter(value == '' ? null : value),
            ),
            // Name
            ContainsFilterWidget(
              identifier: headers[1],
              onChanged: (value) {
                ref
                    .read(transactionFilterProvider.notifier)
                    .setNameFilter(value == '' ? null : value);
              },
            ),
            // Date
            DateFilterWidget(
              onChanged: (year, mode) => ref
                  .read(transactionFilterProvider.notifier)
                  .setDateFilter(year, mode),
            ),
            // consumption
            Center(
              child: NumberRangeFilterWidget(
                onFromChanged: (value) => ref
                    .read(transactionFilterProvider.notifier)
                    .setConsumptionFromFilter(value),
                onToChanged: (value) => ref
                    .read(transactionFilterProvider.notifier)
                    .setConsumptionToFilter(value),
              ),
            ),

            //cost
            Center(
              child: NumberRangeFilterWidget(
                onFromChanged: (value) => ref
                    .read(transactionFilterProvider.notifier)
                    .setCostFromFilter(value),
                onToChanged: (value) => ref
                    .read(transactionFilterProvider.notifier)
                    .setCostToFilter(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
