import 'package:flutter/material.dart';

/// Potontionally disposable!
/// Wrapper for ListViews
class MyListView extends StatelessWidget {
  /// Potontionally disposable!
  /// Wrapper for ListViews
  const MyListView({super.key, required this.children});

  /// The ListView's children
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children,
    );
  }
}
