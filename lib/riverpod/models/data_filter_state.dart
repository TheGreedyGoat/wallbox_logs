import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

@immutable
class TransactionFilterTableState {
  TransactionFilterTableState({
    this.filterConsFrom,
    this.filterConsTo,
    this.filterId,
    this.filterName,
    this.filterDateFrom,
    this.filterDateTo,
  });

  List<WallBoxTransaction> get rawTable => WallBoxTransaction.repo.getAll();

  final DataFilter<String>? filterId;
  final DataFilter<String>? filterName;
  final DataFilter<DateTime>? filterDateFrom;
  final DataFilter<DateTime>? filterDateTo;
  final DataFilter<int>? filterConsFrom;
  final DataFilter<int>? filterConsTo;

  TransactionFilterTableState copyWith({
    DataFilter<String>? Function()? filterId,
    DataFilter<String>? Function()? filterName,
    DataFilter<DateTime>? Function()? filterDateFrom,
    DataFilter<DateTime>? Function()? filterDateTo,
    DataFilter<int>? Function()? filterConsFrom,
    DataFilter<int>? Function()? filterConsTo,
  }) => TransactionFilterTableState(
    filterId: filterId != null ? filterId() : this.filterId,
    filterName: filterName != null ? filterName() : this.filterName,
    filterDateFrom: filterDateFrom != null
        ? filterDateFrom()
        : this.filterDateFrom,
    filterDateTo: filterDateTo != null ? filterDateTo() : this.filterDateTo,
    filterConsFrom: filterConsFrom != null
        ? filterConsFrom()
        : this.filterConsFrom,
    filterConsTo: filterConsTo != null ? filterConsTo() : this.filterConsTo,
  );

  List<WallBoxTransaction> get filtered {
    final raw = [...rawTable];
    print('filter in pogress...');
    final filtered = List<WallBoxTransaction>.empty(growable: true);
    for (int i = 0; i < raw.length; i++) {
      final transaction = raw[i];
      if (_checkFilter(filterId, transaction.tagID) &&
          _checkFilter(filterName, transaction.username) &&
          _checkFilter(filterDateFrom, transaction.startTimeStamp) &&
          _checkFilter(filterDateTo, transaction.startTimeStamp) &&
          _checkFilter(filterConsFrom, transaction.powerUsageWh) &&
          _checkFilter(filterConsTo, transaction.powerUsageWh)) {
        filtered.add(transaction);
      }
    }
    return filtered;
  }

  bool _checkFilter<T>(DataFilter<T>? filter, T toCheck) {
    bool passed = filter == null || filter.passesFilter(toCheck);
    return passed;
  }

  @override
  operator ==(Object other) =>
      other is TransactionFilterTableState && other.hashCode == this.hashCode;

  @override
  int get hashCode => Object.hash(
    filterId,
    filterName,
    filterDateFrom,
    filterDateTo,
    filterConsFrom,
    filterConsTo,
  );
}
