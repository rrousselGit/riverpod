// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ResultTearOff {
  const _$ResultTearOff();

  _ResultData<T> data<T>(T value) {
    return _ResultData<T>(
      value,
    );
  }

  _ResultError<T> error<T>(Object error, StackTrace stackTrace) {
    return _ResultError<T>(
      error,
      stackTrace,
    );
  }
}

/// @nodoc
const $Result = _$ResultTearOff();

/// @nodoc
mixin _$Result<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) data,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResultData<T> value) data,
    required TResult Function(_ResultError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultCopyWith<T, $Res> {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) then) =
      _$ResultCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ResultCopyWithImpl<T, $Res> implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._value, this._then);

  final Result<T> _value;
  // ignore: unused_field
  final $Res Function(Result<T>) _then;
}

/// @nodoc
abstract class _$ResultDataCopyWith<T, $Res> {
  factory _$ResultDataCopyWith(
          _ResultData<T> value, $Res Function(_ResultData<T>) then) =
      __$ResultDataCopyWithImpl<T, $Res>;
  $Res call({T value});
}

/// @nodoc
class __$ResultDataCopyWithImpl<T, $Res> extends _$ResultCopyWithImpl<T, $Res>
    implements _$ResultDataCopyWith<T, $Res> {
  __$ResultDataCopyWithImpl(
      _ResultData<T> _value, $Res Function(_ResultData<T>) _then)
      : super(_value, (v) => _then(v as _ResultData<T>));

  @override
  _ResultData<T> get _value => super._value as _ResultData<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_ResultData<T>(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_ResultData<T> extends _ResultData<T> with DiagnosticableTreeMixin {
  _$_ResultData(this.value) : super._();

  @override
  final T value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.data(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.data'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResultData<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  _$ResultDataCopyWith<T, _ResultData<T>> get copyWith =>
      __$ResultDataCopyWithImpl<T, _ResultData<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) data,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return data(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
  }) {
    return data?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResultData<T> value) data,
    required TResult Function(_ResultError<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _ResultData<T> extends Result<T> {
  factory _ResultData(T value) = _$_ResultData<T>;
  _ResultData._() : super._();

  T get value;
  @JsonKey(ignore: true)
  _$ResultDataCopyWith<T, _ResultData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ResultErrorCopyWith<T, $Res> {
  factory _$ResultErrorCopyWith(
          _ResultError<T> value, $Res Function(_ResultError<T>) then) =
      __$ResultErrorCopyWithImpl<T, $Res>;
  $Res call({Object error, StackTrace stackTrace});
}

/// @nodoc
class __$ResultErrorCopyWithImpl<T, $Res> extends _$ResultCopyWithImpl<T, $Res>
    implements _$ResultErrorCopyWith<T, $Res> {
  __$ResultErrorCopyWithImpl(
      _ResultError<T> _value, $Res Function(_ResultError<T>) _then)
      : super(_value, (v) => _then(v as _ResultError<T>));

  @override
  _ResultError<T> get _value => super._value as _ResultError<T>;

  @override
  $Res call({
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_ResultError<T>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Object,
      stackTrace == freezed
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace,
    ));
  }
}

/// @nodoc

class _$_ResultError<T> extends _ResultError<T> with DiagnosticableTreeMixin {
  _$_ResultError(this.error, this.stackTrace) : super._();

  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Result<$T>.error(error: $error, stackTrace: $stackTrace)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Result<$T>.error'))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('stackTrace', stackTrace));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResultError<T> &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.stackTrace, stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(stackTrace));

  @JsonKey(ignore: true)
  @override
  _$ResultErrorCopyWith<T, _ResultError<T>> get copyWith =>
      __$ResultErrorCopyWithImpl<T, _ResultError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) data,
    required TResult Function(Object error, StackTrace stackTrace) error,
  }) {
    return error(this.error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
  }) {
    return error?.call(this.error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? data,
    TResult Function(Object error, StackTrace stackTrace)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResultData<T> value) data,
    required TResult Function(_ResultError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResultData<T> value)? data,
    TResult Function(_ResultError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ResultError<T> extends Result<T> {
  factory _ResultError(Object error, StackTrace stackTrace) = _$_ResultError<T>;
  _ResultError._() : super._();

  Object get error;
  StackTrace get stackTrace;
  @JsonKey(ignore: true)
  _$ResultErrorCopyWith<T, _ResultError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
