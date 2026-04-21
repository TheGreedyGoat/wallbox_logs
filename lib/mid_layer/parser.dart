import 'package:wallbox_logs/mid_layer/data/file_data.dart';

class Parser {
  static void parseWallBoxFile(FileData data) {
    assert(
      data.extension == 'csv',
      '${data.fullName} is not of file type csv!',
    );
    var dataList = data.content
        .split('\n')
        .where(
          (element) =>
              !(element.startsWith('mv:') ||
                  element.startsWith('#') ||
                  element.length == 1 ||
                  element.isEmpty),
        )
        .toList();
    if (!checkWallBoxDataList(dataList)) {
      return;
    }
    for (int i = 0; i + 1 < dataList.length; i += 2) {
      var res = parseData(dataList[i], dataList[i + 1]);

      print('Tankkarte ${res['id']} hat ${res['usage']}kWh getankt.');
    }
  }

  static Map<String, dynamic> parseData(String start, String stop) {
    var startMap = parseLine(start);
    var stopMap = parseLine(stop);

    double? startLevel = double.tryParse(startMap['level'] ?? 'r');
    double? stopLevel = double.tryParse(stopMap['level'] ?? 'r');
    String id = int.parse(startMap['id']!).toString();

    double usage = (startLevel != null && stopLevel != null)
        ? stopLevel - startLevel
        : -1;

    return {'id': id, 'usage': usage};
  }

  static Map<String, String> parseLine(String line) {
    final String id;
    String level;
    var split = line.split(',');
    id = split[0].split(' ').last;
    level = split[2].split(' ')[3];
    level = level.replaceAll('kWh', '');

    return {"id": id, "level": level};
  }

  static bool checkWallBoxDataList(List<String> dataList) {
    //   txstart2: id 0xffffffffffffffff, socket 1,  2026-01-24 07:40:58 2593.341kWh 050FE8E3210000 3 2 N
    // start/stop: id [idhex],            sockedNum, Datum               Stand       ???            ???
    for (int i = 0; i < dataList.length; i++) {
      String startString = i % 2 == 0 ? 'txstart2:' : 'txstop2:';
      if (!dataList[i].startsWith(startString)) {
        return false;
      }
    }
    return true;
  }
}
