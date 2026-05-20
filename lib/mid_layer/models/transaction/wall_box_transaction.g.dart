// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wall_box_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallBoxTransaction _$WallBoxTransactionFromJson(Map<String, dynamic> json) =>
    WallBoxTransaction(
      start: ChargingEvent.fromJson(json['start'] as Map<String, dynamic>),
      stop: ChargingEvent.fromJson(json['stop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallBoxTransactionToJson(WallBoxTransaction instance) =>
    <String, dynamic>{'start': instance.start, 'stop': instance.stop};

ChargingEvent _$ChargingEventFromJson(Map<String, dynamic> json) =>
    ChargingEvent(
      tagID: json['tagID'] as String,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
      powerLevelWh: (json['powerLevelWh'] as num).toInt(),
    );

Map<String, dynamic> _$ChargingEventToJson(ChargingEvent instance) =>
    <String, dynamic>{
      'tagID': instance.tagID,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'powerLevelWh': instance.powerLevelWh,
    };
