import 'dart:io';
import 'package:wallbox_logs/mid_layer/models/database_model.dart';
import 'package:wallbox_logs/back_layer/model_repos/model_repository.dart';

///Implementation for the simulated local database
class SimulationRepo<T extends DatabaseModel> extends ModelRepository<T> {
  ///
  ///Implementation for the simulated local database
  ///- [repoName] : Name of Repository, also dictates the corresponding files name as [repoName].json
  SimulationRepo(super.repoName);
  @override
  T? getById(String id) => cache[id];

  @override
  Future<File> create(T model) async {
    assert(
      !hasEntry(model.repoID),
      'Database entry for ${T.toString()} $model already exists, use update to change it!',
    );
    cache[model.repoID] = model;

    return updateFile();
  }

  @override
  Future<T> update(T model) async {
    assert(
      hasEntry(model.repoID),
      'Database entry for ${T.toString()} $model does not exist, use create to create it!',
    );
    cache[model.repoID] = model;
    await updateFile();

    return model;
  }

  @override
  Future<void> delete(String id) async {
    if (cache.remove(id) != null) {
      await updateFile();
    }
  }

  @override
  List<T> getAll() {
    return cache.values.toList();
  }
}
