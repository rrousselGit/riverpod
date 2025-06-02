// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'tag.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(tagTheme)
const tagThemeProvider = TagThemeProvider._();

final class TagThemeProvider
    extends $FunctionalProvider<TagTheme, TagTheme, TagTheme>
    with $Provider<TagTheme> {
  const TagThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tagThemeProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[themeProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            TagThemeProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = themeProvider;

  @override
  String debugGetCreateSourceHash() => _$tagThemeHash();

  @$internal
  @override
  $ProviderElement<TagTheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TagTheme create(Ref ref) {
    return tagTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<TagTheme, TagTheme>(value),
    );
  }
}

String _$tagThemeHash() => r'ccf06d5f6b009c601edd44f88bf4f853708c38df';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
