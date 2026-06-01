import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/data/data_filter.dart';
import 'package:wallbox_logs/riverpod/models/data_filter_state.dart';

class TableFilterNotifier extends Notifier<TransactionFilterTableState> {
  TableFilterNotifier({required this.numFilters, required this.getRaw});

  final int numFilters;
  final List<List<dynamic>> Function() getRaw;

  @override
  TransactionFilterTableState build() {
    return TransactionFilterTableState();
  }

  void setFilterName(String? value) {
    state = state.copyWith(
      filterName: value == null
          ? () => null
          : () => DataFilter(filterValue: value),
    );
  }

  void setFilterTagID(String? value) {
    state = state.copyWith(
      filterId: value == null
          ? () => null
          : () => DataFilter(filterValue: value),
    );
  }

  void setFilterConsumFrom(String? value) {
    final parsed = int.tryParse(value ?? '');
    state = state.copyWith(
      filterConsFrom: parsed == null
          ? () => null
          : () => DataFilter(filterValue: parsed),
    );
  }

  void setFilterConsumTo(String? value) {
    final parsed = int.tryParse(value ?? '');
    state = state.copyWith(
      filterConsTo: parsed == null
          ? () => null
          : () => DataFilter(filterValue: parsed, isInverted: true),
    );
  }

  void setFilterCostFrom(String? value) {
    final parsed = double.tryParse(value ?? '');
    print('parsed: $parsed');
    state = state.copyWith(
      filterConsFrom: parsed == null
          ? () => null
          : () => DataFilter(filterValue: (parsed * 1000).floor()),
    );
  }

  void setFilterCostTo(String? value) {
    final parsed = int.tryParse(value ?? '');
    state = state.copyWith(
      filterConsTo: parsed == null
          ? () => null
          : () => DataFilter(
              filterValue: (parsed * 1000).floor(),
              isInverted: true,
            ),
    );
  }
}
