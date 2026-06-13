import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';

/// What field of [WallBoxTransaction] should we sort by?
enum Sorting {
  ///
  tagID,

  ///
  name,

  ///
  date,

  ///
  consumption,

  ///
  cost,
}

/// Stores all the information on how to filter and sort the table atm
class TransactionTableState {
  /// Stores all the information on how to filter and sort the table atm
  TransactionTableState({
    this.filterTagID,
    this.filterName,

    this.filterDate,

    this.filterConsumptionFrom,
    this.filterConsumptionTo,

    this.filterCostFrom,
    this.filterCostTo,

    this.includePaid = false,

    this.sorting,
    this.invertSorting = false,

    this.differenceMaker = false,
  });

  /// Filter for tagID
  final DataFilter<String>? filterTagID;

  /// Filter for username
  final DataFilter<String>? filterName;

  /// Filter for start date
  final DataFilterDate? filterDate;

  /// Filter for power consumption (lower limit)
  final DataFilter<int>? filterConsumptionFrom;

  /// Filter for power consumption (upper limit)
  final DataFilter<int>? filterConsumptionTo;

  /// Filter for costs (lower limit)
  final DataFilter<int>? filterCostFrom;

  /// Filter for costs (upper limit)
  final DataFilter<int>? filterCostTo;

  /// default: false
  ///
  /// If set to true, the table also shows Transactions that already have bills created for
  final bool includePaid;

  /// what to sort by
  final Sorting? sorting;

  /// false => Bottom-Up
  ///
  /// true => Top-Down
  final bool invertSorting;

  /// is switched in every copyWith() - call to ensure the old and new state are considered unEqual
  ///
  /// eg if the full list of transactions changed, we want to make sure the table updates, even though the filter and sorting state doesnt change
  final bool differenceMaker;

  /// returns the list, filtered and sorted according to the state as WallBoxTransactions
  List<WallBoxTransaction> getFiltered() {
    final raw = WallBoxTransaction.repo.getAll();
    late final List<WallBoxTransaction> filtered;
    filtered = List.empty(growable: true);
    for (int i = 0; i < raw.length; i++) {
      final currentTransaction = raw[i];
      if ((includePaid || !currentTransaction.isBilled) &&
          (filterTagID?.check(currentTransaction.tagID) ?? true) &&
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
    // if (sorting == null) return unsorted;

    final sorted = unsorted.toList();
    sorted.sort(
      (a, b) {
        int result =
            (invertSorting ? -1 : 1) *
            switch (sorting ?? Sorting.date) {
              Sorting.tagID => a.tagID.compareTo(b.tagID),
              Sorting.name => a.username.compareTo(b.username),
              Sorting.date => a.startTimeStamp.compareTo(
                b.startTimeStamp,
              ),
              Sorting.consumption => a.powerUsageWh.compareTo(
                b.powerUsageWh,
              ),
              Sorting.cost => a.costsInCent.compareTo(b.costsInCent),
            };
        return result;
      },
    );
    return sorted;
  }

  /// returns the list, filtered and sorted according to the state as al List of Strings, only containing the data we wanna show
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
      other is TransactionTableState &&
      other.differenceMaker == differenceMaker &&
      other.hashCode == hashCode;
  @override
  int get hashCode => Object.hash(
    'taFilterstate',
    filterTagID,
    filterName,
    filterDate,
    filterConsumptionFrom,
    filterCostFrom,
    sorting,
    invertSorting,
    includePaid,
  );

  ///
  TransactionTableState copyWith({
    DataFilter<String>? Function()? getIDFilter,

    DataFilter<String>? Function()? getNameFilter,

    DataFilterDate? Function()? getDateFilter,

    DataFilter<int>? Function()? getConsumptionFromFilter,
    DataFilter<int>? Function()? getConsumptionToFilter,

    DataFilter<int>? Function()? getCostFromFilter,
    DataFilter<int>? Function()? getCostToFilter,
    bool? includePaid,

    Sorting? Function()? getSorting,
    bool? invertSorting,
  }) => TransactionTableState(
    filterTagID: getIDFilter == null ? filterTagID : getIDFilter(),
    filterName: getNameFilter == null ? filterName : getNameFilter(),
    filterDate: getDateFilter == null ? filterDate : getDateFilter(),
    filterConsumptionFrom: getConsumptionFromFilter == null
        ? filterConsumptionFrom
        : getConsumptionFromFilter(),
    filterCostFrom: getCostFromFilter == null
        ? filterCostFrom
        : getCostFromFilter(),
    includePaid: includePaid ?? this.includePaid,
    sorting: getSorting == null ? sorting : getSorting(),
    invertSorting: invertSorting ?? this.invertSorting,
    differenceMaker: !this.differenceMaker,
  );

  @override
  String toString() =>
      '$filterTagID\n$filterName\n$filterConsumptionFrom\n$filterCostFrom';
}
