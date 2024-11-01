// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shared_pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

final class MyListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>> with $Provider<Raw<ValueNotifier<int>>> {
  const MyListenableProvider._(
      {Raw<ValueNotifier<int>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'myListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<ValueNotifier<int>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<ValueNotifier<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<ValueNotifier<int>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  MyListenableProvider $copyWithCreate(
    Raw<ValueNotifier<int>> Function(
      Ref ref,
    ) create,
  ) {
    return MyListenableProvider._(create: create);
  }

  @override
  Raw<ValueNotifier<int>> create(Ref ref) {
    final _$cb = _createCb ?? myListenable;
    return _$cb(ref);
  }
}

String _$myListenableHash() => r'a28ce39430582e0d7be5f8303a31477569153193';

@ProviderFor(anotherListenable)
const anotherListenableProvider = AnotherListenableProvider._();

final class AnotherListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>> with $Provider<Raw<ValueNotifier<int>>> {
  const AnotherListenableProvider._(
      {Raw<ValueNotifier<int>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'anotherListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<ValueNotifier<int>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<ValueNotifier<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<ValueNotifier<int>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<ValueNotifier<int>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AnotherListenableProvider $copyWithCreate(
    Raw<ValueNotifier<int>> Function(
      Ref ref,
    ) create,
  ) {
    return AnotherListenableProvider._(create: create);
  }

  @override
  Raw<ValueNotifier<int>> create(Ref ref) {
    final _$cb = _createCb ?? anotherListenable;
    return _$cb(ref);
  }
}

String _$anotherListenableHash() => r'49aab48c26d8596262c3d89e0190baeaf9d7ac4a';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
