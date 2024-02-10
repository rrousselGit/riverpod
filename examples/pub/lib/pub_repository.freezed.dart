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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$PackageMetricsScoreImplCopyWith<$Res>
    implements $PackageMetricsScoreCopyWith<$Res> {
  factory _$$PackageMetricsScoreImplCopyWith(_$PackageMetricsScoreImpl value,
          $Res Function(_$PackageMetricsScoreImpl) then) =
      __$$PackageMetricsScoreImplCopyWithImpl<$Res>;
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
class __$$PackageMetricsScoreImplCopyWithImpl<$Res>
    extends _$PackageMetricsScoreCopyWithImpl<$Res, _$PackageMetricsScoreImpl>
    implements _$$PackageMetricsScoreImplCopyWith<$Res> {
  __$$PackageMetricsScoreImplCopyWithImpl(_$PackageMetricsScoreImpl _value,
      $Res Function(_$PackageMetricsScoreImpl) _then)
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
    return _then(_$PackageMetricsScoreImpl(
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
class _$PackageMetricsScoreImpl
    with DiagnosticableTreeMixin
    implements _PackageMetricsScore {
  _$PackageMetricsScoreImpl(
      {required this.grantedPoints,
      required this.maxPoints,
      required this.likeCount,
      required this.popularityScore,
      required final List<String> tags})
      : _tags = tags;

  factory _$PackageMetricsScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageMetricsScoreImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageMetricsScoreImpl &&
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
  _$$PackageMetricsScoreImplCopyWith<_$PackageMetricsScoreImpl> get copyWith =>
      __$$PackageMetricsScoreImplCopyWithImpl<_$PackageMetricsScoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageMetricsScoreImplToJson(
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
      required final List<String> tags}) = _$PackageMetricsScoreImpl;

  factory _PackageMetricsScore.fromJson(Map<String, dynamic> json) =
      _$PackageMetricsScoreImpl.fromJson;

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
  _$$PackageMetricsScoreImplCopyWith<_$PackageMetricsScoreImpl> get copyWith =>
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
abstract class _$$PackageMetricsResponseImplCopyWith<$Res>
    implements $PackageMetricsResponseCopyWith<$Res> {
  factory _$$PackageMetricsResponseImplCopyWith(
          _$PackageMetricsResponseImpl value,
          $Res Function(_$PackageMetricsResponseImpl) then) =
      __$$PackageMetricsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PackageMetricsScore score});

  @override
  $PackageMetricsScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$PackageMetricsResponseImplCopyWithImpl<$Res>
    extends _$PackageMetricsResponseCopyWithImpl<$Res,
        _$PackageMetricsResponseImpl>
    implements _$$PackageMetricsResponseImplCopyWith<$Res> {
  __$$PackageMetricsResponseImplCopyWithImpl(
      _$PackageMetricsResponseImpl _value,
      $Res Function(_$PackageMetricsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
  }) {
    return _then(_$PackageMetricsResponseImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as PackageMetricsScore,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageMetricsResponseImpl
    with DiagnosticableTreeMixin
    implements _PackageMetricsResponse {
  _$PackageMetricsResponseImpl({required this.score});

  factory _$PackageMetricsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageMetricsResponseImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageMetricsResponseImpl &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageMetricsResponseImplCopyWith<_$PackageMetricsResponseImpl>
      get copyWith => __$$PackageMetricsResponseImplCopyWithImpl<
          _$PackageMetricsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageMetricsResponseImplToJson(
      this,
    );
  }
}

abstract class _PackageMetricsResponse implements PackageMetricsResponse {
  factory _PackageMetricsResponse({required final PackageMetricsScore score}) =
      _$PackageMetricsResponseImpl;

  factory _PackageMetricsResponse.fromJson(Map<String, dynamic> json) =
      _$PackageMetricsResponseImpl.fromJson;

  @override
  PackageMetricsScore get score;
  @override
  @JsonKey(ignore: true)
  _$$PackageMetricsResponseImplCopyWith<_$PackageMetricsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
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
abstract class _$$PackageDetailsImplCopyWith<$Res>
    implements $PackageDetailsCopyWith<$Res> {
  factory _$$PackageDetailsImplCopyWith(_$PackageDetailsImpl value,
          $Res Function(_$PackageDetailsImpl) then) =
      __$$PackageDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version, Pubspec pubspec});
}

/// @nodoc
class __$$PackageDetailsImplCopyWithImpl<$Res>
    extends _$PackageDetailsCopyWithImpl<$Res, _$PackageDetailsImpl>
    implements _$$PackageDetailsImplCopyWith<$Res> {
  __$$PackageDetailsImplCopyWithImpl(
      _$PackageDetailsImpl _value, $Res Function(_$PackageDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? pubspec = null,
  }) {
    return _then(_$PackageDetailsImpl(
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
class _$PackageDetailsImpl
    with DiagnosticableTreeMixin
    implements _PackageDetails {
  _$PackageDetailsImpl({required this.version, required this.pubspec});

  factory _$PackageDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageDetailsImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageDetailsImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.pubspec, pubspec) || other.pubspec == pubspec));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, version, pubspec);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageDetailsImplCopyWith<_$PackageDetailsImpl> get copyWith =>
      __$$PackageDetailsImplCopyWithImpl<_$PackageDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageDetailsImplToJson(
      this,
    );
  }
}

abstract class _PackageDetails implements PackageDetails {
  factory _PackageDetails(
      {required final String version,
      required final Pubspec pubspec}) = _$PackageDetailsImpl;

  factory _PackageDetails.fromJson(Map<String, dynamic> json) =
      _$PackageDetailsImpl.fromJson;

  @override
  String get version;
  @override
  Pubspec get pubspec;
  @override
  @JsonKey(ignore: true)
  _$$PackageDetailsImplCopyWith<_$PackageDetailsImpl> get copyWith =>
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
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
          _$PackageImpl value, $Res Function(_$PackageImpl) then) =
      __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, PackageDetails latest});

  @override
  $PackageDetailsCopyWith<$Res> get latest;
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
      _$PackageImpl _value, $Res Function(_$PackageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? latest = null,
  }) {
    return _then(_$PackageImpl(
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
class _$PackageImpl with DiagnosticableTreeMixin implements _Package {
  _$PackageImpl({required this.name, required this.latest});

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latest, latest) || other.latest == latest));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, latest);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(
      this,
    );
  }
}

abstract class _Package implements Package {
  factory _Package(
      {required final String name,
      required final PackageDetails latest}) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  String get name;
  @override
  PackageDetails get latest;
  @override
  @JsonKey(ignore: true)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
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
abstract class _$$LikedPackageImplCopyWith<$Res>
    implements $LikedPackageCopyWith<$Res> {
  factory _$$LikedPackageImplCopyWith(
          _$LikedPackageImpl value, $Res Function(_$LikedPackageImpl) then) =
      __$$LikedPackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String package, bool liked});
}

/// @nodoc
class __$$LikedPackageImplCopyWithImpl<$Res>
    extends _$LikedPackageCopyWithImpl<$Res, _$LikedPackageImpl>
    implements _$$LikedPackageImplCopyWith<$Res> {
  __$$LikedPackageImplCopyWithImpl(
      _$LikedPackageImpl _value, $Res Function(_$LikedPackageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
    Object? liked = null,
  }) {
    return _then(_$LikedPackageImpl(
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
class _$LikedPackageImpl with DiagnosticableTreeMixin implements _LikedPackage {
  _$LikedPackageImpl({required this.package, required this.liked});

  factory _$LikedPackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikedPackageImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikedPackageImpl &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, package, liked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LikedPackageImplCopyWith<_$LikedPackageImpl> get copyWith =>
      __$$LikedPackageImplCopyWithImpl<_$LikedPackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikedPackageImplToJson(
      this,
    );
  }
}

abstract class _LikedPackage implements LikedPackage {
  factory _LikedPackage(
      {required final String package,
      required final bool liked}) = _$LikedPackageImpl;

  factory _LikedPackage.fromJson(Map<String, dynamic> json) =
      _$LikedPackageImpl.fromJson;

  @override
  String get package;
  @override
  bool get liked;
  @override
  @JsonKey(ignore: true)
  _$$LikedPackageImplCopyWith<_$LikedPackageImpl> get copyWith =>
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
abstract class _$$LikesPackagesResponseImplCopyWith<$Res>
    implements $LikedPackagesResponseCopyWith<$Res> {
  factory _$$LikesPackagesResponseImplCopyWith(
          _$LikesPackagesResponseImpl value,
          $Res Function(_$LikesPackagesResponseImpl) then) =
      __$$LikesPackagesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LikedPackage> likedPackages});
}

/// @nodoc
class __$$LikesPackagesResponseImplCopyWithImpl<$Res>
    extends _$LikedPackagesResponseCopyWithImpl<$Res,
        _$LikesPackagesResponseImpl>
    implements _$$LikesPackagesResponseImplCopyWith<$Res> {
  __$$LikesPackagesResponseImplCopyWithImpl(_$LikesPackagesResponseImpl _value,
      $Res Function(_$LikesPackagesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likedPackages = null,
  }) {
    return _then(_$LikesPackagesResponseImpl(
      likedPackages: null == likedPackages
          ? _value._likedPackages
          : likedPackages // ignore: cast_nullable_to_non_nullable
              as List<LikedPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LikesPackagesResponseImpl
    with DiagnosticableTreeMixin
    implements _LikesPackagesResponse {
  _$LikesPackagesResponseImpl({required final List<LikedPackage> likedPackages})
      : _likedPackages = likedPackages;

  factory _$LikesPackagesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikesPackagesResponseImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikesPackagesResponseImpl &&
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
  _$$LikesPackagesResponseImplCopyWith<_$LikesPackagesResponseImpl>
      get copyWith => __$$LikesPackagesResponseImplCopyWithImpl<
          _$LikesPackagesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikesPackagesResponseImplToJson(
      this,
    );
  }
}

abstract class _LikesPackagesResponse implements LikedPackagesResponse {
  factory _LikesPackagesResponse(
          {required final List<LikedPackage> likedPackages}) =
      _$LikesPackagesResponseImpl;

  factory _LikesPackagesResponse.fromJson(Map<String, dynamic> json) =
      _$LikesPackagesResponseImpl.fromJson;

  @override
  List<LikedPackage> get likedPackages;
  @override
  @JsonKey(ignore: true)
  _$$LikesPackagesResponseImplCopyWith<_$LikesPackagesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
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
abstract class _$$PubPackagesResponseImplCopyWith<$Res>
    implements $PubPackagesResponseCopyWith<$Res> {
  factory _$$PubPackagesResponseImplCopyWith(_$PubPackagesResponseImpl value,
          $Res Function(_$PubPackagesResponseImpl) then) =
      __$$PubPackagesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Package> packages});
}

/// @nodoc
class __$$PubPackagesResponseImplCopyWithImpl<$Res>
    extends _$PubPackagesResponseCopyWithImpl<$Res, _$PubPackagesResponseImpl>
    implements _$$PubPackagesResponseImplCopyWith<$Res> {
  __$$PubPackagesResponseImplCopyWithImpl(_$PubPackagesResponseImpl _value,
      $Res Function(_$PubPackagesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_$PubPackagesResponseImpl(
      packages: null == packages
          ? _value._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<Package>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PubPackagesResponseImpl
    with DiagnosticableTreeMixin
    implements _PubPackagesResponse {
  _$PubPackagesResponseImpl({required final List<Package> packages})
      : _packages = packages;

  factory _$PubPackagesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PubPackagesResponseImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PubPackagesResponseImpl &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PubPackagesResponseImplCopyWith<_$PubPackagesResponseImpl> get copyWith =>
      __$$PubPackagesResponseImplCopyWithImpl<_$PubPackagesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PubPackagesResponseImplToJson(
      this,
    );
  }
}

abstract class _PubPackagesResponse implements PubPackagesResponse {
  factory _PubPackagesResponse({required final List<Package> packages}) =
      _$PubPackagesResponseImpl;

  factory _PubPackagesResponse.fromJson(Map<String, dynamic> json) =
      _$PubPackagesResponseImpl.fromJson;

  @override
  List<Package> get packages;
  @override
  @JsonKey(ignore: true)
  _$$PubPackagesResponseImplCopyWith<_$PubPackagesResponseImpl> get copyWith =>
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
abstract class _$$SearchPackageImplCopyWith<$Res>
    implements $SearchPackageCopyWith<$Res> {
  factory _$$SearchPackageImplCopyWith(
          _$SearchPackageImpl value, $Res Function(_$SearchPackageImpl) then) =
      __$$SearchPackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String package});
}

/// @nodoc
class __$$SearchPackageImplCopyWithImpl<$Res>
    extends _$SearchPackageCopyWithImpl<$Res, _$SearchPackageImpl>
    implements _$$SearchPackageImplCopyWith<$Res> {
  __$$SearchPackageImplCopyWithImpl(
      _$SearchPackageImpl _value, $Res Function(_$SearchPackageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
  }) {
    return _then(_$SearchPackageImpl(
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchPackageImpl
    with DiagnosticableTreeMixin
    implements _SearchPackage {
  _$SearchPackageImpl({required this.package});

  factory _$SearchPackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchPackageImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchPackageImpl &&
            (identical(other.package, package) || other.package == package));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, package);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchPackageImplCopyWith<_$SearchPackageImpl> get copyWith =>
      __$$SearchPackageImplCopyWithImpl<_$SearchPackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchPackageImplToJson(
      this,
    );
  }
}

abstract class _SearchPackage implements SearchPackage {
  factory _SearchPackage({required final String package}) = _$SearchPackageImpl;

  factory _SearchPackage.fromJson(Map<String, dynamic> json) =
      _$SearchPackageImpl.fromJson;

  @override
  String get package;
  @override
  @JsonKey(ignore: true)
  _$$SearchPackageImplCopyWith<_$SearchPackageImpl> get copyWith =>
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
abstract class _$$PubSearchResponseImplCopyWith<$Res>
    implements $PubSearchResponseCopyWith<$Res> {
  factory _$$PubSearchResponseImplCopyWith(_$PubSearchResponseImpl value,
          $Res Function(_$PubSearchResponseImpl) then) =
      __$$PubSearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SearchPackage> packages});
}

/// @nodoc
class __$$PubSearchResponseImplCopyWithImpl<$Res>
    extends _$PubSearchResponseCopyWithImpl<$Res, _$PubSearchResponseImpl>
    implements _$$PubSearchResponseImplCopyWith<$Res> {
  __$$PubSearchResponseImplCopyWithImpl(_$PubSearchResponseImpl _value,
      $Res Function(_$PubSearchResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_$PubSearchResponseImpl(
      packages: null == packages
          ? _value._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SearchPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PubSearchResponseImpl
    with DiagnosticableTreeMixin
    implements _PubSearchResponse {
  _$PubSearchResponseImpl({required final List<SearchPackage> packages})
      : _packages = packages;

  factory _$PubSearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PubSearchResponseImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PubSearchResponseImpl &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PubSearchResponseImplCopyWith<_$PubSearchResponseImpl> get copyWith =>
      __$$PubSearchResponseImplCopyWithImpl<_$PubSearchResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PubSearchResponseImplToJson(
      this,
    );
  }
}

abstract class _PubSearchResponse implements PubSearchResponse {
  factory _PubSearchResponse({required final List<SearchPackage> packages}) =
      _$PubSearchResponseImpl;

  factory _PubSearchResponse.fromJson(Map<String, dynamic> json) =
      _$PubSearchResponseImpl.fromJson;

  @override
  List<SearchPackage> get packages;
  @override
  @JsonKey(ignore: true)
  _$$PubSearchResponseImplCopyWith<_$PubSearchResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
