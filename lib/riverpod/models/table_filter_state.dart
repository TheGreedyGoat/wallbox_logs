import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class DataFilterState<T> {
  DataFilterState({required this.activeFilters});
  final Map<String, DataFilter<T>?> activeFilters;

  @override
  bool operator ==(Object other) =>
      other is DataFilterState<T> && other.activeFilters == activeFilters;

  @override
  int get hashCode => activeFilters.hashCode;

  DataFilterState<T> copyWith({Map<String, DataFilter<T>?>? filters}) =>
      DataFilterState(activeFilters: filters ?? activeFilters);
}
