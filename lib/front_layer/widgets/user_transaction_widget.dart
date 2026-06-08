import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/my_text_field.dart';
import 'package:wallbox_logs/front_layer/widgets/neat_row.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/utility.dart';

/// Shows all available informations about the [user]'s transactions
class UserTransactionsWidget extends StatefulWidget {
  /// The instance of [UserMasterData] to show corresponding transacion data from
  final String userTagID;

  /// Shows all available informations about the [user]'s transactions
  /// - [user] The instance of [UserMasterData] to show corresponding transacion data from

  const UserTransactionsWidget({
    super.key,
    required this.userTagID,
  });

  @override
  State<UserTransactionsWidget> createState() => _UserTransactionsWidgetState();
}

class _UserTransactionsWidgetState extends State<UserTransactionsWidget> {
  late final List<WallBoxTransaction> _transactions;
  int selectedHead = 0;

  UserMasterData get user => UserMasterData.repo.getById(userTagID)!;

  String get userTagID => widget.userTagID;
  final List<String> headers = const [
    'Start',
    'Ende',
    'Verbrauch',
    'zu zahlen',
  ];

  bool invertSorting = false;

  bool editPrice = false;
  String? newPrice;

  @override
  void initState() {
    super.initState();
    _transactions = WallBoxTransaction.allOfTagID(userTagID);
  }

  void _sort(int index) {
    _transactions.sort(
      (a, b) {
        int? value;
        switch (index) {
          case 0:
            value = a.startTimeStamp.compareTo(b.startTimeStamp);
            break;
          case 1:
            value = a.stopTimeStamp.compareTo(b.startTimeStamp);
            break;
          case 2:
            value = a.powerUsageWh.compareTo(b.powerUsageWh);
          case 3:
            value = a.costsInCent.compareTo(b.costsInCent);
          default:
            value = 0;
        }
        return value * (invertSorting ? -1 : 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledField(
            surfaceColor: colorScheme.surfaceContainerHigh,
            borderColor: colorScheme.onSurface,

            label: 'Individueller Preis: ',

            right: Row(
              children: [
                if (!editPrice) ...[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        editPrice = true;
                      });
                    },
                    icon: Icon(
                      Icons.edit_sharp,
                      color: colorScheme.onSurface,
                    ),
                    iconSize: 20,
                  ),
                ],
                if (editPrice) ...[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        editPrice = false;
                        final double? newPriceValue = newPrice == null
                            ? null
                            : double.tryParse(newPrice!.replaceAll(',', '.'));
                        if (newPriceValue != null) {
                          UserMasterData.repo.update(
                            user.copyWith(
                              individualPricePerkWhInCents: Utility.euroToCents(
                                newPriceValue,
                              ),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      Icons.save_sharp,
                      color: colorScheme.onSurface,
                    ),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        editPrice = false;
                      });
                    },
                    icon: Icon(
                      Icons.cancel_sharp,
                      color: colorScheme.onSurface,
                    ),
                    iconSize: 20,
                  ),
                ],
              ],
            ),
            children: [
              editPrice
                  ? Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              2.0,
                            ),
                            child: MyTextField(
                              backgroundColor: colorScheme.surfaceContainerHigh,
                              foregroundColor: colorScheme.onSurface,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  Utility.doubleInputRegExp(2),
                                ),
                              ],
                              label: 'Preis',
                              onChanged: (value) => newPrice = value,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '€',
                            style: textStyle,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      user.pricePerkWhDisplay,
                      style: textStyle,
                    ),
            ],
          ),

          Container(
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
                    children: headers
                        .map(
                          (headline) => Row(
                            children: [
                              IconButton(
                                // isSelected: selectedHead == headers.indexOf(headline),
                                onPressed: () {
                                  int index = headers.indexOf(headline);
                                  setState(() {
                                    invertSorting =
                                        selectedHead == index && !invertSorting;
                                    selectedHead = index;
                                    _sort(index);
                                  });
                                  // widget.onSortChanged(
                                  //   selectedHead!,
                                  //   invertSorting,
                                  // );
                                },
                                icon: Icon(
                                  selectedHead == headers.indexOf(headline)
                                      ? (invertSorting
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down)
                                      : Icons.sort,
                                ),
                              ),
                              Text(
                                headline,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
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
                                transaction.costsDisplay,
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
        ],
      ),
    );
  }
}
