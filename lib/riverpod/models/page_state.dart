import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'page_state.freezed.dart';

@freezed
class PageState with _$PageState {
  final Widget page;
  final String title;
  final Icon icon;
  final bool showSideBar;

  const PageState({
    required this.page,
    required this.title,
    required this.icon,
    this.showSideBar = true,
  });
}
