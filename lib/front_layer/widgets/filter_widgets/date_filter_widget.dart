import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/my_text_field.dart';

/// provides a input field to set a year aswell as a dropdown menu to set a certain month, quarter or the whole year.
class DateFilterWidget extends ConsumerStatefulWidget {
  /// Filter Widget
  ///
  /// provides an input field to set a year aswell as a dropdown menu to set a certain month, quarter or the whole year.
  /// -
  const DateFilterWidget({required this.onChanged, super.key});

  /// callback to evaluate the user's input
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
          child: MyTextField(
            label: 'Jahr',
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

/// Available options on what part of a given year should be filtered by
enum DateFilterSelections {
  /// the whole year
  wholeYear(
    display: 'Ganzes Jahr',
    type: DateFilterSelectionType.wholeYear,
    value: 0,
  ),

  /// month january
  january(display: 'Januar', type: DateFilterSelectionType.month, value: 1),

  /// month february
  feburary(display: 'Februar', type: DateFilterSelectionType.month, value: 2),

  /// month march
  march(display: 'März', type: DateFilterSelectionType.month, value: 3),

  /// month april
  april(display: 'April', type: DateFilterSelectionType.month, value: 4),

  /// month may
  may(display: 'Mai', type: DateFilterSelectionType.month, value: 5),

  /// month june
  june(display: 'Juni', type: DateFilterSelectionType.month, value: 6),

  /// month july
  july(display: 'Juli', type: DateFilterSelectionType.month, value: 7),

  /// month august
  august(display: 'August', type: DateFilterSelectionType.month, value: 8),

  /// month september
  september(
    display: 'September',
    type: DateFilterSelectionType.month,
    value: 9,
  ),

  /// month october
  october(display: 'Oktober', type: DateFilterSelectionType.month, value: 10),

  /// month november
  november(display: 'November', type: DateFilterSelectionType.month, value: 11),

  /// month december
  december(display: 'Dezember', type: DateFilterSelectionType.month, value: 12),

  /// first quarter of the year (january, february, march)
  quarter1(
    display: '1. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 0,
  ),

  /// second quarter of the year (april, may, june)
  quarter2(
    display: '2. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 1,
  ),

  /// third quarter of the year (july, august, september)
  quarter3(
    display: '3. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 2,
  ),

  /// fourth quarter of the year (october, november, december)
  quarter4(
    display: '4. Quartal',
    type: DateFilterSelectionType.quarter,
    value: 3,
  )
  ;

  /// The String to represent the year's section
  final String display;

  /// quick check if it's the whole year, a single month or a quater
  final DateFilterSelectionType type;

  /// Numerical value used for internal processing
  /// - whole year: not needed
  /// - month: The months's number as used in the DateTime class
  /// - quarter: quarter n =>  value = n - 1
  final int value;

  const DateFilterSelections({
    required this.display,
    required this.type,
    required this.value,
  });
}

/// types for [DateFilterSelections] enum values
enum DateFilterSelectionType {
  /// for a whole year
  wholeYear,

  /// for a single month
  month,

  /// for a quater
  quarter,
}
