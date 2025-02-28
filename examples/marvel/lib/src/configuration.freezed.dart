// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Configuration {
  String get publicKey;
  String get privateKey;

  /// Create a copy of Configuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigurationCopyWith<Configuration> get copyWith =>
      _$ConfigurationCopyWithImpl<Configuration>(
          this as Configuration, _$identity);

  /// Serializes this Configuration to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Configuration &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicKey, privateKey);

  @override
  String toString() {
    return 'Configuration(publicKey: $publicKey, privateKey: $privateKey)';
  }
}

/// @nodoc
abstract mixin class $ConfigurationCopyWith<$Res> {
  factory $ConfigurationCopyWith(
          Configuration value, $Res Function(Configuration) _then) =
      _$ConfigurationCopyWithImpl;
  @useResult
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class _$ConfigurationCopyWithImpl<$Res>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._self, this._then);

  final Configuration _self;
  final $Res Function(Configuration) _then;

  /// Create a copy of Configuration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? privateKey = null,
  }) {
    return _then(_self.copyWith(
      publicKey: null == publicKey
          ? _self.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _self.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Configuration implements Configuration {
  _Configuration({required this.publicKey, required this.privateKey});
  factory _Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);

  @override
  final String publicKey;
  @override
  final String privateKey;

  /// Create a copy of Configuration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfigurationCopyWith<_Configuration> get copyWith =>
      __$ConfigurationCopyWithImpl<_Configuration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfigurationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Configuration &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicKey, privateKey);

  @override
  String toString() {
    return 'Configuration(publicKey: $publicKey, privateKey: $privateKey)';
  }
}

/// @nodoc
abstract mixin class _$ConfigurationCopyWith<$Res>
    implements $ConfigurationCopyWith<$Res> {
  factory _$ConfigurationCopyWith(
          _Configuration value, $Res Function(_Configuration) _then) =
      __$ConfigurationCopyWithImpl;
  @override
  @useResult
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class __$ConfigurationCopyWithImpl<$Res>
    implements _$ConfigurationCopyWith<$Res> {
  __$ConfigurationCopyWithImpl(this._self, this._then);

  final _Configuration _self;
  final $Res Function(_Configuration) _then;

  /// Create a copy of Configuration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? publicKey = null,
    Object? privateKey = null,
  }) {
    return _then(_Configuration(
      publicKey: null == publicKey
          ? _self.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _self.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
