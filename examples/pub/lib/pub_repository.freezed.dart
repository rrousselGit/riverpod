// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pub_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageMetricsScore implements DiagnosticableTreeMixin {
  int get grantedPoints;
  int get maxPoints;
  int get likeCount;
  double get popularityScore;
  List<String> get tags;

  /// Create a copy of PackageMetricsScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PackageMetricsScoreCopyWith<PackageMetricsScore> get copyWith =>
      _$PackageMetricsScoreCopyWithImpl<PackageMetricsScore>(
          this as PackageMetricsScore, _$identity);

  /// Serializes this PackageMetricsScore to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is PackageMetricsScore &&
            (identical(other.grantedPoints, grantedPoints) ||
                other.grantedPoints == grantedPoints) &&
            (identical(other.maxPoints, maxPoints) ||
                other.maxPoints == maxPoints) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            const DeepCollectionEquality().equals(other.tags, tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, grantedPoints, maxPoints,
      likeCount, popularityScore, const DeepCollectionEquality().hash(tags));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsScore(grantedPoints: $grantedPoints, maxPoints: $maxPoints, likeCount: $likeCount, popularityScore: $popularityScore, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $PackageMetricsScoreCopyWith<$Res> {
  factory $PackageMetricsScoreCopyWith(
          PackageMetricsScore value, $Res Function(PackageMetricsScore) _then) =
      _$PackageMetricsScoreCopyWithImpl;
  @useResult
  $Res call(
      {int grantedPoints,
      int maxPoints,
      int likeCount,
      double popularityScore,
      List<String> tags});
}

/// @nodoc
class _$PackageMetricsScoreCopyWithImpl<$Res>
    implements $PackageMetricsScoreCopyWith<$Res> {
  _$PackageMetricsScoreCopyWithImpl(this._self, this._then);

  final PackageMetricsScore _self;
  final $Res Function(PackageMetricsScore) _then;

  /// Create a copy of PackageMetricsScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantedPoints = null,
    Object? maxPoints = null,
    Object? likeCount = null,
    Object? popularityScore = null,
    Object? tags = null,
  }) {
    return _then(_self.copyWith(
      grantedPoints: null == grantedPoints
          ? _self.grantedPoints
          : grantedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _self.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularityScore: null == popularityScore
          ? _self.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PackageMetricsScore
    with DiagnosticableTreeMixin
    implements PackageMetricsScore {
  _PackageMetricsScore(
      {required this.grantedPoints,
      required this.maxPoints,
      required this.likeCount,
      required this.popularityScore,
      required final List<String> tags})
      : _tags = tags;
  factory _PackageMetricsScore.fromJson(Map<String, dynamic> json) =>
      _$PackageMetricsScoreFromJson(json);

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

  /// Create a copy of PackageMetricsScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PackageMetricsScoreCopyWith<_PackageMetricsScore> get copyWith =>
      __$PackageMetricsScoreCopyWithImpl<_PackageMetricsScore>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PackageMetricsScoreToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _PackageMetricsScore &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, grantedPoints, maxPoints,
      likeCount, popularityScore, const DeepCollectionEquality().hash(_tags));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsScore(grantedPoints: $grantedPoints, maxPoints: $maxPoints, likeCount: $likeCount, popularityScore: $popularityScore, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class _$PackageMetricsScoreCopyWith<$Res>
    implements $PackageMetricsScoreCopyWith<$Res> {
  factory _$PackageMetricsScoreCopyWith(_PackageMetricsScore value,
          $Res Function(_PackageMetricsScore) _then) =
      __$PackageMetricsScoreCopyWithImpl;
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
class __$PackageMetricsScoreCopyWithImpl<$Res>
    implements _$PackageMetricsScoreCopyWith<$Res> {
  __$PackageMetricsScoreCopyWithImpl(this._self, this._then);

  final _PackageMetricsScore _self;
  final $Res Function(_PackageMetricsScore) _then;

  /// Create a copy of PackageMetricsScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? grantedPoints = null,
    Object? maxPoints = null,
    Object? likeCount = null,
    Object? popularityScore = null,
    Object? tags = null,
  }) {
    return _then(_PackageMetricsScore(
      grantedPoints: null == grantedPoints
          ? _self.grantedPoints
          : grantedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _self.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      popularityScore: null == popularityScore
          ? _self.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$PackageMetricsResponse implements DiagnosticableTreeMixin {
  PackageMetricsScore get score;

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PackageMetricsResponseCopyWith<PackageMetricsResponse> get copyWith =>
      _$PackageMetricsResponseCopyWithImpl<PackageMetricsResponse>(
          this as PackageMetricsResponse, _$identity);

  /// Serializes this PackageMetricsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PackageMetricsResponse'))
      ..add(DiagnosticsProperty('score', score));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PackageMetricsResponse &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, score);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsResponse(score: $score)';
  }
}

/// @nodoc
abstract mixin class $PackageMetricsResponseCopyWith<$Res> {
  factory $PackageMetricsResponseCopyWith(PackageMetricsResponse value,
          $Res Function(PackageMetricsResponse) _then) =
      _$PackageMetricsResponseCopyWithImpl;
  @useResult
  $Res call({PackageMetricsScore score});

  $PackageMetricsScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$PackageMetricsResponseCopyWithImpl<$Res>
    implements $PackageMetricsResponseCopyWith<$Res> {
  _$PackageMetricsResponseCopyWithImpl(this._self, this._then);

  final PackageMetricsResponse _self;
  final $Res Function(PackageMetricsResponse) _then;

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
  }) {
    return _then(_self.copyWith(
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as PackageMetricsScore,
    ));
  }

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageMetricsScoreCopyWith<$Res> get score {
    return $PackageMetricsScoreCopyWith<$Res>(_self.score, (value) {
      return _then(_self.copyWith(score: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _PackageMetricsResponse
    with DiagnosticableTreeMixin
    implements PackageMetricsResponse {
  _PackageMetricsResponse({required this.score});
  factory _PackageMetricsResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageMetricsResponseFromJson(json);

  @override
  final PackageMetricsScore score;

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PackageMetricsResponseCopyWith<_PackageMetricsResponse> get copyWith =>
      __$PackageMetricsResponseCopyWithImpl<_PackageMetricsResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PackageMetricsResponseToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PackageMetricsResponse'))
      ..add(DiagnosticsProperty('score', score));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PackageMetricsResponse &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, score);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageMetricsResponse(score: $score)';
  }
}

/// @nodoc
abstract mixin class _$PackageMetricsResponseCopyWith<$Res>
    implements $PackageMetricsResponseCopyWith<$Res> {
  factory _$PackageMetricsResponseCopyWith(_PackageMetricsResponse value,
          $Res Function(_PackageMetricsResponse) _then) =
      __$PackageMetricsResponseCopyWithImpl;
  @override
  @useResult
  $Res call({PackageMetricsScore score});

  @override
  $PackageMetricsScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$PackageMetricsResponseCopyWithImpl<$Res>
    implements _$PackageMetricsResponseCopyWith<$Res> {
  __$PackageMetricsResponseCopyWithImpl(this._self, this._then);

  final _PackageMetricsResponse _self;
  final $Res Function(_PackageMetricsResponse) _then;

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? score = null,
  }) {
    return _then(_PackageMetricsResponse(
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as PackageMetricsScore,
    ));
  }

  /// Create a copy of PackageMetricsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageMetricsScoreCopyWith<$Res> get score {
    return $PackageMetricsScoreCopyWith<$Res>(_self.score, (value) {
      return _then(_self.copyWith(score: value));
    });
  }
}

/// @nodoc
mixin _$PackageDetails implements DiagnosticableTreeMixin {
  String get version;
  Pubspec get pubspec;

  /// Create a copy of PackageDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PackageDetailsCopyWith<PackageDetails> get copyWith =>
      _$PackageDetailsCopyWithImpl<PackageDetails>(
          this as PackageDetails, _$identity);

  /// Serializes this PackageDetails to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PackageDetails'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('pubspec', pubspec));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PackageDetails &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.pubspec, pubspec) || other.pubspec == pubspec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, pubspec);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageDetails(version: $version, pubspec: $pubspec)';
  }
}

/// @nodoc
abstract mixin class $PackageDetailsCopyWith<$Res> {
  factory $PackageDetailsCopyWith(
          PackageDetails value, $Res Function(PackageDetails) _then) =
      _$PackageDetailsCopyWithImpl;
  @useResult
  $Res call({String version, Pubspec pubspec});
}

/// @nodoc
class _$PackageDetailsCopyWithImpl<$Res>
    implements $PackageDetailsCopyWith<$Res> {
  _$PackageDetailsCopyWithImpl(this._self, this._then);

  final PackageDetails _self;
  final $Res Function(PackageDetails) _then;

  /// Create a copy of PackageDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? pubspec = null,
  }) {
    return _then(_self.copyWith(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      pubspec: null == pubspec
          ? _self.pubspec
          : pubspec // ignore: cast_nullable_to_non_nullable
              as Pubspec,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PackageDetails with DiagnosticableTreeMixin implements PackageDetails {
  _PackageDetails({required this.version, required this.pubspec});
  factory _PackageDetails.fromJson(Map<String, dynamic> json) =>
      _$PackageDetailsFromJson(json);

  @override
  final String version;
  @override
  final Pubspec pubspec;

  /// Create a copy of PackageDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PackageDetailsCopyWith<_PackageDetails> get copyWith =>
      __$PackageDetailsCopyWithImpl<_PackageDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PackageDetailsToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PackageDetails'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('pubspec', pubspec));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PackageDetails &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.pubspec, pubspec) || other.pubspec == pubspec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, pubspec);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PackageDetails(version: $version, pubspec: $pubspec)';
  }
}

/// @nodoc
abstract mixin class _$PackageDetailsCopyWith<$Res>
    implements $PackageDetailsCopyWith<$Res> {
  factory _$PackageDetailsCopyWith(
          _PackageDetails value, $Res Function(_PackageDetails) _then) =
      __$PackageDetailsCopyWithImpl;
  @override
  @useResult
  $Res call({String version, Pubspec pubspec});
}

/// @nodoc
class __$PackageDetailsCopyWithImpl<$Res>
    implements _$PackageDetailsCopyWith<$Res> {
  __$PackageDetailsCopyWithImpl(this._self, this._then);

  final _PackageDetails _self;
  final $Res Function(_PackageDetails) _then;

  /// Create a copy of PackageDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
    Object? pubspec = null,
  }) {
    return _then(_PackageDetails(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      pubspec: null == pubspec
          ? _self.pubspec
          : pubspec // ignore: cast_nullable_to_non_nullable
              as Pubspec,
    ));
  }
}

/// @nodoc
mixin _$Package implements DiagnosticableTreeMixin {
  String get name;
  PackageDetails get latest;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PackageCopyWith<Package> get copyWith =>
      _$PackageCopyWithImpl<Package>(this as Package, _$identity);

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Package'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('latest', latest));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Package &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latest, latest) || other.latest == latest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, latest);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Package(name: $name, latest: $latest)';
  }
}

/// @nodoc
abstract mixin class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) _then) =
      _$PackageCopyWithImpl;
  @useResult
  $Res call({String name, PackageDetails latest});

  $PackageDetailsCopyWith<$Res> get latest;
}

/// @nodoc
class _$PackageCopyWithImpl<$Res> implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._self, this._then);

  final Package _self;
  final $Res Function(Package) _then;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? latest = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latest: null == latest
          ? _self.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as PackageDetails,
    ));
  }

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageDetailsCopyWith<$Res> get latest {
    return $PackageDetailsCopyWith<$Res>(_self.latest, (value) {
      return _then(_self.copyWith(latest: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Package with DiagnosticableTreeMixin implements Package {
  _Package({required this.name, required this.latest});
  factory _Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);

  @override
  final String name;
  @override
  final PackageDetails latest;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PackageCopyWith<_Package> get copyWith =>
      __$PackageCopyWithImpl<_Package>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PackageToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Package'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('latest', latest));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Package &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latest, latest) || other.latest == latest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, latest);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Package(name: $name, latest: $latest)';
  }
}

/// @nodoc
abstract mixin class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) _then) =
      __$PackageCopyWithImpl;
  @override
  @useResult
  $Res call({String name, PackageDetails latest});

  @override
  $PackageDetailsCopyWith<$Res> get latest;
}

/// @nodoc
class __$PackageCopyWithImpl<$Res> implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(this._self, this._then);

  final _Package _self;
  final $Res Function(_Package) _then;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? latest = null,
  }) {
    return _then(_Package(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latest: null == latest
          ? _self.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as PackageDetails,
    ));
  }

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PackageDetailsCopyWith<$Res> get latest {
    return $PackageDetailsCopyWith<$Res>(_self.latest, (value) {
      return _then(_self.copyWith(latest: value));
    });
  }
}

/// @nodoc
mixin _$LikedPackage implements DiagnosticableTreeMixin {
  String get package;
  bool get liked;

  /// Create a copy of LikedPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LikedPackageCopyWith<LikedPackage> get copyWith =>
      _$LikedPackageCopyWithImpl<LikedPackage>(
          this as LikedPackage, _$identity);

  /// Serializes this LikedPackage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackage'))
      ..add(DiagnosticsProperty('package', package))
      ..add(DiagnosticsProperty('liked', liked));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LikedPackage &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, package, liked);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackage(package: $package, liked: $liked)';
  }
}

/// @nodoc
abstract mixin class $LikedPackageCopyWith<$Res> {
  factory $LikedPackageCopyWith(
          LikedPackage value, $Res Function(LikedPackage) _then) =
      _$LikedPackageCopyWithImpl;
  @useResult
  $Res call({String package, bool liked});
}

/// @nodoc
class _$LikedPackageCopyWithImpl<$Res> implements $LikedPackageCopyWith<$Res> {
  _$LikedPackageCopyWithImpl(this._self, this._then);

  final LikedPackage _self;
  final $Res Function(LikedPackage) _then;

  /// Create a copy of LikedPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
    Object? liked = null,
  }) {
    return _then(_self.copyWith(
      package: null == package
          ? _self.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _self.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LikedPackage with DiagnosticableTreeMixin implements LikedPackage {
  _LikedPackage({required this.package, required this.liked});
  factory _LikedPackage.fromJson(Map<String, dynamic> json) =>
      _$LikedPackageFromJson(json);

  @override
  final String package;
  @override
  final bool liked;

  /// Create a copy of LikedPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LikedPackageCopyWith<_LikedPackage> get copyWith =>
      __$LikedPackageCopyWithImpl<_LikedPackage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LikedPackageToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackage'))
      ..add(DiagnosticsProperty('package', package))
      ..add(DiagnosticsProperty('liked', liked));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LikedPackage &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, package, liked);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackage(package: $package, liked: $liked)';
  }
}

/// @nodoc
abstract mixin class _$LikedPackageCopyWith<$Res>
    implements $LikedPackageCopyWith<$Res> {
  factory _$LikedPackageCopyWith(
          _LikedPackage value, $Res Function(_LikedPackage) _then) =
      __$LikedPackageCopyWithImpl;
  @override
  @useResult
  $Res call({String package, bool liked});
}

/// @nodoc
class __$LikedPackageCopyWithImpl<$Res>
    implements _$LikedPackageCopyWith<$Res> {
  __$LikedPackageCopyWithImpl(this._self, this._then);

  final _LikedPackage _self;
  final $Res Function(_LikedPackage) _then;

  /// Create a copy of LikedPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? package = null,
    Object? liked = null,
  }) {
    return _then(_LikedPackage(
      package: null == package
          ? _self.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      liked: null == liked
          ? _self.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

LikedPackagesResponse _$LikedPackagesResponseFromJson(
    Map<String, dynamic> json) {
  return _LikesPackagesResponse.fromJson(json);
}

/// @nodoc
mixin _$LikedPackagesResponse implements DiagnosticableTreeMixin {
  List<LikedPackage> get likedPackages;

  /// Create a copy of LikedPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LikedPackagesResponseCopyWith<LikedPackagesResponse> get copyWith =>
      _$LikedPackagesResponseCopyWithImpl<LikedPackagesResponse>(
          this as LikedPackagesResponse, _$identity);

  /// Serializes this LikedPackagesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackagesResponse'))
      ..add(DiagnosticsProperty('likedPackages', likedPackages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LikedPackagesResponse &&
            const DeepCollectionEquality()
                .equals(other.likedPackages, likedPackages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(likedPackages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackagesResponse(likedPackages: $likedPackages)';
  }
}

/// @nodoc
abstract mixin class $LikedPackagesResponseCopyWith<$Res> {
  factory $LikedPackagesResponseCopyWith(LikedPackagesResponse value,
          $Res Function(LikedPackagesResponse) _then) =
      _$LikedPackagesResponseCopyWithImpl;
  @useResult
  $Res call({List<LikedPackage> likedPackages});
}

/// @nodoc
class _$LikedPackagesResponseCopyWithImpl<$Res>
    implements $LikedPackagesResponseCopyWith<$Res> {
  _$LikedPackagesResponseCopyWithImpl(this._self, this._then);

  final LikedPackagesResponse _self;
  final $Res Function(LikedPackagesResponse) _then;

  /// Create a copy of LikedPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? likedPackages = null,
  }) {
    return _then(_self.copyWith(
      likedPackages: null == likedPackages
          ? _self.likedPackages
          : likedPackages // ignore: cast_nullable_to_non_nullable
              as List<LikedPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LikesPackagesResponse
    with DiagnosticableTreeMixin
    implements LikedPackagesResponse {
  _LikesPackagesResponse({required final List<LikedPackage> likedPackages})
      : _likedPackages = likedPackages;
  factory _LikesPackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$LikesPackagesResponseFromJson(json);

  final List<LikedPackage> _likedPackages;
  @override
  List<LikedPackage> get likedPackages {
    if (_likedPackages is EqualUnmodifiableListView) return _likedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedPackages);
  }

  /// Create a copy of LikedPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LikesPackagesResponseCopyWith<_LikesPackagesResponse> get copyWith =>
      __$LikesPackagesResponseCopyWithImpl<_LikesPackagesResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LikesPackagesResponseToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LikedPackagesResponse'))
      ..add(DiagnosticsProperty('likedPackages', likedPackages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LikesPackagesResponse &&
            const DeepCollectionEquality()
                .equals(other._likedPackages, _likedPackages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_likedPackages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikedPackagesResponse(likedPackages: $likedPackages)';
  }
}

/// @nodoc
abstract mixin class _$LikesPackagesResponseCopyWith<$Res>
    implements $LikedPackagesResponseCopyWith<$Res> {
  factory _$LikesPackagesResponseCopyWith(_LikesPackagesResponse value,
          $Res Function(_LikesPackagesResponse) _then) =
      __$LikesPackagesResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<LikedPackage> likedPackages});
}

/// @nodoc
class __$LikesPackagesResponseCopyWithImpl<$Res>
    implements _$LikesPackagesResponseCopyWith<$Res> {
  __$LikesPackagesResponseCopyWithImpl(this._self, this._then);

  final _LikesPackagesResponse _self;
  final $Res Function(_LikesPackagesResponse) _then;

  /// Create a copy of LikedPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? likedPackages = null,
  }) {
    return _then(_LikesPackagesResponse(
      likedPackages: null == likedPackages
          ? _self._likedPackages
          : likedPackages // ignore: cast_nullable_to_non_nullable
              as List<LikedPackage>,
    ));
  }
}

/// @nodoc
mixin _$PubPackagesResponse implements DiagnosticableTreeMixin {
  List<Package> get packages;

  /// Create a copy of PubPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PubPackagesResponseCopyWith<PubPackagesResponse> get copyWith =>
      _$PubPackagesResponseCopyWithImpl<PubPackagesResponse>(
          this as PubPackagesResponse, _$identity);

  /// Serializes this PubPackagesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PubPackagesResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PubPackagesResponse &&
            const DeepCollectionEquality().equals(other.packages, packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(packages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubPackagesResponse(packages: $packages)';
  }
}

/// @nodoc
abstract mixin class $PubPackagesResponseCopyWith<$Res> {
  factory $PubPackagesResponseCopyWith(
          PubPackagesResponse value, $Res Function(PubPackagesResponse) _then) =
      _$PubPackagesResponseCopyWithImpl;
  @useResult
  $Res call({List<Package> packages});
}

/// @nodoc
class _$PubPackagesResponseCopyWithImpl<$Res>
    implements $PubPackagesResponseCopyWith<$Res> {
  _$PubPackagesResponseCopyWithImpl(this._self, this._then);

  final PubPackagesResponse _self;
  final $Res Function(PubPackagesResponse) _then;

  /// Create a copy of PubPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_self.copyWith(
      packages: null == packages
          ? _self.packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<Package>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PubPackagesResponse
    with DiagnosticableTreeMixin
    implements PubPackagesResponse {
  _PubPackagesResponse({required final List<Package> packages})
      : _packages = packages;
  factory _PubPackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$PubPackagesResponseFromJson(json);

  final List<Package> _packages;
  @override
  List<Package> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  /// Create a copy of PubPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PubPackagesResponseCopyWith<_PubPackagesResponse> get copyWith =>
      __$PubPackagesResponseCopyWithImpl<_PubPackagesResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PubPackagesResponseToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PubPackagesResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PubPackagesResponse &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubPackagesResponse(packages: $packages)';
  }
}

/// @nodoc
abstract mixin class _$PubPackagesResponseCopyWith<$Res>
    implements $PubPackagesResponseCopyWith<$Res> {
  factory _$PubPackagesResponseCopyWith(_PubPackagesResponse value,
          $Res Function(_PubPackagesResponse) _then) =
      __$PubPackagesResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<Package> packages});
}

/// @nodoc
class __$PubPackagesResponseCopyWithImpl<$Res>
    implements _$PubPackagesResponseCopyWith<$Res> {
  __$PubPackagesResponseCopyWithImpl(this._self, this._then);

  final _PubPackagesResponse _self;
  final $Res Function(_PubPackagesResponse) _then;

  /// Create a copy of PubPackagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? packages = null,
  }) {
    return _then(_PubPackagesResponse(
      packages: null == packages
          ? _self._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<Package>,
    ));
  }
}

/// @nodoc
mixin _$SearchPackage implements DiagnosticableTreeMixin {
  String get package;

  /// Create a copy of SearchPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchPackageCopyWith<SearchPackage> get copyWith =>
      _$SearchPackageCopyWithImpl<SearchPackage>(
          this as SearchPackage, _$identity);

  /// Serializes this SearchPackage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SearchPackage'))
      ..add(DiagnosticsProperty('package', package));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchPackage &&
            (identical(other.package, package) || other.package == package));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, package);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SearchPackage(package: $package)';
  }
}

/// @nodoc
abstract mixin class $SearchPackageCopyWith<$Res> {
  factory $SearchPackageCopyWith(
          SearchPackage value, $Res Function(SearchPackage) _then) =
      _$SearchPackageCopyWithImpl;
  @useResult
  $Res call({String package});
}

/// @nodoc
class _$SearchPackageCopyWithImpl<$Res>
    implements $SearchPackageCopyWith<$Res> {
  _$SearchPackageCopyWithImpl(this._self, this._then);

  final SearchPackage _self;
  final $Res Function(SearchPackage) _then;

  /// Create a copy of SearchPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? package = null,
  }) {
    return _then(_self.copyWith(
      package: null == package
          ? _self.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SearchPackage with DiagnosticableTreeMixin implements SearchPackage {
  _SearchPackage({required this.package});
  factory _SearchPackage.fromJson(Map<String, dynamic> json) =>
      _$SearchPackageFromJson(json);

  @override
  final String package;

  /// Create a copy of SearchPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchPackageCopyWith<_SearchPackage> get copyWith =>
      __$SearchPackageCopyWithImpl<_SearchPackage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchPackageToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'SearchPackage'))
      ..add(DiagnosticsProperty('package', package));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchPackage &&
            (identical(other.package, package) || other.package == package));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, package);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SearchPackage(package: $package)';
  }
}

/// @nodoc
abstract mixin class _$SearchPackageCopyWith<$Res>
    implements $SearchPackageCopyWith<$Res> {
  factory _$SearchPackageCopyWith(
          _SearchPackage value, $Res Function(_SearchPackage) _then) =
      __$SearchPackageCopyWithImpl;
  @override
  @useResult
  $Res call({String package});
}

/// @nodoc
class __$SearchPackageCopyWithImpl<$Res>
    implements _$SearchPackageCopyWith<$Res> {
  __$SearchPackageCopyWithImpl(this._self, this._then);

  final _SearchPackage _self;
  final $Res Function(_SearchPackage) _then;

  /// Create a copy of SearchPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? package = null,
  }) {
    return _then(_SearchPackage(
      package: null == package
          ? _self.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PubSearchResponse implements DiagnosticableTreeMixin {
  List<SearchPackage> get packages;

  /// Create a copy of PubSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PubSearchResponseCopyWith<PubSearchResponse> get copyWith =>
      _$PubSearchResponseCopyWithImpl<PubSearchResponse>(
          this as PubSearchResponse, _$identity);

  /// Serializes this PubSearchResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PubSearchResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PubSearchResponse &&
            const DeepCollectionEquality().equals(other.packages, packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(packages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubSearchResponse(packages: $packages)';
  }
}

/// @nodoc
abstract mixin class $PubSearchResponseCopyWith<$Res> {
  factory $PubSearchResponseCopyWith(
          PubSearchResponse value, $Res Function(PubSearchResponse) _then) =
      _$PubSearchResponseCopyWithImpl;
  @useResult
  $Res call({List<SearchPackage> packages});
}

/// @nodoc
class _$PubSearchResponseCopyWithImpl<$Res>
    implements $PubSearchResponseCopyWith<$Res> {
  _$PubSearchResponseCopyWithImpl(this._self, this._then);

  final PubSearchResponse _self;
  final $Res Function(PubSearchResponse) _then;

  /// Create a copy of PubSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packages = null,
  }) {
    return _then(_self.copyWith(
      packages: null == packages
          ? _self.packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SearchPackage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PubSearchResponse
    with DiagnosticableTreeMixin
    implements PubSearchResponse {
  _PubSearchResponse({required final List<SearchPackage> packages})
      : _packages = packages;
  factory _PubSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PubSearchResponseFromJson(json);

  final List<SearchPackage> _packages;
  @override
  List<SearchPackage> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  /// Create a copy of PubSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PubSearchResponseCopyWith<_PubSearchResponse> get copyWith =>
      __$PubSearchResponseCopyWithImpl<_PubSearchResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PubSearchResponseToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PubSearchResponse'))
      ..add(DiagnosticsProperty('packages', packages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PubSearchResponse &&
            const DeepCollectionEquality().equals(other._packages, _packages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_packages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PubSearchResponse(packages: $packages)';
  }
}

/// @nodoc
abstract mixin class _$PubSearchResponseCopyWith<$Res>
    implements $PubSearchResponseCopyWith<$Res> {
  factory _$PubSearchResponseCopyWith(
          _PubSearchResponse value, $Res Function(_PubSearchResponse) _then) =
      __$PubSearchResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<SearchPackage> packages});
}

/// @nodoc
class __$PubSearchResponseCopyWithImpl<$Res>
    implements _$PubSearchResponseCopyWith<$Res> {
  __$PubSearchResponseCopyWithImpl(this._self, this._then);

  final _PubSearchResponse _self;
  final $Res Function(_PubSearchResponse) _then;

  /// Create a copy of PubSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? packages = null,
  }) {
    return _then(_PubSearchResponse(
      packages: null == packages
          ? _self._packages
          : packages // ignore: cast_nullable_to_non_nullable
              as List<SearchPackage>,
    ));
  }
}

// dart format on
