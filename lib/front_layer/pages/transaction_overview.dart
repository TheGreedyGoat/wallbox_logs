import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/contains_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/number_range_filter_widget.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table_v2.dart';
import 'package:wallbox_logs/front_layer/widgets/neat_row.dart';
import 'package:wallbox_logs/mid_layer/services/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

/// A Main Page.
///
/// Shows a table of all stored [WallBoxTransaction]s.
///
/// attributes shown:
/// - Tag-ID
/// - users full name (if set)
/// - the transaction's (start-) date
/// - power usage
/// - costs
///
/// The table can be filtered and sorted by any of these attributes
///
class TransactionOverview extends ConsumerStatefulWidget {
  /// A Main Page.
  ///
  /// Shows a table of all stored [WallBoxTransaction]s.
  ///
  /// attributes shown:
  /// - Tag-ID
  /// - users full name (if set)
  /// - the transaction's (start-) date
  /// - power usage
  /// - costs
  ///
  /// The table can be filtered and sorted by any of these attributes
  ///
  const TransactionOverview({super.key});

  final List<String> _headers = const [
    'Tag-ID',
    'Name',
    'Datum',
    'Verbrauch',
    'Kosten',
  ];
  @override
  ConsumerState<TransactionOverview> createState() =>
      _TransactionOverviewState();
}

class _TransactionOverviewState extends ConsumerState<TransactionOverview> {
  List<String> get headers => widget._headers;
  bool showPaid = false;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionTableProvider);

    return Form(
      child: Column(
        children: [
          LabeledField(
            label: 'Bezahlte anzeigen? ',
            right: Checkbox(
              value: showPaid,
              onChanged: (value) {
                setState(() {
                  showPaid = value!;
                  ref
                      .read(transactionTableProvider.notifier)
                      .setIncludePaid(showPaid);
                });
              },
            ),
          ),

          FilterableTable(
            selectedActions: [
              (int index) async {
                final transaction = state.getFiltered()[index];
                await WallBoxTransaction.repo.delete(
                  transaction.repoID,
                  () async {
                    return await showDialog<bool>(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Sind Sie sicher, dass Sie diese Transaktion löschen wollen? Der Vorgang kann nicht rückgängig gemacht',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('fortfahren'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('abbrechen'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                  },
                );
                ref.read(transactionTableProvider.notifier).refresh();
              },
              (int index) {
                final transaction = state.getFiltered()[index];

                WallBoxTransaction.repo.update(
                  transaction.copyWith(isPaid: true),
                );
                ref.read(transactionTableProvider.notifier).refresh();
              },
            ],
            selectedActionslabels: [
              Text('löschen'),
              Text('als bezahlt kennzeichnen'),
            ],
            onSortChanged: (index, invert) {
              ref
                  .read(transactionTableProvider.notifier)
                  .setSorting(index, invert);
            },
            onFilterRefresh: ref.read(transactionTableProvider.notifier).clear,
            headers: headers,
            data: state.getFilteredForDisplay(),
            filterWidgets: [
              // Tag-ID
              ContainsFilterWidget(
                identifier: headers[0],
                onChanged: (value) => ref
                    .read(transactionTableProvider.notifier)
                    .setIDFilter(value == '' ? null : value),
              ),
              // Name
              ContainsFilterWidget(
                identifier: headers[1],
                onChanged: (value) {
                  ref
                      .read(transactionTableProvider.notifier)
                      .setNameFilter(value == '' ? null : value);
                },
              ),
              // Date
              DateFilterWidget(
                onChanged: (year, mode) => ref
                    .read(transactionTableProvider.notifier)
                    .setDateFilter(year, mode),
              ),
              // consumption
              Center(
                child: NumberRangeFilterWidget(
                  onFromChanged: (value) => ref
                      .read(transactionTableProvider.notifier)
                      .setConsumptionFromFilter(value),
                  onToChanged: (value) => ref
                      .read(transactionTableProvider.notifier)
                      .setConsumptionToFilter(value),
                ),
              ),

              //cost
              Center(
                child: NumberRangeFilterWidget(
                  onFromChanged: (value) => ref
                      .read(transactionTableProvider.notifier)
                      .setCostFromFilter(value),
                  onToChanged: (value) => ref
                      .read(transactionTableProvider.notifier)
                      .setCostToFilter(value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
