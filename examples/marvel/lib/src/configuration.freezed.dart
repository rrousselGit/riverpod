// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Configuration {

 String get publicKey; String get privateKey;
/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigurationCopyWith<Configuration> get copyWith => _$ConfigurationCopyWithImpl<Configuration>(this as Configuration, _$identity);

  /// Serializes this Configuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Configuration&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicKey,privateKey);

@override
String toString() {
  return 'Configuration(publicKey: $publicKey, privateKey: $privateKey)';
}


}

/// @nodoc
abstract mixin class $ConfigurationCopyWith<$Res>  {
  factory $ConfigurationCopyWith(Configuration value, $Res Function(Configuration) _then) = _$ConfigurationCopyWithImpl;
@useResult
$Res call({
 String publicKey, String privateKey
});




}
/// @nodoc
class _$ConfigurationCopyWithImpl<$Res>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._self, this._then);

  final Configuration _self;
  final $Res Function(Configuration) _then;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicKey = null,Object? privateKey = null,}) {
  return _then(_self.copyWith(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,privateKey: null == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Configuration].
extension ConfigurationPatterns on Configuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Configuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Configuration value)  $default,){
final _that = this;
switch (_that) {
case _Configuration():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Configuration value)?  $default,){
final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String publicKey,  String privateKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that.publicKey,_that.privateKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String publicKey,  String privateKey)  $default,) {final _that = this;
switch (_that) {
case _Configuration():
return $default(_that.publicKey,_that.privateKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String publicKey,  String privateKey)?  $default,) {final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that.publicKey,_that.privateKey);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Configuration implements Configuration {
   _Configuration({required this.publicKey, required this.privateKey});
  factory _Configuration.fromJson(Map<String, dynamic> json) => _$ConfigurationFromJson(json);

@override final  String publicKey;
@override final  String privateKey;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigurationCopyWith<_Configuration> get copyWith => __$ConfigurationCopyWithImpl<_Configuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Configuration&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicKey,privateKey);

@override
String toString() {
  return 'Configuration(publicKey: $publicKey, privateKey: $privateKey)';
}


}

/// @nodoc
abstract mixin class _$ConfigurationCopyWith<$Res> implements $ConfigurationCopyWith<$Res> {
  factory _$ConfigurationCopyWith(_Configuration value, $Res Function(_Configuration) _then) = __$ConfigurationCopyWithImpl;
@override @useResult
$Res call({
 String publicKey, String privateKey
});




}
/// @nodoc
class __$ConfigurationCopyWithImpl<$Res>
    implements _$ConfigurationCopyWith<$Res> {
  __$ConfigurationCopyWithImpl(this._self, this._then);

  final _Configuration _self;
  final $Res Function(_Configuration) _then;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicKey = null,Object? privateKey = null,}) {
  return _then(_Configuration(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,privateKey: null == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
