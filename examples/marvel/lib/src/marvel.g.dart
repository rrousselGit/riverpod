// GENERATED CODE - DO NOT MODIFY BY HAND

part of marvel;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Character _$$_CharacterFromJson(Map<String, dynamic> json) => _$_Character(
      id: json['id'] as int,
      name: json['name'] as String,
      thumbnail: Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CharacterToJson(_$_Character instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
    };

_$_Thumbnail _$$_ThumbnailFromJson(Map<String, dynamic> json) => _$_Thumbnail(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$$_ThumbnailToJson(_$_Thumbnail instance) =>
    <String, dynamic>{
      'path': instance.path,
      'extension': instance.extension,
    };

_$_MarvelResponse _$$_MarvelResponseFromJson(Map<String, dynamic> json) =>
    _$_MarvelResponse(
      MarvelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MarvelResponseToJson(_$_MarvelResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$_MarvelData _$$_MarvelDataFromJson(Map<String, dynamic> json) =>
    _$_MarvelData(
      (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      json['total'] as int,
    );

Map<String, dynamic> _$$_MarvelDataToJson(_$_MarvelData instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
    };
