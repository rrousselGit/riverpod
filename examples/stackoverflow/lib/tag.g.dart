// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'tag.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagTheme)
final tagThemeProvider = TagThemeProvider._();

final class TagThemeProvider
    extends $FunctionalProvider<TagTheme, TagTheme, TagTheme>
    with $Provider<TagTheme> {
  TagThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagThemeProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[themeProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          TagThemeProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = themeProvider;

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
      providerOverride: $SyncValueProvider<TagTheme>(value),
    );
  }
}

String _$tagThemeHash() => r'ccf06d5f6b009c601edd44f88bf4f853708c38df';
