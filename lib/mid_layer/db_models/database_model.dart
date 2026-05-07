import 'package:wallbox_logs/mid_layer/db_models/user_master/user_master_data.dart';

/// Base class for any data base classes.
///
/// inheriting classes should use the [MJsonSerializable<T>] mixin with T being the same subclass!
///
abstract class DatabaseModel {
  /// unique within the same subclass
  String get id;

  /// access method for repository class
  static DatabaseModel convertFromJson<T extends DatabaseModel>(
    Map<String, dynamic> json,
  ) {
    switch (T) {
      case const (UserMasterData):
        return UserMasterData.fromJson(json);
      default:
        throw (Exception(
          'No convertFormJson implementation for DatabaseModel subclass $T',
        ));
    }
  }
}
