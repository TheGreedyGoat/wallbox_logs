import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/file_upload/file_upload_page.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/front_layer/user_overview_Page/user_overview.dart';

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
        return LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth <= WidgetTree.minScreenWidth
                ? _mobile(context, selectedPage)
                : _desktop(context, selectedPage);
          },
        );
      },
    );
  }

  Widget _mobile(BuildContext context, int selectedPage) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainPageTitles[selectedPage]),
      ),

      body: mainPages[selectedPage],
      drawer: IntrinsicWidth(
        child: Drawer(
          child: Align(
            alignment: Alignment.topLeft,
            child: SideBar(
              selectedPage: selectedPage,
              extended: true,
              onPop: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _desktop(BuildContext context, int selectedPage) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainPageTitles[selectedPage]),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SideBar(
              selectedPage: selectedPage,
              extended: extendSideBar,
              onPop: () {
                setState(() {
                  extendSideBar = !extendSideBar;
                });
              },
            ),
          ),
          Expanded(
            child: mainPages[selectedPage],
          ),
        ],
      ),
    );
  }
}
