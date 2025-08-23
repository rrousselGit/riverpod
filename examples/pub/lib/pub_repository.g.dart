// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'pub_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageMetricsScore _$PackageMetricsScoreFromJson(Map<String, dynamic> json) =>
    _PackageMetricsScore(
      grantedPoints: (json['grantedPoints'] as num).toInt(),
      maxPoints: (json['maxPoints'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      popularityScore: (json['popularityScore'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PackageMetricsScoreToJson(
  _PackageMetricsScore instance,
) => <String, dynamic>{
  'grantedPoints': instance.grantedPoints,
  'maxPoints': instance.maxPoints,
  'likeCount': instance.likeCount,
  'popularityScore': instance.popularityScore,
  'tags': instance.tags,
};

_PackageMetricsResponse _$PackageMetricsResponseFromJson(
  Map<String, dynamic> json,
) => _PackageMetricsResponse(
  score: PackageMetricsScore.fromJson(json['score'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PackageMetricsResponseToJson(
  _PackageMetricsResponse instance,
) => <String, dynamic>{'score': instance.score};

_PackageDetails _$PackageDetailsFromJson(Map<String, dynamic> json) =>
    _PackageDetails(
      version: json['version'] as String,
      pubspec: Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PackageDetailsToJson(_PackageDetails instance) =>
    <String, dynamic>{'version': instance.version, 'pubspec': instance.pubspec};

_Package _$PackageFromJson(Map<String, dynamic> json) => _Package(
  name: json['name'] as String,
  latest: PackageDetails.fromJson(json['latest'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PackageToJson(_Package instance) => <String, dynamic>{
  'name': instance.name,
  'latest': instance.latest,
};

_LikedPackage _$LikedPackageFromJson(Map<String, dynamic> json) =>
    _LikedPackage(
      package: json['package'] as String,
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$LikedPackageToJson(_LikedPackage instance) =>
    <String, dynamic>{'package': instance.package, 'liked': instance.liked};

_LikesPackagesResponse _$LikesPackagesResponseFromJson(
  Map<String, dynamic> json,
) => _LikesPackagesResponse(
  likedPackages: (json['likedPackages'] as List<dynamic>)
      .map((e) => LikedPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LikesPackagesResponseToJson(
  _LikesPackagesResponse instance,
) => <String, dynamic>{'likedPackages': instance.likedPackages};

_PubPackagesResponse _$PubPackagesResponseFromJson(Map<String, dynamic> json) =>
    _PubPackagesResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => Package.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PubPackagesResponseToJson(
  _PubPackagesResponse instance,
) => <String, dynamic>{'packages': instance.packages};

_SearchPackage _$SearchPackageFromJson(Map<String, dynamic> json) =>
    _SearchPackage(package: json['package'] as String);

Map<String, dynamic> _$SearchPackageToJson(_SearchPackage instance) =>
    <String, dynamic>{'package': instance.package};

_PubSearchResponse _$PubSearchResponseFromJson(Map<String, dynamic> json) =>
    _PubSearchResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => SearchPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PubSearchResponseToJson(_PubSearchResponse instance) =>
    <String, dynamic>{'packages': instance.packages};
