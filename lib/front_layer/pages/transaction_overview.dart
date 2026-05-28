import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/contains_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/number_range_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table_v2.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class TransactionOverview extends ConsumerWidget {
  const TransactionOverview({super.key});

  final List<String> headers = const ['Tag-ID', 'Name', 'Datum', 'Verbrauch'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = WallBoxTransaction.repo.getAll();
    final notifier = ref.watch(transactionFilterProvider.notifier);
    Future(
      () => _setupFilterCallbacks(ref),
    );

    return Container(
      child: Form(
        child: FilterableTableV2(
          headers: headers,
          data: ref.watch(transactionFilterProvider).filter(list).map(
            (transaction) {
              return [
                transaction.tagID,
                transaction.user?.fullName ?? '[unbekannt]',
                transaction.startTimeDisplay(false),
                transaction.powerUsageKWhDisplay,
              ];
            },
          ).toList(),
          filterWidgets: [
            ContainsFilterWidget(identifier: headers[0], notifier: notifier),
            ContainsFilterWidget(identifier: headers[1], notifier: notifier),
            ContainsFilterWidget(identifier: headers[2], notifier: notifier),
            ContainsFilterWidget(identifier: headers[3], notifier: notifier),
            // for (int i = 0; i < headers.length; i++)
            //   ContainsFilterWidget(
            //     identifier: headers[i],
            //     notifier: notifier,
            //   ),
          ],
        ),
      ),
    );
  }

  void _setupFilterCallbacks(
    WidgetRef ref,
  ) {
    ref.read(transactionFilterProvider.notifier).setupFilters({
      headers[0]: DataFilter(
        filterValue: '',
        getValue: (transaction) => transaction.tagID,
      ),
      headers[1]: DataFilter(
        filterValue: '',
        getValue: (transaction) => transaction.username,
      ),

      '${headers[2]}': DataFilter(
        filterValue: '',
        getValue: (transaction) => transaction.startTimeStamp,
      ),
      '${headers[3]}': DataFilter(
        filterValue: '',
        getValue: (transaction) => transaction.powerUsageKWhDisplay,
      ),
    });
  }
}
