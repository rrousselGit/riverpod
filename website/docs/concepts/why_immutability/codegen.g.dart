// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ThemeNotifier)
const themeNotifierProvider = ThemeNotifierProvider._();

final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, ThemeSettings> {
  const ThemeNotifierProvider._(
      {super.runNotifierBuildOverride, ThemeNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'themeNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ThemeNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ThemeSettings>(value),
    );
  }

  @$internal
  @override
  ThemeNotifier create() => _createCb?.call() ?? ThemeNotifier();

  @$internal
  @override
  ThemeNotifierProvider $copyWithCreate(
    ThemeNotifier Function() create,
  ) {
    return ThemeNotifierProvider._(create: create);
  }

  @$internal
  @override
  ThemeNotifierProvider $copyWithBuild(
    ThemeSettings Function(
      Ref<ThemeSettings>,
      ThemeNotifier,
    ) build,
  ) {
    return ThemeNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ThemeNotifier, ThemeSettings> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$themeNotifierHash() => r'e119d56d9bf8b8d7c19624997f99d116098b45e9';

abstract class _$ThemeNotifier extends $Notifier<ThemeSettings> {
  ThemeSettings build();
  @$internal
  @override
  ThemeSettings runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
