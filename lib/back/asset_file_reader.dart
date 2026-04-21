import 'package:flutter/services.dart';
import 'package:wallbox_logs/mid/data/file_data.dart';

class AssetFileReader {
  static Future<void> loadFileData(
    String path,
    Function(FileData) callback,
  ) async {
    try {
      final content = await rootBundle.loadString(path);
      String fullFileName = path.split('/').last;
      callback(FileData.fromFullName(fullName: fullFileName, content: content));
    } catch (e) {
      print("Error on CSV File $path: $e");
    }
  }
}
