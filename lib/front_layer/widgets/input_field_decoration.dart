import 'package:flutter/material.dart';

class InputFieldDecoration extends StatelessWidget {
  InputFieldDecoration({
    required this.child,
    this.markEdited = false,
    this.hasChanged = false,
    super.key,
  });
  final Widget child;
  final bool markEdited, hasChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(15, 10)),
        color: Theme.of(context).colorScheme.inverseSurface.withAlpha(100),
        border: markEdited && hasChanged
            ? Border.all(color: Colors.red, width: 2.0)
            : null,
        // boxShadow: [BoxShadow(blurRadius: 10)],
      ),
      child: child,
    );
  }
}
