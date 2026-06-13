// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_master_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMasterData _$UserMasterDataFromJson(Map<String, dynamic> json) =>
    UserMasterData(
      tagID: json['tagID'] as String,
      title: $enumDecodeNullable(_$TitlesEnumMap, json['title']) ?? Titles.div,
      prename: json['prename'] as String?,
      surname: json['surname'] as String?,
      company: json['company'] as String?,
      individualPricePerkWhInCents:
          (json['individualPricePerkWhInCents'] as num?)?.toInt(),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      streetAndNumber: json['streetAndNumber'] as String?,
      postCode: json['postCode'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$UserMasterDataToJson(UserMasterData instance) =>
    <String, dynamic>{
      'title': _$TitlesEnumMap[instance.title]!,
      'tagID': instance.tagID,
      'prename': instance.prename,
      'surname': instance.surname,
      'company': instance.company,
      'individualPricePerkWhInCents': instance.individualPricePerkWhInCents,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'streetAndNumber': instance.streetAndNumber,
      'postCode': instance.postCode,
      'city': instance.city,
    };

const _$TitlesEnumMap = {Titles.mrs: 'mrs', Titles.mr: 'mr', Titles.div: 'div'};
