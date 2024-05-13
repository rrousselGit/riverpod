// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigurationImpl _$$ConfigurationImplFromJson(Map<String, dynamic> json) =>
    _$ConfigurationImpl(
      publicKey: json['public_key'] as String,
      privateKey: json['private_key'] as String,
    );

Map<String, dynamic> _$$ConfigurationImplToJson(_$ConfigurationImpl instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'private_key': instance.privateKey,
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
    );

Map<String, dynamic> _$$MarvelDataImplToJson(_$MarvelDataImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$ComicImpl _$$ComicImplFromJson(Map<String, dynamic> json) => _$ComicImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$$ComicImplToJson(_$ComicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
