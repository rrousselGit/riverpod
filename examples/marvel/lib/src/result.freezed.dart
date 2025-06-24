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
mixin _$Result<ValueT> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Result<ValueT>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Result<$ValueT>()';
  }
}

/// @nodoc
class $ResultCopyWith<ValueT, $Res> {
  $ResultCopyWith(Result<ValueT> _, $Res Function(Result<ValueT>) __);
}

/// @nodoc

class _$ResultData<ValueT> extends Result<ValueT> {
  _$ResultData(this.value) : super._();

  final ValueT value;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ResultDataCopyWith<ValueT, _$ResultData<ValueT>> get copyWith =>
      __$$ResultDataCopyWithImpl<ValueT, _$ResultData<ValueT>>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultData<ValueT> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'Result<$ValueT>.data(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$$ResultDataCopyWith<ValueT, $Res>
    implements $ResultCopyWith<ValueT, $Res> {
  factory _$$ResultDataCopyWith(_$ResultData<ValueT> value,
      $Res Function(_$ResultData<ValueT>) _then) = __$$ResultDataCopyWithImpl;
  @useResult
  $Res call({ValueT value});
}

/// @nodoc
class __$$ResultDataCopyWithImpl<ValueT, $Res>
    implements _$$ResultDataCopyWith<ValueT, $Res> {
  __$$ResultDataCopyWithImpl(this._self, this._then);

  final _$ResultData<ValueT> _self;
  final $Res Function(_$ResultData<ValueT>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$ResultData<ValueT>(
      freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as ValueT,
    ));
  }
}

/// @nodoc

class _$ResultError<ValueT> extends Result<ValueT> {
  _$ResultError(this.error, [this.stackTrace]) : super._();

  final Object error;
  final StackTrace? stackTrace;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$$ResultErrorCopyWith<ValueT, _$ResultError<ValueT>> get copyWith =>
      __$$ResultErrorCopyWithImpl<ValueT, _$ResultError<ValueT>>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultError<ValueT> &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), stackTrace);

  @override
  String toString() {
    return 'Result<$ValueT>.error(error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$$ResultErrorCopyWith<ValueT, $Res>
    implements $ResultCopyWith<ValueT, $Res> {
  factory _$$ResultErrorCopyWith(_$ResultError<ValueT> value,
      $Res Function(_$ResultError<ValueT>) _then) = __$$ResultErrorCopyWithImpl;
  @useResult
  $Res call({Object error, StackTrace? stackTrace});
}

/// @nodoc
class __$$ResultErrorCopyWithImpl<ValueT, $Res>
    implements _$$ResultErrorCopyWith<ValueT, $Res> {
  __$$ResultErrorCopyWithImpl(this._self, this._then);

  final _$ResultError<ValueT> _self;
  final $Res Function(_$ResultError<ValueT>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
    Object? stackTrace = freezed,
  }) {
    return _then(_$ResultError<ValueT>(
      null == error ? _self.error : error,
      freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
