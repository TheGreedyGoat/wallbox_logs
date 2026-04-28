///
/// In this class we keep wevery time somebody charged their vehicle at a wallbox
/// We keep data about the begin and end oft the charging process and can recieve how much power was used
///
/// A Charging process can be unfinished, if a log has a starting line and then ends without a stop line.
///
///
class ChargingProcess {
  final ChargingEvent start;
  late ChargingEvent? stop;

  int get id => start.id;
  String get id2 => start.id2;
  DateTime get startDate => start.timeStamp;
  DateTime? get stopDate => stop?.timeStamp;
  bool get isFinished => stop != null;

  int? get durationSeconds =>
      isFinished ? stop!.timeSeconds - start.timeSeconds : null;

  double get powerUsageKiloWh =>
      isFinished ? stop!.powerLevelKiloWH - start.powerLevelKiloWH : 0.0;

  ChargingProcess.completed({
    required this.start,
    required this.stop,
  }) {
    assert(
      isFinished,
      "value for 'stop' in ChargingProcess.finished must not be null!\n: ",
    );
    assert(
      start.type == ChargingEventType.start,
      "ERROR while creating ChargingProcess:\n start event is not of type start.",
    );
    assert(
      stop!.type == ChargingEventType.stop,
      "ERROR while creating ChargingProcess:\n end stop is not of type stop.",
    );
    assert(
      durationSeconds! >= 0,
      "ERROR while creating ChargingProcess:\n duration $durationSeconds is nonpositive but should be pocRsitive",
    );
    assert(
      start.id == id && stop!.id == id,
      "ERROR while creating ChargingProcess:\n ids dont match up:\n* Process: $id\n* start: ${start.id},\n* Stop:${stop!.id}",
    );
    assert(
      start.id2 == id2 && stop!.id2 == id2,
      "ERROR while creating ChargingProcess:\n id2s dont match up:\n* Process: $id\n* start: ${start.id},\n* Stop:${stop!.id}",
    );
  }

  ChargingProcess.unfinished({required this.start}) {
    stop = null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'start': start.toJson(),
    'stop': stop?.toJson(),
    'isFinished': isFinished,
  };
  @override
  String toString() => toJson().toString();
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
  late int id;
  late String id2;
  late final ChargingEventType type;
  final DateTime timeStamp;
  late final double powerLevelKiloWH;
  int get timeSeconds => (timeStamp.millisecondsSinceEpoch / 1000).floor();

  double get powerLevelWh => powerLevelKiloWH * 1000;

  ChargingEvent({
    required this.id,
    required this.id2,
    required this.type,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'timeStamp': timeStamp,
    'powerLevel': powerLevelKiloWH,
  };
}
