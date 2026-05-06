import 'package:flutter/services.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';

/// For handling files in the assets folder
class AssetFileReader {
  /// passes the files content (if it exits) to the [callbacks]
  static Future<void> loadFileData(
    String path,
    Function(FileData) callback,
  ) async {
    try {
      final content = await rootBundle.loadString(path);
      String fullFileName = path.split('/').last;
      callback(FileData.fromFullName(fullName: fullFileName, content: content));
    } catch (e) {
      print("Error on CSV File '$path':\n==============================\n $e");
    }
  }
}
