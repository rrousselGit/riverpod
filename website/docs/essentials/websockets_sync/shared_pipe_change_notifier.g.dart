// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shared_pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

final class MyListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>> with $Provider<Raw<ValueNotifier<int>>> {
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
      providerOverride: $SyncValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }
}

String _$myListenableHash() => r'a28ce39430582e0d7be5f8303a31477569153193';

@ProviderFor(anotherListenable)
const anotherListenableProvider = AnotherListenableProvider._();

final class AnotherListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>> with $Provider<Raw<ValueNotifier<int>>> {
  const AnotherListenableProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'anotherListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$anotherListenableHash();

  @$internal
  @override
  $ProviderElement<Raw<ValueNotifier<int>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw<ValueNotifier<int>> create(Ref ref) {
    return anotherListenable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<ValueNotifier<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }
}

String _$anotherListenableHash() => r'49aab48c26d8596262c3d89e0190baeaf9d7ac4a';
