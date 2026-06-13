import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({this.child, this.level = 0, this.padding, super.key});
  final Widget? child;
  final int level;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 8.0),
      decoration: BoxDecoration(
        color: _backGroundColor(context),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
