import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';

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
  late final List<bool> hovers;

  int get numRows => widget.data[0].length;
  int? _hoveredRowIndex;

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
    hovers = [for (int i = 0; i < numRows; i++) false];
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
    return DataTable(
      columnSpacing: 0,
      headingRowHeight: 100,

      columns: widget.headers
          .map(
            (title) => DataColumn(
              label: IntrinsicWidth(child: Text(title)),
              // ?widget.filterWidgets[widget.headers.indexOf(title)],
            ),
          )
          .toList(),
      rows: [
        DataRow(
          cells: widget.filterWidgets
              .map(
                (e) => DataCell(
                  Padding(
                    padding: EdgeInsetsGeometry.all(3.0),
                    child: e ?? Container(),
                  ),
                ),
              )
              .toList(),
        ),

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
    );
  }
}
