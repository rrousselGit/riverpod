// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$AsyncValueTearOff {
  const _$AsyncValueTearOff();

  _Data<T> data<T>(T value) {
    return _Data<T>(
      value,
    );
  }

  _Loading<T> loading<T>() {
    return _Loading<T>();
  }

  _Error<T> error<T>(Object error, [StackTrace stackTrace]) {
    return _Error<T>(
      error,
      stackTrace,
    );
  }
}

// ignore: unused_element
const $AsyncValue = _$AsyncValueTearOff();

mixin _$AsyncValue<T> {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(T value),
    @required Result loading(),
    @required Result error(Object error, StackTrace stackTrace),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result data(T value),
    Result loading(),
    Result error(Object error, StackTrace stackTrace),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result data(_Data<T> value),
    @required Result loading(_Loading<T> value),
    @required Result error(_Error<T> value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(_Data<T> value),
    Result loading(_Loading<T> value),
    Result error(_Error<T> value),
    @required Result orElse(),
  });
}

abstract class $AsyncValueCopyWith<T, $Res> {
  factory $AsyncValueCopyWith(
          AsyncValue<T> value, $Res Function(AsyncValue<T>) then) =
      _$AsyncValueCopyWithImpl<T, $Res>;
}

class _$AsyncValueCopyWithImpl<T, $Res>
    implements $AsyncValueCopyWith<T, $Res> {
  _$AsyncValueCopyWithImpl(this._value, this._then);

  final AsyncValue<T> _value;
  // ignore: unused_field
  final $Res Function(AsyncValue<T>) _then;
}

abstract class _$DataCopyWith<T, $Res> {
  factory _$DataCopyWith(_Data<T> value, $Res Function(_Data<T>) then) =
      __$DataCopyWithImpl<T, $Res>;
  $Res call({T value});
}

class __$DataCopyWithImpl<T, $Res> extends _$AsyncValueCopyWithImpl<T, $Res>
    implements _$DataCopyWith<T, $Res> {
  __$DataCopyWithImpl(_Data<T> _value, $Res Function(_Data<T>) _then)
      : super(_value, (v) => _then(v as _Data<T>));

  @override
  _Data<T> get _value => super._value as _Data<T>;

  @override
  $Res call({
    Object value = freezed,
  }) {
    return _then(_Data<T>(
      value == freezed ? _value.value : value as T,
    ));
  }
}

class _$_Data<T> implements _Data<T> {
  _$_Data(this.value) : assert(value != null);

  @override
  final T value;

  @override
  String toString() {
    return 'AsyncValue<$T>.data(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Data<T> &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @override
  _$DataCopyWith<T, _Data<T>> get copyWith =>
      __$DataCopyWithImpl<T, _Data<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(T value),
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
    Result data(T value),
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
    @required Result data(_Data<T> value),
    @required Result loading(_Loading<T> value),
    @required Result error(_Error<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return data(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(_Data<T> value),
    Result loading(_Loading<T> value),
    Result error(_Error<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data<T> implements AsyncValue<T> {
  factory _Data(T value) = _$_Data<T>;

  T get value;
  _$DataCopyWith<T, _Data<T>> get copyWith;
}

abstract class _$LoadingCopyWith<T, $Res> {
  factory _$LoadingCopyWith(
          _Loading<T> value, $Res Function(_Loading<T>) then) =
      __$LoadingCopyWithImpl<T, $Res>;
}

class __$LoadingCopyWithImpl<T, $Res> extends _$AsyncValueCopyWithImpl<T, $Res>
    implements _$LoadingCopyWith<T, $Res> {
  __$LoadingCopyWithImpl(_Loading<T> _value, $Res Function(_Loading<T>) _then)
      : super(_value, (v) => _then(v as _Loading<T>));

  @override
  _Loading<T> get _value => super._value as _Loading<T>;
}

class _$_Loading<T> implements _Loading<T> {
  const _$_Loading();

  @override
  String toString() {
    return 'AsyncValue<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Loading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(T value),
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
    Result data(T value),
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
    @required Result data(_Data<T> value),
    @required Result loading(_Loading<T> value),
    @required Result error(_Error<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(_Data<T> value),
    Result loading(_Loading<T> value),
    Result error(_Error<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading<T> implements AsyncValue<T> {
  const factory _Loading() = _$_Loading<T>;
}

abstract class _$ErrorCopyWith<T, $Res> {
  factory _$ErrorCopyWith(_Error<T> value, $Res Function(_Error<T>) then) =
      __$ErrorCopyWithImpl<T, $Res>;
  $Res call({Object error, StackTrace stackTrace});
}

class __$ErrorCopyWithImpl<T, $Res> extends _$AsyncValueCopyWithImpl<T, $Res>
    implements _$ErrorCopyWith<T, $Res> {
  __$ErrorCopyWithImpl(_Error<T> _value, $Res Function(_Error<T>) _then)
      : super(_value, (v) => _then(v as _Error<T>));

  @override
  _Error<T> get _value => super._value as _Error<T>;

  @override
  $Res call({
    Object error = freezed,
    Object stackTrace = freezed,
  }) {
    return _then(_Error<T>(
      error == freezed ? _value.error : error,
      stackTrace == freezed ? _value.stackTrace : stackTrace as StackTrace,
    ));
  }
}

class _$_Error<T> implements _Error<T> {
  _$_Error(this.error, [this.stackTrace]) : assert(error != null);

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
        (other is _Error<T> &&
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
  _$ErrorCopyWith<T, _Error<T>> get copyWith =>
      __$ErrorCopyWithImpl<T, _Error<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result data(T value),
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
    Result data(T value),
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
    @required Result data(_Data<T> value),
    @required Result loading(_Loading<T> value),
    @required Result error(_Error<T> value),
  }) {
    assert(data != null);
    assert(loading != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result data(_Data<T> value),
    Result loading(_Loading<T> value),
    Result error(_Error<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error<T> implements AsyncValue<T> {
  factory _Error(Object error, [StackTrace stackTrace]) = _$_Error<T>;

  Object get error;
  StackTrace get stackTrace;
  _$ErrorCopyWith<T, _Error<T>> get copyWith;
}
