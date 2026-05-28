import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';

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
                          (e) => DataCell(e ?? Container()),
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
