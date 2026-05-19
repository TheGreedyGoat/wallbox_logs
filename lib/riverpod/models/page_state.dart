import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';
part 'page_state.freezed.dart';

/// Data class for a pages.
@freezed
class PageState with _$PageState {
  /// the pages main body
  @override
  final Widget page;

  /// eg displayed in the App- oer SideBar
  @override
  final String title;

  /// a corresponding icon. Also shown in SideBar
  @override
  final Icon icon;

  /// sets if the side navigation bar is displayed
  @override
  final bool showSideBar;

  /// Data class for a pages.
  /// - [page]: the pages main body
  /// - [title]: eg displayed in the App- oer SideBar
  /// - [icon]: a corresponding icon. Also shown in SideBar
  /// - [showSideBar]: sets if the side navigation bar is displayed
  const PageState({
    required this.page,
    required this.title,
    required this.icon,
    this.showSideBar = true,
  });

  // PageState copyWith({
  //   Widget? Function()? page,
  //   String? Function()? title,
  //   Icon? Function()? icon,
  // }) => PageState(
  //   page: page != null ? page() : this.page,
  //   title: title != null ? title() : this.title,
  //   icon: icon != null ? icon() : this.icon,
  // );
}
