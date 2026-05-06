import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';

/// A custom navigation bar
class SideBar extends StatelessWidget {
  /// Indicates that the [NavigationRail] should be in the extended state.
  final bool extended;

  /// The current pages index
  final int selectedPage;

  /// callback for the Sidebars extension and retraction
  final VoidCallback onPop;

  /// A custom navigation bar
  const SideBar({
    super.key,
    required this.selectedPage,
    required this.onPop,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: extended
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPop,
          icon: extended
              ? const Icon(Icons.arrow_back)
              : const Icon(Icons.menu),
        ),
        Expanded(
          child: NavigationRail(
            extended: extended,
            onDestinationSelected: (value) {
              selectedPageNotifier.value = value;
            },
            destinations: [
              for (int i = 0; i < mainPages.length; i++)
                NavigationRailDestination(
                  icon: mainPagesIcons[i],
                  label: Text(mainPageTitles[i]),
                ),
            ],
            selectedIndex: selectedPage,
          ),
        ),
      ],
    );
  }
}
