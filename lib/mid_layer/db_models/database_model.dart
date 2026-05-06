/// Base class for any data base classes.
///
/// inheriting classes should use the [MJsonSerializable<T>] mixin with T being the same subclass!
///
abstract class DatabaseModel {
  /// unique within the same subclass
  String get id;
}
