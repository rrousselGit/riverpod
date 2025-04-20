// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
      activity: json['activity'] as String,
      type: json['type'] as String,
      participants: (json['participants'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
      'activity': instance.activity,
      'type': instance.type,
      'participants': instance.participants,
      'price': instance.price,
    };
