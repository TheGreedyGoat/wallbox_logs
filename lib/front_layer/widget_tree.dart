// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/pages/user_creation.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/front_layer/pages/user_overview.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

enum Pages {
  overview(title: 'Übersicht', icon: Icon(Icons.person)),
  editing(title: 'Nutzer erstellen/ bearbeiten', icon: Icon(Icons.person_add))
  ;

  final String title;
  final Icon icon;
  const Pages({required this.title, required this.icon});
}

Widget getPage(Pages page, List<dynamic>? args) {
  switch (page) {
    case Pages.overview:
      return UserOverview();
    case Pages.editing:
      bool hasOriginal =
          args != null && args.length > 0 && args[0] is UserMasterData;
      return UserEditing(
        original: hasOriginal ? args[0] : null,
      );
    default:
      return Center(
        child: Text('404'),
      );
  }
}

/// Pages in man view
final List<Widget> mainPages = [
  UserOverview(),
  UserEditing(),
];

/// each pages icons for the [SideBar]s [NavigationRail].
final List<Icon> mainPagesIcons = [Icon(Icons.person), Icon(Icons.person_add)];

/// each pages title for the [AppBar] & the [SideBar]s [NavigationRail].
final List<String> mainPageTitles = ['Übersicht', 'Nutzerdaten hinzufügen'];

/// Stores the current pages index
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

/// The apps root, has a mobile and desktop variant
class WidgetTree extends StatefulWidget {
  /// Threshold to switch between
  static const minScreenWidth = 800;

  /// The apps root
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool extendSideBar = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return _content(
          context,
          selectedPage,
        );
      },
    );
  }

  Widget _content(BuildContext context, int selectedPage) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainPageTitles[selectedPage]),
        backgroundColor: Colors.blueGrey[200],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SideBar(
            extended: extendSideBar,
            backgroundColor: Colors.blueGrey[100],
            onPop: () {
              setState(() {
                extendSideBar = !extendSideBar;
              });
            },
          ),
          Expanded(
            child: mainPages[selectedPage],
          ),
        ],
      ),
    );
  }
}
