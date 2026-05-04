import 'package:wallbox_logs/back_layer/database/database_model.dart';

abstract class ModelRepository<T extends DatabaseModel> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<T> create(T model);
  Future<T> update(T model);
  Future<void> delete(int id);
}
