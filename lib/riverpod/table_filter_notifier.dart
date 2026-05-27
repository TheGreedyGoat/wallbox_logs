import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';

class TableFilterNotifier<T> extends Notifier<DataFilterState<T>> {
  TableFilterNotifier();

  @override
  DataFilterState<T> build() {
    return DataFilterState<T>(activeFilters: <String, DataFilter<T>>{});
  }

  void setupFilters(Map<String, DataFilter<T>> filters) {
    if (state.activeFilters.isNotEmpty) return;
    state = state.copyWith(filters: filters);
  }

  _setFilter(String key, DataFilter<T> f) {
    final updatedFilters = {...state.activeFilters};
    updatedFilters[key] = f;
    state = state.copyWith(filters: updatedFilters);
  }

  void setFilterValue(String key, dynamic value) {
    final filter = state.activeFilters[key];
    if (filter != null) {
      _setFilter(key, filter.copyWith(filterValue: value));
      return;
    }
    print('No filter of $key found');
  }

  void setCheckCallback(String key, FilterCallback check) {
    final filter = state.activeFilters[key];
    if (filter != null) {
      _setFilter(key, filter.copyWith(check: check));
      return;
    }
    print('No filter of $key found');
  }

  DataFilter<T>? getFilter(String key) {
    return state.activeFilters[key];
  }
}
