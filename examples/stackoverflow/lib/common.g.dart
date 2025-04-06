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
final class ThemeProvider extends $FunctionalProvider<ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// A Provider that exposes the current theme.
  ///
  /// This is unimplemented by default, and will be overridden inside [MaterialApp]
  /// with the current theme obtained using a [BuildContext].
  const ThemeProvider._(
      {ThemeData Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final ThemeData Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$themeHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ThemeData>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ThemeProvider $copyWithCreate(
    ThemeData Function(
      Ref ref,
    ) create,
  ) {
    return ThemeProvider._(create: create);
  }

  @override
  ThemeData create(Ref ref) {
    final _$cb = _createCb ?? theme;
    return _$cb(ref);
  }
}

String _$themeHash() => r'0fea6438c8bee8be98515c10e8e67c2e75c6af46';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
