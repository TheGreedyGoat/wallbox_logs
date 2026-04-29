import 'package:wallbox_logs/mid_layer/data/charging_process.dart';
import 'package:wallbox_logs/utility.dart';

/// used to store charging process data sorted by their id.
/// Instances are created internally to ensure every id is unique.
class UserData {
  static List<UserData> profiles = List.empty(growable: true);
  final int id;
  final String id2;
  late final List<ChargingProcess> _completetChargingProcesses;

  List<ChargingProcess> get completedChargingProcesses =>
      _completetChargingProcesses.toList();

  double get totalConsumptionKWH {
    double consumption = 0.0;
    for (var process in _completetChargingProcesses) {
      consumption += process.powerUsageKiloWh;
    }
    return consumption;
  }

  /// private to ensure only 1 instance per id
  UserData._create({
    required this.id,
    required this.id2,
  }) {
    assert(tryGetFromID(id2) == null);
    _completetChargingProcesses = List.empty(growable: true);
    profiles.add(this);
  }

  /// Inserts the process into the processes list, so it is sorted by the starting time
  static void insertProcess(ChargingProcess process) {
    final UserData profile =
        tryGetFromID(process.id2) ??
        UserData._create(id: process.id, id2: process.id2);
    // profile._completetChargingProcesses.add(process);
    Utility.insertToList(profile._completetChargingProcesses, process, (a, b) {
      return a.start.timeStamp.compareTo(b.start.timeStamp);
    });
  }

  static UserData? tryGetFromID(String id2) {
    for (var profile in profiles) {
      if (profile.id2 == id2) {
        return profile;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'User with id $id has a total usage of $totalConsumptionKWH kWh';
  }
}
