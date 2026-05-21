import 'package:flutter/material.dart';

class FilterableTable extends StatefulWidget {
  const FilterableTable({
    required this.headers,
    required this.data,
    required this.filterWidgets,
    super.key,
  });
  final List<Widget?> filterWidgets;
  final List<String> headers;
  final List<List<String>> data;
  final double filterBarHeight = 40;

  @override
  State<FilterableTable> createState() => _FilterableTableState();
}

class _FilterableTableState extends State<FilterableTable> {
  late final List<TextEditingController> filterControllers;

  @override
  void initState() {
    super.initState();
    final validation = _validateLists();
    assert(validation == null, validation);
    filterControllers = widget.headers
        .map(
          (e) => TextEditingController(text: ''),
        )
        .toList();
  }

  String? _validateLists() {
    if (widget.headers.isEmpty) {
      return 'No headers provided';
    }
    if (widget.filterWidgets.length != widget.headers.length) {
      return 'number of filters dont match';
    }
    if (!widget.data.fold(
      true,
      (previousValue, row) =>
          previousValue && row.length == widget.headers.length,
    )) {
      return 'data list lengths dont match header length';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DataTable(
        columnSpacing: 0,
        headingRowColor: WidgetStatePropertyAll(Colors.amber),
        headingRowHeight: 100,
        columns: widget.headers
            .map(
              (title) => DataColumn(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(
                      width:
                          (MediaQuery.of(context).size.width - 300) /
                          widget.headers.length,
                      child: SizedBox(
                        height: 30,
                        child:
                            widget.filterWidgets[widget.headers.indexOf(
                              title,
                            )] ??
                            Container(),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        rows: [
          ...widget.data.map(
            (row) => DataRow(
              cells: row
                  .map(
                    (cell) => DataCell(Text(cell)),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
