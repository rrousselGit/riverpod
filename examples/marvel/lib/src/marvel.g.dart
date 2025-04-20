// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marvel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Character _$CharacterFromJson(Map<String, dynamic> json) => _Character(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      thumbnail: Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterToJson(_Character instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
    };

_Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => _Thumbnail(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$ThumbnailToJson(_Thumbnail instance) =>
    <String, dynamic>{
      'path': instance.path,
      'extension': instance.extension,
    };

_MarvelResponse _$MarvelResponseFromJson(Map<String, dynamic> json) =>
    _MarvelResponse(
      MarvelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MarvelResponseToJson(_MarvelResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_MarvelData _$MarvelDataFromJson(Map<String, dynamic> json) => _MarvelData(
      (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MarvelDataToJson(_MarvelData instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
    };
