import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  LabeledField({
    this.children,
    required this.label,
    required this.right,
    this.labelStyle,
    this.borderColor = Colors.black,
    this.surfaceColor = Colors.white,
    super.key,
  });

  final String label;
  final TextStyle? labelStyle;
  final Widget right;
  final List<Widget>? children;
  final Color borderColor;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          color: surfaceColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                label,
                style:
                    labelStyle ??
                    Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(
                      color: borderColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            _separator(context),
            if (children != null)
              for (final child in children!) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: child,
                ),
                _separator(context),
              ],
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: right,
            ),
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
