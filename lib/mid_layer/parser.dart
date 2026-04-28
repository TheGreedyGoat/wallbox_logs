// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:wallbox_logs/mid_layer/data/charging_process.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:wallbox_logs/mid_layer/data/user_profile.dart';

/// 0 => tag;
/// 1 => id;
/// 2 => socketnum;
/// 3 => date;
/// 4 => time;
/// 5 => power level
enum _Value { tag, idValue, socketnum, date, time, powerLevel, id2Value }

class Parser {
  static void parseWallBoxFile(FileData data) {
    assert(
      data.extension == 'csv',
      '${data.fullName} is not of file type csv!',
    );
    var dataList = getDataListFromWallboxFile(data);
    _parseList(dataList);
  }

  static List<String> getDataListFromWallboxFile(FileData data) {
    return data.content
        .split('\n')
        .where((element) => element.startsWith('tx'))
        .toList();
  }

  static void _parseList(List<String> dataList) {
    int i = 0;
    while (i < dataList.length) {
      var currentData = _parseLine(dataList[i]);
      final ChargingEventType lineType = currentData[_Value.tag];
      //! For now We ignore the case if the file starts within a process
      ChargingEvent start = ChargingEvent(
        id: currentData[_Value.idValue],
        id2: currentData[_Value.id2Value],
        type: currentData[_Value.tag],
        timeStamp: currentData[_Value.date],
        powerLevelInKiloWattHours: currentData[_Value.powerLevel],
      );
      if (lineType == ChargingEventType.start && i + 1 < dataList.length) {
        //? build this and the next one

        var nextData = _parseLine(dataList[i + 1]);
        ChargingEvent stop = ChargingEvent(
          id: nextData[_Value.idValue],
          id2: nextData[_Value.id2Value],
          type: nextData[_Value.tag],
          timeStamp: nextData[_Value.date],
          powerLevelInKiloWattHours: nextData[_Value.powerLevel],
        );

        UserData.insertProcess(
          ChargingProcess.completed(start: start, stop: stop),
        );
        i += 2;
      } else {
        i++;
      }
    }
  }

  static Map<_Value, dynamic> _parseLine(String line) {
    line = line
        .replaceFirst(' id', '')
        .replaceFirst(' socket', '')
        .replaceAll(' ', ',')
        .replaceAll(',,', ',');

    var filteredList = line.split(',');
    var valueList = _Value.values;
    assert(filteredList.length >= valueList.length);

    var parsedData = {
      _Value.tag: ChargingEvent.typeFromString(filteredList[0]),
      _Value.idValue: int.tryParse(filteredList[1]),
      _Value.date: DateTime.parse('${filteredList[3]} ${filteredList[4]}'),
      _Value.powerLevel: double.tryParse(filteredList[5].replaceAll('kWh', '')),
      _Value.id2Value: filteredList[6],
    };

    var status = _validateParsedMap(parsedData);
    assert(
      status == 'ok',
      'Validation Failed: $status\ncausing line:\n$line',
    );

    return parsedData;
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
}
