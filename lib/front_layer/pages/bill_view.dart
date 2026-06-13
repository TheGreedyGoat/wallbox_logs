import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widgets/my_container.dart';
import 'package:wallbox_logs/utility.dart';

class BillView extends StatelessWidget {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> usage = const [34, 20, 10, 5.3, 12.6];
    final int price = 50;

    return ListView(
      children: [
        Text('Rechnung für  [Name] von [Monat]\n'),

        Text('Adresse:\n'),
        Text('Beispielstraße 5'),
        Text('12345 Musterstadt\n'),

        Text('Preis/ kWh: ${Utility.costsDisplay(price)}'),

        MyContainer(
          level: 0,
          child: Table(
            border: TableBorder.all(),
            children: [
              const TableRow(
                children: [
                  TableCell(child: Text('Datum')),
                  TableCell(child: Text('Verbrauch')),
                  TableCell(child: Text('Kosten')),
                ],
              ),
              for (int i = 0; i < 5; i++)
                TableRow(
                  children: [
                    TableCell(
                      child: SelectableText(
                        Utility.niceDateString(DateTime.now()),
                      ),
                    ),
                    TableCell(
                      child: Text(usage[i].toStringAsFixed(2)),
                    ),
                    TableCell(
                      child: Text(
                        Utility.costsDisplay((usage[i] * price).floor()),
                      ),
                    ),
                  ],
                ),
              TableRow(
                children: [
                  TableCell(child: Text('Summe')),
                  TableCell(
                    child: SelectableText(
                      usage
                          .fold(
                            0.0,
                            (previousValue, element) => previousValue + element,
                          )
                          .toStringAsFixed(2),
                    ),
                  ),
                  TableCell(
                    child: SelectableText(
                      Utility.costsDisplay(
                        usage.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + (price * element).floor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
