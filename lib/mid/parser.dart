import 'package:wallbox_logs/mid/data/file_data.dart';

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
    print(checkWallBoxDataList(dataList));
  }

  static bool checkWallBoxDataList(List<String> dataList) {
    for (int i = 0; i < dataList.length; i++) {
      String startString = i % 2 == 0 ? 'txstart2:' : 'txstop2:';
      if (!dataList[i].startsWith(startString)) {
        return false;
      }
    }
    return true;
  }
}
