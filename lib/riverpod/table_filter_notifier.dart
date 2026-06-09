import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/models/transaction_table_state.dart';

/// Notifier for the transaction overview table
class TransactionTableNotifierNotifier<T>
    extends Notifier<TransactionTableState> {
  /// Notifier for the transaction overview table
  TransactionTableNotifierNotifier();

  @override
  TransactionTableState build() {
    return TransactionTableState();
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setIDFilter(String? value) {
    state = state.copyWith(
      getIDFilter: () => value == null ? null : DataFilter(filterValue: value),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setNameFilter(String? value) {
    state = state.copyWith(
      getNameFilter: () =>
          value == null ? null : DataFilter(filterValue: value),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setDateFilter(String? year, DateFilterSelections mode) {
    int? yearNum = int.tryParse(year ?? '');
    state = state.copyWith(
      getDateFilter: () => yearNum == null
          //
          ? null
          : DataFilterDate.fromValues(yearNum, mode),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setConsumptionFromFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getConsumptionFromFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 1000).floor()),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setConsumptionToFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getConsumptionToFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 1000).floor(), isInverted: true),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setCostFromFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getCostFromFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 100).floor()),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setCostToFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getCostToFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 100).floor(), isInverted: true),
    );
  }

  /// set this filter to filter by [value]. If value == null, the filter is reset
  void setSorting(int? sortIndex, bool isInverted) {
    state = state.copyWith(
      getSorting: () => sortIndex != null ? Sorting.values[sortIndex] : null,
      invertSorting: isInverted,
    );
  }

  /// set if we want to show billed Transactions
  void setIncludePaid(bool value) => state = state.copyWith(includePaid: value);

  /// clear all filters
  void clear() {
    state = build();
  }

  /// trigger a state change without actually changing a relevant value
  void refresh() {
    state = state.copyWith();
  }
}
