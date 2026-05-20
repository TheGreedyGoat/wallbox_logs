import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/utility.dart';

/// Shows all available informations about the [user]'s transactions
class UserTransactionsWidget extends StatefulWidget {
  /// The instance of [UserMasterData] to show corresponding transacion data from
  final UserMasterData user;

  /// Shows all available informations about the [user]'s transactions
  /// - [user] The instance of [UserMasterData] to show corresponding transacion data from

  const UserTransactionsWidget({super.key, required this.user});

  @override
  State<UserTransactionsWidget> createState() => _UserTransactionsWidgetState();
}

class _UserTransactionsWidgetState extends State<UserTransactionsWidget> {
  late final List<WallBoxTransaction> _transactions;

  String get tagID => widget.user.tagID;
  @override
  void initState() {
    super.initState();
    _transactions = WallBoxTransaction.allOfTagID(tagID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Table(
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: BorderDirectional(bottom: BorderSide(width: 1)),
                ),
                children: ['Start', 'Ende', 'Verbrauch']
                    .map(
                      (e) => Text(
                        e,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                    .toList(),
              ),
              for (var transaction in _transactions)
                TableRow(
                  decoration: BoxDecoration(
                    color:
                        _transactions.indexOf(
                                  transaction,
                                ) %
                                2 ==
                            0
                        ? Theme.of(context).colorScheme.surface
                        : Colors.blue[200],
                  ),
                  children:
                      [
                            transaction.startTimeDisplay(),
                            transaction.startTimeDisplay(),
                            transaction.powerUsageKWhDisplay,
                          ]
                          .map(
                            (display) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                display,
                              ),
                            ),
                          )
                          .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
