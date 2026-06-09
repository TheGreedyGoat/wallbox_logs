// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wall_box_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainLine _$MainLineFromJson(Map<String, dynamic> json) => MainLine(
  DateTime.parse(json['timeStamp'] as String),
  (json['powerLevelWh'] as num).toInt(),
  json['tagID'] as String,
  json['isStart'] as bool,
);

Map<String, dynamic> _$MainLineToJson(MainLine instance) => <String, dynamic>{
  'powerLevelWh': instance.powerLevelWh,
  'timeStamp': instance.timeStamp.toIso8601String(),
  'tagID': instance.tagID,
  'isStart': instance.isStart,
};

MVLine _$MVLineFromJson(Map<String, dynamic> json) => MVLine(
  DateTime.parse(json['timeStamp'] as String),
  (json['powerLevelWh'] as num).toInt(),
);

Map<String, dynamic> _$MVLineToJson(MVLine instance) => <String, dynamic>{
  'powerLevelWh': instance.powerLevelWh,
  'timeStamp': instance.timeStamp.toIso8601String(),
};
