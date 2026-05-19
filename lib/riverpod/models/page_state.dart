import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'page_state.freezed.dart';

/// Data class for app pages.
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

  /// Data class for app pages.
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
}
