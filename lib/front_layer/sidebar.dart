import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

class SideBarRP extends ConsumerStatefulWidget {
  final Color? backgroundColor;
  const SideBarRP({this.backgroundColor, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SideBarRPState();
}

class _SideBarRPState extends ConsumerState<SideBarRP> {
  bool extended = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.backgroundColor),
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
              backgroundColor: widget.backgroundColor,
              indicatorShape: CircleBorder(),
              extended: extended,
              onDestinationSelected: (index) {
                ref
                    .read(widgetTreeProvider.notifier)
                    .setMainPage(MainPage.values[index]);
                setState(() {
                  selectedIndex = index;
                });
              },
              destinations: [
                for (final p in MainPage.values)
                  NavigationRailDestination(
                    icon: p.pageState.icon,
                    label: Text(p.pageState.title),
                  ),
              ],
              selectedIndex: selectedIndex,
            ),
          ),
        ],
      ),
    );
    ;
  }
}

/// A custom navigation bar
class SideBar extends ConsumerWidget {
  /// Indicates that the [NavigationRail] should be in the extended state.
  final bool extended;

  /// callback for the Sidebars extension and retraction
  final VoidCallback onPop;

  final Color? backgroundColor;

  /// A custom navigation bar
  const SideBar({
    super.key,
    required this.onPop,
    this.extended = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final notifier = ref.watch(widgetTreeProvider.notifier);
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        crossAxisAlignment: extended
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPop,
            icon: extended
                ? const Icon(Icons.arrow_back)
                : const Icon(Icons.arrow_forward),
          ),
          Expanded(
            child: NavigationRail(
              backgroundColor: backgroundColor,
              indicatorShape: CircleBorder(),
              extended: extended,
              onDestinationSelected: (index) {
                ref
                    .read(widgetTreeProvider.notifier)
                    .setMainPage(MainPage.values[index]);
              },
              destinations: [
                for (final p in MainPage.values)
                  NavigationRailDestination(
                    icon: p.pageState.icon,
                    label: Text(p.pageState.title),
                  ),
              ],
              //TODO handle this
              selectedIndex: 0,
            ),
          ),
        ],
      ),
    );
  }
}
