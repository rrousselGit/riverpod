// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AsyncValueTearOff {
  const _$AsyncValueTearOff();

// ignore: unused_element
  AsyncData<T> data<T>(@nullable T value) {
    return AsyncData<T>(
      value,
    );
  }

// ignore: unused_element
  AsyncLoading<T> loading<T>() {
    return AsyncLoading<T>();
  }

// ignore: unused_element
  AsyncError<T> error<T>(Object error, [StackTrace stackTrace]) {
    return AsyncError<T>(
      error,
      stackTrace,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $AsyncValue = _$AsyncValueTearOff();

/// @nodoc
mixin _$AsyncValue<T> {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(@nullable T value),
    @required Result loading(),
    @required Result error(Object error, StackTrace stackTrace),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result data(@nullable T value),
    Result loading(),
    Result error(Object error, StackTrace stackTrace),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result data(AsyncData<T> value),
    @required Result loading(AsyncLoading<T> value),
    @required Result error(AsyncError<T> value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(AsyncData<T> value),
    Result loading(AsyncLoading<T> value),
    Result error(AsyncError<T> value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueCopyWith(
          AsyncValue<T> value, $Res Function(AsyncValue<T>) then) =
      _$AsyncValueCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$AsyncValueCopyWithImpl<T, $Res>
    implements $AsyncValueCopyWith<T, $Res> {
  _$AsyncValueCopyWithImpl(this._value, this._then);

  final AsyncValue<T> _value;
  // ignore: unused_field
  final $Res Function(AsyncValue<T>) _then;
}

/// @nodoc
abstract class $AsyncDataCopyWith<T, $Res> {
  factory $AsyncDataCopyWith(
          AsyncData<T> value, $Res Function(AsyncData<T>) then) =
      _$AsyncDataCopyWithImpl<T, $Res>;
  $Res call({@nullable T value});
}

/// @nodoc
class _$AsyncDataCopyWithImpl<T, $Res> extends _$AsyncValueCopyWithImpl<T, $Res>
    implements $AsyncDataCopyWith<T, $Res> {
  _$AsyncDataCopyWithImpl(
      AsyncData<T> _value, $Res Function(AsyncData<T>) _then)
      : super(_value, (v) => _then(v as AsyncData<T>));

  @override
  AsyncData<T> get _value => super._value as AsyncData<T>;

  @override
  $Res call({
    Object value = freezed,
  }) {
    return _then(AsyncData<T>(
      value == freezed ? _value.value : value as T,
    ));
  }
}

/// @nodoc
class _$AsyncData<T> extends AsyncData<T> {
  const _$AsyncData(@nullable this.value) : super._();

  @override
  @nullable
  final T value;

  @override
  String toString() {
    return 'AsyncValue<$T>.data(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AsyncData<T> &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @override
  $AsyncDataCopyWith<T, AsyncData<T>> get copyWith =>
      _$AsyncDataCopyWithImpl<T, AsyncData<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(@nullable T value),
    @required Result loading(),
    @required Result error(Object error, StackTrace stackTrace),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return data(value);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result data(@nullable T value),
    Result loading(),
    Result error(Object error, StackTrace stackTrace),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result data(AsyncData<T> value),
    @required Result loading(AsyncLoading<T> value),
    @required Result error(AsyncError<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return data(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(AsyncData<T> value),
    Result loading(AsyncLoading<T> value),
    Result error(AsyncError<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AsyncData<T> extends AsyncValue<T> {
  const AsyncData._() : super._();
  const factory AsyncData(@nullable T value) = _$AsyncData<T>;

  @nullable
  T get value;
  $AsyncDataCopyWith<T, AsyncData<T>> get copyWith;
}

/// @nodoc
abstract class $AsyncLoadingCopyWith<T, $Res> {
  factory $AsyncLoadingCopyWith(
          AsyncLoading<T> value, $Res Function(AsyncLoading<T>) then) =
      _$AsyncLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$AsyncLoadingCopyWithImpl<T, $Res>
    extends _$AsyncValueCopyWithImpl<T, $Res>
    implements $AsyncLoadingCopyWith<T, $Res> {
  _$AsyncLoadingCopyWithImpl(
      AsyncLoading<T> _value, $Res Function(AsyncLoading<T>) _then)
      : super(_value, (v) => _then(v as AsyncLoading<T>));

  @override
  AsyncLoading<T> get _value => super._value as AsyncLoading<T>;
}

/// @nodoc
class _$AsyncLoading<T> extends AsyncLoading<T> {
  const _$AsyncLoading() : super._();

  @override
  String toString() {
    return 'AsyncValue<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is AsyncLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(@nullable T value),
    @required Result loading(),
    @required Result error(Object error, StackTrace stackTrace),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result data(@nullable T value),
    Result loading(),
    Result error(Object error, StackTrace stackTrace),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result data(AsyncData<T> value),
    @required Result loading(AsyncLoading<T> value),
    @required Result error(AsyncError<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(AsyncData<T> value),
    Result loading(AsyncLoading<T> value),
    Result error(AsyncError<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading._() : super._();
  const factory AsyncLoading() = _$AsyncLoading<T>;
}

/// @nodoc
abstract class $AsyncErrorCopyWith<T, $Res> {
  factory $AsyncErrorCopyWith(
          AsyncError<T> value, $Res Function(AsyncError<T>) then) =
      _$AsyncErrorCopyWithImpl<T, $Res>;
  $Res call({Object error, StackTrace stackTrace});
}

/// @nodoc
class _$AsyncErrorCopyWithImpl<T, $Res>
    extends _$AsyncValueCopyWithImpl<T, $Res>
    implements $AsyncErrorCopyWith<T, $Res> {
  _$AsyncErrorCopyWithImpl(
      AsyncError<T> _value, $Res Function(AsyncError<T>) _then)
      : super(_value, (v) => _then(v as AsyncError<T>));

  @override
  AsyncError<T> get _value => super._value as AsyncError<T>;

  @override
  $Res call({
    Object error = freezed,
    Object stackTrace = freezed,
  }) {
    return _then(AsyncError<T>(
      error == freezed ? _value.error : error,
      stackTrace == freezed ? _value.stackTrace : stackTrace as StackTrace,
    ));
  }
}

/// @nodoc
class _$AsyncError<T> extends AsyncError<T> {
  _$AsyncError(this.error, [this.stackTrace])
      : assert(error != null),
        super._();

  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  String toString() {
    return 'AsyncValue<$T>.error(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AsyncError<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.stackTrace, stackTrace) ||
                const DeepCollectionEquality()
                    .equals(other.stackTrace, stackTrace)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(stackTrace);

  @override
  $AsyncErrorCopyWith<T, AsyncError<T>> get copyWith =>
      _$AsyncErrorCopyWithImpl<T, AsyncError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(@nullable T value),
    @required Result loading(),
    @required Result error(Object error, StackTrace stackTrace),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return error(this.error, stackTrace);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result data(@nullable T value),
    Result loading(),
    Result error(Object error, StackTrace stackTrace),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this.error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result data(AsyncData<T> value),
    @required Result loading(AsyncLoading<T> value),
    @required Result error(AsyncError<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(AsyncData<T> value),
    Result loading(AsyncLoading<T> value),
    Result error(AsyncError<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AsyncError<T> extends AsyncValue<T> {
  AsyncError._() : super._();
  factory AsyncError(Object error, [StackTrace stackTrace]) = _$AsyncError<T>;

  Object get error;
  StackTrace get stackTrace;
  $AsyncErrorCopyWith<T, AsyncError<T>> get copyWith;
}
