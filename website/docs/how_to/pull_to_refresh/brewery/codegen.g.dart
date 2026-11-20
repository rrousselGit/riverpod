// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Brewery _$BreweryFromJson(Map<String, dynamic> json) => _Brewery(
  name: json['name'] as String,
  breweryType: json['brewery_type'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
);

Map<String, dynamic> _$BreweryToJson(_Brewery instance) => <String, dynamic>{
  'name': instance.name,
  'brewery_type': instance.breweryType,
  'city': instance.city,
  'country': instance.country,
};
