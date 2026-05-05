import 'dart:convert';
import 'dart:io';

import 'package:wallbox_logs/back_layer/database.dart';
import 'package:wallbox_logs/back_layer/model_repos/database_model.dart';

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
    final decoded = jsonDecode(data) as Map;
    for (var key in decoded.keys) {
      final value = decoded[key];
      if (value is T) {
        cache[key] = value;
      }
    }
    isLoaded = true;
  }
}
