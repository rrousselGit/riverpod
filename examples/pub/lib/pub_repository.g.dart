// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'pub_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageMetricsScoreImpl _$$PackageMetricsScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$PackageMetricsScoreImpl(
      grantedPoints: json['grantedPoints'] as int,
      maxPoints: json['maxPoints'] as int,
      likeCount: json['likeCount'] as int,
      popularityScore: (json['popularityScore'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PackageMetricsScoreImplToJson(
        _$PackageMetricsScoreImpl instance) =>
    <String, dynamic>{
      'grantedPoints': instance.grantedPoints,
      'maxPoints': instance.maxPoints,
      'likeCount': instance.likeCount,
      'popularityScore': instance.popularityScore,
      'tags': instance.tags,
    };

_$PackageMetricsResponseImpl _$$PackageMetricsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PackageMetricsResponseImpl(
      score:
          PackageMetricsScore.fromJson(json['score'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PackageMetricsResponseImplToJson(
        _$PackageMetricsResponseImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
    };

_$PackageDetailsImpl _$$PackageDetailsImplFromJson(Map<String, dynamic> json) =>
    _$PackageDetailsImpl(
      version: json['version'] as String,
      pubspec: Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PackageDetailsImplToJson(
        _$PackageDetailsImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pubspec': instance.pubspec,
    };

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      name: json['name'] as String,
      latest: PackageDetails.fromJson(json['latest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latest': instance.latest,
    };

_$LikedPackageImpl _$$LikedPackageImplFromJson(Map<String, dynamic> json) =>
    _$LikedPackageImpl(
      package: json['package'] as String,
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$$LikedPackageImplToJson(_$LikedPackageImpl instance) =>
    <String, dynamic>{
      'package': instance.package,
      'liked': instance.liked,
    };

_$LikesPackagesResponseImpl _$$LikesPackagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LikesPackagesResponseImpl(
      likedPackages: (json['likedPackages'] as List<dynamic>)
          .map((e) => LikedPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LikesPackagesResponseImplToJson(
        _$LikesPackagesResponseImpl instance) =>
    <String, dynamic>{
      'likedPackages': instance.likedPackages,
    };

_$PubPackagesResponseImpl _$$PubPackagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PubPackagesResponseImpl(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => Package.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PubPackagesResponseImplToJson(
        _$PubPackagesResponseImpl instance) =>
    <String, dynamic>{
      'packages': instance.packages,
    };

_$SearchPackageImpl _$$SearchPackageImplFromJson(Map<String, dynamic> json) =>
    _$SearchPackageImpl(
      package: json['package'] as String,
    );

Map<String, dynamic> _$$SearchPackageImplToJson(_$SearchPackageImpl instance) =>
    <String, dynamic>{
      'package': instance.package,
    };

_$PubSearchResponseImpl _$$PubSearchResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PubSearchResponseImpl(
      packages: (json['packages'] as List<dynamic>)
          .map((e) => SearchPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PubSearchResponseImplToJson(
        _$PubSearchResponseImpl instance) =>
    <String, dynamic>{
      'packages': instance.packages,
    };
