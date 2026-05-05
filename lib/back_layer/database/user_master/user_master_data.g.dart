// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_master_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMasterData _$UserMasterDataFromJson(Map<String, dynamic> json) =>
    UserMasterData(
      tagID: json['tagID'] as String,
      name: json['name'] as String?,
      company: json['company'] as String?,
      individualPrice: (json['individualPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserMasterDataToJson(UserMasterData instance) =>
    <String, dynamic>{
      'tagID': instance.tagID,
      'name': instance.name,
      'company': instance.company,
      'individualPrice': instance.individualPrice,
    };
