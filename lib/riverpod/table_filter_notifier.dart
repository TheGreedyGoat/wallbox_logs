import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/date_filter_widget.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/models/transaction_filter_state.dart';

class TableFilterNotifier<T> extends Notifier<TransactionFilterState> {
  TableFilterNotifier();

  @override
  TransactionFilterState build() {
    return TransactionFilterState();
  }

  void setIDFilter(String? value) {
    state = state.copyWith(
      getIDFilter: () => value == null ? null : DataFilter(filterValue: value),
    );
  }

  void setNameFilter(String? value) {
    state = state.copyWith(
      getNameFilter: () =>
          value == null ? null : DataFilter(filterValue: value),
    );
  }

  void setDateFilter(String? year, DateFilterSelections mode) {
    int? yearNum = int.tryParse(year ?? '');
    state = state.copyWith(
      getDateFilter: () => yearNum == null
          //
          ? null
          : DataFilterDate.fromValues(yearNum, mode),
    );
  }

  void setConsumptionFromFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getConsumptionFromFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 1000).floor()),
    );
  }

  void setConsumptionToFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getConsumptionToFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 1000).floor(), isInverted: true),
    );
  }

  void setCostFromFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getCostFromFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 100).floor()),
    );
  }

  void setCostToFilter(String? value) {
    double? parsed = double.tryParse(value?.replaceAll(',', '.') ?? '');
    state = state.copyWith(
      getCostToFilter: () => parsed == null
          ? null
          : DataFilter(filterValue: (parsed * 100).floor(), isInverted: true),
    );
  }

  void setSorting(int? sortIndex, bool isInverted) {
    state = state.copyWith(
      getSorting: () => sortIndex != null ? Sorting.values[sortIndex] : null,
      invertSorting: isInverted,
    );
  }

  void clear() {
    state = build();
  }
}
