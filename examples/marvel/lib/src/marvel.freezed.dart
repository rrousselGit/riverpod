// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marvel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarvelListCharactersResponse {
  int get totalCount;
  List<Character> get characters;

  /// Create a copy of MarvelListCharactersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarvelListCharactersResponseCopyWith<MarvelListCharactersResponse>
      get copyWith => _$MarvelListCharactersResponseCopyWithImpl<
              MarvelListCharactersResponse>(
          this as MarvelListCharactersResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarvelListCharactersResponse &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality()
                .equals(other.characters, characters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, totalCount, const DeepCollectionEquality().hash(characters));

  @override
  String toString() {
    return 'MarvelListCharactersResponse(totalCount: $totalCount, characters: $characters)';
  }
}

/// @nodoc
abstract mixin class $MarvelListCharactersResponseCopyWith<$Res> {
  factory $MarvelListCharactersResponseCopyWith(
          MarvelListCharactersResponse value,
          $Res Function(MarvelListCharactersResponse) _then) =
      _$MarvelListCharactersResponseCopyWithImpl;
  @useResult
  $Res call({int totalCount, List<Character> characters});
}

/// @nodoc
class _$MarvelListCharactersResponseCopyWithImpl<$Res>
    implements $MarvelListCharactersResponseCopyWith<$Res> {
  _$MarvelListCharactersResponseCopyWithImpl(this._self, this._then);

  final MarvelListCharactersResponse _self;
  final $Res Function(MarvelListCharactersResponse) _then;

  /// Create a copy of MarvelListCharactersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? characters = null,
  }) {
    return _then(_self.copyWith(
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      characters: null == characters
          ? _self.characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<Character>,
    ));
  }
}

/// @nodoc

class _MarvelListCharactersResponse implements MarvelListCharactersResponse {
  _MarvelListCharactersResponse(
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

  /// Create a copy of MarvelListCharactersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MarvelListCharactersResponseCopyWith<_MarvelListCharactersResponse>
      get copyWith => __$MarvelListCharactersResponseCopyWithImpl<
          _MarvelListCharactersResponse>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MarvelListCharactersResponse &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality()
                .equals(other._characters, _characters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalCount,
      const DeepCollectionEquality().hash(_characters));

  @override
  String toString() {
    return 'MarvelListCharactersResponse(totalCount: $totalCount, characters: $characters)';
  }
}

/// @nodoc
abstract mixin class _$MarvelListCharactersResponseCopyWith<$Res>
    implements $MarvelListCharactersResponseCopyWith<$Res> {
  factory _$MarvelListCharactersResponseCopyWith(
          _MarvelListCharactersResponse value,
          $Res Function(_MarvelListCharactersResponse) _then) =
      __$MarvelListCharactersResponseCopyWithImpl;
  @override
  @useResult
  $Res call({int totalCount, List<Character> characters});
}

/// @nodoc
class __$MarvelListCharactersResponseCopyWithImpl<$Res>
    implements _$MarvelListCharactersResponseCopyWith<$Res> {
  __$MarvelListCharactersResponseCopyWithImpl(this._self, this._then);

  final _MarvelListCharactersResponse _self;
  final $Res Function(_MarvelListCharactersResponse) _then;

  /// Create a copy of MarvelListCharactersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalCount = null,
    Object? characters = null,
  }) {
    return _then(_MarvelListCharactersResponse(
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      characters: null == characters
          ? _self._characters
          : characters // ignore: cast_nullable_to_non_nullable
              as List<Character>,
    ));
  }
}

/// @nodoc
mixin _$Character {
  int get id;
  String get name;
  Thumbnail get thumbnail;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CharacterCopyWith<Character> get copyWith =>
      _$CharacterCopyWithImpl<Character>(this as Character, _$identity);

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Character &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, thumbnail);

  @override
  String toString() {
    return 'Character(id: $id, name: $name, thumbnail: $thumbnail)';
  }
}

/// @nodoc
abstract mixin class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) _then) =
      _$CharacterCopyWithImpl;
  @useResult
  $Res call({int id, String name, Thumbnail thumbnail});

  $ThumbnailCopyWith<$Res> get thumbnail;
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res> implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._self, this._then);

  final Character _self;
  final $Res Function(Character) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as Thumbnail,
    ));
  }

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThumbnailCopyWith<$Res> get thumbnail {
    return $ThumbnailCopyWith<$Res>(_self.thumbnail, (value) {
      return _then(_self.copyWith(thumbnail: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Character implements Character {
  _Character({required this.id, required this.name, required this.thumbnail});
  factory _Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final Thumbnail thumbnail;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CharacterCopyWith<_Character> get copyWith =>
      __$CharacterCopyWithImpl<_Character>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CharacterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Character &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, thumbnail);

  @override
  String toString() {
    return 'Character(id: $id, name: $name, thumbnail: $thumbnail)';
  }
}

/// @nodoc
abstract mixin class _$CharacterCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(
          _Character value, $Res Function(_Character) _then) =
      __$CharacterCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String name, Thumbnail thumbnail});

  @override
  $ThumbnailCopyWith<$Res> get thumbnail;
}

/// @nodoc
class __$CharacterCopyWithImpl<$Res> implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(this._self, this._then);

  final _Character _self;
  final $Res Function(_Character) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = null,
  }) {
    return _then(_Character(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as Thumbnail,
    ));
  }

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThumbnailCopyWith<$Res> get thumbnail {
    return $ThumbnailCopyWith<$Res>(_self.thumbnail, (value) {
      return _then(_self.copyWith(thumbnail: value));
    });
  }
}

/// @nodoc
mixin _$Thumbnail {
  String get url;
  String get path;
  String get extension;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThumbnailCopyWith<Thumbnail> get copyWith =>
      _$ThumbnailCopyWithImpl<Thumbnail>(this as Thumbnail, _$identity);

  /// Serializes this Thumbnail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Thumbnail &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.extension, extension) ||
                other.extension == extension));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, path, extension);

  @override
  String toString() {
    return 'Thumbnail(url: $url, path: $path, extension: $extension)';
  }
}

/// @nodoc
abstract mixin class $ThumbnailCopyWith<$Res> {
  factory $ThumbnailCopyWith(Thumbnail value, $Res Function(Thumbnail) _then) =
      _$ThumbnailCopyWithImpl;
  @useResult
  $Res call({String path, String extension});
}

/// @nodoc
class _$ThumbnailCopyWithImpl<$Res> implements $ThumbnailCopyWith<$Res> {
  _$ThumbnailCopyWithImpl(this._self, this._then);

  final Thumbnail _self;
  final $Res Function(Thumbnail) _then;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? extension = null,
  }) {
    return _then(_self.copyWith(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _self.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Thumbnail extends Thumbnail {
  _Thumbnail({required this.path, required this.extension}) : super._();
  factory _Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  @override
  final String path;
  @override
  final String extension;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThumbnailCopyWith<_Thumbnail> get copyWith =>
      __$ThumbnailCopyWithImpl<_Thumbnail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ThumbnailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Thumbnail &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.extension, extension) ||
                other.extension == extension));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, extension);

  @override
  String toString() {
    return 'Thumbnail(path: $path, extension: $extension)';
  }
}

/// @nodoc
abstract mixin class _$ThumbnailCopyWith<$Res>
    implements $ThumbnailCopyWith<$Res> {
  factory _$ThumbnailCopyWith(
          _Thumbnail value, $Res Function(_Thumbnail) _then) =
      __$ThumbnailCopyWithImpl;
  @override
  @useResult
  $Res call({String path, String extension});
}

/// @nodoc
class __$ThumbnailCopyWithImpl<$Res> implements _$ThumbnailCopyWith<$Res> {
  __$ThumbnailCopyWithImpl(this._self, this._then);

  final _Thumbnail _self;
  final $Res Function(_Thumbnail) _then;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? path = null,
    Object? extension = null,
  }) {
    return _then(_Thumbnail(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _self.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$MarvelResponse {
  MarvelData get data;

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarvelResponseCopyWith<MarvelResponse> get copyWith =>
      _$MarvelResponseCopyWithImpl<MarvelResponse>(
          this as MarvelResponse, _$identity);

  /// Serializes this MarvelResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarvelResponse &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @override
  String toString() {
    return 'MarvelResponse(data: $data)';
  }
}

/// @nodoc
abstract mixin class $MarvelResponseCopyWith<$Res> {
  factory $MarvelResponseCopyWith(
          MarvelResponse value, $Res Function(MarvelResponse) _then) =
      _$MarvelResponseCopyWithImpl;
  @useResult
  $Res call({MarvelData data});

  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MarvelResponseCopyWithImpl<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  _$MarvelResponseCopyWithImpl(this._self, this._then);

  final MarvelResponse _self;
  final $Res Function(MarvelResponse) _then;

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_self.copyWith(
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ));
  }

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarvelDataCopyWith<$Res> get data {
    return $MarvelDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _MarvelResponse implements MarvelResponse {
  _MarvelResponse(this.data);
  factory _MarvelResponse.fromJson(Map<String, dynamic> json) =>
      _$MarvelResponseFromJson(json);

  @override
  final MarvelData data;

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MarvelResponseCopyWith<_MarvelResponse> get copyWith =>
      __$MarvelResponseCopyWithImpl<_MarvelResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MarvelResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MarvelResponse &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @override
  String toString() {
    return 'MarvelResponse(data: $data)';
  }
}

/// @nodoc
abstract mixin class _$MarvelResponseCopyWith<$Res>
    implements $MarvelResponseCopyWith<$Res> {
  factory _$MarvelResponseCopyWith(
          _MarvelResponse value, $Res Function(_MarvelResponse) _then) =
      __$MarvelResponseCopyWithImpl;
  @override
  @useResult
  $Res call({MarvelData data});

  @override
  $MarvelDataCopyWith<$Res> get data;
}

/// @nodoc
class __$MarvelResponseCopyWithImpl<$Res>
    implements _$MarvelResponseCopyWith<$Res> {
  __$MarvelResponseCopyWithImpl(this._self, this._then);

  final _MarvelResponse _self;
  final $Res Function(_MarvelResponse) _then;

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = null,
  }) {
    return _then(_MarvelResponse(
      null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as MarvelData,
    ));
  }

  /// Create a copy of MarvelResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarvelDataCopyWith<$Res> get data {
    return $MarvelDataCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }
}

/// @nodoc
mixin _$MarvelData {
  List<Map<String, Object?>> get results;
  int get total;

  /// Create a copy of MarvelData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarvelDataCopyWith<MarvelData> get copyWith =>
      _$MarvelDataCopyWithImpl<MarvelData>(this as MarvelData, _$identity);

  /// Serializes this MarvelData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarvelData &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(results), total);

  @override
  String toString() {
    return 'MarvelData(results: $results, total: $total)';
  }
}

/// @nodoc
abstract mixin class $MarvelDataCopyWith<$Res> {
  factory $MarvelDataCopyWith(
          MarvelData value, $Res Function(MarvelData) _then) =
      _$MarvelDataCopyWithImpl;
  @useResult
  $Res call({List<Map<String, Object?>> results, int total});
}

/// @nodoc
class _$MarvelDataCopyWithImpl<$Res> implements $MarvelDataCopyWith<$Res> {
  _$MarvelDataCopyWithImpl(this._self, this._then);

  final MarvelData _self;
  final $Res Function(MarvelData) _then;

  /// Create a copy of MarvelData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? total = null,
  }) {
    return _then(_self.copyWith(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MarvelData implements MarvelData {
  _MarvelData(final List<Map<String, Object?>> results, this.total)
      : _results = results;
  factory _MarvelData.fromJson(Map<String, dynamic> json) =>
      _$MarvelDataFromJson(json);

  final List<Map<String, Object?>> _results;
  @override
  List<Map<String, Object?>> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final int total;

  /// Create a copy of MarvelData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MarvelDataCopyWith<_MarvelData> get copyWith =>
      __$MarvelDataCopyWithImpl<_MarvelData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MarvelDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MarvelData &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_results), total);

  @override
  String toString() {
    return 'MarvelData(results: $results, total: $total)';
  }
}

/// @nodoc
abstract mixin class _$MarvelDataCopyWith<$Res>
    implements $MarvelDataCopyWith<$Res> {
  factory _$MarvelDataCopyWith(
          _MarvelData value, $Res Function(_MarvelData) _then) =
      __$MarvelDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<Map<String, Object?>> results, int total});
}

/// @nodoc
class __$MarvelDataCopyWithImpl<$Res> implements _$MarvelDataCopyWith<$Res> {
  __$MarvelDataCopyWithImpl(this._self, this._then);

  final _MarvelData _self;
  final $Res Function(_MarvelData) _then;

  /// Create a copy of MarvelData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? results = null,
    Object? total = null,
  }) {
    return _then(_MarvelData(
      null == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Map<String, Object?>>,
      null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
