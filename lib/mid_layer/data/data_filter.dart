class DataFilter {
  const DataFilter({required this.filterValue, this.isInverted = false});
  final dynamic filterValue;
  final bool isInverted;

  bool passesFilter(dynamic value) {
    print(filterValue);
    if (filterValue == null) return true;
    assert(
      value.runtimeType == filterValue.runtimeType,
      'Error while filtering: types dont mach up: Value: $value (${value.runtimeType}), Filter: $filterValue(${filterValue.runtimeType})',
    );

    bool result = true;
    switch (value.runtimeType) {
      case const (String):
        result = (filterValue as String).contains(value as String);
      case const (int):
        result = (value as int) < (filterValue as int);
      case const (double):
        result = (value as double) < (filterValue as double);
      case const (DateTime):
        result = (value as DateTime).isAfter(filterValue as DateTime);
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
