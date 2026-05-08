import 'package:flutter/material.dart';

typedef ChildWidgetBuilder = Widget Function(Widget child);

extension ConditionalWrapper on Widget {
  Widget wrapIf<T extends SingleChildRenderObjectWidget>(
    bool condition,
    ChildWidgetBuilder wrapper,
  ) {
    return condition ? wrapper(this) : this;
  }
}
