typedef FilterCallback = bool Function(dynamic filterValue, dynamic value);

class DataFilter<T> {
  DataFilter({
    this.filterValue,
    this.check,
    required this.getValue,
  });
  final dynamic filterValue;
  final dynamic Function(T object) getValue;

  final FilterCallback? check;

  bool filter(T checkObject) =>
      check?.call(filterValue, getValue(checkObject)) ?? true;

  @override
  bool operator ==(Object other) =>
      other is DataFilter<T> &&
      other.filterValue == filterValue &&
      other.check == check;

  @override
  int get hashCode => filterValue.hashCode + check.hashCode;

  DataFilter<T> copyWith({
    dynamic filterValue,
    FilterCallback? check,
    dynamic Function(T)? getValue,
  }) => DataFilter(
    filterValue: filterValue ?? this.filterValue,
    check: check ?? this.check,
    getValue: getValue ?? this.getValue,
  );
}
