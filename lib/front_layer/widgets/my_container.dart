import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({this.child, this.level = 0, super.key});
  final Widget? child;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backGroundColor(context),
      ),
      child: child,
    );
  }

  Color _backGroundColor(BuildContext context) {
    switch (level) {
      case 0:
        return Theme.of(context).colorScheme.primaryContainer;
      case 1:
        return Theme.of(context).colorScheme.secondaryContainer;
      case 2:
        return Theme.of(context).colorScheme.tertiaryContainer;
      default:
        return Theme.of(context).colorScheme.primaryContainer;
    }
  }
}
