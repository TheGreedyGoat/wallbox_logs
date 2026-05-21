import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table.dart';

class FilterableTableV2 extends StatelessWidget {
  FilterableTableV2({
    required this.headers,
    required this.data,
    required this.filterWidgets,
    this.columnWidth,
    super.key,
  });
  final double? columnWidth;
  final List<Widget?> filterWidgets;
  final List<String> headers;
  final List<List<String>> data;
  final double filterBarHeight = 40;

  late final List<TextEditingController> _filterControllers;

  String? _validateLists() {
    if (headers.isEmpty) {
      return 'No headers provided';
    }
    if (filterWidgets.length != headers.length) {
      return 'number of filters dont match';
    }
    if (!data.fold(
      true,
      (previousValue, row) => previousValue && row.length == headers.length,
    )) {
      return 'data list lengths dont match header length';
    }
    return null;
  }

  void _init() {
    final validation = _validateLists();
    assert(validation == null, validation);
    _filterControllers = headers
        .map(
          (e) => TextEditingController(text: ''),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: DataTable(
                columns: headers
                    .map(
                      (e) => DataColumn(
                        columnWidth: FlexColumnWidth(),
                        label: Text(
                          e,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: [],
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                    rows: data
                        .map(
                          (row) => DataRow(
                            cells: row
                                .map(
                                  (cellText) => DataCell(Text(cellText)),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
