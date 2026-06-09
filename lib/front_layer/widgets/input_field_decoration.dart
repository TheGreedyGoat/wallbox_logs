import 'package:flutter/material.dart';

/// Wrapper Widget to unify the visuals and functionality of Input fields
class InputFieldDecoration extends StatelessWidget {
  /// Wrapper Widget to unify the visuals and functionality of Input fields
  const InputFieldDecoration({
    required this.child,
    this.markEdited = false,
    this.hasChanged = false,
    this.backgroundColor,
    super.key,
  });

  /// The widget to be decorated
  final Widget child;

  /// [markEdited] tells the widget that it should be able to mark the field as edited
  ///
  /// if set to true, [hasChanged] decides if it actually gets marked
  final bool markEdited, hasChanged;

  /// set a custom background color
  final Color? backgroundColor;

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
