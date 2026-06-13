import 'dart:async';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';
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
  Future<void> delete(
    String id,
    FutureOr<bool> Function() deletionConfirmationCallback,
  ) async {
    if (!await deletionConfirmationCallback()) return;
    if (cache.remove(id) != null) {
      updateFile();
    }
  }

  @override
  Future<void> deleteList(
    List<String> keys,
    FutureOr<bool> Function() deletionConfirmationCallback,
  ) async {
    if (!await deletionConfirmationCallback()) return;
    for (final key in keys) {
      delete(
        key,
        () => true,
      );
    }
  }

  @override
  List<T> getAll() {
    return cache.values.toList();
  }
}
