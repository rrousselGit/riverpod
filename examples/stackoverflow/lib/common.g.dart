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
typedef ThemeRef = Ref<ThemeData>;

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
    with $Provider<ThemeData, ThemeRef> {
  /// A Provider that exposes the current theme.
  ///
  /// This is unimplemented by default, and will be overridden inside [MaterialApp]
  /// with the current theme obtained using a [BuildContext].
  const ThemeProvider._(
      {ThemeData Function(
        ThemeRef ref,
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
    ThemeRef ref,
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
      ThemeRef ref,
    ) create,
  ) {
    return ThemeProvider._(create: create);
  }

  @override
  ThemeData create(ThemeRef ref) {
    final _$cb = _createCb ?? theme;
    return _$cb(ref);
  }
}

String _$themeHash() => r'ff39eda97684261eefc24ddb24e41172880644cd';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
