import 'package:flutter/material.dart';

class MyTable extends StatelessWidget {
  const MyTable({required this.content, this.head, super.key});
  final List<Widget>? head;
  final List<List<String>> content;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        left: BorderSide(),
        right: BorderSide(),
        horizontalInside: BorderSide(width: 0.3),
      ),
      children: [
        if (head != null)
          TableRow(
            children: [
              for (final widget in head!) widget,
            ],
          ),
        for (int i = 0; i < content.length; i++)
          TableRow(
            decoration: i % 2 == 1
                ? BoxDecoration(color: Colors.blueGrey[50])
                : null,
            children: [
              for (final c in content[i])
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SelectableText(c),
                ),
            ],
          ),
      ],
    );
  }
}
