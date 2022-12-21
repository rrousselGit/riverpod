// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'frontmatter_parse_exception.freezed.dart';

/// Thrown when the frontmatter is not valid.
///
/// At the moment, the only exception is thrown when the frontmatter does not contain the delimiter.
@freezed
class FrontmatterParseException
    with _$FrontmatterParseException
    implements Exception {
  const factory FrontmatterParseException(String message) =
      _FrontmatterParseException;
  const factory FrontmatterParseException.delimiter([
    @Default('Frontmatter document must start with your delimiter.')
        String message,
  ]) = FrontmatterParseExceptionDelimiter;

  const FrontmatterParseException._();
}
