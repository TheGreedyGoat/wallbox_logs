// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:wallbox_logs/mid_layer/data/charging_process.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';

/// 0 => tag;
/// 1 => id;
/// 2 => socketnum;
/// 3 => date;
/// 4 => time;
/// 5 => power level
enum _Value {
  tag,
  idValue,
  socketnum,
  date,
  time,
  powerLevel,
}

class Parser {
  static void parseWallBoxFile(FileData data) {
    assert(
      data.extension == 'csv',
      '${data.fullName} is not of file type csv!',
    );
    var dataList = getDataListFromWallboxFile(data);
    _parseList2(dataList);
  }

  static List<String> getDataListFromWallboxFile(FileData data) {
    return data.content
        .split('\n')
        .where((element) => element.startsWith('tx'))
        .toList();
  }

  static void _parseList2(List<String> dataList) {
    int i = 0;
    while (i < dataList.length) {
      var parsed = _parseLine2(dataList[i]);
      var status = _validateParsedMap(parsed);
      assert(
        status == 'ok',
        'Validation Failed: $status\ncausing line:\n${dataList[i]}',
      ); //From this point the lines are all valid!

      final ChargingEventType lineType = parsed[_Value.tag];
      //! For now We ignore the case when the file starts within a process
      if (lineType == ChargingEventType.start && i + 1 < dataList.length) {
        //? build this and the next one
        i += 2;
      } else {
        i++;
      }
    }
  }

  static Map<_Value, dynamic> _parseLine2(String line) {
    line = line
        .replaceFirst(' id', '')
        .replaceFirst(' socket', '')
        .replaceAll(' ', ',')
        .replaceAll(',,', ',');

    var list = line.split(',');
    var valueList = _Value.values;
    assert(list.length >= valueList.length);

    return {
      _Value.tag: ChargingEvent.fromString(list[0]),
      _Value.idValue: int.tryParse(list[1]),
      _Value.date: ('${list[3]} ${list[4]}'),
      _Value.powerLevel: double.tryParse(list[5].replaceAll('kWh', '')),
    };
  }

  static String _validateParsedMap(Map<_Value, dynamic> parsed) {
    var tag = parsed[_Value.tag]!;
    if (tag == ChargingEventType.invalid) {
      return 'Line has invalid tag!';
    }

    var id = parsed[_Value.idValue];
    if (id == null) {
      return 'No user ID found!';
    }

    var date = parsed[_Value.date];
    if (date == null) {
      return 'No date found!';
    }

    var powerLevel = parsed[_Value.powerLevel];
    if (powerLevel == null) {
      return 'No Power Level found!';
    }

    return 'ok';
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  static Map<String, dynamic> parseData(String start, String stop) {
    String validation = 'ok';
    int? id;
    DateTime? startTime, stopTime;
    double? startLevel;
    double? stopLevel;

    var startMap = parseLine(start);
    var stopMap = parseLine(stop);
    //validate order of start/ stop
    if (startMap['type'] != 'txstart2' || stopMap['type'] != 'txstop2') {
      validation =
          '\nleading tags invalid: \nstart: {${startMap['type']}\nend: ${stopMap['type']}}';
    }

    // validate power levels
    if (validation == 'ok') {
      startLevel = double.tryParse(startMap['level'] ?? 'r');
      stopLevel = double.tryParse(stopMap['level'] ?? 'r');

      bool validLevels =
          startLevel != null && stopLevel != null && startLevel <= stopLevel;

      validation = validLevels
          ? 'ok'
          : 'Invalid Power usage levels:' +
                ' \nstart:$startLevel' +
                ' \nstop:$stopLevel';
    }
    // validate id
    if (validation == 'ok') {
      String? startID = startMap['id'];
      String? stopID = stopMap['id'];

      if (startID == stopID) {
        id = int.parse(startMap['id']!);
      } else {
        validation = "Start id ($startID) and Stop id($stopID) don't match";
      }
    }
    // validate timestamps
    if (validation == 'ok') {
      String? startStamp = startMap['timeStamp'];
      String? stopStamp = stopMap['timeStamp'];
      if (startStamp != null && stopStamp != null) {
        startTime = DateTime.tryParse(startStamp);
        stopTime = DateTime.tryParse(stopStamp);
      }
      if (startTime == null ||
          stopTime == null ||
          stopTime.millisecondsSinceEpoch < startTime.millisecondsSinceEpoch) {
        validation =
            'Dates invalid: either null or stopTime <= startTime:\n' +
            '____________________________________________________\n' +
            'start: $startTime (from stamp $startStamp)\n' +
            'stop: $stopTime (from stamp $stopStamp)';
      }
    }

    return {
      'validation': validation,
      'value': validation == 'ok'
          ? ChargingProcess.finished(
              id: id!,
              start: ChargingEvent(
                id: id,
                tag: startMap['type']!,
                timeStamp: startTime!,
                powerLevelInKiloWattHours: startLevel!,
              ),
              stop: ChargingEvent(
                id: id,
                tag: stopMap['type']!,
                timeStamp: stopTime!,
                powerLevelInKiloWattHours: stopLevel!,
              ),
            )
          : null,
    };
  }

  // ChargingProcess
  static Map<String, String> parseLine(String line) {
    final String type;
    final String id;
    final String timeStamp;

    String level;

    List<String> splitLine = line.split(',');

    List<String> head = splitLine[0].split(' ');
    List<String> details = splitLine.last.trim().split(' ');

    type = head[0].replaceAll(':', '');

    id = head.last;
    level = details[2].replaceAll('kWh', '');

    timeStamp = '${details[0]} ${details[1]}';

    return {
      "type": type,
      "id": id,
      'timeStamp': timeStamp,
      "level": level,
    };
  }
}
