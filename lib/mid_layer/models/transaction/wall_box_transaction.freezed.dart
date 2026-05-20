// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wall_box_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WallBoxTransaction {

 ChargingEvent get start; ChargingEvent get stop; set stop(ChargingEvent value);
/// Create a copy of WallBoxTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WallBoxTransactionCopyWith<WallBoxTransaction> get copyWith => _$WallBoxTransactionCopyWithImpl<WallBoxTransaction>(this as WallBoxTransaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WallBoxTransaction&&(identical(other.start, start) || other.start == start)&&(identical(other.stop, stop) || other.stop == stop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,stop);

@override
String toString() {
  return 'WallBoxTransaction(start: $start, stop: $stop)';
}


}

/// @nodoc
abstract mixin class $WallBoxTransactionCopyWith<$Res>  {
  factory $WallBoxTransactionCopyWith(WallBoxTransaction value, $Res Function(WallBoxTransaction) _then) = _$WallBoxTransactionCopyWithImpl;
@useResult
$Res call({
 ChargingEvent start, ChargingEvent stop
});




}
/// @nodoc
class _$WallBoxTransactionCopyWithImpl<$Res>
    implements $WallBoxTransactionCopyWith<$Res> {
  _$WallBoxTransactionCopyWithImpl(this._self, this._then);

  final WallBoxTransaction _self;
  final $Res Function(WallBoxTransaction) _then;

/// Create a copy of WallBoxTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? stop = null,}) {
  return _then(WallBoxTransaction(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as ChargingEvent,stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as ChargingEvent,
  ));
}

}


/// Adds pattern-matching-related methods to [WallBoxTransaction].
extension WallBoxTransactionPatterns on WallBoxTransaction {
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


/// @nodoc
mixin _$ChargingEvent {

 String get tagID; DateTime get timeStamp; int get powerLevelWh;
/// Create a copy of ChargingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargingEventCopyWith<ChargingEvent> get copyWith => _$ChargingEventCopyWithImpl<ChargingEvent>(this as ChargingEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChargingEvent&&(identical(other.tagID, tagID) || other.tagID == tagID)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.powerLevelWh, powerLevelWh) || other.powerLevelWh == powerLevelWh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tagID,timeStamp,powerLevelWh);

@override
String toString() {
  return 'ChargingEvent(tagID: $tagID, timeStamp: $timeStamp, powerLevelWh: $powerLevelWh)';
}


}

/// @nodoc
abstract mixin class $ChargingEventCopyWith<$Res>  {
  factory $ChargingEventCopyWith(ChargingEvent value, $Res Function(ChargingEvent) _then) = _$ChargingEventCopyWithImpl;
@useResult
$Res call({
 String tagID, DateTime timeStamp, int powerLevelWh
});




}
/// @nodoc
class _$ChargingEventCopyWithImpl<$Res>
    implements $ChargingEventCopyWith<$Res> {
  _$ChargingEventCopyWithImpl(this._self, this._then);

  final ChargingEvent _self;
  final $Res Function(ChargingEvent) _then;

/// Create a copy of ChargingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagID = null,Object? timeStamp = null,Object? powerLevelWh = null,}) {
  return _then(ChargingEvent(
tagID: null == tagID ? _self.tagID : tagID // ignore: cast_nullable_to_non_nullable
as String,timeStamp: null == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as DateTime,powerLevelWh: null == powerLevelWh ? _self.powerLevelWh : powerLevelWh // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChargingEvent].
extension ChargingEventPatterns on ChargingEvent {
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
