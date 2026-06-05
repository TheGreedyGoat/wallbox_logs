import 'package:flutter/material.dart';

class InputFieldDecoration extends StatelessWidget {
  InputFieldDecoration({
    required this.child,
    this.markEdited = false,
    this.hasChanged = false,
    this.backgroundColor,
    super.key,
  });
  final Widget child;
  final bool markEdited, hasChanged;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.inverseSurface.withAlpha(100),
        border: markEdited && hasChanged
            ? Border.all(color: Colors.red, width: 2.0)
            : null,
        // boxShadow: [BoxShadow(blurRadius: 10)],
      ),
      child: child,
    );
  }
}
