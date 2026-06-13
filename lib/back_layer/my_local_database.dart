import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Implementation for a local database on the device
class MyLocalDatabase {
  /// local directory for all files
  static Future<Directory> get _localDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    String rootPath = '${appDir.path}/wallbox_logs';
    final rootDirectory = Directory(rootPath);
    if (!await rootDirectory.exists()) {
      await rootDirectory.create();
    }
    return rootDirectory;
  }

  /// specified directory within _localDirectory
  static Future<Directory> _subDirectory(String subPath) async {
    String fullPath = '${(await _localDirectory).path}/$subPath';
    final directory = Directory(fullPath);
    if (!await directory.exists()) await directory.create();
    return directory;
  }

  static Future<String> _localPath(String path) async {
    final directory = Directory(
      (await _subDirectory(path)).path,
    );
    print('local path is: ${directory.path}');
    if (!await directory.exists()) {
      await directory.create();
    }
    return directory.path;
  }

  static Future<File> _localFile(String fullFileName, String subPath) async {
    final path = '${(await _localPath(subPath))}/$fullFileName';

    return File(path);
  }

  static Future<List<File>> localFilesFromPath(String subPath) async {
    final directory = await _subDirectory(subPath);
    List<File> files = List.empty(growable: true);
    await directory.list().forEach(
      (element) {
        if (element is File) {
          files.add(element);
        }
      },
    );
    return files;
  }

  /// returns the requested file if it exits
  /// - [fullFileName] : including the extension
  static Future<String> readFile(String fullFileName, String subPath) async {
    try {
      final file = await _localFile(fullFileName, subPath);
      final content = await file.readAsString();

      return content;
    } catch (e) {
      print('Error while reading file $fullFileName from $subPath: $e');
      return '';
    }
  }

  static final List<Future<void> Function()> _writingQueue = List.empty(
    growable: true,
  );
  static bool _queueIsActive = false;

  /// Writes the [content] to the file and returns it
  static void writeFile(
    String fullFileName,
    String content,
    String subPath, [
    Function()? callback,
  ]) {
    print('Enqueuing ');
    _writingQueue.add(
      () async {
        await _writeToFile(fullFileName, content, subPath);
        callback?.call();
      },
    );
    if (!_queueIsActive) {
      _queueIsActive = true;
      _processQueue();
    }
  }

  static Future<void> _writeToFile(
    String fullFileName,
    String content,
    String subPath,
  ) async {
    final file = await _localFile(fullFileName, subPath);
    await file.writeAsString(content);
  }

  static Future<void> _processQueue() async {
    _queueIsActive = true;
    try {
      while (_writingQueue.isNotEmpty) {
        await _writingQueue.removeAt(0)();
      }
    } finally {
      _queueIsActive = false;
    }
  }

  static Future<void> openDirectory(String path) async {
    final uri = Uri.file(await _localPath(path));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> deleteFile(
    String fullFileName,
    String subPath,
  ) async {
    final file = await _localFile(fullFileName, subPath);
    if (await file.exists()) await file.delete();
  }
}
