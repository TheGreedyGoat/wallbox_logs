import 'package:flutter/material.dart';

class TableHeaderEntry extends StatelessWidget {
  const TableHeaderEntry({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });
  final String label;
  final void Function() onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(side: BorderSide()),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), ?icon],
      ),
    );
  }
}
