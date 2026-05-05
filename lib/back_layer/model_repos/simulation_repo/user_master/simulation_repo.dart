import 'dart:convert';
import 'dart:io';

import 'package:wallbox_logs/back_layer/database.dart';
import 'package:wallbox_logs/back_layer/model_repos/database_model.dart';
import 'package:wallbox_logs/back_layer/model_repos/model_repository.dart';

///
///Implementation for the simulated local database
///
class SimulationRepo<T extends DatabaseModel> extends ModelRepository<T> {
  SimulationRepo(super.repoName);
  @override
  T? getById(String id) => cache[id];

  @override
  Future<File> create(T model) async {
    assert(
      !exists(model.id),
      'Database entry for ${T.toString()} $model already exists, use update to change it!',
    );
    cache[model.id] = model;

    return _updateFile();
  }

  @override
  Future<T> update(T model) async {
    assert(
      exists(model.id),
      'Database entry for ${T.toString()} $model does not exist, use create to create it!',
    );
    cache[model.id] = model;
    await _updateFile();

    return model;
  }

  @override
  Future<void> delete(String id) async {
    if (cache.remove(id) != null) {
      await _updateFile();
    }
  }

  Future<File> _updateFile() async {
    final file = await MyDatabase.writeFile(fullFileName, jsonEncode(cache));
    return file;
  }

  @override
  Future<List<T>> getAll() async {
    return cache.values.toList();
  }
}
