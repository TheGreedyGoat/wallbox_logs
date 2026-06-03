import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';

class DateFilterWidget extends ConsumerStatefulWidget {
  const DateFilterWidget({required this.onChanged, super.key});

  final void Function(String? year, DateFilterSelections mode) onChanged;

  @override
  ConsumerState<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends ConsumerState<DateFilterWidget> {
  DateFilterSelections mode = DateFilterSelections.wholeYear;
  String? year;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<DateFilterSelections>(
          // menuWidth: 200,
          value: mode,
          items: [
            for (final s in DateFilterSelections.values) ...[
              if (s == DateFilterSelections.january)
                _subHeader('Monat', context),
              if (s == DateFilterSelections.quarter1)
                _subHeader('Quartal', context),
              DropdownMenuItem(
                value: s,
                child: SizedBox(
                  width: 150,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        s.display,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
          onChanged: (value) {
            setState(() {
              this.mode = value ?? this.mode;
              _update();
            });
          },
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(label: Text('Jahr')),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d+')),
            ],
            onChanged: (value) => setState(() {
              year = value;
              _update();
            }),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  DropdownMenuItem<DateFilterSelections> _subHeader(
    String label,
    BuildContext context,
  ) => DropdownMenuItem(
    enabled: false,
    child: SizedBox(
      width: 150,
      child: ListTile(
        dense: true,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface,
          ),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ),
  );

  void _update() => widget.onChanged(year, mode);
}

enum DateFilterSelections {
  wholeYear(
    display: 'Ganzes Jahr',
    type: DateFilterSelectionType.wholeYear,
    value: 0,
  ),
  january(display: 'Januar', type: DateFilterSelectionType.month, value: 1),
  feburary(display: 'Februar', type: DateFilterSelectionType.month, value: 2),
  march(display: 'März', type: DateFilterSelectionType.month, value: 3),
  april(display: 'April', type: DateFilterSelectionType.month, value: 4),
  may(display: 'Mai', type: DateFilterSelectionType.month, value: 5),
  june(display: 'Juni', type: DateFilterSelectionType.month, value: 6),
  july(display: 'Juli', type: DateFilterSelectionType.month, value: 7),
  august(display: 'August', type: DateFilterSelectionType.month, value: 8),
  september(
    display: 'September',
    type: DateFilterSelectionType.month,
    value: 9,
  ),
  october(display: 'Oktober', type: DateFilterSelectionType.month, value: 10),
  november(display: 'November', type: DateFilterSelectionType.month, value: 11),
  december(display: 'Dezember', type: DateFilterSelectionType.month, value: 12),
  quarter1(
    display: '1. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 0,
  ),
  quarter2(
    display: '2. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 1,
  ),
  quarter3(
    display: '3. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 2,
  ),
  quarter4(
    display: '4. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 3,
  )
  ;

  final String display;
  final DateFilterSelectionType type;
  final int value;

  const DateFilterSelections({
    required this.display,
    required this.type,
    required this.value,
  });
}

enum DateFilterSelectionType { wholeYear, month, quarter }
