// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:wallbox_logs/mid_layer/data/charging_process.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';

enum ParseValue { tag, idValue, date, time, powerLevel, id2Value }

class Parser {
  static void parseWallBoxFile2(FileData data) {
    const String startTag = 'txstart2';
    const String stopTag = 'txstop2';
    const String mvTag = 'mv';
    try {
      assert(
        data.extension == 'csv',
        '${data.fullName} is not of file type csv!',
      );
      List<String> dataList = data.content.split('\n').where(
        (element) {
          return element.isNotEmpty &&
              (element.startsWith('mv') || element.startsWith('tx'));
        },
      ).toList();
      //? Find index of first starting tag

      int startIndex = 0;
      while (startIndex < dataList.length &&
          _getTag(dataList[startIndex]) != startTag) {
        print('startIndex');
        startIndex++;
      }

      //? Find index of last stop tag
      int stopIndex = dataList.length - 1;
      for (
        ;
        stopIndex >= 0 && _getTag(dataList[stopIndex]) != stopTag;
        stopIndex--
      ) {}

      //? core
      for (int i = startIndex; i <= stopIndex; i++) {
        String tag = _getTag(dataList[i]);
        assert(
          tag == startTag,
          'expected to finde tag $startTag, but found $tag at line $i.',
        );
        int j = i + 1;
        for (; j < stopIndex; j++) {
          String tagJ = _getTag(dataList[j]);
          assert(
            tagJ != startTag,
            'Invalid order of tags: expected tags $mvTag or $stopTag, but found $startTag at line $j',
          );
          if (tagJ == stopTag) {
            //? parse start and stop
            parseFullProcess(dataList[i], dataList[j]);
            break;
          }
        }

        i = j;
      }

      //TODO resolve loose starts/ stops, as soon as we have access to multiple files
      if (startIndex != 0) {}
      if (stopIndex != dataList.length - 1) {}
    } on Exception catch (e) {
      print("Error on Wallbox file ${data.fullName}: \n$e");
    }
  }

  static void parseFullProcess(String start, String stop) {
    var startParsed = _parseLine(start);
    var stopParsed = _parseLine(stop);
    ChargingProcess.completed(
      start: ChargingEvent.fromMap(startParsed),
      stop: ChargingEvent.fromMap(stopParsed),
    );
  }

  static String _getTag(String line) => line.split(':')[0];

  static Map<ParseValue, dynamic> _parseLine(String line) {
    line = line
        .replaceFirst(' id', '')
        .replaceFirst(' socket', '')
        .replaceAll(' ', ',')
        .replaceAll(',,', ',');

    var filteredList = line.split(',');
    var valueList = ParseValue.values;
    assert(filteredList.length >= valueList.length);

    var parsedData = {
      ParseValue.tag: ChargingEvent.typeFromString(filteredList[0]),
      ParseValue.idValue: int.tryParse(filteredList[1]),
      ParseValue.date: DateTime.parse('${filteredList[3]} ${filteredList[4]}'),
      ParseValue.powerLevel: double.tryParse(
        filteredList[5].replaceAll('kWh', ''),
      ),
      ParseValue.id2Value: filteredList[6],
    };

    var status = _validateParsedMap(parsedData);
    assert(
      status == 'ok',
      'Validation Failed: $status\ncausing line:\n$line',
    );

    return parsedData;
  }

  static String _validateParsedMap(Map<ParseValue, dynamic> parsed) {
    var tag = parsed[ParseValue.tag]!;
    if (tag == ChargingEventType.invalid) {
      return 'Line has invalid tag!';
    }

    var id = parsed[ParseValue.idValue];
    if (id == null) {
      return 'No user ID found!';
    }

    var date = parsed[ParseValue.date];
    if (date == null) {
      return 'No date found!';
    }

    var powerLevel = parsed[ParseValue.powerLevel];
    if (powerLevel == null) {
      return 'No Power Level found!';
    }

    return 'ok';
  }
}
