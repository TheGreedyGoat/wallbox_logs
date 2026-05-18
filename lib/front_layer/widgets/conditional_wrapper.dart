import 'package:flutter/material.dart';

/// Typedef for a Widget that has a single child property
typedef ChildWidgetBuilder = Widget Function(Widget child);

/// Extension to add the functionality of wrap a widget with another one conditionally
extension ConditionalWrapper on Widget {
  /// Returns this Widget wrapped by [wrapper] if [condition] is true, else just this Widget itself.
  Widget wrapIf<T extends SingleChildRenderObjectWidget>(
    bool condition,
    ChildWidgetBuilder wrapper,
  ) {
    return condition ? wrapper(this) : this;
  }
}
