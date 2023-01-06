// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document<T> _$DocumentFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Document<T>(
      frontmatter: fromJsonT(json['frontmatter']),
      body: json['body'] as String,
    );

Map<String, dynamic> _$DocumentToJson<T>(
  Document<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'frontmatter': toJsonT(instance.frontmatter),
      'body': instance.body,
    };
