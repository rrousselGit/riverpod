// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shared_pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef MyListenableRef = Ref<ValueNotifier<int>>;

@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

final class MyListenableProvider extends $FunctionalProvider<
    ValueNotifier<int>,
    ValueNotifier<int>,
    MyListenableRef> with $Provider<ValueNotifier<int>, MyListenableRef> {
  const MyListenableProvider._(
      {ValueNotifier<int> Function(
        MyListenableRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ValueNotifier<int> Function(
    MyListenableRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ValueNotifier<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ValueNotifier<int>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<ValueNotifier<int>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  MyListenableProvider $copyWithCreate(
    ValueNotifier<int> Function(
      MyListenableRef ref,
    ) create,
  ) {
    return MyListenableProvider._(create: create);
  }

  @override
  ValueNotifier<int> create(MyListenableRef ref) {
    final _$cb = _createCb ?? myListenable;
    return _$cb(ref);
  }
}

String _$myListenableHash() => r'7096094cd24ed50dbabb9fb9ab64b340176c04bf';

typedef AnotherListenableRef = Ref<ValueNotifier<int>>;

@ProviderFor(anotherListenable)
const anotherListenableProvider = AnotherListenableProvider._();

final class AnotherListenableProvider extends $FunctionalProvider<
        ValueNotifier<int>, ValueNotifier<int>, AnotherListenableRef>
    with $Provider<ValueNotifier<int>, AnotherListenableRef> {
  const AnotherListenableProvider._(
      {ValueNotifier<int> Function(
        AnotherListenableRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'anotherListenableProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ValueNotifier<int> Function(
    AnotherListenableRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherListenableHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ValueNotifier<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ValueNotifier<int>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<ValueNotifier<int>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AnotherListenableProvider $copyWithCreate(
    ValueNotifier<int> Function(
      AnotherListenableRef ref,
    ) create,
  ) {
    return AnotherListenableProvider._(create: create);
  }

  @override
  ValueNotifier<int> create(AnotherListenableRef ref) {
    final _$cb = _createCb ?? anotherListenable;
    return _$cb(ref);
  }
}

String _$anotherListenableHash() => r'38bfe5dbf5f148819b3671ad69d15c8e05264c23';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
