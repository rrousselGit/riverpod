// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'tag.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(tagTheme)
const tagThemeProvider = TagThemeProvider._();

final class TagThemeProvider extends $FunctionalProvider<TagTheme, TagTheme>
    with $Provider<TagTheme> {
  const TagThemeProvider._(
      {TagTheme Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'tagThemeProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[themeProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            TagThemeProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = themeProvider;

  final TagTheme Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$tagThemeHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<TagTheme>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<TagTheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  TagThemeProvider $copyWithCreate(
    TagTheme Function(
      Ref ref,
    ) create,
  ) {
    return TagThemeProvider._(create: create);
  }

  @override
  TagTheme create(Ref ref) {
    final _$cb = _createCb ?? tagTheme;
    return _$cb(ref);
  }
}

String _$tagThemeHash() => r'ccf06d5f6b009c601edd44f88bf4f853708c38df';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
