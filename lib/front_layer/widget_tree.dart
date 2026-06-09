import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/sidebar.dart';
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
            if (state.showSideBar) SideBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: state.page,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: state.floatingActionButton,
    );
  }
}
