import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/pages/bill_view.dart';
import 'package:wallbox_logs/front_layer/widgets/my_container.dart';
import 'package:wallbox_logs/front_layer/widgets/section_title.dart';
import 'package:wallbox_logs/mid_layer/models/bill/bill.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/models/page_state.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/utility.dart';
import 'package:window_manager/window_manager.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    final bills = BillService.bills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            BillService.resetBilling();
          }),
          child: Text('Rechnungen zurücksetzen'),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final tagID in bills.keys)
                ExpansionTile(
                  expandedAlignment: Alignment.centerLeft,
                  title: SelectableText(
                    '${UserMasterData.nameOfTagID(tagID)} #${tagID}',
                  ),
                  subtitle: SelectableText(
                    'Preis/ kWh: ${UserMasterData.getByKey(tagID)!.pricePerkWhDisplay}',
                  ),
                  children: [
                    for (final bill in bills[tagID]!)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyContainer(
                          child: ExpansionTile(
                            title: Text(bill.monthDisplay),
                            children: [
                              for (final transaction in bill.transactions)
                                ListTile(
                                  title: Text(transaction.costsDisplay),
                                  subtitle: Text(
                                    transaction.powerUsageKWhDisplay,
                                  ),
                                  trailing: Text(
                                    transaction.startTimeDisplay(),
                                  ),
                                ),
                              SectionTitle(title: 'Summe'),
                              ListTile(
                                title: Text(
                                  Utility.costsDisplay(bill.totalCost),
                                ),
                                subtitle: Text(
                                  Utility.kWhDisplay(bill.totalUsage),
                                ),
                              ),
                            ],
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

  Widget billDisplay(BuildContext context, String user, String date) {
    return Text.rich(
      TextSpan(children: [TextSpan(text: 'Rechnung für $user von ')]),
    );
  }
}
