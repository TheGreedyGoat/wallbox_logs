// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wall_box_transaction_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WallBoxTransactionBlock {

 MainLine? get start; List<MVLine> get mvLines; set mvLines(List<MVLine> value); MainLine? get stop;
/// Create a copy of WallBoxTransactionBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WallBoxTransactionBlockCopyWith<WallBoxTransactionBlock> get copyWith => _$WallBoxTransactionBlockCopyWithImpl<WallBoxTransactionBlock>(this as WallBoxTransactionBlock, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WallBoxTransactionBlock&&(identical(other.start, start) || other.start == start)&&const DeepCollectionEquality().equals(other.mvLines, mvLines)&&(identical(other.stop, stop) || other.stop == stop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,const DeepCollectionEquality().hash(mvLines),stop);



}

/// @nodoc
abstract mixin class $WallBoxTransactionBlockCopyWith<$Res>  {
  factory $WallBoxTransactionBlockCopyWith(WallBoxTransactionBlock value, $Res Function(WallBoxTransactionBlock) _then) = _$WallBoxTransactionBlockCopyWithImpl;
@useResult
$Res call({
 MainLine? start, List<MVLine> mvLines, MainLine? stop
});




}
/// @nodoc
class _$WallBoxTransactionBlockCopyWithImpl<$Res>
    implements $WallBoxTransactionBlockCopyWith<$Res> {
  _$WallBoxTransactionBlockCopyWithImpl(this._self, this._then);

  final WallBoxTransactionBlock _self;
  final $Res Function(WallBoxTransactionBlock) _then;

/// Create a copy of WallBoxTransactionBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = freezed,Object? mvLines = null,Object? stop = freezed,}) {
  return _then(WallBoxTransactionBlock(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as MainLine?,mvLines: null == mvLines ? _self.mvLines : mvLines // ignore: cast_nullable_to_non_nullable
as List<MVLine>,stop: freezed == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as MainLine?,
  ));
}

}


/// Adds pattern-matching-related methods to [WallBoxTransactionBlock].
extension WallBoxTransactionBlockPatterns on WallBoxTransactionBlock {
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
