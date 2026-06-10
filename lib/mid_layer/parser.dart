import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/data/file_data_2.dart';
import 'package:wallbox_logs/mid_layer/services/parser/wall_box_log.dart';

///static class to validate and parse Wallbox files
class WallBoxParser {
  static bool isLoaded = false;

  // static Future<void> _ensurePreload() async {
  //   if (isLoaded) return;
  //   String data = await MyLocalDatabase.readFile(_fileName);
  //   _existingFileNames = data
  //       .split('\n')
  //       .where(
  //         (element) => element.isNotEmpty,
  //       )
  //       .toList(growable: true);
  //   isLoaded = true;
  // }

  // static Future<void> _registerFileName(String fileName) async {
  //   _existingFileNames.add(fileName);
  //   MyLocalDatabase.writeFile(
  //     _fileName,
  //     _existingFileNames.fold(
  //       '',
  //       (previousValue, element) {
  //         return '$previousValue\n$element';
  //       },
  //     ),
  //   );
  // }

  static Future<int> processFilePickerResult(
    FilePickerResult? result,
    Future<String?> Function(String fileName) overrideOnExisting,
  ) async {
    int successful = 0;
    if (result == null) return 0;
    for (int i = 0; i < result.paths.length; i++) {
      final path = result.paths[i];
      if (path == null) continue;
      final fullName = _fileNameFromPath(path);
      final splitName = fullName.split('.');
      final ext = splitName.removeLast();
      final name = splitName
          .fold(
            '',
            (previousValue, element) => '$previousValue.$element',
          )
          .replaceFirst('.', '');

      String content = await File(path).readAsString();
      if (await _createLog(name, ext, content, overrideOnExisting)) {
        successful++;
      }
    }
    return successful;
  }

  static Future<bool> _createLog(
    String name,
    String ext,
    String content,
    Future<String?> Function(String fileName) overrideOnExisting,
  ) async {
    print('check if $name exists:');
    print(LogFileData.checkExisting(name, ext));
    try {
      (await WallBoxLog.fromFileData(
        await LogFileData.create(name: name, ext: ext, content: content),
      )).createTransactions();
      return true;
    } catch (e) {
      String? override = await overrideOnExisting(name);
      print('new file name: $override');
      if (override != null) {
        return await _createLog(override, ext, content, overrideOnExisting);
      }
      return false;
    }
  }

  static String _fileNameFromPath(String path) => path.split('\\').last;
}
