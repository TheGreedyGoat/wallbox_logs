import 'dart:io';

import 'package:wallbox_logs/back_layer/my_local_database.dart';

class LogFileData {
  static final String pathRoot = 'file_data';

  static final List<LogFileData> _existing = List.empty(growable: true);

  static List<LogFileData> get logs => _existing.toList(growable: false);

  LogFileData._p({required this.name, required this.ext});

  static Future<void> openDirectory() async =>
      MyLocalDatabase.openDirectory(pathRoot);

  static Future<void> preload() async {
    final files = await MyLocalDatabase.localFilesFromPath(pathRoot);
    for (final file in files) {
      _existing.add(await fromFile(file));
    }
  }

  final String name;
  final String ext;

  static Future<LogFileData> fromFile(File file) async {
    final splitName = file.path.split('/').last.split('.');
    return LogFileData._p(name: splitName[0], ext: splitName[1]);
  }

  String get fullName => '$name.$ext';

  Future<String> get content async =>
      await MyLocalDatabase.readFile(fullName, pathRoot);

  Future<void> writeContent(String content) async {
    print('Writing ${content.length} chars to $pathRoot/$fullName');
    await MyLocalDatabase.writeFile(fullName, content, pathRoot);
  }

  static Future<LogFileData> create({
    required String name,
    required String ext,
    String content = '',
  }) async {
    final data = LogFileData._p(name: name, ext: ext);
    assert(
      !checkExisting(name, ext),
      'File $name.$ext already exists!',
    );
    await data.writeContent(content);
    _existing.add(data);
    return data;
  }

  static bool checkExisting(String name, String ext) {
    for (final data in _existing) {
      if (data.name == name && data.ext == ext) return true;
    }
    return false;
  }

  bool checkEqual(
    String name,
    String ext,
  ) => name == this.name && ext == this.ext;
}
