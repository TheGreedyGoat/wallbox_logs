// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

/// Used for ParserMaps
enum WallBoxParserValue {
  ///
  date,

  ///
  powerLevel,

  ///
  id2Value,
}

///static class to validate and parse Wallbox files
class WallBoxParser {
  static const String _startTag = 'txstart2';
  static const String _stopTag = 'txstop2';
  static const String _mvTag = 'mv';

  /// parses the wallbox file and saves the data into a [WallBoxTransaction] object
  ///
  /// TO DO: Handle end of file shite
  static Future<void> parseWallBoxFile(FileData data) async {
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
          _getTag(dataList[startIndex]) != _startTag) {
        startIndex++;
      }

      //? Find index of last stop tag
      int stopIndex = dataList.length - 1;
      for (
        ;
        stopIndex >= 0 && _getTag(dataList[stopIndex]) != _stopTag;
        stopIndex--
      ) {}

      if (startIndex != 0) {
        String firstLine = dataList.first;
        String stopLine = dataList[startIndex - 1];
        _parseIncompleteBlock(firstLine, stopLine, true);
      }

      //? core
      for (int i = startIndex; i <= stopIndex; i++) {
        String tag = _getTag(dataList[i]);
        assert(
          tag == _startTag,
          'expected to finde tag $_startTag, but found $tag at line $i.',
        );
        int j = i + 1;
        for (; j < stopIndex; j++) {
          String tagJ = _getTag(dataList[j]);
          assert(
            tagJ != _startTag,
            'Invalid order of tags: expected tags $_mvTag or $_stopTag, but found $_startTag at line $j',
          );
          if (tagJ == _stopTag) {
            //? parse start and stop
            _parseFullProcess(dataList[i], dataList[j]);
            break;
          }
        }

        i = j;
      }
      if (stopIndex != dataList.length - 1) {
        String startLine = dataList[stopIndex + 1];
        String lastLine = dataList.last;
        _parseIncompleteBlock(startLine, lastLine, false);
      }
    } on Exception catch (e) {
      print('Error parsing Wallbox file ${data.fullName}: \n$e');
    }
  }

  static Future<void> _saveTransaction(WallBoxTransaction transaction) async {
    await WallBoxTransaction.repo.create(transaction);
    String tagID = transaction.tagID;
    if (!UserMasterData.repo.hasEntry(tagID)) {
      await UserMasterData.repo.create(UserMasterData(tagID: tagID));
    }
  }

  //  ###
  //   #  #    #  ####   ####  #    # #####  #      ###### ##### ######
  //   #  ##   # #    # #    # ##  ## #    # #      #        #   #
  //   #  # #  # #      #    # # ## # #    # #      #####    #   #####
  //   #  #  # # #      #    # #    # #####  #      #        #   #
  //   #  #   ## #    # #    # #    # #      #      #        #   #
  //  ### #    #  ####   ####  #    # #      ###### ######   #   ######

  ///For a block that either has no start or end line (eg by being interrubted by an end of file)
  static Future<void> _parseIncompleteBlock(
    String line1,
    String line2,
    bool isAtStartOfFile,
  ) async {
    final mainLine = isAtStartOfFile ? line2 : line1;
    final mvLine = isAtStartOfFile ? line1 : line2;
    assert(_getTag(mainLine) != _mvTag);
    assert(_getTag(mvLine) == _mvTag);

    var mainValues = _parseLine(mainLine);
    var mvValues = _parseLine(mvLine);

    mvValues[WallBoxParserValue.id2Value] =
        mainValues[WallBoxParserValue.id2Value];

    ChargingEvent mainEvent = ChargingEvent.fromEnumMap(mainValues);
    ChargingEvent mvEvent = ChargingEvent.fromEnumMap(mvValues);

    await _saveTransaction(
      WallBoxTransaction(
        start: isAtStartOfFile ? mvEvent : mainEvent,
        stop: isAtStartOfFile ? mainEvent : mvEvent,
      ),
    );
  }

  //                                 ######
  //  ###### #    # #      #         #     # #####   ####   ####  ######  ####   ####
  //  #      #    # #      #         #     # #    # #    # #    # #      #      #
  //  #####  #    # #      #         ######  #    # #    # #      #####   ####   ####
  //  #      #    # #      #         #       #####  #    # #      #           #      #
  //  #      #    # #      #         #       #   #  #    # #    # #      #    # #    #
  //  #       ####  ###### ######    #       #    #  ####   ####  ######  ####   ####
  static Future<void> _parseFullProcess(String start, String stop) async {
    var startParsed = _parseMainLine(start);
    var stopParsed = _parseMainLine(stop);
    await _saveTransaction(
      WallBoxTransaction(
        start: ChargingEvent.fromEnumMap(startParsed),
        stop: ChargingEvent.fromEnumMap(stopParsed),
      ),
    );
  }

  static String _getTag(String line) => line.split(':')[0];

  static Map<WallBoxParserValue, dynamic> _parseLine(String line) {
    switch (_getTag(line)) {
      case _startTag:
      case _stopTag:
        return _parseMainLine(line);
      case _mvTag:
        return _parseMVLine(line);
      default:
        throw (Exception('Invalid line tag of line $line'));
    }
  }

  //  #
  //  #       # #    # ######  ####
  //  #       # ##   # #      #
  //  #       # # #  # #####   ####
  //  #       # #  # # #           #
  //  #       # #   ## #      #    #
  //  ####### # #    # ######  ####

  static Map<WallBoxParserValue, dynamic> _parseLineData(String dataBlock) {
    final splitData = dataBlock.trim().split(' ');
    return {
      WallBoxParserValue.date: DateTime.parse(
        '${splitData[0]} ${splitData[1]}',
      ),
      WallBoxParserValue.powerLevel: double.parse(
        splitData[2].replaceAll('kWh', ''),
      ),
      WallBoxParserValue.id2Value: splitData[3],
    };
  }

  static Map<WallBoxParserValue, dynamic> _parseMVLine(String line) {
    assert(
      _getTag(line) == _mvTag,
      'Non - MV line was passed to parseMVLine: $line',
    );

    final parsedBlock = _parseLineData(line.split(',')[1]);
    parsedBlock[WallBoxParserValue.id2Value] = 'NONE';
    return parsedBlock;
  }

  static Map<WallBoxParserValue, dynamic> _parseMainLine(String line) {
    assert(
      _getTag(line) == _startTag || _getTag(line) == _stopTag,
      'Non - Main line was passed to parseMainLine: $line',
    );
    String dataBlock = line.split(',')[2];
    var data = _parseLineData(dataBlock);

    var status = _validateParsedMap(data);
    assert(
      status == 'ok',
      'Validation Failed: $status\ncausing line:\n$line',
    );

    return data;
  }

  static String _validateParsedMap(Map<WallBoxParserValue, dynamic> parsed) {
    var date = parsed[WallBoxParserValue.date];
    if (date == null) {
      return 'No date found!';
    }

    var powerLevel = parsed[WallBoxParserValue.powerLevel];
    if (powerLevel == null) {
      return 'No Power Level found!';
    }

    return 'ok';
  }
}
