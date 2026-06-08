import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';
import 'package:wallbox_logs/front_layer/widgets/neat_row.dart';
import 'package:wallbox_logs/front_layer/widgets/user_transaction_widget.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/utility.dart';

/// Displays the main informations about he given [profile].
/// Can be expanded for an overview over corresponing transactions
class UserListTile extends ConsumerStatefulWidget {
  /// The source for the displayed data
  final UserMasterData profile;
  final String userTagID;

  /// Displays the main informations about he given [profile].
  /// Can be expanded for an overview over corresponing transactions
  /// - [profile]: The source for the displayed data
  const UserListTile({
    required this.profile,
    required this.userTagID,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserListTileConsumerState();
}

class _UserListTileConsumerState extends ConsumerState<UserListTile> {
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.primaryContainer,
        // gradient: LinearGradient(
        //   colors: [
        //     Theme.of(context).colorScheme.primaryContainer,
        //     const Color.fromARGB(255, 190, 190, 190),
        //     const Color.fromARGB(255, 190, 190, 190),
        //   ],

        //   begin: AlignmentGeometry.topCenter,
        //   end: AlignmentGeometry.bottomCenter,
        // ),
      ),
      child: ExpansionTile(
        shape: Border.fromBorderSide(BorderSide.none),
        initiallyExpanded: false,
        leading: Icon(
          isExpanded ? Icons.arrow_drop_down : Icons.arrow_right_sharp,
        ),
        title: SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.profile.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' #${widget.userTagID}'),
            ],
          ),
        ),
        subtitle: Row(
          children: [
            LabeledField(
              label: 'Totaler Verbrauch: ',
              right: SelectableText(widget.profile.fullPowerUsageDisplay),
            ),
            SizedBox(
              width: 10,
            ),
            LabeledField(
              label: 'Totale Kosten: ',
              right: SelectableText(widget.profile.fullCostsDisplay),
            ),
          ],
        ),

        trailing: IconButton(
          onPressed: () => ref
              .read(widgetTreeProvider.notifier)
              .setUserEditingPageByTagID(widget.userTagID),
          icon: Icon(Icons.edit),
        ),

        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 1000),
              child: Builder(
                builder: (context) {
                  final transactions = widget.profile.transactionsByMonth();
                  return ListView(
                    children: transactions.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InputFieldDecoration(
                          child: ExpansionTile(
                            dense: true,
                            expandedAlignment: Alignment.topLeft,
                            title: Text(
                              '${Utility.monthName(key.month)} ${key.year}',
                            ),
                            subtitle: SelectableText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Gesamtbetrag: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: Utility.costsDisplay(
                                      transactions[key]!.fold<int>(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.costsInCent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: transactions[key]!.map(
                              (ta) {
                                return Text(ta.costsDisplay);
                              },
                            ).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          // UserTransactionsWidget(userTagID: widget.profile.tagID),
        ],
        onExpansionChanged: (value) => setState(() {
          isExpanded = value;
        }),
      ),
    );
  }
}
