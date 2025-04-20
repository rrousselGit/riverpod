// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

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
