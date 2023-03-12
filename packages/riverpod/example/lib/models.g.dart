// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Configuration _$$_ConfigurationFromJson(Map<String, dynamic> json) =>
    _$_Configuration(
      publicKey: json['public_key'] as String,
      privateKey: json['private_key'] as String,
    );

Map<String, dynamic> _$$_ConfigurationToJson(_$_Configuration instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'private_key': instance.privateKey,
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
    );

Map<String, dynamic> _$$_MarvelDataToJson(_$_MarvelData instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$_Comic _$$_ComicFromJson(Map<String, dynamic> json) => _$_Comic(
      id: json['id'] as int,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$_ComicToJson(_$_Comic instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
