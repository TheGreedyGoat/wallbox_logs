import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/front_layer/widgets/my_list_view.dart';

class SideBar extends StatelessWidget {
  final bool extended;
  final int selectedPage;
  const SideBar({super.key, required this.selectedPage, this.extended = false});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
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
    );
  }
}
