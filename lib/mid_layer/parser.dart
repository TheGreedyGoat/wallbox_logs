// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:wallbox_logs/mid_layer/data/file_data.dart';

class Parser {
  static void parseWallBoxFile(FileData data) {
    assert(
      data.extension == 'csv',
      '${data.fullName} is not of file type csv!',
    );
    var dataList = getDataListFromWallboxFile(data);

    for (int start = 0; start + 1 < dataList.length; start += 2) {
      int stop = start + 1;
      var extractedData = parseData(
        dataList[start].trim(),
        dataList[stop].trim(),
      );
      print('|| VALIDATION |||: ' + extractedData['validation']);
      assert(
        extractedData['validation'] == "ok",
        '\nValidation failed on charging process $start:\n' +
            ' Parsing result:\n' +
            extractedData.toString(),
      );
    }
  }

  static List<String> getDataListFromWallboxFile(FileData data) {
    return data.content
        .split('\n')
        .where(
          (element) =>
              !(element.startsWith('mv:') ||
                  element.startsWith('#') ||
                  element.length == 1 ||
                  element.isEmpty),
        )
        .toList();
  }

  static Map<String, dynamic> parseData(String start, String stop) {
    String validation = 'ok';
    int? id;
    double? usage;
    DateTime? startTime, stopTime;

    var startMap = parseLine(start);
    var stopMap = parseLine(stop);
    //validate order of start/ stop
    if (startMap['type'] != 'txstart2' || stopMap['type'] != 'txstop2') {
      validation =
          '\nleading tags invalid: \nstart: {${startMap['type']}\nend: ${stopMap['type']}}';
    }
    // validate power levels
    if (validation == 'ok') {
      double? startLevel = double.tryParse(startMap['level'] ?? 'r');
      double? stopLevel = double.tryParse(stopMap['level'] ?? 'r');
      id = int.parse(startMap['id']!);

      bool validLevels =
          startLevel != null && stopLevel != null && startLevel <= stopLevel;
      usage = (validLevels) ? stopLevel - startLevel : double.nan;
      validation = validLevels
          ? 'ok'
          : 'Invalid Power usage levels:' +
                ' \nstart:$startLevel' +
                ' \nstop:$stopLevel';
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
      'id': id,
      'usage': usage,
      'startTime': startTime,
      'stopTime': stopTime,
    };
  }

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
