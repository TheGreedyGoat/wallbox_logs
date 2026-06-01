// [tagID, ame, datum...]
// [ , , ]

class DataFilter<T> {
  const DataFilter({required this.filterValue, this.isInverted = false});
  final T filterValue;
  final bool isInverted;

  bool passesFilter(T value) {
    print('filterValue: $filterValue, value: $value, isInverted: $isInverted');
    assert(
      value.runtimeType == filterValue.runtimeType,
      'Error while filtering: types dont mach up: Value: $value (${value.runtimeType}), Filter: $filterValue(${filterValue.runtimeType})',
    );

    bool result = true;
    switch (T) {
      case const (String):
        result = (value as String).contains(filterValue as String);
      case const (int):
        result = (value as int) >= (filterValue as int);
      case const (double):
        result = (value as double) >= (filterValue as double);
      case const (DataFilterDatum):
        result = (filterValue as DataFilterDatum).passesFilter(
          value as DateTime,
        );
      case const (bool):
        result = value == filterValue;
      default:
        throw ('No filtering logic provided for type ${value.runtimeType}');
    }
    return result != isInverted;
  }

  DataFilter copyWith({dynamic filterValue, bool? isInverted}) => DataFilter(
    filterValue: filterValue ?? this.filterValue,
    isInverted: isInverted ?? this.isInverted,
  );
  @override
  operator ==(Object other) =>
      other is DataFilter &&
      other.filterValue == filterValue &&
      other.isInverted == isInverted;

  @override
  int get hashCode =>
      (filterValue ?? 'null').hashCode ^ isInverted.toString().hashCode;
}

abstract class DataFilterDatum {
  bool passesFilter(DateTime value);
}

class DataFilterDatumMonat implements DataFilterDatum {
  final int jahr;
  final int monat;

  DataFilterDatumMonat(this.jahr, this.monat);

  bool passesFilter(DateTime value) {
    return value.year == jahr && value.month == monat;
  }
}
