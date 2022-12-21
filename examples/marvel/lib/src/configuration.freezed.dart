// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Configuration _$ConfigurationFromJson(Map<String, dynamic> json) {
  return _Configuration.fromJson(json);
}

/// @nodoc
mixin _$Configuration {
  String get publicKey => throw _privateConstructorUsedError;
  String get privateKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigurationCopyWith<Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigurationCopyWith<$Res> {
  factory $ConfigurationCopyWith(
          Configuration value, $Res Function(Configuration) then) =
      _$ConfigurationCopyWithImpl<$Res, Configuration>;
  @useResult
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class _$ConfigurationCopyWithImpl<$Res, $Val extends Configuration>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? privateKey = null,
  }) {
    return _then(_value.copyWith(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _value.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConfigurationCopyWith<$Res>
    implements $ConfigurationCopyWith<$Res> {
  factory _$$_ConfigurationCopyWith(
          _$_Configuration value, $Res Function(_$_Configuration) then) =
      __$$_ConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class __$$_ConfigurationCopyWithImpl<$Res>
    extends _$ConfigurationCopyWithImpl<$Res, _$_Configuration>
    implements _$$_ConfigurationCopyWith<$Res> {
  __$$_ConfigurationCopyWithImpl(
      _$_Configuration _value, $Res Function(_$_Configuration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? privateKey = null,
  }) {
    return _then(_$_Configuration(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _value.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_Configuration implements _Configuration {
  _$_Configuration({required this.publicKey, required this.privateKey});

  factory _$_Configuration.fromJson(Map<String, dynamic> json) =>
      _$$_ConfigurationFromJson(json);

  @override
  final String publicKey;
  @override
  final String privateKey;

  @override
  String toString() {
    return 'Configuration(publicKey: $publicKey, privateKey: $privateKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Configuration &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, publicKey, privateKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConfigurationCopyWith<_$_Configuration> get copyWith =>
      __$$_ConfigurationCopyWithImpl<_$_Configuration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfigurationToJson(
      this,
    );
  }
}

abstract class _Configuration implements Configuration {
  factory _Configuration(
      {required final String publicKey,
      required final String privateKey}) = _$_Configuration;

  factory _Configuration.fromJson(Map<String, dynamic> json) =
      _$_Configuration.fromJson;

  @override
  String get publicKey;
  @override
  String get privateKey;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigurationCopyWith<_$_Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}
