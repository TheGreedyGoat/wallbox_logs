import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';

enum Sorting {
  tagID,
  name,
  date,
  consumption,
  cost,
}

class TransactionFilterState {
  TransactionFilterState({
    this.filterTagID,
    this.filterName,

    this.filterDate,

    this.filterConsumptionFrom,
    this.filterConsumptionTo,

    this.filterCostFrom,
    this.filterCostTo,

    this.sorting,
    this.invertSorting = false,
  });

  final DataFilter<String>? filterTagID;
  final DataFilter<String>? filterName;

  final DataFilterDate? filterDate;

  final DataFilter<int>? filterConsumptionFrom;
  final DataFilter<int>? filterConsumptionTo;

  final DataFilter<int>? filterCostFrom;
  final DataFilter<int>? filterCostTo;

  final Sorting? sorting;
  final bool invertSorting;

  List<WallBoxTransaction> getFiltered() {
    final raw = WallBoxTransaction.repo.getAll();
    final List<WallBoxTransaction> filtered = List.empty(growable: true);

    for (int i = 0; i < raw.length; i++) {
      final currentTransaction = raw[i];
      if ((filterTagID?.check(currentTransaction.tagID) ?? true) &&
          (filterName?.check(currentTransaction.username) ?? true) &&
          (filterDate?.checkDate(currentTransaction.startTimeStamp) ?? true) &&
          (filterConsumptionFrom?.check(currentTransaction.powerUsageWh) ??
              true) &&
          (filterCostFrom?.check(currentTransaction.costsInCent) ?? true)) {
        filtered.add(currentTransaction);
      }
    }

    return _sort(filtered);
  }

  List<WallBoxTransaction> _sort(
    List<WallBoxTransaction> unsorted,
  ) {
    if (sorting == null) return unsorted;

    final sorted = unsorted.toList();
    sorted.sort(
      (a, b) => invertSorting
          ? -1
          : 1 *
                switch (sorting!) {
                  Sorting.tagID => a.tagID.compareTo(b.tagID),
                  Sorting.name => a.username.compareTo(b.username),
                  Sorting.date => a.startTimeStamp.compareTo(b.startTimeStamp),
                  Sorting.consumption => a.powerUsageWh.compareTo(
                    b.powerUsageWh,
                  ),
                  Sorting.cost => a.costsInCent.compareTo(b.costsInCent),
                },
    );
    return sorted;
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
    filterDate,
    filterConsumptionFrom,
    filterCostFrom,
    sorting,
    invertSorting,
  );

  TransactionFilterState copyWith({
    DataFilter<String>? Function()? getIDFilter,

    DataFilter<String>? Function()? getNameFilter,

    DataFilterDate? Function()? getDateFilter,

    DataFilter<int>? Function()? getConsumptionFromFilter,
    DataFilter<int>? Function()? getConsumptionToFilter,

    DataFilter<int>? Function()? getCostFromFilter,
    DataFilter<int>? Function()? getCostToFilter,

    Sorting? Function()? getSorting,
    bool? invertSorting,
  }) => TransactionFilterState(
    filterTagID: getIDFilter == null ? filterTagID : getIDFilter(),
    filterName: getNameFilter == null ? filterName : getNameFilter(),
    filterDate: getDateFilter == null ? filterDate : getDateFilter(),
    filterConsumptionFrom: getConsumptionFromFilter == null
        ? filterConsumptionFrom
        : getConsumptionFromFilter(),
    filterCostFrom: getCostFromFilter == null
        ? filterCostFrom
        : getCostFromFilter(),
    sorting: getSorting == null ? sorting : getSorting(),
    invertSorting: invertSorting ?? this.invertSorting,
  );

  @override
  String toString() =>
      '$filterTagID\n$filterName\n$filterConsumptionFrom\n$filterCostFrom';
}
