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
      _$ConfigurationCopyWithImpl<$Res>;
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class _$ConfigurationCopyWithImpl<$Res>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._value, this._then);

  final Configuration _value;
  // ignore: unused_field
  final $Res Function(Configuration) _then;

  @override
  $Res call({
    Object? publicKey = freezed,
    Object? privateKey = freezed,
  }) {
    return _then(_value.copyWith(
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: privateKey == freezed
          ? _value.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ConfigurationCopyWith<$Res>
    implements $ConfigurationCopyWith<$Res> {
  factory _$$_ConfigurationCopyWith(
          _$_Configuration value, $Res Function(_$_Configuration) then) =
      __$$_ConfigurationCopyWithImpl<$Res>;
  @override
  $Res call({String publicKey, String privateKey});
}

/// @nodoc
class __$$_ConfigurationCopyWithImpl<$Res>
    extends _$ConfigurationCopyWithImpl<$Res>
    implements _$$_ConfigurationCopyWith<$Res> {
  __$$_ConfigurationCopyWithImpl(
      _$_Configuration _value, $Res Function(_$_Configuration) _then)
      : super(_value, (v) => _then(v as _$_Configuration));

  @override
  _$_Configuration get _value => super._value as _$_Configuration;

  @override
  $Res call({
    Object? publicKey = freezed,
    Object? privateKey = freezed,
  }) {
    return _then(_$_Configuration(
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: privateKey == freezed
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
            const DeepCollectionEquality().equals(other.publicKey, publicKey) &&
            const DeepCollectionEquality()
                .equals(other.privateKey, privateKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(publicKey),
      const DeepCollectionEquality().hash(privateKey));

  @JsonKey(ignore: true)
  @override
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

MarvelResponse _$MarvelResponseFromJson(Map<String, dynamic> json) {
  return _MarvelResponse.fromJson(json);
}

/// @nodoc
mixin _$MarvelResponse {
  MarvelData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarvelResponseCopyWith<MarvelResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarvelResponseCopyWith<$Res> {
  factory $MarvelResponseCopyWith(
          MarvelResponse value, $Res Function(MarvelResponse) then) =
      _$MarvelResponseCopyWithImpl<$Res>;
  $Res call({MarvelData data});

  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MarvelResponseCopyWithImpl<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  _$MarvelResponseCopyWithImpl(this._value, this._then);

  final MarvelResponse _value;
  // ignore: unused_field
  final $Res Function(MarvelResponse) _then;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ));
  }

  @override
  $MarvelDataCopyWith<$Res> get data {
    return $MarvelDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
abstract class _$$_MarvelResponseCopyWith<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  factory _$$_MarvelResponseCopyWith(
          _$_MarvelResponse value, $Res Function(_$_MarvelResponse) then) =
      __$$_MarvelResponseCopyWithImpl<$Res>;
  @override
  $Res call({MarvelData data});

  @override
  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$_MarvelResponseCopyWithImpl<$Res>
    extends _$MarvelResponseCopyWithImpl<$Res>
    implements _$$_MarvelResponseCopyWith<$Res> {
  __$$_MarvelResponseCopyWithImpl(
      _$_MarvelResponse _value, $Res Function(_$_MarvelResponse) _then)
      : super(_value, (v) => _then(v as _$_MarvelResponse));

  @override
  _$_MarvelResponse get _value => super._value as _$_MarvelResponse;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$_MarvelResponse(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MarvelResponse implements _MarvelResponse {
  _$_MarvelResponse(this.data);

  factory _$_MarvelResponse.fromJson(Map<String, dynamic> json) =>
      _$$_MarvelResponseFromJson(json);

  @override
  final MarvelData data;

  @override
  String toString() {
    return 'MarvelResponse(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MarvelResponse &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$$_MarvelResponseCopyWith<_$_MarvelResponse> get copyWith =>
      __$$_MarvelResponseCopyWithImpl<_$_MarvelResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MarvelResponseToJson(
      this,
    );
  }
}

abstract class _MarvelResponse implements MarvelResponse {
  factory _MarvelResponse(final MarvelData data) = _$_MarvelResponse;

  factory _MarvelResponse.fromJson(Map<String, dynamic> json) =
      _$_MarvelResponse.fromJson;

  @override
  MarvelData get data;
  @override
  @JsonKey(ignore: true)
  _$$_MarvelResponseCopyWith<_$_MarvelResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

MarvelData _$MarvelDataFromJson(Map<String, dynamic> json) {
  return _MarvelData.fromJson(json);
}

/// @nodoc
mixin _$MarvelData {
  List<Map<String, Object?>> get results => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarvelDataCopyWith<MarvelData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarvelDataCopyWith<$Res> {
  factory $MarvelDataCopyWith(
          MarvelData value, $Res Function(MarvelData) then) =
      _$MarvelDataCopyWithImpl<$Res>;
  $Res call({List<Map<String, Object?>> results});
}

/// @nodoc
class _$MarvelDataCopyWithImpl<$Res> implements $MarvelDataCopyWith<$Res> {
  _$MarvelDataCopyWithImpl(this._value, this._then);

  final MarvelData _value;
  // ignore: unused_field
  final $Res Function(MarvelData) _then;

  @override
  $Res call({
    Object? results = freezed,
  }) {
    return _then(_value.copyWith(
      results: results == freezed
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
    ));
  }
}

/// @nodoc
abstract class _$$_MarvelDataCopyWith<$Res>
    implements $MarvelDataCopyWith<$Res> {
  factory _$$_MarvelDataCopyWith(
          _$_MarvelData value, $Res Function(_$_MarvelData) then) =
      __$$_MarvelDataCopyWithImpl<$Res>;
  @override
  $Res call({List<Map<String, Object?>> results});
}

/// @nodoc
class __$$_MarvelDataCopyWithImpl<$Res> extends _$MarvelDataCopyWithImpl<$Res>
    implements _$$_MarvelDataCopyWith<$Res> {
  __$$_MarvelDataCopyWithImpl(
      _$_MarvelData _value, $Res Function(_$_MarvelData) _then)
      : super(_value, (v) => _then(v as _$_MarvelData));

  @override
  _$_MarvelData get _value => super._value as _$_MarvelData;

  @override
  $Res call({
    Object? results = freezed,
  }) {
    return _then(_$_MarvelData(
      results == freezed
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MarvelData implements _MarvelData {
  _$_MarvelData(final List<Map<String, Object?>> results) : _results = results;

  factory _$_MarvelData.fromJson(Map<String, dynamic> json) =>
      _$$_MarvelDataFromJson(json);

  final List<Map<String, Object?>> _results;
  @override
  List<Map<String, Object?>> get results {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'MarvelData(results: $results)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MarvelData &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_results));

  @JsonKey(ignore: true)
  @override
  _$$_MarvelDataCopyWith<_$_MarvelData> get copyWith =>
      __$$_MarvelDataCopyWithImpl<_$_MarvelData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MarvelDataToJson(
      this,
    );
  }
}

abstract class _MarvelData implements MarvelData {
  factory _MarvelData(final List<Map<String, Object?>> results) = _$_MarvelData;

  factory _MarvelData.fromJson(Map<String, dynamic> json) =
      _$_MarvelData.fromJson;

  @override
  List<Map<String, Object?>> get results;
  @override
  @JsonKey(ignore: true)
  _$$_MarvelDataCopyWith<_$_MarvelData> get copyWith =>
      throw _privateConstructorUsedError;
}

Comic _$ComicFromJson(Map<String, dynamic> json) {
  return _Comic.fromJson(json);
}

/// @nodoc
mixin _$Comic {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComicCopyWith<Comic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComicCopyWith<$Res> {
  factory $ComicCopyWith(Comic value, $Res Function(Comic) then) =
      _$ComicCopyWithImpl<$Res>;
  $Res call({int id, String title});
}

/// @nodoc
class _$ComicCopyWithImpl<$Res> implements $ComicCopyWith<$Res> {
  _$ComicCopyWithImpl(this._value, this._then);

  final Comic _value;
  // ignore: unused_field
  final $Res Function(Comic) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ComicCopyWith<$Res> implements $ComicCopyWith<$Res> {
  factory _$$_ComicCopyWith(_$_Comic value, $Res Function(_$_Comic) then) =
      __$$_ComicCopyWithImpl<$Res>;
  @override
  $Res call({int id, String title});
}

/// @nodoc
class __$$_ComicCopyWithImpl<$Res> extends _$ComicCopyWithImpl<$Res>
    implements _$$_ComicCopyWith<$Res> {
  __$$_ComicCopyWithImpl(_$_Comic _value, $Res Function(_$_Comic) _then)
      : super(_value, (v) => _then(v as _$_Comic));

  @override
  _$_Comic get _value => super._value as _$_Comic;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
  }) {
    return _then(_$_Comic(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Comic implements _Comic {
  _$_Comic({required this.id, required this.title});

  factory _$_Comic.fromJson(Map<String, dynamic> json) =>
      _$$_ComicFromJson(json);

  @override
  final int id;
  @override
  final String title;

  @override
  String toString() {
    return 'Comic(id: $id, title: $title)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Comic &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.title, title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(title));

  @JsonKey(ignore: true)
  @override
  _$$_ComicCopyWith<_$_Comic> get copyWith =>
      __$$_ComicCopyWithImpl<_$_Comic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ComicToJson(
      this,
    );
  }
}

abstract class _Comic implements Comic {
  factory _Comic({required final int id, required final String title}) =
      _$_Comic;

  factory _Comic.fromJson(Map<String, dynamic> json) = _$_Comic.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(ignore: true)
  _$$_ComicCopyWith<_$_Comic> get copyWith =>
      throw _privateConstructorUsedError;
}
