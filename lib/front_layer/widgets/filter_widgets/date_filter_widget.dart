import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateFilterWidget extends ConsumerStatefulWidget {
  const DateFilterWidget({super.key});

  @override
  ConsumerState<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends ConsumerState<DateFilterWidget> {
  DateFilterSelections? value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.red,
          child: DropdownButton<DateFilterSelections?>(
            value: value,
            isDense: true,
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('---'),
              ),
              ...DateFilterSelections.values.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.display),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            },
          ),
        ),
        SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(label: Text('Jahr')),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum DateFilterSelections {
  whole(display: 'Ganzes Jahr'),
  january(display: 'Januar'),
  feburary(display: 'Februar'),
  march(display: 'März'),
  april(display: 'April'),
  may(display: 'Mai'),
  june(display: 'Juni'),
  july(display: 'Juli'),
  august(display: 'August'),
  september(display: 'September'),
  october(display: 'Oktober'),
  november(display: 'November'),
  december(display: 'Dezember'),
  quarter1(display: '1. Quartal'),
  quarter2(display: '2. Quartal'),
  quarter3(display: '3. Quartal'),
  quarter4(display: '4. Quartal')
  ;

  final String display;

  const DateFilterSelections({required this.display});
}
