// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
// {@endtemplate}
@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

/// A provider which creates a ValueNotifier and update its listeners
/// whenever the value changes.
// {@endtemplate}
final class MyListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>> with $Provider<Raw<ValueNotifier<int>>> {
  /// A provider which creates a ValueNotifier and update its listeners
  /// whenever the value changes.
// {@endtemplate}
  const MyListenableProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myListenableHash();

  @$internal
  @override
  $ProviderElement<Raw<ValueNotifier<int>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw<ValueNotifier<int>> create(Ref ref) {
    return myListenable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<ValueNotifier<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }
}

String _$myListenableHash() => r'11b973997ad9787b8f775746d7a87211df2cb6bb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
