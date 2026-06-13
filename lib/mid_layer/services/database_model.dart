import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

/// Base class for any data base classes.
///
/// inheriting classes should use the [MJsonSerializable<T>] mixin with T being the same subclass!
///
abstract class DatabaseModel {
  /// The objects ID within the Repository
  /// unique within the same subclass
  String get repoKey;

  /// access method for repository class
  static DatabaseModel convertFromJson<T extends DatabaseModel>(
    Map<String, dynamic> json,
  ) {
    switch (T) {
      case const (UserMasterData):
        return UserMasterData.fromJson(json);
      case const (WallBoxTransaction):
        return WallBoxTransaction.fromJson(json);
      default:
        throw (Exception(
          'No convertFormJson implementation for DatabaseModel subclass $T',
        ));
    }
  }
}
