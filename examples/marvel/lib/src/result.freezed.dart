// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Result<T> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Result<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Result<$T>()';
  }
}

/// @nodoc
class $ResultCopyWith<T, $Res> {
  $ResultCopyWith(Result<T> _, $Res Function(Result<T>) __);
}

/// @nodoc

class _$ResultData<T> extends Result<T> {
  _$ResultData(this.value) : super._();

  final T value;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ResultDataCopyWith<T, _$ResultData<T>> get copyWith =>
      __$$ResultDataCopyWithImpl<T, _$ResultData<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultData<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'Result<$T>.data(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$$ResultDataCopyWith<T, $Res>
    implements $ResultCopyWith<T, $Res> {
  factory _$$ResultDataCopyWith(
          _$ResultData<T> value, $Res Function(_$ResultData<T>) _then) =
      __$$ResultDataCopyWithImpl;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$ResultDataCopyWithImpl<T, $Res>
    implements _$$ResultDataCopyWith<T, $Res> {
  __$$ResultDataCopyWithImpl(this._self, this._then);

  final _$ResultData<T> _self;
  final $Res Function(_$ResultData<T>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$ResultData<T>(
      freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ResultError<T> extends Result<T> {
  _$ResultError(this.error, [this.stackTrace]) : super._();

  final Object error;
  final StackTrace? stackTrace;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ResultErrorCopyWith<T, _$ResultError<T>> get copyWith =>
      __$$ResultErrorCopyWithImpl<T, _$ResultError<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultError<T> &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), stackTrace);

  @override
  String toString() {
    return 'Result<$T>.error(error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$$ResultErrorCopyWith<T, $Res>
    implements $ResultCopyWith<T, $Res> {
  factory _$$ResultErrorCopyWith(
          _$ResultError<T> value, $Res Function(_$ResultError<T>) _then) =
      __$$ResultErrorCopyWithImpl;
  @useResult
  $Res call({Object error, StackTrace? stackTrace});
}

/// @nodoc
class __$$ResultErrorCopyWithImpl<T, $Res>
    implements _$$ResultErrorCopyWith<T, $Res> {
  __$$ResultErrorCopyWithImpl(this._self, this._then);

  final _$ResultError<T> _self;
  final $Res Function(_$ResultError<T>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
    Object? stackTrace = freezed,
  }) {
    return _then(_$ResultError<T>(
      null == error ? _self.error : error,
      freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
