import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

/// Provides the state of the Widget Tree
final widgetTreeProvider = NotifierProvider(
  () => WidgetTreeNotifier(),
);
