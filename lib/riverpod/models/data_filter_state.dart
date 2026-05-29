import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

@immutable
class DataFilterState {
  DataFilterState({required this.filters, required this.rawTable});

  final List<List<dynamic>> rawTable;
  final List<DataFilter> filters;

  List<List<dynamic>> get filtered => rawTable
      .where(
        (e) => _filterItem(e),
      )
      .toList();

  bool _filterItem(List<dynamic> toCheck) {
    assert(
      toCheck.length == filters.length,
      'Error while filtering: passed data list does not share length with filterValues: \n----filterValues: $filters (Length ${filters.length}\n----toCheck: $toCheck (Length ${toCheck.length})',
    );

    for (int i = 0; i < toCheck.length; i++) {
      if (!filters[i].passesFilter(toCheck[i])) {
        print('failed');
        return false;
      }
    }
    print('passed');
    return true;
  }

  @override
  operator ==(Object other) =>
      other is DataFilterState && other.filters == filters;

  @override
  int get hashCode => filters.hashCode ^ filters.length;

  DataFilterState copyWith({
    List<DataFilter>? filters,
    List<List<dynamic>>? rawTable,
  }) => DataFilterState(
    filters:
        filters ??
        this.filters
            .map(
              (filter) => filter.copyWith(),
            )
            .toList(),
    rawTable: rawTable ?? this.rawTable,
  );
}
