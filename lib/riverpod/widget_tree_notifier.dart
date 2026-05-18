import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/user_creation.dart';
import 'package:wallbox_logs/front_layer/pages/user_overview.dart';
import 'package:wallbox_logs/riverpod/models/page_state.dart';

enum MainPage {
  overview(
    pageState: PageState(
      page: UserOverview(),
      title: 'Übersicht',
      icon: Icon(Icons.person),
    ),
  ),
  editUser(
    pageState: PageState(
      page: UserEditing(),
      title: 'Nutzer anlegen',
      icon: Icon(Icons.person_add),
    ),
  )
  ;

  final PageState pageState;

  const MainPage({required this.pageState});
}

class WidgetTreeNotifier extends Notifier<PageState> {
  static const int historyMax = 20;
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

  void back() {
    if (history.isNotEmpty) {
      _setState(history.removeLast());
    }
  }

  void setMainPage(MainPage p) => _setState(p.pageState);

  void setCustom(PageState pageState) => _setState(pageState);

  Widget get pageWidget => state.page;
  String get pageTitle => state.title;
  Icon get pageIcon => state.icon;
}
