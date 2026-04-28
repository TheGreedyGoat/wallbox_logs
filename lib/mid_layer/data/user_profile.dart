import 'package:wallbox_logs/mid_layer/data/charging_process.dart';

class UserProfile {
  static List<UserProfile> profiles = List.empty(growable: true);
  final int id;
  late final List<ChargingProcess> _completetChargingProcesses;

  double get totalConsumption {
    double consumption = 0.0;
    for (var process in _completetChargingProcesses) {
      consumption += process.powerUsageKiloWh!;
    }
    return consumption;
  }

  UserProfile._create({
    required this.id,
  }) {
    assert(tryGetFromID(id) == null);
    _completetChargingProcesses = List.empty(growable: true);
    profiles.add(this);
  }

  static void insertProcess(ChargingProcess process) {
    if (!process.isFinished) {
      return;
    }
    int id = process.id;
    final UserProfile profile = tryGetFromID(id) ?? UserProfile._create(id: id);
    profile._completetChargingProcesses.add(process);
  }

  static UserProfile? tryGetFromID(int id) {
    for (var profile in profiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'User with id $id has a total usage of $totalConsumption kWh';
  }
}
