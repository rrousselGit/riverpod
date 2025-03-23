// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    _Configuration(
      publicKey: json['public_key'] as String,
      privateKey: json['private_key'] as String,
    );

Map<String, dynamic> _$ConfigurationToJson(_Configuration instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'private_key': instance.privateKey,
    };

_MarvelResponse _$MarvelResponseFromJson(Map<String, dynamic> json) =>
    _MarvelResponse(MarvelData.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$MarvelResponseToJson(_MarvelResponse instance) =>
    <String, dynamic>{'data': instance.data};

_MarvelData _$MarvelDataFromJson(Map<String, dynamic> json) => _MarvelData(
      (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$MarvelDataToJson(_MarvelData instance) =>
    <String, dynamic>{'results': instance.results};

_Comic _$ComicFromJson(Map<String, dynamic> json) =>
    _Comic(id: (json['id'] as num).toInt(), title: json['title'] as String);

Map<String, dynamic> _$ComicToJson(_Comic instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
