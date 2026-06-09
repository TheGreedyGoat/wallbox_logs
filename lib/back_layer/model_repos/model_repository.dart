import 'dart:convert';
import 'dart:io';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';

/// basic Repository class
/// to be implemented for the type of database used
abstract class ModelRepository<T extends DatabaseModel> {
  /// runtime storage for model objects
  final Map<String, T> cache = {};

  bool _queueIsWorking = false;
  final List<T> _writingQueue = List.empty(growable: true);

  /// check if DB files are loaded
  bool isLoaded = false;

  /// Name of Repository, also dictates the corresponding files name as
  /// [repoName].json
  final String repoName;

  /// getter for the corresponding file name
  String get fullFileName => '$repoName.json';

  /// basic Repository class
  /// to be implemented for the type of database used
  ModelRepository(this.repoName);

  /// Returns a list of all saved model objects
  List<T> getAll();

  /// Returns an object with the given id if it exists, else null
  T? getById(String id);

  /// Creates a new entry for that model.
  /// Throws an Exception If another model with the same ID already exists
  Future<T> create(T model);

  /// Replaces an existing object witht the same id as [model]
  Future<T> update(T model);

  /// adds [model] to the writing queue and starts it if nessecary
  Future<void> enqeueCacheValue(T model) async {
    _writingQueue.add(model);
    _resolveQueue();
  }

  Future<void> _resolveQueue() async {
    if (_queueIsWorking) return;
    while (_writingQueue.isNotEmpty) {
      final model = _writingQueue.removeAt(0);
      cache[model.repoID] = model;
    }
    await updateFile();
    _queueIsWorking = false;
  }

  /// Updates the entry if it exists or creates it if not
  ///
  /// Returns it asynchronously afterwards
  Future<T> createOrUpdate(T model) async {
    if (hasEntry(model.repoID)) {
      await update(model);
    } else {
      await create(model);
    }

    return model;
  }

  /// Deletes the object with the given id if it exists
  Future<void> delete(
    String id,
    Future<bool> Function() deletionConfirmationCallback,
  );

  /// Returns true if a Database entry with the given [id] exits
  bool hasEntry(String id) => getById(id) != null;

  /// Overrides the cache with data in database.
  /// The [isLoaded] property has to be set to ```false```
  Future<void> preload() async {
    if (isLoaded) return;
    String data = await MyLocalDatabase.readFile(fullFileName);
    try {
      final decoded = jsonDecode(data);
      for (var json in decoded) {
        final model = DatabaseModel.convertFromJson<T>(json);
        if (model is T) {
          create(model);
        }
      }
    } catch (e) {
      print('error');
      print(e);
    }
  }

  /// ```!!DANGER ZONE!!``` Deletes everything from the cache aswell as the Database
  Future<void> clear() async {
    cache.removeWhere(
      (key, value) => true,
    );
    updateFile();
  }

  /// Overrides the reop files content with the cache
  Future<File> updateFile() async {
    final file = await MyLocalDatabase.writeFile(
      fullFileName,
      jsonEncode(cache.values.toList()),
    );
    return file;
  }
}
