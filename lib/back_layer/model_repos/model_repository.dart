import 'dart:async';
import 'dart:convert';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';

/// basic Repository class
/// to be implemented for the type of database used
abstract class ModelRepository<T extends DatabaseModel> {
  static const String _filePath = 'repositories';

  /// runtime storage for model objects
  final Map<String, T> cache = {};

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

  List<String> get allKeys => getAll()
      .map(
        (model) => model.repoKey,
      )
      .toList();

  /// Returns an object with the given id if it exists, else null
  T? getById(String id);

  /// Updates the entry if it exists or creates it if not
  ///
  /// Returns it asynchronously afterwards
  void createOrUpdate(T model) {
    cache[model.repoKey] = model;
    updateFile();
  }

  /// Deletes the object with the given id if it exists
  Future<void> delete(
    String id,
    FutureOr<bool> Function() deletionConfirmationCallback,
  );
  Future<void> deleteList(
    List<String> keys,
    FutureOr<bool> Function() deletionConfirmationCallback,
  );

  /// Returns true if a Database entry with the given [key] exits
  bool hasEntry(String key) => getById(key) != null;

  bool hasNoEntry(String key) => !hasEntry(key);

  /// Overrides the cache with data in database.
  /// The [isLoaded] property has to be set to ```false```
  Future<void> preload() async {
    if (isLoaded) return;
    String data = await MyLocalDatabase.readFile(fullFileName, _filePath);
    try {
      final decoded = jsonDecode(data);
      for (var json in decoded) {
        final model = DatabaseModel.convertFromJson<T>(json);
        if (model is T) {
          cache[model.repoKey] = model;
        }
      }
      isLoaded = true;
    } catch (e) {
      print('Error while loading data for $T: $e \n data: $data');
      if (e is FormatException) await clear();
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
  void updateFile() {
    MyLocalDatabase.writeFile(
      fullFileName,
      jsonEncode(cache.values.toList()),
      _filePath,
    );
  }
}
