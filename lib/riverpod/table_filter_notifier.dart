import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/riverpod/models/table_filter_state.dart';

typedef DataFilter<T> = bool Function(T);

class TableFilterNotifier<T> extends Notifier<DataFilterState<T>> {
  TableFilterNotifier();

  @override
  DataFilterState<T> build() {
    return DataFilterState(activeFilters: {});
  }

  void setAllFilters(Map<String, DataFilter<T>> filters) =>
      state = state.copyWith(filters: filters);

  void setFilter(String key, DataFilter<T> filter) {
    final newFilters = Map<String, DataFilter<T>>.from(state.activeFilters);
    newFilters[key] = filter;
    setAllFilters(newFilters);
  }

  void removeFilter(String key) {
    final newFilters = Map<String, DataFilter<T>>.from(state.activeFilters);
    newFilters.remove(key);
    setAllFilters(newFilters);
  }

  /// returns a list of all elements in [original] that pass all filters of the current state
  List<T> filter(List<T> original) {
    return original
        .where(
          (element) => state.activeFilters.keys.fold(
            true,
            (previousValue, key) =>
                previousValue &&
                (state.activeFilters[key]?.call(element) ?? true),
          ),
        )
        .toList();
  }

  List<String> filterAsStrings(List<T> original) =>
      filter(original).map((e) => e.toString()).toList();
}
