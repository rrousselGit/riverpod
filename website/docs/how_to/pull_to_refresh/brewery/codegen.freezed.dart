// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Brewery {

 String get name;@JsonKey(name: 'brewery_type') String get breweryType; String get city; String get country;
/// Create a copy of Brewery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreweryCopyWith<Brewery> get copyWith => _$BreweryCopyWithImpl<Brewery>(this as Brewery, _$identity);

  /// Serializes this Brewery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Brewery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Brewery&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.breweryType, _this.breweryType) || other.breweryType == _this.breweryType)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.country, _this.country) || other.country == _this.country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Brewery;
  return Object.hash(runtimeType,_this.name,_this.breweryType,_this.city,_this.country);
}

@override
String toString() {
  final _this = this as Brewery;
  return 'Brewery(name: ${_this.name}, breweryType: ${_this.breweryType}, city: ${_this.city}, country: ${_this.country})';
}


}

/// @nodoc
abstract mixin class $BreweryCopyWith<$Res>  {
  factory $BreweryCopyWith(Brewery value, $Res Function(Brewery) _then) = _$BreweryCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'brewery_type') String breweryType, String city, String country
});




}
/// @nodoc
class _$BreweryCopyWithImpl<$Res>
    implements $BreweryCopyWith<$Res> {
  _$BreweryCopyWithImpl(this._self, this._then);

  final Brewery _self;
  final $Res Function(Brewery) _then;

/// Create a copy of Brewery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? breweryType = null,Object? city = null,Object? country = null,}) {
  return _then(Brewery(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,breweryType: null == breweryType ? _self.breweryType : breweryType // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Brewery].
extension BreweryPatterns on Brewery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Brewery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Brewery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Brewery value)  $default,){
final _that = this;
switch (_that) {
case _Brewery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Brewery value)?  $default,){
final _that = this;
switch (_that) {
case _Brewery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'brewery_type')  String breweryType,  String city,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Brewery() when $default != null:
return $default(_that.name,_that.breweryType,_that.city,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'brewery_type')  String breweryType,  String city,  String country)  $default,) {final _that = this;
switch (_that) {
case _Brewery():
return $default(_that.name,_that.breweryType,_that.city,_that.country);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'brewery_type')  String breweryType,  String city,  String country)?  $default,) {final _that = this;
switch (_that) {
case _Brewery() when $default != null:
return $default(_that.name,_that.breweryType,_that.city,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Brewery implements Brewery {
   _Brewery({required this.name, @JsonKey(name: 'brewery_type') required this.breweryType, required this.city, required this.country});
  factory _Brewery.fromJson(Map<String, dynamic> json) => _$BreweryFromJson(json);

@override final  String name;
@override@JsonKey(name: 'brewery_type') final  String breweryType;
@override final  String city;
@override final  String country;

/// Create a copy of Brewery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreweryCopyWith<_Brewery> get copyWith => __$BreweryCopyWithImpl<_Brewery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreweryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Brewery&&(identical(other.name, name) || other.name == name)&&(identical(other.breweryType, breweryType) || other.breweryType == breweryType)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,breweryType,city,country);
}

@override
String toString() {
    return 'Brewery(name: $name, breweryType: $breweryType, city: $city, country: $country)';
}


}

/// @nodoc
abstract mixin class _$BreweryCopyWith<$Res> implements $BreweryCopyWith<$Res> {
  factory _$BreweryCopyWith(_Brewery value, $Res Function(_Brewery) _then) = __$BreweryCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'brewery_type') String breweryType, String city, String country
});




}
/// @nodoc
class __$BreweryCopyWithImpl<$Res>
    implements _$BreweryCopyWith<$Res> {
  __$BreweryCopyWithImpl(this._self, this._then);

  final _Brewery _self;
  final $Res Function(_Brewery) _then;

/// Create a copy of Brewery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? breweryType = null,Object? city = null,Object? country = null,}) {
  return _then(_Brewery(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,breweryType: null == breweryType ? _self.breweryType : breweryType // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
