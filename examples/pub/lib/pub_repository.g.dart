// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pub_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PackageMetricsScore _$$_PackageMetricsScoreFromJson(
        Map<String, dynamic> json) =>
    _$_PackageMetricsScore(
      grantedPoints: json['grantedPoints'] as int,
      maxPoints: json['maxPoints'] as int,
      likeCount: json['likeCount'] as int,
      popularityScore: (json['popularityScore'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_PackageMetricsScoreToJson(
        _$_PackageMetricsScore instance) =>
    <String, dynamic>{
      'grantedPoints': instance.grantedPoints,
      'maxPoints': instance.maxPoints,
      'likeCount': instance.likeCount,
      'popularityScore': instance.popularityScore,
      'tags': instance.tags,
    };

_$_PackageMetricsResponse _$$_PackageMetricsResponseFromJson(
        Map<String, dynamic> json) =>
    _$_PackageMetricsResponse(
      score:
          PackageMetricsScore.fromJson(json['score'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PackageMetricsResponseToJson(
        _$_PackageMetricsResponse instance) =>
    <String, dynamic>{
      'score': instance.score,
    };

_$_PackageDetails _$$_PackageDetailsFromJson(Map<String, dynamic> json) =>
    _$_PackageDetails(
      version: json['version'] as String,
      pubspec: Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PackageDetailsToJson(_$_PackageDetails instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pubspec': instance.pubspec,
    };

_$_Package _$$_PackageFromJson(Map<String, dynamic> json) => _$_Package(
      name: json['name'] as String,
      latest: PackageDetails.fromJson(json['latest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PackageToJson(_$_Package instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latest': instance.latest,
    };

_$_LikedPackage _$$_LikedPackageFromJson(Map<String, dynamic> json) =>
    _$_LikedPackage(
      package: json['package'] as String,
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$$_LikedPackageToJson(_$_LikedPackage instance) =>
    <String, dynamic>{
      'package': instance.package,
      'liked': instance.liked,
    };

_$_LikesPackagesResponse _$$_LikesPackagesResponseFromJson(
        Map<String, dynamic> json) =>
    _$_LikesPackagesResponse(
      likedPackages: (json['likedPackages'] as List<dynamic>)
          .map((e) => LikedPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_LikesPackagesResponseToJson(
        _$_LikesPackagesResponse instance) =>
    <String, dynamic>{
      'likedPackages': instance.likedPackages,
    };

_$_PubPackagesResponse _$$_PubPackagesResponseFromJson(
        Map<String, dynamic> json) =>
    _$_PubPackagesResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => Package.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_PubPackagesResponseToJson(
        _$_PubPackagesResponse instance) =>
    <String, dynamic>{
      'packages': instance.packages,
    };

_$_SearchPackage _$$_SearchPackageFromJson(Map<String, dynamic> json) =>
    _$_SearchPackage(
      package: json['package'] as String,
    );

Map<String, dynamic> _$$_SearchPackageToJson(_$_SearchPackage instance) =>
    <String, dynamic>{
      'package': instance.package,
    };

_$_PubSearchResponse _$$_PubSearchResponseFromJson(Map<String, dynamic> json) =>
    _$_PubSearchResponse(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => SearchPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_PubSearchResponseToJson(
        _$_PubSearchResponse instance) =>
    <String, dynamic>{
      'packages': instance.packages,
    };
