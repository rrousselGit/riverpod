// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)

/// Representation of a Markdown document with frontmatter.
@immutable
class Document<T> {
  const Document({required this.frontmatter, required this.body});

  factory Document.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$DocumentFromJson(json, fromJsonT);

  final T frontmatter;
  final String body;

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$DocumentToJson(this, toJsonT);

  @override
  int get hashCode => Object.hash(
        frontmatter.hashCode,
        body,
      );

  @override
  bool operator ==(Object other) {
    return other is Document<T> &&
        other.body == body &&
        other.frontmatter.toString() == frontmatter.toString();
  }
}
