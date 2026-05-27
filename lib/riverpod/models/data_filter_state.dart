import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class DataFilterState<T> {
  DataFilterState({required this.activeFilters});
  final Map<String, DataFilter<T>> activeFilters;
  @override
  bool operator ==(Object other) =>
      other is DataFilterState<T> && other.activeFilters == activeFilters;

  @override
  int get hashCode => activeFilters.hashCode;

  DataFilterState<T> copyWith({
    Map<String, DataFilter<T>>? filters,
  }) => DataFilterState(activeFilters: filters ?? {...activeFilters});

  List<T> filter(List<T> original) {
    final result = original.where(
      (T tObject) {
        return activeFilters.values.fold(
          true,
          (previousValue, filter) {
            return previousValue && filter.filter(tObject);
          },
        );
      },
    ).toList();
    print('${original.length}, ${result.length}');
    return result;
  }
}
