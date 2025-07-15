// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [Result].
extension ResultPatterns<ValueT> on Result<ValueT> {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$ResultData<ValueT> value)? data,
    TResult Function(_$ResultError<ValueT> value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData() when data != null:
        return data(_that);
      case _$ResultError() when error != null:
        return error(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$ResultData<ValueT> value) data,
    required TResult Function(_$ResultError<ValueT> value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData():
        return data(_that);
      case _$ResultError():
        return error(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_$ResultData<ValueT> value)? data,
    TResult? Function(_$ResultError<ValueT> value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData() when data != null:
        return data(_that);
      case _$ResultError() when error != null:
        return error(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ValueT value)? data,
    TResult Function(Object error, StackTrace? stackTrace)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData() when data != null:
        return data(_that.value);
      case _$ResultError() when error != null:
        return error(_that.error, _that.stackTrace);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ValueT value) data,
    required TResult Function(Object error, StackTrace? stackTrace) error,
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData():
        return data(_that.value);
      case _$ResultError():
        return error(_that.error, _that.stackTrace);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ValueT value)? data,
    TResult? Function(Object error, StackTrace? stackTrace)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _$ResultData() when data != null:
        return data(_that.value);
      case _$ResultError() when error != null:
        return error(_that.error, _that.stackTrace);
      case _:
        return null;
    }
  }
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
