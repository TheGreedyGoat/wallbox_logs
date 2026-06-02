import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

class TransactionFilterState {
  TransactionFilterState({
    this.filterTagID,
    this.filterName,
    this.filterConsumptionFrom,
    this.filterConsumptionTo,

    this.filterCostFrom,
    this.filterCostTo,
  });

  DataFilter<String>? filterTagID;
  DataFilter<String>? filterName;
  DataFilter<int>? filterConsumptionFrom;
  DataFilter<int>? filterConsumptionTo;
  DataFilter<int>? filterCostFrom;
  DataFilter<int>? filterCostTo;

  bool _checkFilterTagID(String toCheck) {
    return filterTagID == null
        ? true
        : toCheck.contains(filterTagID!.filterValue);
  }

  List<WallBoxTransaction> getFiltered() {
    final raw = WallBoxTransaction.repo.getAll();
    final List<WallBoxTransaction> filtered = List.empty(growable: true);

    for (int i = 0; i < raw.length; i++) {
      final currentTransaction = raw[i];
      if ((filterTagID?.check(currentTransaction.tagID) ?? true) &&
          (filterName?.check(currentTransaction.username) ?? true) &&
          (filterConsumptionFrom?.check(currentTransaction.powerUsageWh) ??
              true) &&
          (filterCostFrom?.check(currentTransaction.costsInCent) ?? true)) {
        filtered.add(currentTransaction);
      }
    }

    return filtered;
  }

  List<List<String>> getFilteredForDisplay() {
    final filtered = getFiltered();
    final List<List<String>> display = List.empty(growable: true);
    for (final transaction in filtered) {
      display.add([
        transaction.tagID,
        transaction.username,
        transaction.startTimeDisplay(),
        transaction.powerUsageKWhDisplay,
        transaction.costsDisplay,
      ]);
    }

    return display.toList(growable: false);
  }

  @override
  bool operator ==(Object other) =>
      other is TransactionFilterState && other.hashCode == hashCode;
  @override
  int get hashCode => Object.hash(
    filterTagID,
    filterName,
    filterConsumptionFrom,
    filterCostFrom,
  );

  TransactionFilterState copyWith({
    DataFilter<String>? Function()? getIDFilter,

    DataFilter<String>? Function()? getNameFilter,

    DataFilter<int>? Function()? getConsumptionFromFilter,
    DataFilter<int>? Function()? getConsumptionToFilter,

    DataFilter<int>? Function()? getCostFromFilter,
    DataFilter<int>? Function()? getCostToFilter,
  }) => TransactionFilterState(
    filterTagID: getIDFilter == null ? filterTagID : getIDFilter(),
    filterName: getNameFilter == null ? filterName : getNameFilter(),
    filterConsumptionFrom: getConsumptionFromFilter == null
        ? filterConsumptionFrom
        : getConsumptionFromFilter(),
    filterCostFrom: getCostFromFilter == null
        ? filterCostFrom
        : getCostFromFilter(),
  );

  @override
  String toString() =>
      '$filterTagID\n$filterName\n$filterConsumptionFrom\n$filterCostFrom';
}
