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
    this.selectedActions,
    this.selectedActionslabels,
    super.key,
  });

  final List<Widget?> filterWidgets;
  final List<String> headers;
  final List<List<String>> data;
  final double filterBarHeight = 70;

  final void Function()? onFilterRefresh;
  final List<void Function(int index)>? selectedActions;
  final List<Widget>? selectedActionslabels;
  final void Function(int index, bool invert) onSortChanged;

  @override
  State<FilterableTableV2> createState() => _FilterableTableV2State();
}

class _FilterableTableV2State extends State<FilterableTableV2> {
  List<String> get headers => widget.headers;
  List<List<String>> get data => widget.data;
  List<Widget?> get filterWidgets => widget.filterWidgets;

  List<int> selected = List.empty(growable: true);

  int? selectedHead;
  bool invertSorting = false;

  static const filterColumnWidth = 50.0;
  bool showFilters = true;
  @override
  Widget build(BuildContext context) {
    print(selected);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = MediaQuery.sizeOf(context).height - 200;

          final colWidth = (maxWidth - filterColumnWidth) / headers.length;
          return SizedBox(
            height: maxHeight,
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
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 10)],
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: DataTable(
                    border: TableBorder(verticalInside: BorderSide()),
                    showBottomBorder: true,
                    dataRowColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primaryContainer,
                    ),
                    headingRowColor: WidgetStatePropertyAll(
                      Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withAlpha(100),
                    ),
                    // border: TableBorder.all(color: Colors.white),
                    dataRowMinHeight: showFilters ? widget.filterBarHeight : 5,
                    dataRowMaxHeight: showFilters ? widget.filterBarHeight : 10,
                    columnSpacing: 10,
                    horizontalMargin: 0,
                    columns: [
                      ...headers.map(
                        (headline) => DataColumn(
                          columnWidth: FixedColumnWidth(colWidth),
                          label: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: colWidth - 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(headline),
                                IconButton(
                                  isSelected:
                                      selectedHead == headers.indexOf(headline),
                                  onPressed: () {
                                    setState(() {
                                      invertSorting =
                                          selectedHead ==
                                              headers.indexOf(headline) &&
                                          !invertSorting;
                                      selectedHead = headers.indexOf(
                                        headline,
                                      );
                                      widget.onSortChanged(
                                        selectedHead!,
                                        invertSorting,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        columnWidth: FixedColumnWidth(filterColumnWidth),
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
                // SizedBox(
                //   height: 10,
                // ),

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
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return DataTable(
                        border: TableBorder(verticalInside: BorderSide()),
                        // border: TableBorder.symmetric(
                        //   inside: BorderSide(),
                        // ),
                        headingRowHeight: 0,

                        columnSpacing: 10,
                        horizontalMargin: 0,
                        columns: [
                          ...headers.map(
                            (e) => DataColumn(
                              columnWidth: FixedColumnWidth(colWidth),
                              label: Container(),
                            ),
                          ),
                          DataColumn(
                            columnWidth: FixedColumnWidth(filterColumnWidth),
                            label: Container(),
                          ),
                        ],
                        rows: data.map((row) {
                          int index = data.indexOf(row);
                          return DataRow(
                            color: WidgetStatePropertyAll(
                              selected.contains(index) ? Colors.red : null,
                            ),
                            cells: [
                              ...row.map(
                                (cellText) => DataCell(
                                  onTap: () {
                                    setState(() {
                                      selected.contains(index)
                                          ? selected.remove(index)
                                          : selected.add(index);
                                    });
                                  },
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      cellText,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Checkbox(
                                    value: selected.contains(index),
                                    onChanged: (value) {
                                      setState(() {
                                        (value ?? false)
                                            ? selected.add(index)
                                            : selected.remove(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                if (widget.selectedActions != null &&
                    widget.selectedActionslabels != null)
                  Row(
                    children: [
                      for (final action in widget.selectedActions!)
                        ElevatedButton(
                          onPressed: () {
                            for (final index in selected) action(index);
                            selected.clear();
                          },
                          child:
                              widget.selectedActionslabels![widget
                                  .selectedActions!
                                  .indexOf(action)],
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
