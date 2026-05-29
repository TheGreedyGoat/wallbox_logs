import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';

class TableFilterNotifier extends Notifier<DataFilterState> {
  TableFilterNotifier({required this.numFilters, required this.getRaw});

  final int numFilters;
  final List<List<dynamic>> Function() getRaw;

  @override
  DataFilterState build() {
    return DataFilterState(
      filters: [
        for (int i = 0; i < numFilters; i++) DataFilter(filterValue: null),
      ],
      rawTable: getRaw(),
    );
  }

  void setFilters(List<DataFilter> filters) {
    state = state.copyWith(filters: filters);
  }

  void updateRaw() => state = state.copyWith(rawTable: getRaw());

  set rawTable(List<List<dynamic>> raw) {
    state = state.copyWith(
      rawTable: raw,
      filters: raw[0]
          .map(
            (e) => DataFilter(filterValue: e),
          )
          .toList(),
    );
  }

  void setFilterValue(int index, dynamic value) {
    assert(_checkIndex(index), 'out of filterbounds');
    final nextFilters = [
      for (int i = 0; i < state.filters.length; i++)
        state.filters[i].copyWith(filterValue: index == i ? value : null),
    ];

    setFilters(nextFilters);
  }

  void setFilterInversion(int index, bool value) {
    assert(_checkIndex(index), 'out of filterbounds');
    final nextFilters = [
      for (int i = 0; i < state.filters.length; i++)
        state.filters[i].copyWith(isInverted: index == i ? value : null),
    ];
    setFilters(nextFilters);
  }

  List<List<dynamic>> getFiltered() => state.filtered;

  bool _checkIndex(int index) => index >= 0 && index < state.filters.length;
}
