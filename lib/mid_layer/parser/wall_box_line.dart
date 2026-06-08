import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/parser/wall_box_log.dart';

const _startTag = 'txstart';
const _stopTag = 'txstop';
const _mvTag = 'mv';

abstract class WallboxLine {
  late final DateTime timeStamp;
  late final int powerLevelWh;

  LineType get type;

  static WallboxLine? tryParse(String source) {
    bool isMV = source.startsWith(_mvTag);
    bool isStart = !isMV && source.startsWith(_startTag);
    bool isStop = !isMV && !isStart && source.startsWith(_stopTag);

    if (!isMV && !isStart && !isStop) return null;

    final timeStampMatch = RegExp(
      DataType.date.regExSource,
    ).stringMatch(source);
    final DateTime? timeStamp = DateTime.tryParse(timeStampMatch.toString());

    assert(timeStamp != null, 'Line $source does not contain a date');

    final powerUsageMatch = RegExp(
      DataType.power.regExSource,
    ).stringMatch(source);

    final double? pU = double.tryParse(
      powerUsageMatch.toString(),
    );
    final int? powerUsage = pU != null ? (pU * 1000).floor() : null;

    assert(
      powerUsage != null,
      'Line $source does not contain a value for power usage',
    );

    if (isMV) {
      return MVLine(timeStamp!, powerUsage!);
    } else if (isStart || isStop) {
      final tagIDMatch = RegExp(DataType.tagID.regExSource).stringMatch(source);
      assert(
        tagIDMatch != null,
        'Line $source does not contain a value for tagID',
      );
      return MainLine(timeStamp!, powerUsage!, tagIDMatch!, isStart);
    }
  }

  @override
  String toString() =>
      'Type: $type, TimeStamp: $timeStamp, Usage: $powerLevelWh';
}

class MainLine extends WallboxLine {
  MainLine(
    this.timeStamp,
    this.powerLevelWh,
    this.tagID,
    this.isStart,
  );
  @override
  final int powerLevelWh;

  @override
  final DateTime timeStamp;

  final String tagID;
  final bool isStart;
  @override
  LineType get type => isStart ? LineType.start : LineType.stop;
  @override
  String toString() {
    return '${super.toString()}, $tagID';
  }

  ChargingEvent get toEvent => ChargingEvent(
    tagID: tagID,
    timeStamp: timeStamp,
    powerLevelWh: powerLevelWh,
  );
}

class MVLine extends WallboxLine {
  @override
  LineType get type => LineType.mv;

  MVLine(this.timeStamp, this.powerLevelWh);
  @override
  late final int powerLevelWh;

  @override
  late final DateTime timeStamp;
}
