// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'common.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A Provider that exposes the current theme.
///
/// This is unimplemented by default, and will be overridden inside [MaterialApp]
/// with the current theme obtained using a [BuildContext].
@ProviderFor(theme)
const themeProvider = ThemeProvider._();

/// A Provider that exposes the current theme.
///
/// This is unimplemented by default, and will be overridden inside [MaterialApp]
/// with the current theme obtained using a [BuildContext].
final class ThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// A Provider that exposes the current theme.
  ///
  /// This is unimplemented by default, and will be overridden inside [MaterialApp]
  /// with the current theme obtained using a [BuildContext].
  const ThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          $allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$themeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return theme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ThemeData, ThemeData>(value),
    );
  }
}

String _$themeHash() => r'0fea6438c8bee8be98515c10e8e67c2e75c6af46';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
