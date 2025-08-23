// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CharacterPagination {

 int get page; String? get name;
/// Create a copy of CharacterPagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterPaginationCopyWith<CharacterPagination> get copyWith => _$CharacterPaginationCopyWithImpl<CharacterPagination>(this as CharacterPagination, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterPagination&&(identical(other.page, page) || other.page == page)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,page,name);

@override
String toString() {
  return 'CharacterPagination(page: $page, name: $name)';
}


}

/// @nodoc
abstract mixin class $CharacterPaginationCopyWith<$Res>  {
  factory $CharacterPaginationCopyWith(CharacterPagination value, $Res Function(CharacterPagination) _then) = _$CharacterPaginationCopyWithImpl;
@useResult
$Res call({
 int page, String? name
});




}
/// @nodoc
class _$CharacterPaginationCopyWithImpl<$Res>
    implements $CharacterPaginationCopyWith<$Res> {
  _$CharacterPaginationCopyWithImpl(this._self, this._then);

  final CharacterPagination _self;
  final $Res Function(CharacterPagination) _then;

/// Create a copy of CharacterPagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterPagination].
extension CharacterPaginationPatterns on CharacterPagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterPagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterPagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterPagination value)  $default,){
final _that = this;
switch (_that) {
case _CharacterPagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterPagination value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterPagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterPagination() when $default != null:
return $default(_that.page,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  String? name)  $default,) {final _that = this;
switch (_that) {
case _CharacterPagination():
return $default(_that.page,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _CharacterPagination() when $default != null:
return $default(_that.page,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterPagination implements CharacterPagination {
   _CharacterPagination({required this.page, this.name});
  

@override final  int page;
@override final  String? name;

/// Create a copy of CharacterPagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterPaginationCopyWith<_CharacterPagination> get copyWith => __$CharacterPaginationCopyWithImpl<_CharacterPagination>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterPagination&&(identical(other.page, page) || other.page == page)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,page,name);

@override
String toString() {
  return 'CharacterPagination(page: $page, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CharacterPaginationCopyWith<$Res> implements $CharacterPaginationCopyWith<$Res> {
  factory _$CharacterPaginationCopyWith(_CharacterPagination value, $Res Function(_CharacterPagination) _then) = __$CharacterPaginationCopyWithImpl;
@override @useResult
$Res call({
 int page, String? name
});




}
/// @nodoc
class __$CharacterPaginationCopyWithImpl<$Res>
    implements _$CharacterPaginationCopyWith<$Res> {
  __$CharacterPaginationCopyWithImpl(this._self, this._then);

  final _CharacterPagination _self;
  final $Res Function(_CharacterPagination) _then;

/// Create a copy of CharacterPagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? name = freezed,}) {
  return _then(_CharacterPagination(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CharacterOffset {

 int get offset; String get name;
/// Create a copy of CharacterOffset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterOffsetCopyWith<CharacterOffset> get copyWith => _$CharacterOffsetCopyWithImpl<CharacterOffset>(this as CharacterOffset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterOffset&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,offset,name);

@override
String toString() {
  return 'CharacterOffset(offset: $offset, name: $name)';
}


}

/// @nodoc
abstract mixin class $CharacterOffsetCopyWith<$Res>  {
  factory $CharacterOffsetCopyWith(CharacterOffset value, $Res Function(CharacterOffset) _then) = _$CharacterOffsetCopyWithImpl;
@useResult
$Res call({
 int offset, String name
});




}
/// @nodoc
class _$CharacterOffsetCopyWithImpl<$Res>
    implements $CharacterOffsetCopyWith<$Res> {
  _$CharacterOffsetCopyWithImpl(this._self, this._then);

  final CharacterOffset _self;
  final $Res Function(CharacterOffset) _then;

/// Create a copy of CharacterOffset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offset = null,Object? name = null,}) {
  return _then(_self.copyWith(
offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterOffset].
extension CharacterOffsetPatterns on CharacterOffset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterOffset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterOffset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterOffset value)  $default,){
final _that = this;
switch (_that) {
case _CharacterOffset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterOffset value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterOffset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int offset,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterOffset() when $default != null:
return $default(_that.offset,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int offset,  String name)  $default,) {final _that = this;
switch (_that) {
case _CharacterOffset():
return $default(_that.offset,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int offset,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CharacterOffset() when $default != null:
return $default(_that.offset,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterOffset implements CharacterOffset {
   _CharacterOffset({required this.offset, this.name = ''});
  

@override final  int offset;
@override@JsonKey() final  String name;

/// Create a copy of CharacterOffset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterOffsetCopyWith<_CharacterOffset> get copyWith => __$CharacterOffsetCopyWithImpl<_CharacterOffset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterOffset&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,offset,name);

@override
String toString() {
  return 'CharacterOffset(offset: $offset, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CharacterOffsetCopyWith<$Res> implements $CharacterOffsetCopyWith<$Res> {
  factory _$CharacterOffsetCopyWith(_CharacterOffset value, $Res Function(_CharacterOffset) _then) = __$CharacterOffsetCopyWithImpl;
@override @useResult
$Res call({
 int offset, String name
});




}
/// @nodoc
class __$CharacterOffsetCopyWithImpl<$Res>
    implements _$CharacterOffsetCopyWith<$Res> {
  __$CharacterOffsetCopyWithImpl(this._self, this._then);

  final _CharacterOffset _self;
  final $Res Function(_CharacterOffset) _then;

/// Create a copy of CharacterOffset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offset = null,Object? name = null,}) {
  return _then(_CharacterOffset(
offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
