// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frontmatter_parse_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FrontmatterParseException {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(String message) delimiter,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(String message)? delimiter,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(String message)? delimiter,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value) $default, {
    required TResult Function(FrontmatterParseExceptionDelimiter value)
        delimiter,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FrontmatterParseException value)? $default, {
    TResult? Function(FrontmatterParseExceptionDelimiter value)? delimiter,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value)? $default, {
    TResult Function(FrontmatterParseExceptionDelimiter value)? delimiter,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FrontmatterParseExceptionCopyWith<FrontmatterParseException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FrontmatterParseExceptionCopyWith<$Res> {
  factory $FrontmatterParseExceptionCopyWith(FrontmatterParseException value,
          $Res Function(FrontmatterParseException) then) =
      _$FrontmatterParseExceptionCopyWithImpl<$Res, FrontmatterParseException>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FrontmatterParseExceptionCopyWithImpl<$Res,
        $Val extends FrontmatterParseException>
    implements $FrontmatterParseExceptionCopyWith<$Res> {
  _$FrontmatterParseExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FrontmatterParseExceptionCopyWith<$Res>
    implements $FrontmatterParseExceptionCopyWith<$Res> {
  factory _$$_FrontmatterParseExceptionCopyWith(
          _$_FrontmatterParseException value,
          $Res Function(_$_FrontmatterParseException) then) =
      __$$_FrontmatterParseExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$_FrontmatterParseExceptionCopyWithImpl<$Res>
    extends _$FrontmatterParseExceptionCopyWithImpl<$Res,
        _$_FrontmatterParseException>
    implements _$$_FrontmatterParseExceptionCopyWith<$Res> {
  __$$_FrontmatterParseExceptionCopyWithImpl(
      _$_FrontmatterParseException _value,
      $Res Function(_$_FrontmatterParseException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$_FrontmatterParseException(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_FrontmatterParseException extends _FrontmatterParseException {
  const _$_FrontmatterParseException(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'FrontmatterParseException(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FrontmatterParseException &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FrontmatterParseExceptionCopyWith<_$_FrontmatterParseException>
      get copyWith => __$$_FrontmatterParseExceptionCopyWithImpl<
          _$_FrontmatterParseException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(String message) delimiter,
  }) {
    return $default(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(String message)? delimiter,
  }) {
    return $default?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(String message)? delimiter,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value) $default, {
    required TResult Function(FrontmatterParseExceptionDelimiter value)
        delimiter,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FrontmatterParseException value)? $default, {
    TResult? Function(FrontmatterParseExceptionDelimiter value)? delimiter,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value)? $default, {
    TResult Function(FrontmatterParseExceptionDelimiter value)? delimiter,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _FrontmatterParseException extends FrontmatterParseException {
  const factory _FrontmatterParseException(final String message) =
      _$_FrontmatterParseException;
  const _FrontmatterParseException._() : super._();

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$_FrontmatterParseExceptionCopyWith<_$_FrontmatterParseException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FrontmatterParseExceptionDelimiterCopyWith<$Res>
    implements $FrontmatterParseExceptionCopyWith<$Res> {
  factory _$$FrontmatterParseExceptionDelimiterCopyWith(
          _$FrontmatterParseExceptionDelimiter value,
          $Res Function(_$FrontmatterParseExceptionDelimiter) then) =
      __$$FrontmatterParseExceptionDelimiterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FrontmatterParseExceptionDelimiterCopyWithImpl<$Res>
    extends _$FrontmatterParseExceptionCopyWithImpl<$Res,
        _$FrontmatterParseExceptionDelimiter>
    implements _$$FrontmatterParseExceptionDelimiterCopyWith<$Res> {
  __$$FrontmatterParseExceptionDelimiterCopyWithImpl(
      _$FrontmatterParseExceptionDelimiter _value,
      $Res Function(_$FrontmatterParseExceptionDelimiter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FrontmatterParseExceptionDelimiter(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FrontmatterParseExceptionDelimiter
    extends FrontmatterParseExceptionDelimiter {
  const _$FrontmatterParseExceptionDelimiter(
      [this.message = 'Frontmatter document must start with your delimiter.'])
      : super._();

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'FrontmatterParseException.delimiter(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FrontmatterParseExceptionDelimiter &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FrontmatterParseExceptionDelimiterCopyWith<
          _$FrontmatterParseExceptionDelimiter>
      get copyWith => __$$FrontmatterParseExceptionDelimiterCopyWithImpl<
          _$FrontmatterParseExceptionDelimiter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(String message) delimiter,
  }) {
    return delimiter(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(String message)? delimiter,
  }) {
    return delimiter?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(String message)? delimiter,
    required TResult orElse(),
  }) {
    if (delimiter != null) {
      return delimiter(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value) $default, {
    required TResult Function(FrontmatterParseExceptionDelimiter value)
        delimiter,
  }) {
    return delimiter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FrontmatterParseException value)? $default, {
    TResult? Function(FrontmatterParseExceptionDelimiter value)? delimiter,
  }) {
    return delimiter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FrontmatterParseException value)? $default, {
    TResult Function(FrontmatterParseExceptionDelimiter value)? delimiter,
    required TResult orElse(),
  }) {
    if (delimiter != null) {
      return delimiter(this);
    }
    return orElse();
  }
}

abstract class FrontmatterParseExceptionDelimiter
    extends FrontmatterParseException {
  const factory FrontmatterParseExceptionDelimiter([final String message]) =
      _$FrontmatterParseExceptionDelimiter;
  const FrontmatterParseExceptionDelimiter._() : super._();

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$FrontmatterParseExceptionDelimiterCopyWith<
          _$FrontmatterParseExceptionDelimiter>
      get copyWith => throw _privateConstructorUsedError;
}
