import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/services/parser/wall_box_log.dart';

///static class to validate and parse Wallbox files
class WallBoxParser {
  static const String _fileName = 'existing_log_files.txt';
  static late final List<String> _existingFileNames;

  static Future<List<String>> get existingFileNames async {
    await _ensurePreload();
    return _existingFileNames;
  }

  static bool isLoaded = false;

  static Future<void> _ensurePreload() async {
    if (isLoaded) return;
    String data = await MyLocalDatabase.readFile(_fileName);
    _existingFileNames = data
        .split('\n')
        .where(
          (element) => element.isNotEmpty,
        )
        .toList(growable: true);
    isLoaded = true;
  }

  static Future<void> _registerFileName(String fileName) async {
    _existingFileNames.add(fileName);
    MyLocalDatabase.writeFile(
      _fileName,
      _existingFileNames.fold(
        '',
        (previousValue, element) {
          return '$previousValue\n$element';
        },
      ),
    );
  }

  static Future<void> processFilePickerResult(
    FilePickerResult? result,
    Future<bool> Function(String fileName) skipExistingCallback,
  ) async {
    if (result == null) return;
    await _ensurePreload();
    for (int i = 0; i < result.paths.length; i++) {
      final name = _fileNameFromPath(result.paths[i]!);
      if (_existingFileNames.contains(name)) {
        if (await skipExistingCallback(name)) {
          continue;
        }
      } else {
        await _registerFileName(name);
      }
      File file = File(result.paths[i]!);
      (await WallBoxLog.fromFile(file)).createTransactions(true);
    }
  }

  static String _fileNameFromPath(String path) => path.split('\\').last;
}
