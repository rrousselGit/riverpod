// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marvel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterImpl _$$CharacterImplFromJson(Map<String, dynamic> json) =>
    _$CharacterImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      thumbnail: Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CharacterImplToJson(_$CharacterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
    };

_$ThumbnailImpl _$$ThumbnailImplFromJson(Map<String, dynamic> json) =>
    _$ThumbnailImpl(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$$ThumbnailImplToJson(_$ThumbnailImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'extension': instance.extension,
    };

_$MarvelResponseImpl _$$MarvelResponseImplFromJson(Map<String, dynamic> json) =>
    _$MarvelResponseImpl(
      MarvelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MarvelResponseImplToJson(
        _$MarvelResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$MarvelDataImpl _$$MarvelDataImplFromJson(Map<String, dynamic> json) =>
    _$MarvelDataImpl(
      (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      json['total'] as int,
    );

Map<String, dynamic> _$$MarvelDataImplToJson(_$MarvelDataImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
    };
