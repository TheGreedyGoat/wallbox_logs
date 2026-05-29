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

  final List<String> headers = const [
    'Tag-ID',
    'Name',
    'Datum',
    'Verbrauch',
    'Kosten',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Form(
        child: FilterableTableV2(
          headers: headers,
          provider: transactionFilterProvider,
          filterWidgets: [
            ContainsFilterWidget(
              identifier: 0,
              provider: transactionFilterProvider,
            ),
            ContainsFilterWidget(
              identifier: 1,
              provider: transactionFilterProvider,
            ),
            ContainsFilterWidget(
              identifier: 2,
              provider: transactionFilterProvider,
            ),
            ContainsFilterWidget(
              identifier: 3,
              provider: transactionFilterProvider,
            ),
            ContainsFilterWidget(
              identifier: 3,
              provider: transactionFilterProvider,
            ),
          ],
        ),
      ),
    );
  }
}
