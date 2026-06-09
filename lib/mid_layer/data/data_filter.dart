import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';

/// short for a filter Function.
/// Should return true, if [toCheck] meets the requirements provided by  the [filterValue] and the internal logic.
/// - [filterValue] : the value to check with
/// - [toCheck] : the value to check if it meets the filter's requirements
typedef FilterCallback = bool Function(dynamic filterValue, dynamic toCheck);

/// Data struct to set filter logic
class DataFilter<T> {
  /// Data struct to set filter logic
  /// - [filterValue] : the value to compare/ check against
  /// - [isInverted] :  reverts the filter: Any value that would normally pass the filter will not pass and vice verca
  /// - [customCheck] : optional custom logic for the filter. This will override the default behaviour
  /// ### Examples
  /// ```dart
  /// final filter = DataFilter<String>(filterValue: 'Hello', isInverted: false);
  /// final filterInverted = DataFilter<String>(filterValue: 'Hello', isInverted: false);
  ///
  /// final filterCustom = DataFilter<String>(
  ///   filterValue: 'World',
  ///   customCheck(filterValue, toCheck)=> toCheck != null && toCheck.endsWith(filterValue),
  /// );
  /// const List<String> unfiltered = ['Hello World', 'Ahoy World', 'Let me say Hello'];
  ///
  /// print(unfiltered.where((element) => filter.check(element)));          // => ['Hello World', 'Let me say Hello']
  /// print(unfiltered.where((element) => filterInverted.check(element)));  // => ['Ahoy World',]
  /// print(unfiltered.where((element) => filterCustom.check(element)));    // => ['Hello World', 'Ahoy World']
  /// ```
  ///
  DataFilter({
    required this.filterValue,
    this.customCheck,
    this.isInverted = false,
  });

  /// the value to use as reference
  final T filterValue;

  /// reverts the filter: Any value that would normally pass the filter will not pass and vice verca
  bool isInverted;

  /// optional custom logic for the filter. This will override the default behaviour
  bool Function(T filterValue, T? toCheck)? customCheck;

  /// returns true if [toCheck] meets the filter's requirements
  bool check(T? toCheck) {
    if (customCheck != null) return customCheck!(filterValue, toCheck);

    if (toCheck == null) return true;
    bool result = true;
    switch (T) {
      case const (String):
        result = (toCheck as String).contains(filterValue as String);
      case const (int):
        result = (toCheck as int) >= (filterValue as int);
      case const (double):
        result = (toCheck as double) >= (filterValue as double);
      default:
        throw ('No filterLogic implemented for Type $T');
    }

    return result != isInverted;
  }

  @override
  bool operator ==(Object other) =>
      other is DataFilter<T> && other.filterValue == filterValue;

  @override
  int get hashCode => filterValue.hashCode;

  /// I wont explain this rn :D
  ///
  DataFilter<T> copyWith({
    dynamic filterValue,
    FilterCallback? check,
    dynamic Function(T)? getValue,
  }) => DataFilter(
    filterValue: filterValue ?? this.filterValue,
  );

  @override
  String toString() =>
      'Filter of type $T with value $filterValue, inversion:$isInverted';
}

/// A special type of filter for some specific date filtering logic
abstract class DataFilterDate {
  /// returns true, if the checked date meets the requirements
  bool checkDate(DateTime date);

  /// returns tan instance of the matching subtype defined by [mode]
  factory DataFilterDate.fromValues(int year, DateFilterSelections mode) {
    print('$mode, $year');
    return mode.type == DateFilterSelectionType.month
        ? DataFilterMonth.fromValues(year, mode)
        : (mode.type == DateFilterSelectionType.quarter
              ? DataFilterQuarter.fromValues(year, mode)
              : DataFilterWholeYear(year: year));
  }
}

/// A filter to check, i f a date is within a specific month of a year
class DataFilterMonth implements DataFilterDate {
  /// A filter to check, i f a date is within a specific month of a year
  /// values as in [DateTime] class
  DataFilterMonth({required this.year, required this.month});

  /// The year to filter for
  final int year;

  /// the month to filter for. [1,12]
  final int month;

  @override
  bool checkDate(DateTime date) {
    print('month');
    return date.year == year && date.month == month;
  }

  @override
  /// create a new MonthFilter [mode] has to be of type month!
  factory DataFilterMonth.fromValues(int year, DateFilterSelections mode) {
    assert(
      mode.type == DateFilterSelectionType.month,
      'Passed quarter value to month Filter',
    );
    return DataFilterMonth(year: year, month: mode.value);
  }

  @override
  bool operator ==(Object other) =>
      other is DataFilterMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month, 'Month Filter');
}

/// A filter to check, i f a date is within a specific quater of a year
class DataFilterQuarter implements DataFilterDate {
  /// A filter to check, i f a date is within a specific quater of a year
  DataFilterQuarter({required this.quaterNum, required this.year});

  /// the quater to filter for. range: [0, 4]
  final int quaterNum;

  /// The year to filter for
  final int year;

  int get _firstMonth => quaterNum * 3 + 1;
  int get _lastMonth => quaterNum * 3 + 3;

  @override
  bool checkDate(DateTime date) {
    print('quater');
    return date.year == year &&
        date.month >= _firstMonth &&
        date.month <= _lastMonth;
  }

  @override
  /// create a new QuaterFilter [mode] has to be of type quater!
  factory DataFilterQuarter.fromValues(int year, DateFilterSelections mode) {
    assert(
      mode.type == DateFilterSelectionType.quarter,
      'Passed month value to quater Filter',
    );
    return DataFilterQuarter(quaterNum: mode.value, year: year);
  }
  @override
  bool operator ==(Object other) =>
      other is DataFilterQuarter &&
      other.year == year &&
      other.quaterNum == quaterNum;

  @override
  int get hashCode => Object.hash(year, quaterNum, 'Quater Filter');
}

/// A filter to check, if a date is within the given year itself
class DataFilterWholeYear implements DataFilterDate {
  /// A filter to check, if a date is within the given year itself
  DataFilterWholeYear({required this.year});

  /// The year to filter for
  final int year;

  @override
  bool checkDate(DateTime date) {
    print('toCheck: ${date.year} | filter: $year');
    return date.year == year;
  }

  @override
  bool operator ==(Object other) =>
      other is DataFilterWholeYear && other.year == year;
  @override
  int get hashCode => Object.hash(year, 'Year Filter');
}
