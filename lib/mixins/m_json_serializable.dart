/// mixin for [DataBaseModel] classes
mixin MJsonSerializable<T> {
  /// converts a valid json MAp to an instance.
  T fromJson(Map<String, dynamic> json);

  /// Convert an instance to a json Map
  Map<String, dynamic> toJson();
}
