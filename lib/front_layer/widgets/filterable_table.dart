import 'package:flutter/material.dart';

class FilterableTable extends StatefulWidget {
  final List<Map<String, dynamic>> jsonData;
  final List<String> titles;
  const FilterableTable({
    required this.jsonData,
    required this.titles,
    super.key,
  });

  @override
  State<FilterableTable> createState() => _FilterableTableState();
}

class _FilterableTableState extends State<FilterableTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: widget.titles
              .map(
                (e) => ElevatedButton(onPressed: () {}, child: Text(e)),
              )
              .toList(),
        ),
        ...widget.jsonData.map((json) {
          return TableRow(
            children: widget.titles.map(
              (title) {
                return Text(json[title].toString());
              },
            ).toList(),
          );
        }).toList(),
      ],
    );
  }
}
