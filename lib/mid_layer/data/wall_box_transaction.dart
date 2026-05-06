import 'package:wallbox_logs/mid_layer/data/user_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

/// In this class we keep every time somebody charged their vehicle at a wallbox
/// We keep data about the begin and end oft the charging process and can recieve how much power was used
///
/// This class stores completed processes only!
class WallBoxTransaction {
  /// The start of the [WallBoxTransaction]
  final ChargingEvent start;

  /// The end of the [WallBoxTransaction]
  late ChargingEvent stop;

  /// The tagID wich is used to identifie the user who charged
  String get tagID => start.tagID;

  /// Getter for when did the process start
  DateTime get startTimeStamp => start.timeStamp;

  /// Getter for when did the process end
  DateTime get stopDate => stop.timeStamp;

  /// The total time the [WallBoxTransaction] took
  int get durationSeconds => stop.timeSeconds - start.timeSeconds;

  /// How much Power was consumed during this [WallBoxTransaction]?
  double get powerUsageKiloWh => stop.powerLevelKiloWH - start.powerLevelKiloWH;

  /// In this class we keep every time somebody charged their vehicle at a wallbox
  /// We keep data about the begin and end oft the charging process and can recieve how much power was used
  ///
  /// This class stores completed processes only!
  WallBoxTransaction({
    required this.start,
    required this.stop,
  }) {
    assert(
      durationSeconds >= 0,
      'ERROR while creating $WallBoxTransaction:\n duration $durationSeconds is nonpositive but should be pocRsitive',
    );
    assert(
      start.tagID == tagID && stop.tagID == tagID,
      'ERROR while creating $WallBoxTransaction:\n id2s dont match up:\n* Process: $tagID\n* start: ${start.tagID},\n* Stop:${stop.tagID}',
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

/// Detailed information about a start or end of a [WallBoxTransaction]
class ChargingEvent {
  /// Detailed information about a start or end of a [WallBoxTransaction]
  ChargingEvent({
    required this.tagID,
    required this.timeStamp,
    required this.powerLevelKiloWH,
  });

  /// Surprisingly: creates a [ChargingEvent] from a JSON Map
  ChargingEvent.fromJSON(Map<WallBoxParserValue, dynamic> map) {
    for (var key in WallBoxParserValue.values) {
      assert(
        map.containsKey(key),
        'Map $map should contain key $key, but it does not.',
      );
    }
    tagID = map[WallBoxParserValue.id2Value];
    timeStamp = map[WallBoxParserValue.date];
    powerLevelKiloWH = map[WallBoxParserValue.powerLevel];
  }

  /// The tagID wich is used to identifie the user who charged
  late final String tagID;

  /// The exact time this event happened
  late final DateTime timeStamp;

  /// The Wallboxes PowerLevel in kWh when this event happened
  late final double powerLevelKiloWH;

  /// The seconds of the event aafter epoch
  int get timeSeconds => (timeStamp.millisecondsSinceEpoch / 1000).floor();
}
