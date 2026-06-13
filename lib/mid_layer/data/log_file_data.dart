import 'dart:io';

import 'package:wallbox_logs/back_layer/my_local_database.dart';

class LogFileData {
  static final String pathRoot = 'file_data';

  static final List<LogFileData> _existing = List.empty(growable: true);

  static List<LogFileData> get logs => _existing.toList(growable: false);

  LogFileData._p({required this.name, required this.ext});

  final String name;
  final String ext;

  bool _access = false;

  String get fullName => '$name.$ext';

  Future<String> get content async =>
      await MyLocalDatabase.readFile(fullName, pathRoot);

  static Future<void> openDirectory() async =>
      MyLocalDatabase.openDirectory(pathRoot);

  static Future<void> preload() async {
    final files = await MyLocalDatabase.localFilesFromPath(pathRoot);
    for (final file in files) {
      _existing.add(await fromFile(file));
    }
  }

  static Future<void> clear() async {
    final copy = logs.toList(growable: false);
    for (final log in copy) {
      log._delete();
    }
  }

  Future<void> _delete() async {
    _existing.remove(this);
    await MyLocalDatabase.deleteFile(fullName, pathRoot);
  }

  static Future<LogFileData> fromFile(File file) async {
    final splitName = file.path.split('/').last.split('\\').last.split('.');
    return LogFileData._p(name: splitName[0], ext: splitName[1]);
  }

  void writeContent(String content) {
    print('Writing ${content.length} chars to $pathRoot/$fullName');
    _access == false;
    MyLocalDatabase.writeFile(
      fullName,
      content,
      pathRoot,
      () => _access = true,
    );
  }

  static Future<LogFileData> create({
    required String name,
    required String ext,
    String content = '',
  }) async {
    final logFileData = LogFileData._p(name: name, ext: ext);
    assert(
      !checkExisting(name, ext),
      'File $name.$ext already exists!',
    );
    logFileData.writeContent(content);

    _existing.add(logFileData);
    return logFileData;
  }

  Future<void> waitForAccess() async {
    while (!_access) {
      await Future.delayed(Duration(seconds: 1));
    }
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
