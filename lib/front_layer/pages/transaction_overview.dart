import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table_v2.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class TransactionOverview extends ConsumerWidget {
  const TransactionOverview({super.key});

  bool Function(WallBoxTransaction transaction, String filterValue) getTemplate(
    int i,
  ) {
    final filterTemplates =
        <bool Function(WallBoxTransaction transaction, String filterValue)>[
          (tr, f) {
            return tr.tagID.contains(f);
          },
          (tr, f) {
            return true;
          },
          (tr, f) {
            return true;
          },
          (tr, f) {
            double? parsed = double.tryParse(f.trim().replaceAll(',', '.'));
            return parsed == null || (parsed * 1000).floor() <= tr.powerUsageWh;
          },
        ];

    return filterTemplates[i];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = WallBoxTransaction.repo.getAll();
    final state = ref.watch(transactionFilterProvider);
    final notifier = ref.watch(transactionFilterProvider.notifier);
    // List<WallBoxTransaction> filtered =
    //     notifier
    //     .filter(list);

    return Container(
      // color: Theme.of(context).colorScheme.surfaceBright,
      child: FilterableTableV2(
        headers: ['Tag-ID', 'Start', 'Ende', 'Verbrauch'],
        data: notifier.filter(list).map(
          (transaction) {
            return [
              transaction.tagID,
              transaction.startTimeDisplay(),
              transaction.stopTimeDisplay(),
              transaction.powerUsageKWhDisplay,
            ];
          },
        ).toList(),
        filterWidgets: [
          for (int i = 0; i < 4; i++)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(100),
                  right: Radius.circular(100),
                ),
              ),
              padding: EdgeInsets.all(8.0),

              child: Center(
                child: TextField(
                  onChanged: (value) {
                    print(value);
                    ref.read(transactionFilterProvider.notifier).setFilter(
                      'filter$i',
                      (p0) {
                        return getTemplate(i)(p0, value);
                      },
                    );
                  },
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
