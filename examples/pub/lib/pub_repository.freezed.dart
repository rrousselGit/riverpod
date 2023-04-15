// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pub_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PackageMetricsScore _$PackageMetricsScoreFromJson(Map<String, dynamic> json) {
  return _PackageMetricsScore.fromJson(json);
}

/// @nodoc
mixin _$PackageMetricsScore {
  int get grantedPoints => throw _privateConstructorUsedError;
  int get maxPoints => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  double get popularityScore => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageMetricsScoreCopyWith<PackageMetricsScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageMetricsScoreCopyWith<$Res> {
  factory $PackageMetricsScoreCopyWith(
          PackageMetricsScore value, $Res Function(PackageMetricsScore) then) =
      _$PackageMetricsScoreCopyWithImpl<$Res, PackageMetricsScore>;
  @useResult
  $Res call(
      {int grantedPoints,
      int maxPoints,
      int likeCount,
      double popularityScore,
      List<String> tags});
}

/// @nodoc
class _$PackageMetricsScoreCopyWithImpl<$Res, $Val extends PackageMetricsScore>
    implements $PackageMetricsScoreCopyWith<$Res> {
  _$PackageMetricsScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantedPoints = null,
    Object? maxPoints = null,
    Object? likeCount = null,
    Object? popularityScore = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      grantedPoints: null == grantedPoints
          ? _value.grantedPoints
          : grantedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _value.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PackageMetricsScoreCopyWith<$Res>
    implements $PackageMetricsScoreCopyWith<$Res> {
  factory _$$_PackageMetricsScoreCopyWith(_$_PackageMetricsScore value,
          $Res Function(_$_PackageMetricsScore) then) =
      __$$_PackageMetricsScoreCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int grantedPoints,
      int maxPoints,
      int likeCount,
      double popularityScore,
      List<String> tags});
}

/// @nodoc
class __$$_PackageMetricsScoreCopyWithImpl<$Res>
    extends _$PackageMetricsScoreCopyWithImpl<$Res, _$_PackageMetricsScore>
    implements _$$_PackageMetricsScoreCopyWith<$Res> {
  __$$_PackageMetricsScoreCopyWithImpl(_$_PackageMetricsScore _value,
      $Res Function(_$_PackageMetricsScore) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantedPoints = null,
    Object? maxPoints = null,
    Object? likeCount = null,
    Object? popularityScore = null,
    Object? tags = null,
  }) {
    return _then(_$_PackageMetricsScore(
      grantedPoints: null == grantedPoints
          ? _value.grantedPoints
          : grantedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _value.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PackageMetricsScore
    with DiagnosticableTreeMixin
    implements _PackageMetricsScore {
  _$_PackageMetricsScore(
      {required this.grantedPoints,
      required this.maxPoints,
      required this.likeCount,
      required this.popularityScore,
      required final List<String> tags})
      : _tags = tags;

  factory _$_PackageMetricsScore.fromJson(Map<String, dynamic> json) =>
      _$$_PackageMetricsScoreFromJson(json);

  @override
  final int grantedPoints;
  @override
  final int maxPoints;
  @override
  final int likeCount;
  @override
  final double popularityScore;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsScore(grantedPoints: $grantedPoints, maxPoints: $maxPoints, likeCount: $likeCount, popularityScore: $popularityScore, tags: $tags)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PackageMetricsScore'))
      ..add(DiagnosticsProperty('grantedPoints', grantedPoints))
      ..add(DiagnosticsProperty('maxPoints', maxPoints))
      ..add(DiagnosticsProperty('likeCount', likeCount))
      ..add(DiagnosticsProperty('popularityScore', popularityScore))
      ..add(DiagnosticsProperty('tags', tags));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PackageMetricsScore &&
            (identical(other.grantedPoints, grantedPoints) ||
                other.grantedPoints == grantedPoints) &&
            (identical(other.maxPoints, maxPoints) ||
                other.maxPoints == maxPoints) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, grantedPoints, maxPoints,
      likeCount, popularityScore, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PackageMetricsScoreCopyWith<_$_PackageMetricsScore> get copyWith =>
      __$$_PackageMetricsScoreCopyWithImpl<_$_PackageMetricsScore>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PackageMetricsScoreToJson(
      this,
    );
  }
}

abstract class _PackageMetricsScore implements PackageMetricsScore {
  factory _PackageMetricsScore(
      {required final int grantedPoints,
      required final int maxPoints,
      required final int likeCount,
      required final double popularityScore,
      required final List<String> tags}) = _$_PackageMetricsScore;

  factory _PackageMetricsScore.fromJson(Map<String, dynamic> json) =
      _$_PackageMetricsScore.fromJson;

  @override
  int get grantedPoints;
  @override
  int get maxPoints;
  @override
  int get likeCount;
  @override
  double get popularityScore;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_PackageMetricsScoreCopyWith<_$_PackageMetricsScore> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageMetricsResponse _$PackageMetricsResponseFromJson(
    Map<String, dynamic> json) {
  return _PackageMetricsResponse.fromJson(json);
}

/// @nodoc
mixin _$PackageMetricsResponse {
  PackageMetricsScore get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageMetricsResponseCopyWith<PackageMetricsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageMetricsResponseCopyWith<$Res> {
  factory $PackageMetricsResponseCopyWith(PackageMetricsResponse value,
          $Res Function(PackageMetricsResponse) then) =
      _$PackageMetricsResponseCopyWithImpl<$Res, PackageMetricsResponse>;
  @useResult
  $Res call({PackageMetricsScore score});

  $PackageMetricsScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$PackageMetricsResponseCopyWithImpl<$Res,
        $Val extends PackageMetricsResponse>
    implements $PackageMetricsResponseCopyWith<$Res> {
  _$PackageMetricsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as PackageMetricsScore,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PackageMetricsScoreCopyWith<$Res> get score {
    return $PackageMetricsScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PackageMetricsResponseCopyWith<$Res>
    implements $PackageMetricsResponseCopyWith<$Res> {
  factory _$$_PackageMetricsResponseCopyWith(_$_PackageMetricsResponse value,
          $Res Function(_$_PackageMetricsResponse) then) =
      __$$_PackageMetricsResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PackageMetricsScore score});

  @override
  $PackageMetricsScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$_PackageMetricsResponseCopyWithImpl<$Res>
    extends _$PackageMetricsResponseCopyWithImpl<$Res,
        _$_PackageMetricsResponse>
    implements _$$_PackageMetricsResponseCopyWith<$Res> {
  __$$_PackageMetricsResponseCopyWithImpl(_$_PackageMetricsResponse _value,
      $Res Function(_$_PackageMetricsResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
  }) {
    return _then(_$_PackageMetricsResponse(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as PackageMetricsScore,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PackageMetricsResponse
    with DiagnosticableTreeMixin
    implements _PackageMetricsResponse {
  _$_PackageMetricsResponse({required this.score});

  factory _$_PackageMetricsResponse.fromJson(Map<String, dynamic> json) =>
      _$$_PackageMetricsResponseFromJson(json);

  @override
  final PackageMetricsScore score;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsResponse(score: $score)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PackageMetricsResponse'))
      ..add(DiagnosticsProperty('score', score));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PackageMetricsResponse &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PackageMetricsResponseCopyWith<_$_PackageMetricsResponse> get copyWith =>
      __$$_PackageMetricsResponseCopyWithImpl<_$_PackageMetricsResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PackageMetricsResponseToJson(
      this,
    );
  }
}

abstract class _PackageMetricsResponse implements PackageMetricsResponse {
  factory _PackageMetricsResponse({required final PackageMetricsScore score}) =
      _$_PackageMetricsResponse;

  factory _PackageMetricsResponse.fromJson(Map<String, dynamic> json) =
      _$_PackageMetricsResponse.fromJson;

  @override
  PackageMetricsScore get score;
  @override
  @JsonKey(ignore: true)
  _$$_PackageMetricsResponseCopyWith<_$_PackageMetricsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageDetails _$PackageDetailsFromJson(Map<String, dynamic> json) {
  return _PackageDetails.fromJson(json);
}

/// @nodoc
mixin _$PackageDetails {
  String get version => throw _privateConstructorUsedError;
  Pubspec get pubspec => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageDetailsCopyWith<PackageDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageDetailsCopyWith<$Res> {
  factory $PackageDetailsCopyWith(
          PackageDetails value, $Res Function(PackageDetails) then) =
      _$PackageDetailsCopyWithImpl<$Res, PackageDetails>;
  @useResult
  $Res call({String version, Pubspec pubspec});
}

/// @nodoc
class _$PackageDetailsCopyWithImpl<$Res, $Val extends PackageDetails>
    implements $PackageDetailsCopyWith<$Res> {
  _$PackageDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? pubspec = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      pubspec: null == pubspec
          ? _value.pubspec
          : pubspec // ignore: cast_nullable_to_non_nullable
              as Pubspec,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PackageDetailsCopyWith<$Res>
    implements $PackageDetailsCopyWith<$Res> {
  factory _$$_PackageDetailsCopyWith(
          _$_PackageDetails value, $Res Function(_$_PackageDetails) then) =
      __$$_PackageDetailsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version, Pubspec pubspec});
}

/// @nodoc
class __$$_PackageDetailsCopyWithImpl<$Res>
    extends _$PackageDetailsCopyWithImpl<$Res, _$_PackageDetails>
    implements _$$_PackageDetailsCopyWith<$Res> {
  __$$_PackageDetailsCopyWithImpl(
      _$_PackageDetails _value, $Res Function(_$_PackageDetails) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? pubspec = null,
  }) {
    return _then(_$_PackageDetails(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      pubspec: null == pubspec
          ? _value.pubspec
          : pubspec // ignore: cast_nullable_to_non_nullable
              as Pubspec,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PackageDetails
    with DiagnosticableTreeMixin
    implements _PackageDetails {
  _$_PackageDetails({required this.version, required this.pubspec});

  factory _$_PackageDetails.fromJson(Map<String, dynamic> json) =>
      _$$_PackageDetailsFromJson(json);

  @override
  final String version;
  @override
  final Pubspec pubspec;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageDetails(version: $version, pubspec: $pubspec)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PackageDetails'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('pubspec', pubspec));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PackageDetails &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.pubspec, pubspec) || other.pubspec == pubspec));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, version, pubspec);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PackageDetailsCopyWith<_$_PackageDetails> get copyWith =>
      __$$_PackageDetailsCopyWithImpl<_$_PackageDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PackageDetailsToJson(
      this,
    );
  }
}

abstract class _PackageDetails implements PackageDetails {
  factory _PackageDetails(
      {required final String version,
      required final Pubspec pubspec}) = _$_PackageDetails;

  factory _PackageDetails.fromJson(Map<String, dynamic> json) =
      _$_PackageDetails.fromJson;

  @override
  String get version;
  @override
  Pubspec get pubspec;
  @override
  @JsonKey(ignore: true)
  _$$_PackageDetailsCopyWith<_$_PackageDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  String get name => throw _privateConstructorUsedError;
  PackageDetails get latest => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call({String name, PackageDetails latest});

  $PackageDetailsCopyWith<$Res> get latest;
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? latest = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latest: null == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as PackageDetails,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PackageDetailsCopyWith<$Res> get latest {
    return $PackageDetailsCopyWith<$Res>(_value.latest, (value) {
      return _then(_value.copyWith(latest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$_PackageCopyWith(
          _$_Package value, $Res Function(_$_Package) then) =
      __$$_PackageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, PackageDetails latest});

  @override
  $PackageDetailsCopyWith<$Res> get latest;
}

/// @nodoc
class __$$_PackageCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$_Package>
    implements _$$_PackageCopyWith<$Res> {
  __$$_PackageCopyWithImpl(_$_Package _value, $Res Function(_$_Package) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? latest = null,
  }) {
    return _then(_$_Package(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latest: null == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as PackageDetails,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Package with DiagnosticableTreeMixin implements _Package {
  _$_Package({required this.name, required this.latest});

  factory _$_Package.fromJson(Map<String, dynamic> json) =>
      _$$_PackageFromJson(json);

  @override
  final String name;
  @override
  final PackageDetails latest;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Package(name: $name, latest: $latest)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Package'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('latest', latest));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Package &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latest, latest) || other.latest == latest));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, latest);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PackageCopyWith<_$_Package> get copyWith =>
      __$$_PackageCopyWithImpl<_$_Package>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PackageToJson(
      this,
    );
  }
}

abstract class _Package implements Package {
  factory _Package(
      {required final String name,
      required final PackageDetails latest}) = _$_Package;

  factory _Package.fromJson(Map<String, dynamic> json) = _$_Package.fromJson;

  @override
  String get name;
  @override
  PackageDetails get latest;
  @override
  @JsonKey(ignore: true)
  _$$_PackageCopyWith<_$_Package> get copyWith =>
      throw _privateConstructorUsedError;
}

LikedPackage _$LikedPackageFromJson(Map<String, dynamic> json) {
  return _LikedPackage.fromJson(json);
}

/// @nodoc
mixin _$LikedPackage {
  String get package => throw _privateConstructorUsedError;
  bool get liked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikedPackageCopyWith<LikedPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikedPackageCopyWith<$Res> {
  factory $LikedPackageCopyWith(
          LikedPackage value, $Res Function(LikedPackage) then) =
      _$LikedPackageCopyWithImpl<$Res, LikedPackage>;
  @useResult
  $Res call({String package, bool liked});
}

/// @nodoc
class _$LikedPackageCopyWithImpl<$Res, $Val extends LikedPackage>
    implements $LikedPackageCopyWith<$Res> {
  _$LikedPackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
    Object? liked = null,
  }) {
    return _then(_value.copyWith(
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _value.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LikedPackageCopyWith<$Res>
    implements $LikedPackageCopyWith<$Res> {
  factory _$$_LikedPackageCopyWith(
          _$_LikedPackage value, $Res Function(_$_LikedPackage) then) =
      __$$_LikedPackageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String package, bool liked});
}

/// @nodoc
class __$$_LikedPackageCopyWithImpl<$Res>
    extends _$LikedPackageCopyWithImpl<$Res, _$_LikedPackage>
    implements _$$_LikedPackageCopyWith<$Res> {
  __$$_LikedPackageCopyWithImpl(
      _$_LikedPackage _value, $Res Function(_$_LikedPackage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
    Object? liked = null,
  }) {
    return _then(_$_LikedPackage(
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _value.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikedPackage with DiagnosticableTreeMixin implements _LikedPackage {
  _$_LikedPackage({required this.package, required this.liked});

  factory _$_LikedPackage.fromJson(Map<String, dynamic> json) =>
      _$$_LikedPackageFromJson(json);

  @override
  final String package;
  @override
  final bool liked;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackage(package: $package, liked: $liked)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackage'))
      ..add(DiagnosticsProperty('package', package))
      ..add(DiagnosticsProperty('liked', liked));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikedPackage &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, package, liked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikedPackageCopyWith<_$_LikedPackage> get copyWith =>
      __$$_LikedPackageCopyWithImpl<_$_LikedPackage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikedPackageToJson(
      this,
    );
  }
}

abstract class _LikedPackage implements LikedPackage {
  factory _LikedPackage(
      {required final String package,
      required final bool liked}) = _$_LikedPackage;

  factory _LikedPackage.fromJson(Map<String, dynamic> json) =
      _$_LikedPackage.fromJson;

  @override
  String get package;
  @override
  bool get liked;
  @override
  @JsonKey(ignore: true)
  _$$_LikedPackageCopyWith<_$_LikedPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

LikedPackagesResponse _$LikedPackagesResponseFromJson(
    Map<String, dynamic> json) {
  return _LikesPackagesResponse.fromJson(json);
}

/// @nodoc
mixin _$LikedPackagesResponse {
  List<LikedPackage> get likedPackages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikedPackagesResponseCopyWith<LikedPackagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikedPackagesResponseCopyWith<$Res> {
  factory $LikedPackagesResponseCopyWith(LikedPackagesResponse value,
          $Res Function(LikedPackagesResponse) then) =
      _$LikedPackagesResponseCopyWithImpl<$Res, LikedPackagesResponse>;
  @useResult
  $Res call({List<LikedPackage> likedPackages});
}

/// @nodoc
class _$LikedPackagesResponseCopyWithImpl<$Res,
        $Val extends LikedPackagesResponse>
    implements $LikedPackagesResponseCopyWith<$Res> {
  _$LikedPackagesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likedPackages = null,
  }) {
    return _then(_value.copyWith(
      likedPackages: null == likedPackages
          ? _value.likedPackages
          : likedPackages // ignore: cast_nullable_to_non_nullable
              as List<LikedPackage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LikesPackagesResponseCopyWith<$Res>
    implements $LikedPackagesResponseCopyWith<$Res> {
  factory _$$_LikesPackagesResponseCopyWith(_$_LikesPackagesResponse value,
          $Res Function(_$_LikesPackagesResponse) then) =
      __$$_LikesPackagesResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LikedPackage> likedPackages});
}

/// @nodoc
class __$$_LikesPackagesResponseCopyWithImpl<$Res>
    extends _$LikedPackagesResponseCopyWithImpl<$Res, _$_LikesPackagesResponse>
    implements _$$_LikesPackagesResponseCopyWith<$Res> {
  __$$_LikesPackagesResponseCopyWithImpl(_$_LikesPackagesResponse _value,
      $Res Function(_$_LikesPackagesResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likedPackages = null,
  }) {
    return _then(_$_LikesPackagesResponse(
      likedPackages: null == likedPackages
          ? _value._likedPackages
          : likedPackages // ignore: cast_nullable_to_non_nullable
              as List<LikedPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikesPackagesResponse
    with DiagnosticableTreeMixin
    implements _LikesPackagesResponse {
  _$_LikesPackagesResponse({required final List<LikedPackage> likedPackages})
      : _likedPackages = likedPackages;

  factory _$_LikesPackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$$_LikesPackagesResponseFromJson(json);

  final List<LikedPackage> _likedPackages;
  @override
  List<LikedPackage> get likedPackages {
    if (_likedPackages is EqualUnmodifiableListView) return _likedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedPackages);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackagesResponse(likedPackages: $likedPackages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackagesResponse'))
      ..add(DiagnosticsProperty('likedPackages', likedPackages));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikesPackagesResponse &&
            const DeepCollectionEquality()
                .equals(other._likedPackages, _likedPackages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_likedPackages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikesPackagesResponseCopyWith<_$_LikesPackagesResponse> get copyWith =>
      __$$_LikesPackagesResponseCopyWithImpl<_$_LikesPackagesResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikesPackagesResponseToJson(
      this,
    );
  }
}

abstract class _LikesPackagesResponse implements LikedPackagesResponse {
  factory _LikesPackagesResponse(
          {required final List<LikedPackage> likedPackages}) =
      _$_LikesPackagesResponse;

  factory _LikesPackagesResponse.fromJson(Map<String, dynamic> json) =
      _$_LikesPackagesResponse.fromJson;

  @override
  List<LikedPackage> get likedPackages;
  @override
  @JsonKey(ignore: true)
  _$$_LikesPackagesResponseCopyWith<_$_LikesPackagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

PubPackagesResponse _$PubPackagesResponseFromJson(Map<String, dynamic> json) {
  return _PubPackagesResponse.fromJson(json);
}

/// @nodoc
mixin _$PubPackagesResponse {
  List<Package> get packages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PubPackagesResponseCopyWith<PubPackagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PubPackagesResponseCopyWith<$Res> {
  factory $PubPackagesResponseCopyWith(
          PubPackagesResponse value, $Res Function(PubPackagesResponse) then) =
      _$PubPackagesResponseCopyWithImpl<$Res, PubPackagesResponse>;
  @useResult
  $Res call({List<Package> packages});
}

/// @nodoc
class _$PubPackagesResponseCopyWithImpl<$Res, $Val extends PubPackagesResponse>
    implements $PubPackagesResponseCopyWith<$Res> {
  _$PubPackagesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_value.copyWith(
      packages: null == packages
          ? _value.packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<Package>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PubPackagesResponseCopyWith<$Res>
    implements $PubPackagesResponseCopyWith<$Res> {
  factory _$$_PubPackagesResponseCopyWith(_$_PubPackagesResponse value,
          $Res Function(_$_PubPackagesResponse) then) =
      __$$_PubPackagesResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Package> packages});
}

/// @nodoc
class __$$_PubPackagesResponseCopyWithImpl<$Res>
    extends _$PubPackagesResponseCopyWithImpl<$Res, _$_PubPackagesResponse>
    implements _$$_PubPackagesResponseCopyWith<$Res> {
  __$$_PubPackagesResponseCopyWithImpl(_$_PubPackagesResponse _value,
      $Res Function(_$_PubPackagesResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_$_PubPackagesResponse(
      packages: null == packages
          ? _value._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<Package>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PubPackagesResponse
    with DiagnosticableTreeMixin
    implements _PubPackagesResponse {
  _$_PubPackagesResponse({required final List<Package> packages})
      : _packages = packages;

  factory _$_PubPackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$$_PubPackagesResponseFromJson(json);

  final List<Package> _packages;
  @override
  List<Package> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubPackagesResponse(packages: $packages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PubPackagesResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PubPackagesResponse &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PubPackagesResponseCopyWith<_$_PubPackagesResponse> get copyWith =>
      __$$_PubPackagesResponseCopyWithImpl<_$_PubPackagesResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PubPackagesResponseToJson(
      this,
    );
  }
}

abstract class _PubPackagesResponse implements PubPackagesResponse {
  factory _PubPackagesResponse({required final List<Package> packages}) =
      _$_PubPackagesResponse;

  factory _PubPackagesResponse.fromJson(Map<String, dynamic> json) =
      _$_PubPackagesResponse.fromJson;

  @override
  List<Package> get packages;
  @override
  @JsonKey(ignore: true)
  _$$_PubPackagesResponseCopyWith<_$_PubPackagesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchPackage _$SearchPackageFromJson(Map<String, dynamic> json) {
  return _SearchPackage.fromJson(json);
}

/// @nodoc
mixin _$SearchPackage {
  String get package => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchPackageCopyWith<SearchPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchPackageCopyWith<$Res> {
  factory $SearchPackageCopyWith(
          SearchPackage value, $Res Function(SearchPackage) then) =
      _$SearchPackageCopyWithImpl<$Res, SearchPackage>;
  @useResult
  $Res call({String package});
}

/// @nodoc
class _$SearchPackageCopyWithImpl<$Res, $Val extends SearchPackage>
    implements $SearchPackageCopyWith<$Res> {
  _$SearchPackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
  }) {
    return _then(_value.copyWith(
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchPackageCopyWith<$Res>
    implements $SearchPackageCopyWith<$Res> {
  factory _$$_SearchPackageCopyWith(
          _$_SearchPackage value, $Res Function(_$_SearchPackage) then) =
      __$$_SearchPackageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String package});
}

/// @nodoc
class __$$_SearchPackageCopyWithImpl<$Res>
    extends _$SearchPackageCopyWithImpl<$Res, _$_SearchPackage>
    implements _$$_SearchPackageCopyWith<$Res> {
  __$$_SearchPackageCopyWithImpl(
      _$_SearchPackage _value, $Res Function(_$_SearchPackage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
  }) {
    return _then(_$_SearchPackage(
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SearchPackage with DiagnosticableTreeMixin implements _SearchPackage {
  _$_SearchPackage({required this.package});

  factory _$_SearchPackage.fromJson(Map<String, dynamic> json) =>
      _$$_SearchPackageFromJson(json);

  @override
  final String package;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SearchPackage(package: $package)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SearchPackage'))
      ..add(DiagnosticsProperty('package', package));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchPackage &&
            (identical(other.package, package) || other.package == package));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, package);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchPackageCopyWith<_$_SearchPackage> get copyWith =>
      __$$_SearchPackageCopyWithImpl<_$_SearchPackage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SearchPackageToJson(
      this,
    );
  }
}

abstract class _SearchPackage implements SearchPackage {
  factory _SearchPackage({required final String package}) = _$_SearchPackage;

  factory _SearchPackage.fromJson(Map<String, dynamic> json) =
      _$_SearchPackage.fromJson;

  @override
  String get package;
  @override
  @JsonKey(ignore: true)
  _$$_SearchPackageCopyWith<_$_SearchPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

PubSearchResponse _$PubSearchResponseFromJson(Map<String, dynamic> json) {
  return _PubSearchResponse.fromJson(json);
}

/// @nodoc
mixin _$PubSearchResponse {
  List<SearchPackage> get packages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PubSearchResponseCopyWith<PubSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PubSearchResponseCopyWith<$Res> {
  factory $PubSearchResponseCopyWith(
          PubSearchResponse value, $Res Function(PubSearchResponse) then) =
      _$PubSearchResponseCopyWithImpl<$Res, PubSearchResponse>;
  @useResult
  $Res call({List<SearchPackage> packages});
}

/// @nodoc
class _$PubSearchResponseCopyWithImpl<$Res, $Val extends PubSearchResponse>
    implements $PubSearchResponseCopyWith<$Res> {
  _$PubSearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_value.copyWith(
      packages: null == packages
          ? _value.packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SearchPackage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PubSearchResponseCopyWith<$Res>
    implements $PubSearchResponseCopyWith<$Res> {
  factory _$$_PubSearchResponseCopyWith(_$_PubSearchResponse value,
          $Res Function(_$_PubSearchResponse) then) =
      __$$_PubSearchResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SearchPackage> packages});
}

/// @nodoc
class __$$_PubSearchResponseCopyWithImpl<$Res>
    extends _$PubSearchResponseCopyWithImpl<$Res, _$_PubSearchResponse>
    implements _$$_PubSearchResponseCopyWith<$Res> {
  __$$_PubSearchResponseCopyWithImpl(
      _$_PubSearchResponse _value, $Res Function(_$_PubSearchResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_$_PubSearchResponse(
      packages: null == packages
          ? _value._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SearchPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PubSearchResponse
    with DiagnosticableTreeMixin
    implements _PubSearchResponse {
  _$_PubSearchResponse({required final List<SearchPackage> packages})
      : _packages = packages;

  factory _$_PubSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$$_PubSearchResponseFromJson(json);

  final List<SearchPackage> _packages;
  @override
  List<SearchPackage> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubSearchResponse(packages: $packages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PubSearchResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PubSearchResponse &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PubSearchResponseCopyWith<_$_PubSearchResponse> get copyWith =>
      __$$_PubSearchResponseCopyWithImpl<_$_PubSearchResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PubSearchResponseToJson(
      this,
    );
  }
}

abstract class _PubSearchResponse implements PubSearchResponse {
  factory _PubSearchResponse({required final List<SearchPackage> packages}) =
      _$_PubSearchResponse;

  factory _PubSearchResponse.fromJson(Map<String, dynamic> json) =
      _$_PubSearchResponse.fromJson;

  @override
  List<SearchPackage> get packages;
  @override
  @JsonKey(ignore: true)
  _$$_PubSearchResponseCopyWith<_$_PubSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
