// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marvel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MarvelListCharactersResponse {
  int get totalCount => throw _privateConstructorUsedError;
  List<Character> get characters => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MarvelListCharactersResponseCopyWith<MarvelListCharactersResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarvelListCharactersResponseCopyWith<$Res> {
  factory $MarvelListCharactersResponseCopyWith(
          MarvelListCharactersResponse value,
          $Res Function(MarvelListCharactersResponse) then) =
      _$MarvelListCharactersResponseCopyWithImpl<$Res,
          MarvelListCharactersResponse>;
  @useResult
  $Res call({int totalCount, List<Character> characters});
}

/// @nodoc
class _$MarvelListCharactersResponseCopyWithImpl<$Res,
        $Val extends MarvelListCharactersResponse>
    implements $MarvelListCharactersResponseCopyWith<$Res> {
  _$MarvelListCharactersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? characters = null,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      characters: null == characters
          ? _value.characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<Character>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarvelListCharactersResponseImplCopyWith<$Res>
    implements $MarvelListCharactersResponseCopyWith<$Res> {
  factory _$$MarvelListCharactersResponseImplCopyWith(
          _$MarvelListCharactersResponseImpl value,
          $Res Function(_$MarvelListCharactersResponseImpl) then) =
      __$$MarvelListCharactersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalCount, List<Character> characters});
}

/// @nodoc
class __$$MarvelListCharactersResponseImplCopyWithImpl<$Res>
    extends _$MarvelListCharactersResponseCopyWithImpl<$Res,
        _$MarvelListCharactersResponseImpl>
    implements _$$MarvelListCharactersResponseImplCopyWith<$Res> {
  __$$MarvelListCharactersResponseImplCopyWithImpl(
      _$MarvelListCharactersResponseImpl _value,
      $Res Function(_$MarvelListCharactersResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? characters = null,
  }) {
    return _then(_$MarvelListCharactersResponseImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      characters: null == characters
          ? _value._characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<Character>,
    ));
  }
}

/// @nodoc

class _$MarvelListCharactersResponseImpl
    implements _MarvelListCharactersResponse {
  _$MarvelListCharactersResponseImpl(
      {required this.totalCount, required final List<Character> characters})
      : _characters = characters;

  @override
  final int totalCount;
  final List<Character> _characters;
  @override
  List<Character> get characters {
    if (_characters is EqualUnmodifiableListView) return _characters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characters);
  }

  @override
  String toString() {
    return 'MarvelListCharactersResponse(totalCount: $totalCount, characters: $characters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarvelListCharactersResponseImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality()
                .equals(other._characters, _characters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalCount,
      const DeepCollectionEquality().hash(_characters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarvelListCharactersResponseImplCopyWith<
          _$MarvelListCharactersResponseImpl>
      get copyWith => __$$MarvelListCharactersResponseImplCopyWithImpl<
          _$MarvelListCharactersResponseImpl>(this, _$identity);
}

abstract class _MarvelListCharactersResponse
    implements MarvelListCharactersResponse {
  factory _MarvelListCharactersResponse(
          {required final int totalCount,
          required final List<Character> characters}) =
      _$MarvelListCharactersResponseImpl;

  @override
  int get totalCount;
  @override
  List<Character> get characters;
  @override
  @JsonKey(ignore: true)
  _$$MarvelListCharactersResponseImplCopyWith<
          _$MarvelListCharactersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return _Character.fromJson(json);
}

/// @nodoc
mixin _$Character {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Thumbnail get thumbnail => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
  @useResult
  $Res call({int id, String name, Thumbnail thumbnail});

  $ThumbnailCopyWith<$Res> get thumbnail;
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as Thumbnail,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ThumbnailCopyWith<$Res> get thumbnail {
    return $ThumbnailCopyWith<$Res>(_value.thumbnail, (value) {
      return _then(_value.copyWith(thumbnail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
          _$CharacterImpl value, $Res Function(_$CharacterImpl) then) =
      __$$CharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, Thumbnail thumbnail});

  @override
  $ThumbnailCopyWith<$Res> get thumbnail;
}

/// @nodoc
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
      _$CharacterImpl _value, $Res Function(_$CharacterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = null,
  }) {
    return _then(_$CharacterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as Thumbnail,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterImpl implements _Character {
  _$CharacterImpl(
      {required this.id, required this.name, required this.thumbnail});

  factory _$CharacterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final Thumbnail thumbnail;

  @override
  String toString() {
    return 'Character(id: $id, name: $name, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, thumbnail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterImplToJson(
      this,
    );
  }
}

abstract class _Character implements Character {
  factory _Character(
      {required final int id,
      required final String name,
      required final Thumbnail thumbnail}) = _$CharacterImpl;

  factory _Character.fromJson(Map<String, dynamic> json) =
      _$CharacterImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  Thumbnail get thumbnail;
  @override
  @JsonKey(ignore: true)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) {
  return _Thumbnail.fromJson(json);
}

/// @nodoc
mixin _$Thumbnail {
  String get path => throw _privateConstructorUsedError;
  String get extension => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThumbnailCopyWith<Thumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThumbnailCopyWith<$Res> {
  factory $ThumbnailCopyWith(Thumbnail value, $Res Function(Thumbnail) then) =
      _$ThumbnailCopyWithImpl<$Res, Thumbnail>;
  @useResult
  $Res call({String path, String extension});
}

/// @nodoc
class _$ThumbnailCopyWithImpl<$Res, $Val extends Thumbnail>
    implements $ThumbnailCopyWith<$Res> {
  _$ThumbnailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? extension = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThumbnailImplCopyWith<$Res>
    implements $ThumbnailCopyWith<$Res> {
  factory _$$ThumbnailImplCopyWith(
          _$ThumbnailImpl value, $Res Function(_$ThumbnailImpl) then) =
      __$$ThumbnailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String extension});
}

/// @nodoc
class __$$ThumbnailImplCopyWithImpl<$Res>
    extends _$ThumbnailCopyWithImpl<$Res, _$ThumbnailImpl>
    implements _$$ThumbnailImplCopyWith<$Res> {
  __$$ThumbnailImplCopyWithImpl(
      _$ThumbnailImpl _value, $Res Function(_$ThumbnailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? extension = null,
  }) {
    return _then(_$ThumbnailImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThumbnailImpl extends _Thumbnail {
  _$ThumbnailImpl({required this.path, required this.extension}) : super._();

  factory _$ThumbnailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThumbnailImplFromJson(json);

  @override
  final String path;
  @override
  final String extension;

  @override
  String toString() {
    return 'Thumbnail(path: $path, extension: $extension)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThumbnailImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.extension, extension) ||
                other.extension == extension));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, extension);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThumbnailImplCopyWith<_$ThumbnailImpl> get copyWith =>
      __$$ThumbnailImplCopyWithImpl<_$ThumbnailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThumbnailImplToJson(
      this,
    );
  }
}

abstract class _Thumbnail extends Thumbnail {
  factory _Thumbnail(
      {required final String path,
      required final String extension}) = _$ThumbnailImpl;
  _Thumbnail._() : super._();

  factory _Thumbnail.fromJson(Map<String, dynamic> json) =
      _$ThumbnailImpl.fromJson;

  @override
  String get path;
  @override
  String get extension;
  @override
  @JsonKey(ignore: true)
  _$$ThumbnailImplCopyWith<_$ThumbnailImpl> get copyWith =>
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
      _$MarvelResponseCopyWithImpl<$Res, MarvelResponse>;
  @useResult
  $Res call({MarvelData data});

  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MarvelResponseCopyWithImpl<$Res, $Val extends MarvelResponse>
    implements $MarvelResponseCopyWith<$Res> {
  _$MarvelResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MarvelDataCopyWith<$Res> get data {
    return $MarvelDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarvelResponseImplCopyWith<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  factory _$$MarvelResponseImplCopyWith(_$MarvelResponseImpl value,
          $Res Function(_$MarvelResponseImpl) then) =
      __$$MarvelResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MarvelData data});

  @override
  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MarvelResponseImplCopyWithImpl<$Res>
    extends _$MarvelResponseCopyWithImpl<$Res, _$MarvelResponseImpl>
    implements _$$MarvelResponseImplCopyWith<$Res> {
  __$$MarvelResponseImplCopyWithImpl(
      _$MarvelResponseImpl _value, $Res Function(_$MarvelResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$MarvelResponseImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarvelResponseImpl implements _MarvelResponse {
  _$MarvelResponseImpl(this.data);

  factory _$MarvelResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarvelResponseImplFromJson(json);

  @override
  final MarvelData data;

  @override
  String toString() {
    return 'MarvelResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarvelResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarvelResponseImplCopyWith<_$MarvelResponseImpl> get copyWith =>
      __$$MarvelResponseImplCopyWithImpl<_$MarvelResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarvelResponseImplToJson(
      this,
    );
  }
}

abstract class _MarvelResponse implements MarvelResponse {
  factory _MarvelResponse(final MarvelData data) = _$MarvelResponseImpl;

  factory _MarvelResponse.fromJson(Map<String, dynamic> json) =
      _$MarvelResponseImpl.fromJson;

  @override
  MarvelData get data;
  @override
  @JsonKey(ignore: true)
  _$$MarvelResponseImplCopyWith<_$MarvelResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarvelData _$MarvelDataFromJson(Map<String, dynamic> json) {
  return _MarvelData.fromJson(json);
}

/// @nodoc
mixin _$MarvelData {
  List<Map<String, Object?>> get results => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarvelDataCopyWith<MarvelData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarvelDataCopyWith<$Res> {
  factory $MarvelDataCopyWith(
          MarvelData value, $Res Function(MarvelData) then) =
      _$MarvelDataCopyWithImpl<$Res, MarvelData>;
  @useResult
  $Res call({List<Map<String, Object?>> results, int total});
}

/// @nodoc
class _$MarvelDataCopyWithImpl<$Res, $Val extends MarvelData>
    implements $MarvelDataCopyWith<$Res> {
  _$MarvelDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarvelDataImplCopyWith<$Res>
    implements $MarvelDataCopyWith<$Res> {
  factory _$$MarvelDataImplCopyWith(
          _$MarvelDataImpl value, $Res Function(_$MarvelDataImpl) then) =
      __$$MarvelDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Map<String, Object?>> results, int total});
}

/// @nodoc
class __$$MarvelDataImplCopyWithImpl<$Res>
    extends _$MarvelDataCopyWithImpl<$Res, _$MarvelDataImpl>
    implements _$$MarvelDataImplCopyWith<$Res> {
  __$$MarvelDataImplCopyWithImpl(
      _$MarvelDataImpl _value, $Res Function(_$MarvelDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? total = null,
  }) {
    return _then(_$MarvelDataImpl(
      null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarvelDataImpl implements _MarvelData {
  _$MarvelDataImpl(final List<Map<String, Object?>> results, this.total)
      : _results = results;

  factory _$MarvelDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarvelDataImplFromJson(json);

  final List<Map<String, Object?>> _results;
  @override
  List<Map<String, Object?>> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final int total;

  @override
  String toString() {
    return 'MarvelData(results: $results, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarvelDataImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_results), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarvelDataImplCopyWith<_$MarvelDataImpl> get copyWith =>
      __$$MarvelDataImplCopyWithImpl<_$MarvelDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarvelDataImplToJson(
      this,
    );
  }
}

abstract class _MarvelData implements MarvelData {
  factory _MarvelData(
          final List<Map<String, Object?>> results, final int total) =
      _$MarvelDataImpl;

  factory _MarvelData.fromJson(Map<String, dynamic> json) =
      _$MarvelDataImpl.fromJson;

  @override
  List<Map<String, Object?>> get results;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$MarvelDataImplCopyWith<_$MarvelDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
