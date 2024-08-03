// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'tag.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef TagThemeRef = Ref<TagTheme>;

@ProviderFor(tagTheme)
const tagThemeProvider = TagThemeProvider._();

final class TagThemeProvider extends $FunctionalProvider<TagTheme, TagTheme>
    with $Provider<TagTheme, TagThemeRef> {
  const TagThemeProvider._(
      {TagTheme Function(
        TagThemeRef ref,
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
    TagThemeRef ref,
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
      TagThemeRef ref,
    ) create,
  ) {
    return TagThemeProvider._(create: create);
  }

  @override
  TagTheme create(TagThemeRef ref) {
    final _$cb = _createCb ?? tagTheme;
    return _$cb(ref);
  }
}

String _$tagThemeHash() => r'bf5d051ea43e2f60d370096bb756aa81f21e9d68';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
