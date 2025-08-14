// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeNotifier)
const themeNotifierProvider = ThemeNotifierProvider._();

final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, ThemeSettings> {
  const ThemeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeSettings>(value),
    );
  }
}

String _$themeNotifierHash() => r'e119d56d9bf8b8d7c19624997f99d116098b45e9';

abstract class _$ThemeNotifier extends $Notifier<ThemeSettings> {
  ThemeSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ThemeSettings, ThemeSettings>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ThemeSettings, ThemeSettings>,
        ThemeSettings,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
