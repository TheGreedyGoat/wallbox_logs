import 'dart:convert';
import 'dart:io';

import 'package:wallbox_logs/back_layer/database.dart';
import 'package:wallbox_logs/mid_layer/db_models/database_model.dart';
import 'package:wallbox_logs/mid_layer/db_models/user_master/user_master_data.dart';

/// basic Repository class
/// to be implemented for the type of database used
abstract class ModelRepository<T extends DatabaseModel> {
  late final Map<String, T> cache = {};
  bool isLoaded = false;
  final String repoName;
  ModelRepository(this.repoName);

  String get fullFileName => '$repoName.json';

  Future<List<T>> getAll();
  T? getById(String id);
  Future<File> create(T model);
  Future<T> update(T model);
  Future<void> delete(String id);

  bool exists(String id) => getById(id) != null;

  Future<void> preload() async {
    if (isLoaded) return;
    String data = await MyDatabase.readFile(fullFileName);
    print(data);
    final decoded = jsonDecode(data);
    for (var json in decoded) {
      print(json.runtimeType);
    }
  }

  Future<void> clear() async {
    cache.removeWhere(
      (key, value) => true,
    );
    updateFile();
  }

  Future<File> updateFile() async {
    final file = await MyDatabase.writeFile(
      fullFileName,
      jsonEncode(cache.values.toList()),
    );
    return file;
  }
}
