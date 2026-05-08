import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/pages/file_upload_page.dart';
import 'package:wallbox_logs/front_layer/pages/user_creation.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/front_layer/pages/user_overview.dart';

/// Pages in man view
List<Widget> mainPages = [UserOverview(), FileUploadPage()];

/// each pages icons for the [SideBar]s [NavigationRail].
List<Icon> mainPagesIcons = [Icon(Icons.person), Icon(Icons.upload)];

/// each pages title for the [AppBar] & the [SideBar]s [NavigationRail].
List<String> mainPageTitles = ['Übersicht', 'Datei hochladen'];

/// Stores the current pages index
ValueNotifier selectedPageNotifier = ValueNotifier(0);

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
        children: [
          SideBar(
            selectedPage: selectedPage,
            extended: extendSideBar,
            backgroundColor: Colors.blueGrey[100],
            onPop: () {
              setState(() {
                extendSideBar = !extendSideBar;
              });
            },
          ),
          Expanded(
            child: UserCreation(), //mainPages[selectedPage],
          ),
        ],
      ),
    );
  }
}
