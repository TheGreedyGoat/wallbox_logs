import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/transaction_overview.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

/// The app's root structure.
/// change Page by setting the state of [widgetTreeProvider]
class WidgetTree extends ConsumerWidget {
  /// The app's root structure.
  /// change Page by setting the state of [widgetTreeProvider]
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(widgetTreeProvider);
    final notifier = ref.watch(widgetTreeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: state.showSideBar
            ? state.icon
            : BackButton(
                onPressed: () => notifier.back(),
              ),
        title: Text(state.title),
        backgroundColor: Colors.blueGrey[200],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.showSideBar)
            SideBarRP(
              backgroundColor: Colors.blueGrey[100],
            ),
          Expanded(
            child: state.page,
          ),
        ],
      ),
    );
  }
}
