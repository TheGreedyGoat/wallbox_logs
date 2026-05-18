import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

final widgetTreeProvider = NotifierProvider(
  () => WidgetTreeNotifier(),
);
