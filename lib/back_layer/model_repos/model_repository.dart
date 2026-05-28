import 'dart:convert';
import 'dart:io';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/models/database_model.dart';

/// basic Repository class
/// to be implemented for the type of database used
abstract class ModelRepository<T extends DatabaseModel> {
  /// runtime storage for model objects
  final Map<String, T> cache = {};
  bool queueIsWorking = false;
  final List<T> writingQueue = List.empty(growable: true);

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

  Future<void> enqeueCacheValue(T model) async {
    writingQueue.add(model);
    _resolveQueue();
  }

  Future<void> _resolveQueue() async {
    if (queueIsWorking) return;
    while (writingQueue.isNotEmpty) {
      final model = writingQueue.removeAt(0);
      cache[model.repoID] = model;
    }
    await updateFile();
    queueIsWorking = false;
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
  Future<void> delete(String id);

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
