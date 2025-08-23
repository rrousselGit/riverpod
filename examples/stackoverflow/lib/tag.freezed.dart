// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagTheme {

 TextStyle get style; EdgeInsets get padding; Color get backgroundColor; BorderRadius get borderRadius;
/// Create a copy of TagTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagThemeCopyWith<TagTheme> get copyWith => _$TagThemeCopyWithImpl<TagTheme>(this as TagTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagTheme&&(identical(other.style, style) || other.style == style)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius));
}


@override
int get hashCode => Object.hash(runtimeType,style,padding,backgroundColor,borderRadius);

@override
String toString() {
  return 'TagTheme(style: $style, padding: $padding, backgroundColor: $backgroundColor, borderRadius: $borderRadius)';
}


}

/// @nodoc
abstract mixin class $TagThemeCopyWith<$Res>  {
  factory $TagThemeCopyWith(TagTheme value, $Res Function(TagTheme) _then) = _$TagThemeCopyWithImpl;
@useResult
$Res call({
 TextStyle style, EdgeInsets padding, Color backgroundColor, BorderRadius borderRadius
});




}
/// @nodoc
class _$TagThemeCopyWithImpl<$Res>
    implements $TagThemeCopyWith<$Res> {
  _$TagThemeCopyWithImpl(this._self, this._then);

  final TagTheme _self;
  final $Res Function(TagTheme) _then;

/// Create a copy of TagTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? style = null,Object? padding = null,Object? backgroundColor = null,Object? borderRadius = null,}) {
  return _then(_self.copyWith(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as TextStyle,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius,
  ));
}

}


/// Adds pattern-matching-related methods to [TagTheme].
extension TagThemePatterns on TagTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagTheme value)  $default,){
final _that = this;
switch (_that) {
case _TagTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagTheme value)?  $default,){
final _that = this;
switch (_that) {
case _TagTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextStyle style,  EdgeInsets padding,  Color backgroundColor,  BorderRadius borderRadius)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagTheme() when $default != null:
return $default(_that.style,_that.padding,_that.backgroundColor,_that.borderRadius);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextStyle style,  EdgeInsets padding,  Color backgroundColor,  BorderRadius borderRadius)  $default,) {final _that = this;
switch (_that) {
case _TagTheme():
return $default(_that.style,_that.padding,_that.backgroundColor,_that.borderRadius);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextStyle style,  EdgeInsets padding,  Color backgroundColor,  BorderRadius borderRadius)?  $default,) {final _that = this;
switch (_that) {
case _TagTheme() when $default != null:
return $default(_that.style,_that.padding,_that.backgroundColor,_that.borderRadius);case _:
  return null;

}
}

}

/// @nodoc


class _TagTheme implements TagTheme {
  const _TagTheme({required this.style, required this.padding, required this.backgroundColor, required this.borderRadius});
  

@override final  TextStyle style;
@override final  EdgeInsets padding;
@override final  Color backgroundColor;
@override final  BorderRadius borderRadius;

/// Create a copy of TagTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagThemeCopyWith<_TagTheme> get copyWith => __$TagThemeCopyWithImpl<_TagTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagTheme&&(identical(other.style, style) || other.style == style)&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius));
}


@override
int get hashCode => Object.hash(runtimeType,style,padding,backgroundColor,borderRadius);

@override
String toString() {
  return 'TagTheme(style: $style, padding: $padding, backgroundColor: $backgroundColor, borderRadius: $borderRadius)';
}


}

/// @nodoc
abstract mixin class _$TagThemeCopyWith<$Res> implements $TagThemeCopyWith<$Res> {
  factory _$TagThemeCopyWith(_TagTheme value, $Res Function(_TagTheme) _then) = __$TagThemeCopyWithImpl;
@override @useResult
$Res call({
 TextStyle style, EdgeInsets padding, Color backgroundColor, BorderRadius borderRadius
});




}
/// @nodoc
class __$TagThemeCopyWithImpl<$Res>
    implements _$TagThemeCopyWith<$Res> {
  __$TagThemeCopyWithImpl(this._self, this._then);

  final _TagTheme _self;
  final $Res Function(_TagTheme) _then;

/// Create a copy of TagTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? style = null,Object? padding = null,Object? backgroundColor = null,Object? borderRadius = null,}) {
  return _then(_TagTheme(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as TextStyle,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as EdgeInsets,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as BorderRadius,
  ));
}


}

// dart format on
