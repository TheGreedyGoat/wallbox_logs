import 'package:wallbox_logs/mid_layer/data/user_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

///
/// In this class we keep every time somebody charged their vehicle at a wallbox
/// We keep data about the begin and end oft the charging process and can recieve how much power was used
///
///This class stores completed processes only!
///
///
class ChargingProcess {
  final ChargingEvent start;
  late ChargingEvent stop;

  String get id2 => start.id2;
  DateTime get startDate => start.timeStamp;
  DateTime get stopDate => stop.timeStamp;

  int get durationSeconds => stop.timeSeconds - start.timeSeconds;

  double get powerUsageKiloWh => stop.powerLevelKiloWH - start.powerLevelKiloWH;

  ChargingProcess.completed({
    required this.start,
    required this.stop,
  }) {
    assert(
      durationSeconds >= 0,
      "ERROR while creating ChargingProcess:\n duration $durationSeconds is nonpositive but should be pocRsitive",
    );
    assert(
      start.id2 == id2 && stop.id2 == id2,
      "ERROR while creating ChargingProcess:\n id2s dont match up:\n* Process: $id2\n* start: ${start.id2},\n* Stop:${stop.id2}",
    );
    UserData.insertProcess(this);
  }
}

//  ####### #     # ####### #     # #######
//  #       #     # #       ##    #    #
//  #       #     # #       # #   #    #
//  #####   #     # #####   #  #  #    #
//  #        #   #  #       #   # #    #
//  #         # #   #       #    ##    #
//  #######    #    ####### #     #    #

enum ChargingEventType { start, stop, invalid }

/// whenever a charging process was started or stopped
class ChargingEvent {
  late final String id2;
  late final DateTime timeStamp;
  late final double powerLevelKiloWH;
  int get timeSeconds => (timeStamp.millisecondsSinceEpoch / 1000).floor();

  double get powerLevelWh => powerLevelKiloWH * 1000;

  ChargingEvent({
    required this.id2,
    required this.timeStamp,
    required powerLevelInKiloWattHours,
  }) {
    this.powerLevelKiloWH = powerLevelInKiloWattHours;
  }
  static ChargingEventType typeFromString(String tag) {
    switch (tag) {
      case 'txstart2:':
        return ChargingEventType.start;
      case 'txstop2:':
        return ChargingEventType.stop;
      default:
        return ChargingEventType.invalid;
    }
  }

  ChargingEvent.fromMap(Map<ParseValue, dynamic> map) {
    for (var key in ParseValue.values) {
      assert(
        map.containsKey(key),
        'Map $map should contain key $key, but it does not.',
      );
    }
    id2 = map[ParseValue.id2Value];
    timeStamp = map[ParseValue.date];
    powerLevelKiloWH = map[ParseValue.powerLevel];
  }
}
