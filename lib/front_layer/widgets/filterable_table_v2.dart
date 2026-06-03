import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class FilterableTableV2 extends StatefulWidget {
  FilterableTableV2({
    required this.headers,
    required this.data,
    required this.filterWidgets,

    required this.onSortChanged,

    this.onFilterRefresh,

    this.columnWidth,
    super.key,
  });

  final double? columnWidth;
  final List<Widget?> filterWidgets;
  final List<String> headers;
  final List<List<String>> data;
  final double filterBarHeight = 70;

  final void Function()? onFilterRefresh;

  final void Function(int index, bool invert) onSortChanged;

  @override
  State<FilterableTableV2> createState() => _FilterableTableV2State();
}

class _FilterableTableV2State extends State<FilterableTableV2> {
  List<String> get headers => widget.headers;
  List<List<String>> get data => widget.data;
  List<Widget?> get filterWidgets => widget.filterWidgets;

  int? selectedHead;
  bool invertSorting = false;

  bool showFilters = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
              dataRowColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              headingRowColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
              ),
              // border: TableBorder.all(color: Colors.white),
              dataRowMinHeight: showFilters ? widget.filterBarHeight : 5,
              dataRowMaxHeight: showFilters ? widget.filterBarHeight : 10,
              columnSpacing: 10,
              horizontalMargin: 0,
              columns: [
                ...headers.map(
                  (headline) => DataColumn(
                    columnWidth: FlexColumnWidth(),
                    label: IntrinsicWidth(
                      child: ListTile(
                        title: Text(headline),
                        leading: IconButton(
                          isSelected: selectedHead == headers.indexOf(headline),
                          onPressed: () {
                            setState(() {
                              invertSorting =
                                  selectedHead == headers.indexOf(headline) &&
                                  !invertSorting;
                              selectedHead = headers.indexOf(headline);
                              widget.onSortChanged(
                                selectedHead!,
                                invertSorting,
                              );
                              print(
                                'Button request to sort by $headline, ${invertSorting ? 'BU' : 'TD'}',
                              );
                            });
                          },
                          icon: Icon(
                            selectedHead == headers.indexOf(headline)
                                ? (invertSorting
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down)
                                : Icons.sort,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: IconButton(
                    icon: Icon(
                      showFilters
                          ? Icons.filter_alt_sharp
                          : Icons.filter_alt_off_sharp,
                    ),
                    onPressed: () => setState(() {
                      showFilters = !showFilters;
                    }),
                  ),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    ...filterWidgets
                        .map(
                          (filterW) => DataCell(
                            showFilters
                                ? filterW ?? Container()
                                : SizedBox(
                                    height: 10,
                                  ),
                          ),
                        )
                        .toList(),
                    DataCell(
                      showFilters
                          ? IconButton(
                              onPressed: widget.onFilterRefresh,
                              icon: Icon(Icons.refresh_sharp),
                            )
                          : Container(),
                    ),
                  ],
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
                                (cellText) => DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(cellText),
                                  ),
                                ),
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
    );
  }
}
