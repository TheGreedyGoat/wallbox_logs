import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/app_settings.dart';
import 'package:wallbox_logs/riverpod/models/page_state.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

/// A custom navigation bar
class SideBar extends ConsumerStatefulWidget {
  /// optional custom background color
  final Color? backgroundColor;

  /// A custom navigation bar
  const SideBar({this.backgroundColor, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SideBarRPState();
}

class _SideBarRPState extends ConsumerState<SideBar> {
  bool extended = false;

  Color background(BuildContext context) =>
      widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceDim;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background(context),
      ),
      child: Column(
        crossAxisAlignment: extended
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                extended = !extended;
              });
            },
            icon: extended
                ? const Icon(Icons.arrow_back)
                : const Icon(Icons.arrow_forward),
          ),
          Expanded(
            child: NavigationRail(
              indicatorColor: Theme.of(
                context,
              ).colorScheme.primaryContainer,
              backgroundColor: background(context),
              extended: extended,
              onDestinationSelected: (index) {
                ref
                    .read(widgetTreeProvider.notifier)
                    .setMainPage(MainPage.values[index]);
                // setState(() {
                //   selectedIndex = index;
                // });
              },
              destinations: [
                for (final p in MainPage.values)
                  NavigationRailDestination(
                    icon: Container(
                      child: p.pageState.icon,
                    ),
                    label: Text(p.pageState.title),
                  ),
              ],
              selectedIndex: MainPage.values.indexOf(
                MainPage.values.firstWhere(
                  (element) =>
                      element.pageState.title ==
                      ref.watch(widgetTreeProvider).title,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(widgetTreeProvider.notifier)
                        .setCustomPage(
                          PageState(
                            page: AppSettingsPage(),
                            title: 'AppSettings',
                            icon: Icon(Icons.settings),
                            showSideBar: false,
                          ),
                        );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      if (extended) Text('Einstellungen'),
                    ],
                  ),
                ),
              ),
              trailingAtBottom: true,
            ),
          ),
        ],
      ),
    );
  }
}
