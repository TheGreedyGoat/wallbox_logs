import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/riverpod/app_data_notifier.dart';
import 'package:wallbox_logs/riverpod/table_filter_notifier.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

/// Provides the state of the Widget Tree
final widgetTreeProvider = NotifierProvider(
  () => WidgetTreeNotifier(),
);

final transactionFilterProvider = NotifierProvider(
  () => TableFilterNotifier<WallBoxTransaction>(),
);

final appDataProvider = NotifierProvider(
  () => AppDataNotifier(),
);
