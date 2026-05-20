import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

class TransactionOverview extends ConsumerWidget {
  const TransactionOverview({super.key});

  get list => [
    for (int j = 0; j < 6; j++) <int>[Random(5).nextInt(100)],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorter = ref.watch(filterTestProvider.notifier);
    final filtered = sorter
        .filter(list)
        .map(
          (l) => l
              .map(
                (e) => e.toString(),
              )
              .toList(),
        )
        .toList();
    return FilterableTable(
      headers: [for (int i = 0; i < filtered.length; i++) 'Spalte ${i + 1}'],
      data: filtered,
      filterWidgets: [
        for (int i = 0; i < filtered.length; i++)
          i == 1
              ? null
              : TextFormField(
                  onChanged: (value) {
                    int number = int.tryParse(value) ?? 0;
                    ref
                        .read(filterTestProvider.notifier)
                        .setFilter(
                          'Filter$i',
                          (p0) => p0[i] > number,
                        );
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
