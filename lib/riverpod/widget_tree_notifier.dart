import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/user_editing.dart';
import 'package:wallbox_logs/front_layer/pages/user_overview.dart';
import 'package:wallbox_logs/riverpod/models/page_state.dart';

/// The Apps default main pages to navigate between via the [SideBar]
enum MainPage {
  /// shows an overview of all Wallbox users
  overview(
    pageState: PageState(
      page: UserOverview(),
      title: 'Übersicht',
      icon: Icon(Icons.person),
    ),
  ),

  /// create or edit user profiles
  editUser(
    pageState: PageState(
      page: UserEditing(),
      title: 'Nutzer anlegen',
      icon: Icon(Icons.person_add),
    ),
  )
  ;

  /// The corresponding default [PageState]
  final PageState pageState;

  const MainPage({required this.pageState});
}

/// Notifier class for the [widgetTreeProvider]
class WidgetTreeNotifier extends Notifier<PageState> {
  /// limit on how many pagges schould be cached in [history]
  static const int historyMax = 20;

  /// saves previously visited pages up to a number of [historyMax]
  final List<PageState> history = List.empty(growable: true);

  @override
  PageState build() => MainPage.overview.pageState;

  void _setState(PageState pageState) {
    history.add(state);
    if (history.length > historyMax) {
      history.removeAt(0);
    }
    state = pageState;
  }

  /// Return to the previously visited page, if available
  void back() {
    if (history.isNotEmpty) {
      _setState(history.removeLast());
    }
  }

  /// quick access to set the WidgetTree to one of the App's default main pages.
  ///
  /// To set a different page use [setCustomPage]
  void setMainPage(MainPage p) => _setState(p.pageState);

  /// set the widget to any PageState
  void setCustomPage(PageState pageState) => _setState(pageState);

  /// getter to the current page
  Widget get pageWidget => state.page;

  /// getter to the current pages title
  String get pageTitle => state.title;

  /// getter to the current pages icon
  Icon get pageIcon => state.icon;
}
