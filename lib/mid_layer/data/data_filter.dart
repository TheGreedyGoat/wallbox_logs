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
