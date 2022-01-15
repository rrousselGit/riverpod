// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DataTearOff {
  const _$DataTearOff();

  _Data call(
      {required String providerName,
      required String refName,
      required ProviderType providerType,
      required String valueDisplayType}) {
    return _Data(
      providerName: providerName,
      refName: refName,
      providerType: providerType,
      valueDisplayType: valueDisplayType,
    );
  }
}

/// @nodoc
const $Data = _$DataTearOff();

/// @nodoc
mixin _$Data {
  String get providerName => throw _privateConstructorUsedError;
  String get refName => throw _privateConstructorUsedError;
  ProviderType get providerType => throw _privateConstructorUsedError;
  String get valueDisplayType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataCopyWith<Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataCopyWith<$Res> {
  factory $DataCopyWith(Data value, $Res Function(Data) then) =
      _$DataCopyWithImpl<$Res>;
  $Res call(
      {String providerName,
      String refName,
      ProviderType providerType,
      String valueDisplayType});
}

/// @nodoc
class _$DataCopyWithImpl<$Res> implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._value, this._then);

  final Data _value;
  // ignore: unused_field
  final $Res Function(Data) _then;

  @override
  $Res call({
    Object? providerName = freezed,
    Object? refName = freezed,
    Object? providerType = freezed,
    Object? valueDisplayType = freezed,
  }) {
    return _then(_value.copyWith(
      providerName: providerName == freezed
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      refName: refName == freezed
          ? _value.refName
          : refName // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: providerType == freezed
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ProviderType,
      valueDisplayType: valueDisplayType == freezed
          ? _value.valueDisplayType
          : valueDisplayType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$DataCopyWith<$Res> implements $DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) then) =
      __$DataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String providerName,
      String refName,
      ProviderType providerType,
      String valueDisplayType});
}

/// @nodoc
class __$DataCopyWithImpl<$Res> extends _$DataCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(_Data _value, $Res Function(_Data) _then)
      : super(_value, (v) => _then(v as _Data));

  @override
  _Data get _value => super._value as _Data;

  @override
  $Res call({
    Object? providerName = freezed,
    Object? refName = freezed,
    Object? providerType = freezed,
    Object? valueDisplayType = freezed,
  }) {
    return _then(_Data(
      providerName: providerName == freezed
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      refName: refName == freezed
          ? _value.refName
          : refName // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: providerType == freezed
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ProviderType,
      valueDisplayType: valueDisplayType == freezed
          ? _value.valueDisplayType
          : valueDisplayType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Data implements _Data {
  _$_Data(
      {required this.providerName,
      required this.refName,
      required this.providerType,
      required this.valueDisplayType});

  @override
  final String providerName;
  @override
  final String refName;
  @override
  final ProviderType providerType;
  @override
  final String valueDisplayType;

  @override
  String toString() {
    return 'Data(providerName: $providerName, refName: $refName, providerType: $providerType, valueDisplayType: $valueDisplayType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Data &&
            const DeepCollectionEquality()
                .equals(other.providerName, providerName) &&
            const DeepCollectionEquality().equals(other.refName, refName) &&
            const DeepCollectionEquality()
                .equals(other.providerType, providerType) &&
            const DeepCollectionEquality()
                .equals(other.valueDisplayType, valueDisplayType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(providerName),
      const DeepCollectionEquality().hash(refName),
      const DeepCollectionEquality().hash(providerType),
      const DeepCollectionEquality().hash(valueDisplayType));

  @JsonKey(ignore: true)
  @override
  _$DataCopyWith<_Data> get copyWith =>
      __$DataCopyWithImpl<_Data>(this, _$identity);
}

abstract class _Data implements Data {
  factory _Data(
      {required String providerName,
      required String refName,
      required ProviderType providerType,
      required String valueDisplayType}) = _$_Data;

  @override
  String get providerName;
  @override
  String get refName;
  @override
  ProviderType get providerType;
  @override
  String get valueDisplayType;
  @override
  @JsonKey(ignore: true)
  _$DataCopyWith<_Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
class _$GlobalDataTearOff {
  const _$GlobalDataTearOff();

  _GlobalData call() {
    return _GlobalData();
  }
}

/// @nodoc
const $GlobalData = _$GlobalDataTearOff();

/// @nodoc
mixin _$GlobalData {}

/// @nodoc
abstract class $GlobalDataCopyWith<$Res> {
  factory $GlobalDataCopyWith(
          GlobalData value, $Res Function(GlobalData) then) =
      _$GlobalDataCopyWithImpl<$Res>;
}

/// @nodoc
class _$GlobalDataCopyWithImpl<$Res> implements $GlobalDataCopyWith<$Res> {
  _$GlobalDataCopyWithImpl(this._value, this._then);

  final GlobalData _value;
  // ignore: unused_field
  final $Res Function(GlobalData) _then;
}

/// @nodoc
abstract class _$GlobalDataCopyWith<$Res> {
  factory _$GlobalDataCopyWith(
          _GlobalData value, $Res Function(_GlobalData) then) =
      __$GlobalDataCopyWithImpl<$Res>;
}

/// @nodoc
class __$GlobalDataCopyWithImpl<$Res> extends _$GlobalDataCopyWithImpl<$Res>
    implements _$GlobalDataCopyWith<$Res> {
  __$GlobalDataCopyWithImpl(
      _GlobalData _value, $Res Function(_GlobalData) _then)
      : super(_value, (v) => _then(v as _GlobalData));

  @override
  _GlobalData get _value => super._value as _GlobalData;
}

/// @nodoc

class _$_GlobalData implements _GlobalData {
  _$_GlobalData();

  @override
  String toString() {
    return 'GlobalData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GlobalData);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _GlobalData implements GlobalData {
  factory _GlobalData() = _$_GlobalData;
}
