import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/file_upload/file_upload_page.dart';
import 'package:wallbox_logs/front_layer/sidebar.dart';
import 'package:wallbox_logs/front_layer/user_overview_Page/user_overview.dart';

List<Widget> mainPages = [UserOverview(), FileUploadPage()];
List<Icon> mainPagesIcons = [Icon(Icons.person), Icon(Icons.upload)];
List<String> mainPageTitles = ["Übersicht", "Datei hochladen"];
ValueNotifier selectedPageNotifier = ValueNotifier(0);

class WidgetTree extends StatefulWidget {
  static const minScreenWidth = 800;

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
