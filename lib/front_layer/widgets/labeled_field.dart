import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  LabeledField({
    this.children,
    required this.label,
    required this.right,
    this.labelStyle,
    this.borderColor = Colors.black,
    this.surfaceColor = Colors.white,
    this.height = 30,
    this.widthLeft,
    this.widthPerChild,
    this.widthRight,

    super.key,
  });

  final String label;
  final TextStyle? labelStyle;
  final Widget right;
  final List<Widget>? children;
  final Color borderColor;
  final Color surfaceColor;

  final double? widthLeft;
  final double? widthRight;
  final double? widthPerChild;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ooooo                   .o88o.     .
            // `888'                   888 `"   .o8
            //  888          .ooooo.  o888oo  .o888oo
            //  888         d88' `88b  888      888
            //  888         888ooo888  888      888
            //  888       o 888    .o  888      888 .
            // o888ooooood8 `Y8bod8P' o888o     "888"
            SizedBox(
              width: widthLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            ),
            _separator(context),

            //   .oooooo.                             .
            //  d8P'  `Y8b                          .o8
            // 888           .ooooo.  ooo. .oo.   .o888oo  .ooooo.  oooo d8b
            // 888          d88' `88b `888P"Y88b    888   d88' `88b `888""8P
            // 888          888ooo888  888   888    888   888ooo888  888
            // `88b    ooo  888    .o  888   888    888 . 888    .o  888
            //  `Y8bood8P'  `Y8bod8P' o888o o888o   "888" `Y8bod8P' d888b
            if (children != null)
              for (final child in children!) ...[
                SizedBox(
                  width: widthPerChild,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: child,
                  ),
                ),
                _separator(context),
              ],

            // ooooooooo.    o8o             oooo            .
            // `888   `Y88.  `"'             `888          .o8
            //  888   .d88' oooo   .oooooooo  888 .oo.   .o888oo
            //  888ooo88P'  `888  888' `88b   888P"Y88b    888
            //  888`88b.     888  888   888   888   888    888
            //  888  `88b.   888  `88bod8P'   888   888    888 .
            // o888o  o888o o888o `8oooooo.  o888o o888o   "888"
            //                    d"     YD
            //                    "Y88888P'
            SizedBox(
              width: widthRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: right,
              ),
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
