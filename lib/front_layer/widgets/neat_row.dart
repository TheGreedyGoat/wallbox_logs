import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  LabeledField({
    this.children,
    required this.left,
    required this.right,
    this.borderColor = Colors.black,
    this.surfaceColor = Colors.white,
    super.key,
  });

  final Widget left;
  final Widget right;
  final List<Widget>? children;
  final Color borderColor;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: surfaceColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            left,
            _separator(context),
            if (children != null)
              for (final child in children!) ...[child, _separator(context)],
            right,
          ],
        ),
      ),
    );
  }

  Widget _separator(BuildContext context) => SizedBox(
    width: 1.0,
    height: double.infinity,
    child: Container(
      color: borderColor,
    ),
  );
}
