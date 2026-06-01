import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class FilterableTableV2 extends ConsumerStatefulWidget {
  FilterableTableV2({
    required this.headers,
    required this.filterWidgets,
    required this.provider,

    this.columnWidth,
    super.key,
  });

  final NotifierProvider<TableFilterNotifier, TransactionFilterTableState>
  provider;
  final double? columnWidth;
  final List<Widget?> filterWidgets;
  final List<String> headers;
  final double filterBarHeight = 40;

  @override
  ConsumerState<FilterableTableV2> createState() => _FilterableTableV2State();
}

class _FilterableTableV2State extends ConsumerState<FilterableTableV2> {
  NotifierProvider<TableFilterNotifier, TransactionFilterTableState>
  get provider => widget.provider;
  List<Widget?> get filterWidgets => widget.filterWidgets;
  List<String> get headers => widget.headers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 888    888                        888
            // 888    888                        888
            // 888    888                        888
            // 8888888888  .d88b.   8888b.   .d88888
            // 888    888 d8P  Y8b     "88b d88" 888
            // 888    888 88888888 .d888888 888  888
            // 888    888 Y8b.     888  888 Y88b 888
            // 888    888  "Y8888  "Y888888  "Y88888
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: DataTable(
                columns: headers
                    .map(
                      (headline) => DataColumn(
                        columnWidth: FlexColumnWidth(),
                        label: Text(
                          headline,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: [
                  DataRow(
                    cells: filterWidgets
                        .map(
                          (e) => DataCell(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: e ?? Container(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // 888888b.                 888
            // 888  "88b                888
            // 888  .88P                888
            // 8888888K.   .d88b.   .d88888 888  888
            // 888  "Y88b d88""88b d88" 888 888  888
            // 888    888 888  888 888  888 888  888
            // 888   d88P Y88..88P Y88b 888 Y88b 888
            // 8888888P"   "Y88P"   "Y88888  "Y88888
            //                                   888
            //                              Y8b d88P
            //                               "Y88P"
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return DataTable(
                    headingRowHeight: 0,

                    columnSpacing: 0,
                    horizontalMargin: 0,
                    columns: headers
                        .map(
                          (e) => DataColumn(
                            columnWidth: FlexColumnWidth(),
                            label: Container(),
                          ),
                        )
                        .toList(),
                    rows: ref
                        .watch(provider)
                        .filtered
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.tagID.toString())),
                              DataCell(Text(item.username)),
                              DataCell(
                                Text(item.startTimeDisplay()),
                              ),
                              DataCell(
                                Text(item.powerUsageKWhDisplay),
                              ),
                              DataCell(Text(item.costsDisplay)),
                            ],
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
