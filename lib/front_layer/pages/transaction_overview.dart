import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widgets/my_list_view.dart';
import 'package:wallbox_logs/front_layer/widgets/my_table.dart';
import 'package:wallbox_logs/front_layer/widgets/table_header_entry.dart';
import 'package:wallbox_logs/general/date_time_extension.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';

enum Sort {
  tagID(label: 'Tag-ID'),
  surname(label: 'Nachname'),
  prename(label: 'Vorname'),
  startTime(label: 'Start'),
  endTime(label: 'Ende'),
  usage(label: 'Verbrauch(kWh)')
  ;

  final String label;
  const Sort({required this.label});
}

class TransactionOverview extends StatefulWidget {
  const TransactionOverview({super.key});

  @override
  State<TransactionOverview> createState() => _TransactionOverviewState();
}

class _TransactionOverviewState extends State<TransactionOverview> {
  Sort sortBy = Sort.startTime;
  bool invertOrder = false;
  late Future<List<WallBoxTransaction>> _transactions;

  @override
  void initState() {
    super.initState();
    updateTransactions();
  }

  @override
  void setState(VoidCallback fn) {
    final last = sortBy;
    super.setState(fn);
    if (sortBy == last) {
      invertOrder = !invertOrder;
    } else {
      invertOrder = false;
    }
    updateTransactions();
  }

  void updateTransactions() {
    _transactions = WallBoxTransaction.getTransactions(
      sorter: (a, b) {
        int result = invertOrder ? -1 : 1;
        switch (sortBy) {
          case Sort.tagID:
            result *= a.tagID.compareTo(b.tagID);
          case Sort.prename:
            result *= (a.user.prename ?? '[unbekannt]').compareTo(
              b.user.prename ?? '[unbekannt]',
            );
          case Sort.surname:
            result *= (a.user.surname ?? '[unbekannt]').compareTo(
              b.user.surname ?? '[unbekannt]',
            );
          case Sort.startTime:
            result *= a.startTimeStamp.compareTo(b.startTimeStamp);
          case Sort.endTime:
            result *= a.stopTimeStamp.compareTo(b.stopTimeStamp);
          case Sort.usage:
            result *= a.powerUsageKiloWh.compareTo(b.powerUsageKiloWh);
        }
        return result;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _transactions,
      builder: (context, asyncSnapshot) {
        return asyncSnapshot.hasData
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Table(
                      children: [
                        TableRow(
                          children: [
                            for (final value in Sort.values)
                              TableHeaderEntry(
                                label: value.label,
                                onTap: () => setState(() => sortBy = value),
                                icon: (value == sortBy)
                                    ? Icon(
                                        invertOrder
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_drop_up,
                                      )
                                    : null,
                              ),
                          ],
                        ),
                      ],
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: MyTable(
                          content: [
                            for (final transaction in asyncSnapshot.data!)
                              [
                                transaction.tagID,
                                transaction.user.surname ?? '[unbekannt]',
                                transaction.user.prename ?? '[unbekannt]',
                                transaction.startTimeStamp.toNiceDateString(),
                                transaction.stopTimeStamp.toNiceDateString(),
                                transaction.powerUsageKiloWh.toStringAsFixed(2),
                              ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator();
      },
    );
  }
}
