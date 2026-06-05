import 'package:freezed_annotation/freezed_annotation.dart';

enum LineType { start, stop, mv }

Map<LineType, List<LineType>> successors = {
  LineType.start: [LineType.mv],
  LineType.stop: [LineType.start],
  LineType.mv: [LineType.mv, LineType.stop],
};

enum DataType {
  date(r'\d{4}(\-\d{2}){2} \d{2}(:\d{2}){2}'),
  power(r'\d+\.\d{2,3}'),
  tagID(r'[0-9A-Z]{5,}')
  ;

  final String regExSource;
  const DataType(this.regExSource);
}

RegExp startExp = RegExp(r'txstart');
RegExp stopExp = RegExp(r'txstop');
RegExp mvExp = RegExp(r'mv');

class WallBoxParser2 {}

class WallBoxLog {
  WallBoxLog(String source) {
    final lines = List<WallboxLine>.empty(growable: true);
    final split = source.split('\n');
    LineType? currentType;

    for (final l in split) {
      WallboxLine? line = WallboxLine.tryParse(l);
      if (line != null) {
        assert(
          currentType == null || successors[currentType]!.contains(line.type),
          'Mismatching order of lines in Log file: $currentType followed by ${line.type} at file line ${split.indexOf(l)}',
        );
        lines.add(line);
      }
    }
    this.lines = lines;
  }
  late final List<WallboxLine> lines;

  @override
  String toString() => lines.fold(
    '',
    (previousValue, element) => '${previousValue}${element.toString()}\n',
  );
}

const _startTag = 'txstart';
const _stopTag = 'txstop';
const _mvTag = 'mv';

abstract class WallboxLine {
  late final DateTime timeStamp;
  late final double powerUsage;

  LineType get type;

  static WallboxLine? tryParse(String source) {
    bool isMV = source.startsWith(_mvTag);
    bool isStart = !isMV && source.startsWith(_startTag);
    bool isStop = !isMV && !isStart && source.startsWith(_startTag);

    if (!isMV && !isStart && !isStop) return null;

    final timeStampMatch = RegExp(
      DataType.date.regExSource,
    ).stringMatch(source);
    final DateTime? timeStamp = DateTime.tryParse(timeStampMatch.toString());

    assert(timeStamp != null, 'Line $source does not contain a date');

    final powerUsageMatch = RegExp(
      DataType.power.regExSource,
    ).stringMatch(source);
    final double? powerUsage = double.tryParse(powerUsageMatch.toString());

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
  String toString() => 'Type: $type, TimeStamp: $timeStamp, Usage: $powerUsage';
}

class MainLine extends WallboxLine {
  MainLine(
    this.timeStamp,
    this.powerUsage,
    this.tagID,
    this.isStart,
  );
  @override
  final double powerUsage;

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
}

class MVLine extends WallboxLine {
  @override
  LineType get type => LineType.mv;

  MVLine(this.timeStamp, this.powerUsage);
  @override
  late final double powerUsage;

  @override
  late final DateTime timeStamp;
}
