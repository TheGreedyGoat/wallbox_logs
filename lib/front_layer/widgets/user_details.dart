import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/general/utility.dart';

///
class UserDetails extends StatefulWidget {
  final UserMasterData profile;

  ///
  const UserDetails({super.key, required this.profile});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late final Future<List<WallBoxTransaction>> _transactions;

  String get tagID => widget.profile.tagID;
  UserMasterData get profile => widget.profile;
  @override
  void initState() {
    super.initState();
    _transactions = WallBoxTransaction.allOfTagID(tagID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          final data = snapshot.data;
          if (data == null) {
            return Text('Etwas ist schief gelaufen');
          } else {
            print(data);
            return Table(
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: BorderDirectional(bottom: BorderSide(width: 1)),
                  ),
                  children: [Text('Start'), Text('Ende'), Text('Verbrauch')],
                ),
                for (var transaction in data)
                  TableRow(
                    decoration: BoxDecoration(
                      color:
                          data.indexOf(
                                    transaction,
                                  ) %
                                  2 ==
                              0
                          ? null
                          : Colors.blue[200],
                    ),
                    children: [
                      Text(
                        '${Utility.niceDateString(transaction.startTimeStamp)}, ${Utility.niceTimeString(transaction.startTimeStamp)}',
                      ),
                      Text(
                        '${Utility.niceDateString(transaction.stopTimeStamp)}, ${Utility.niceTimeString(transaction.stopTimeStamp)}',
                      ),
                      Text(
                        '${transaction.powerUsageKiloWh.toStringAsFixed(2)} kWh',
                      ),
                    ],
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
