import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyDatabase {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> _localFile(String fullFileName) async {
    final path = "${await _localPath}/$fullFileName";
    return File(path);
  }

  static Future<String> readFile(String fullFileName) async {
    try {
      final file = await _localFile(fullFileName);
      final content = await file.readAsString();
      return content;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<File> writeFile(String fullFileName, String content) async {
    final file = await _localFile(fullFileName);
    return file.writeAsString(content);
  }
}
