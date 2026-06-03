import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';

typedef FilterCallback = bool Function(dynamic filterValue, dynamic value);

class DataFilter<T> {
  DataFilter({
    required this.filterValue,
    this.customCheck,
    this.isInverted = false,
  });
  final T filterValue;
  bool isInverted;
  bool Function(T? toCheck)? customCheck;

  bool check(T? toCheck) {
    if (customCheck != null) return customCheck!(toCheck);

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

abstract class DataFilterDate {
  bool checkDate(DateTime date);

  factory DataFilterDate.fromValues(int year, DateFilterSelections mode) {
    print('$mode, $year');
    return mode.type == DateFilterSelectionType.month
        ? DataFilterMonth.fromValues(year, mode)
        : (mode.type == DateFilterSelectionType.quarter
              ? DataFilterQuarter.fromValues(year, mode)
              : DataFilterWholeYear(year: year));
  }
}

class DataFilterMonth implements DataFilterDate {
  DataFilterMonth({required this.year, required this.month});
  final int year;
  final int month;

  @override
  bool checkDate(DateTime date) {
    print('month');
    return date.year == year && date.month == month;
  }

  @override
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

class DataFilterQuarter implements DataFilterDate {
  DataFilterQuarter({required this.quaterNum, required this.year});
  final int quaterNum;
  final int year;

  int get firstMonth => quaterNum * 3 + 1;
  int get lastMonth => quaterNum * 3 + 3;

  @override
  bool checkDate(DateTime date) {
    print('quater');
    return date.year == year &&
        date.month >= firstMonth &&
        date.month <= lastMonth;
  }

  @override
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

class DataFilterWholeYear implements DataFilterDate {
  DataFilterWholeYear({required this.year});
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
