// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mock_frontmatter.freezed.dart';
part 'mock_frontmatter.g.dart';

@freezed
class MockFrontmatter with _$MockFrontmatter {
  const factory MockFrontmatter({
    required String title,
    required String author,
    required String excerpt,
    required String category,
    required String date,
  }) = _MockFrontmatter;

  const MockFrontmatter._();

  factory MockFrontmatter.fromJson(Map<String, dynamic> json) =>
      _$MockFrontmatterFromJson(json);
}
