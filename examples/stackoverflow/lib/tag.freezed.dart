// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TagTheme {
  TextStyle get style => throw _privateConstructorUsedError;
  EdgeInsets get padding => throw _privateConstructorUsedError;
  Color get backgroundColor => throw _privateConstructorUsedError;
  BorderRadius get borderRadius => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TagThemeCopyWith<TagTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagThemeCopyWith<$Res> {
  factory $TagThemeCopyWith(TagTheme value, $Res Function(TagTheme) then) =
      _$TagThemeCopyWithImpl<$Res, TagTheme>;
  @useResult
  $Res call(
      {TextStyle style,
      EdgeInsets padding,
      Color backgroundColor,
      BorderRadius borderRadius});
}

/// @nodoc
class _$TagThemeCopyWithImpl<$Res, $Val extends TagTheme>
    implements $TagThemeCopyWith<$Res> {
  _$TagThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
    Object? padding = null,
    Object? backgroundColor = null,
    Object? borderRadius = null,
  }) {
    return _then(_value.copyWith(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      padding: null == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      borderRadius: null == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TagThemeCopyWith<$Res> implements $TagThemeCopyWith<$Res> {
  factory _$$_TagThemeCopyWith(
          _$_TagTheme value, $Res Function(_$_TagTheme) then) =
      __$$_TagThemeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TextStyle style,
      EdgeInsets padding,
      Color backgroundColor,
      BorderRadius borderRadius});
}

/// @nodoc
class __$$_TagThemeCopyWithImpl<$Res>
    extends _$TagThemeCopyWithImpl<$Res, _$_TagTheme>
    implements _$$_TagThemeCopyWith<$Res> {
  __$$_TagThemeCopyWithImpl(
      _$_TagTheme _value, $Res Function(_$_TagTheme) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
    Object? padding = null,
    Object? backgroundColor = null,
    Object? borderRadius = null,
  }) {
    return _then(_$_TagTheme(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      padding: null == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      borderRadius: null == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
    ));
  }
}

/// @nodoc

class _$_TagTheme implements _TagTheme {
  const _$_TagTheme(
      {required this.style,
      required this.padding,
      required this.backgroundColor,
      required this.borderRadius});

  @override
  final TextStyle style;
  @override
  final EdgeInsets padding;
  @override
  final Color backgroundColor;
  @override
  final BorderRadius borderRadius;

  @override
  String toString() {
    return 'TagTheme(style: $style, padding: $padding, backgroundColor: $backgroundColor, borderRadius: $borderRadius)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagTheme &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.borderRadius, borderRadius) ||
                other.borderRadius == borderRadius));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, style, padding, backgroundColor, borderRadius);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagThemeCopyWith<_$_TagTheme> get copyWith =>
      __$$_TagThemeCopyWithImpl<_$_TagTheme>(this, _$identity);
}

abstract class _TagTheme implements TagTheme {
  const factory _TagTheme(
      {required final TextStyle style,
      required final EdgeInsets padding,
      required final Color backgroundColor,
      required final BorderRadius borderRadius}) = _$_TagTheme;

  @override
  TextStyle get style;
  @override
  EdgeInsets get padding;
  @override
  Color get backgroundColor;
  @override
  BorderRadius get borderRadius;
  @override
  @JsonKey(ignore: true)
  _$$_TagThemeCopyWith<_$_TagTheme> get copyWith =>
      throw _privateConstructorUsedError;
}
