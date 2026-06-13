import 'package:wallbox_logs/mid_layer/class_extensions.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/utility.dart';

class Bill {
  Bill({
    required this.userTagID,
    required this.transactionIDs,
    required DateTime month,
  }) {
    assert(
      UserMasterData.repo.hasEntry(userTagID),
      'Fehler ($Bill): Rechung für Tag-ID $userTagID kann nicht erstellt werden, da kein Profil existiert!',
    );
    this.month = month.monthOnly;
  }
  late final DateTime month;
  final String userTagID;
  final List<String> transactionIDs;

  //  ###### #    # ##### #####    ##    ####  #####
  //  #       #  #    #   #    #  #  #  #    #   #
  //  #####    ##     #   #    # #    # #        #
  //  #        ##     #   #####  ###### #        #
  //  #       #  #    #   #   #  #    # #    #   #
  //  ###### #    #   #   #    # #    #  ####    #

  UserMasterData get user => UserMasterData.repo.getById(userTagID)!;

  String get username => user.fullName;
  String get adress => user.address;

  List<WallBoxTransaction> get transactions => user.transactions
      .where(
        (transacion) {
          return transacion.startTimeStamp.monthOnly == month;
        },
      )
      .toList(growable: false);

  List<int> get powerUsages => transactions
      .map(
        (transaction) => transaction.powerUsageWh,
      )
      .toList(growable: false);

  List<int> get costs => transactions
      .map(
        (transaction) => transaction.costsInCent,
      )
      .toList(growable: false);

  int get totalUsage => powerUsages.fold(
    0,
    (totalUsage, usage) => totalUsage + usage,
  );
  int get totalCost => costs.fold(
    0,
    (totalCost, cost) => totalCost + cost,
  );

  String get totalUsageDisplay => Utility.kWhDisplay(totalUsage);

  @override
  bool operator ==(Object other) =>
      other is Bill && other.userTagID == userTagID && other.month == month;

  @override
  int get hashCode => userTagID.hashCode ^ month.hashCode;

  String get monthDisplay => Utility.monthYearDisplay(month);
}

class BillService {
  static Map<String, List<Bill>> _createdBills = {};

  static List<Bill> _createBillsForUser(String tagID) {
    if (!UserMasterData.repo.hasEntry(tagID)) return [];
    final transactions = WallBoxTransaction.allOfTagID(tagID);
    final Map<DateTime, List<String>> monthToTransactionID = {};
    // collect bill data
    for (final ta in transactions) {
      if (ta.isBilled) continue;
      final month = ta.startTimeStamp.monthOnly;
      if (!monthToTransactionID.containsKey(month)) {
        monthToTransactionID[month] = List.empty(growable: true);
      }
      monthToTransactionID[month]!.add(ta.repoKey);
      WallBoxTransaction.repo.createOrUpdate(ta.copyWith(isBilled: true));
    }
    final List<Bill> billsOfUser = List.empty(growable: true);
    // create bills
    for (final month in monthToTransactionID.keys) {
      billsOfUser.add(
        Bill(
          userTagID: tagID,
          transactionIDs: monthToTransactionID[month]!,
          month: month,
        ),
      );
    }
    return billsOfUser;
  }

  static Map<String, List<Bill>> get bills {
    final userKeys = UserMasterData.repo.allKeys;
    Map<String, List<Bill>> allBills = {};

    for (final tagID in userKeys) {
      if (!_createdBills.containsKey(tagID)) _createdBills[tagID] = [];

      _createdBills[tagID]!.addAll(_createBillsForUser(tagID));
    }

    return _createdBills;
  }

  static void resetBilling() {
    for (final ta in WallBoxTransaction.repo.getAll()) {
      WallBoxTransaction.repo.createOrUpdate(ta.copyWith(isBilled: false));
    }
  }
}
