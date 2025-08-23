// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

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


/// @nodoc
mixin _$MarvelResponse {

 MarvelData get data;
/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarvelResponseCopyWith<MarvelResponse> get copyWith => _$MarvelResponseCopyWithImpl<MarvelResponse>(this as MarvelResponse, _$identity);

  /// Serializes this MarvelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarvelResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'MarvelResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $MarvelResponseCopyWith<$Res>  {
  factory $MarvelResponseCopyWith(MarvelResponse value, $Res Function(MarvelResponse) _then) = _$MarvelResponseCopyWithImpl;
@useResult
$Res call({
 MarvelData data
});


$MarvelDataCopyWith<$Res> get data;

}
/// @nodoc
class _$MarvelResponseCopyWithImpl<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  _$MarvelResponseCopyWithImpl(this._self, this._then);

  final MarvelResponse _self;
  final $Res Function(MarvelResponse) _then;

/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MarvelData,
  ));
}
/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarvelDataCopyWith<$Res> get data {
  
  return $MarvelDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MarvelResponse].
extension MarvelResponsePatterns on MarvelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarvelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarvelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarvelResponse value)  $default,){
final _that = this;
switch (_that) {
case _MarvelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarvelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MarvelResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MarvelData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarvelResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MarvelData data)  $default,) {final _that = this;
switch (_that) {
case _MarvelResponse():
return $default(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MarvelData data)?  $default,) {final _that = this;
switch (_that) {
case _MarvelResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarvelResponse implements MarvelResponse {
   _MarvelResponse(this.data);
  factory _MarvelResponse.fromJson(Map<String, dynamic> json) => _$MarvelResponseFromJson(json);

@override final  MarvelData data;

/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarvelResponseCopyWith<_MarvelResponse> get copyWith => __$MarvelResponseCopyWithImpl<_MarvelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarvelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarvelResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'MarvelResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$MarvelResponseCopyWith<$Res> implements $MarvelResponseCopyWith<$Res> {
  factory _$MarvelResponseCopyWith(_MarvelResponse value, $Res Function(_MarvelResponse) _then) = __$MarvelResponseCopyWithImpl;
@override @useResult
$Res call({
 MarvelData data
});


@override $MarvelDataCopyWith<$Res> get data;

}
/// @nodoc
class __$MarvelResponseCopyWithImpl<$Res>
    implements _$MarvelResponseCopyWith<$Res> {
  __$MarvelResponseCopyWithImpl(this._self, this._then);

  final _MarvelResponse _self;
  final $Res Function(_MarvelResponse) _then;

/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_MarvelResponse(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MarvelData,
  ));
}

/// Create a copy of MarvelResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarvelDataCopyWith<$Res> get data {
  
  return $MarvelDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MarvelData {

 List<Map<String, Object?>> get results;
/// Create a copy of MarvelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarvelDataCopyWith<MarvelData> get copyWith => _$MarvelDataCopyWithImpl<MarvelData>(this as MarvelData, _$identity);

  /// Serializes this MarvelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarvelData&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'MarvelData(results: $results)';
}


}

/// @nodoc
abstract mixin class $MarvelDataCopyWith<$Res>  {
  factory $MarvelDataCopyWith(MarvelData value, $Res Function(MarvelData) _then) = _$MarvelDataCopyWithImpl;
@useResult
$Res call({
 List<Map<String, Object?>> results
});




}
/// @nodoc
class _$MarvelDataCopyWithImpl<$Res>
    implements $MarvelDataCopyWith<$Res> {
  _$MarvelDataCopyWithImpl(this._self, this._then);

  final MarvelData _self;
  final $Res Function(MarvelData) _then;

/// Create a copy of MarvelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,
  ));
}

}


/// Adds pattern-matching-related methods to [MarvelData].
extension MarvelDataPatterns on MarvelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarvelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarvelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarvelData value)  $default,){
final _that = this;
switch (_that) {
case _MarvelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarvelData value)?  $default,){
final _that = this;
switch (_that) {
case _MarvelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, Object?>> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarvelData() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, Object?>> results)  $default,) {final _that = this;
switch (_that) {
case _MarvelData():
return $default(_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, Object?>> results)?  $default,) {final _that = this;
switch (_that) {
case _MarvelData() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarvelData implements MarvelData {
   _MarvelData(final  List<Map<String, Object?>> results): _results = results;
  factory _MarvelData.fromJson(Map<String, dynamic> json) => _$MarvelDataFromJson(json);

 final  List<Map<String, Object?>> _results;
@override List<Map<String, Object?>> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of MarvelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarvelDataCopyWith<_MarvelData> get copyWith => __$MarvelDataCopyWithImpl<_MarvelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarvelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarvelData&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'MarvelData(results: $results)';
}


}

/// @nodoc
abstract mixin class _$MarvelDataCopyWith<$Res> implements $MarvelDataCopyWith<$Res> {
  factory _$MarvelDataCopyWith(_MarvelData value, $Res Function(_MarvelData) _then) = __$MarvelDataCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, Object?>> results
});




}
/// @nodoc
class __$MarvelDataCopyWithImpl<$Res>
    implements _$MarvelDataCopyWith<$Res> {
  __$MarvelDataCopyWithImpl(this._self, this._then);

  final _MarvelData _self;
  final $Res Function(_MarvelData) _then;

/// Create a copy of MarvelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_MarvelData(
null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,
  ));
}


}


/// @nodoc
mixin _$Comic {

 int get id; String get title;
/// Create a copy of Comic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComicCopyWith<Comic> get copyWith => _$ComicCopyWithImpl<Comic>(this as Comic, _$identity);

  /// Serializes this Comic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'Comic(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $ComicCopyWith<$Res>  {
  factory $ComicCopyWith(Comic value, $Res Function(Comic) _then) = _$ComicCopyWithImpl;
@useResult
$Res call({
 int id, String title
});




}
/// @nodoc
class _$ComicCopyWithImpl<$Res>
    implements $ComicCopyWith<$Res> {
  _$ComicCopyWithImpl(this._self, this._then);

  final Comic _self;
  final $Res Function(Comic) _then;

/// Create a copy of Comic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Comic].
extension ComicPatterns on Comic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comic value)  $default,){
final _that = this;
switch (_that) {
case _Comic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comic value)?  $default,){
final _that = this;
switch (_that) {
case _Comic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comic() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title)  $default,) {final _that = this;
switch (_that) {
case _Comic():
return $default(_that.id,_that.title);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _Comic() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Comic implements Comic {
   _Comic({required this.id, required this.title});
  factory _Comic.fromJson(Map<String, dynamic> json) => _$ComicFromJson(json);

@override final  int id;
@override final  String title;

/// Create a copy of Comic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComicCopyWith<_Comic> get copyWith => __$ComicCopyWithImpl<_Comic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'Comic(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ComicCopyWith<$Res> implements $ComicCopyWith<$Res> {
  factory _$ComicCopyWith(_Comic value, $Res Function(_Comic) _then) = __$ComicCopyWithImpl;
@override @useResult
$Res call({
 int id, String title
});




}
/// @nodoc
class __$ComicCopyWithImpl<$Res>
    implements _$ComicCopyWith<$Res> {
  __$ComicCopyWithImpl(this._self, this._then);

  final _Comic _self;
  final $Res Function(_Comic) _then;

/// Create a copy of Comic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_Comic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
