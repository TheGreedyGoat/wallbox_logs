// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_master_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMasterData {

 Titles get title; String get tagID; String? get prename; String? get surname; String? get company; double? get individualPrice; String? get email; String? get phoneNumber; String? get streetAndNumber; String? get postCode; String? get city;
/// Create a copy of UserMasterData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMasterDataCopyWith<UserMasterData> get copyWith => _$UserMasterDataCopyWithImpl<UserMasterData>(this as UserMasterData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMasterData&&(identical(other.title, title) || other.title == title)&&(identical(other.tagID, tagID) || other.tagID == tagID)&&(identical(other.prename, prename) || other.prename == prename)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.company, company) || other.company == company)&&(identical(other.individualPrice, individualPrice) || other.individualPrice == individualPrice)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.streetAndNumber, streetAndNumber) || other.streetAndNumber == streetAndNumber)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,tagID,prename,surname,company,individualPrice,email,phoneNumber,streetAndNumber,postCode,city);

@override
String toString() {
  return 'UserMasterData(title: $title, tagID: $tagID, prename: $prename, surname: $surname, company: $company, individualPrice: $individualPrice, email: $email, phoneNumber: $phoneNumber, streetAndNumber: $streetAndNumber, postCode: $postCode, city: $city)';
}


}

/// @nodoc
abstract mixin class $UserMasterDataCopyWith<$Res>  {
  factory $UserMasterDataCopyWith(UserMasterData value, $Res Function(UserMasterData) _then) = _$UserMasterDataCopyWithImpl;
@useResult
$Res call({
 Titles title, String tagID, String? prename, String? surname, String? company, double? individualPrice, String? email, String? phoneNumber, String? streetAndNumber, String? postCode, String? city
});




}
/// @nodoc
class _$UserMasterDataCopyWithImpl<$Res>
    implements $UserMasterDataCopyWith<$Res> {
  _$UserMasterDataCopyWithImpl(this._self, this._then);

  final UserMasterData _self;
  final $Res Function(UserMasterData) _then;

/// Create a copy of UserMasterData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? tagID = null,Object? prename = freezed,Object? surname = freezed,Object? company = freezed,Object? individualPrice = freezed,Object? email = freezed,Object? phoneNumber = freezed,Object? streetAndNumber = freezed,Object? postCode = freezed,Object? city = freezed,}) {
  return _then(UserMasterData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Titles,tagID: null == tagID ? _self.tagID : tagID // ignore: cast_nullable_to_non_nullable
as String,prename: freezed == prename ? _self.prename : prename // ignore: cast_nullable_to_non_nullable
as String?,surname: freezed == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,individualPrice: freezed == individualPrice ? _self.individualPrice : individualPrice // ignore: cast_nullable_to_non_nullable
as double?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,streetAndNumber: freezed == streetAndNumber ? _self.streetAndNumber : streetAndNumber // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMasterData].
extension UserMasterDataPatterns on UserMasterData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
