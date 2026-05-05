/// Base class for any data base classes
///
abstract class DatabaseModel {
  String get id;
  Map<String, dynamic> toJson();
}
