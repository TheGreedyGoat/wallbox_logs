import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/transaction_overview.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/front_layer/widgets/filterable_table.dart';
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
        elevation: 10,
        shadowColor: Colors.black,
        leading: state.showSideBar
            ? state.icon
            : BackButton(
                onPressed: () => notifier.back(),
              ),
        title: Text(state.title),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceBright,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.showSideBar) SideBarRP(),
            Expanded(
              child: state.page,
            ),
          ],
        ),
      ),
    );
  }
}
