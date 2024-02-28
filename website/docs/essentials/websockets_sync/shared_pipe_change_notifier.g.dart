// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'shared_pipe_change_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef MyListenableRef = Ref<Raw<ValueNotifier<int>>>;

@ProviderFor(myListenable)
const myListenableProvider = MyListenableProvider._();

final class MyListenableProvider extends $FunctionalProvider<
    Raw<ValueNotifier<int>>,
    Raw<ValueNotifier<int>>,
    MyListenableRef> with $Provider<Raw<ValueNotifier<int>>, MyListenableRef> {
  const MyListenableProvider._(
      {Raw<ValueNotifier<int>> Function(
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

  final Raw<ValueNotifier<int>> Function(
    MyListenableRef ref,
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
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  MyListenableProvider $copyWithCreate(
    Raw<ValueNotifier<int>> Function(
      MyListenableRef ref,
    ) create,
  ) {
    return MyListenableProvider._(create: create);
  }

  @override
  Raw<ValueNotifier<int>> create(MyListenableRef ref) {
    final _$cb = _createCb ?? myListenable;
    return _$cb(ref);
  }
}

String _$myListenableHash() => r'90f4227ef5442f978d742115663e5f0869622a27';

typedef AnotherListenableRef = Ref<Raw<ValueNotifier<int>>>;

@ProviderFor(anotherListenable)
const anotherListenableProvider = AnotherListenableProvider._();

final class AnotherListenableProvider extends $FunctionalProvider<
        Raw<ValueNotifier<int>>, Raw<ValueNotifier<int>>, AnotherListenableRef>
    with $Provider<Raw<ValueNotifier<int>>, AnotherListenableRef> {
  const AnotherListenableProvider._(
      {Raw<ValueNotifier<int>> Function(
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

  final Raw<ValueNotifier<int>> Function(
    AnotherListenableRef ref,
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
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AnotherListenableProvider $copyWithCreate(
    Raw<ValueNotifier<int>> Function(
      AnotherListenableRef ref,
    ) create,
  ) {
    return AnotherListenableProvider._(create: create);
  }

  @override
  Raw<ValueNotifier<int>> create(AnotherListenableRef ref) {
    final _$cb = _createCb ?? anotherListenable;
    return _$cb(ref);
  }
}

String _$anotherListenableHash() => r'50dd36b21e07c50818944ec49f9e68d21fcae876';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
