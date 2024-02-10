// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef UserRef = Ref<AsyncValue<User>>;

@ProviderFor(user)
const userProvider = UserProvider._();

final class UserProvider
    extends $FunctionalProvider<AsyncValue<User>, FutureOr<User>, UserRef>
    with $FutureModifier<User>, $FutureProvider<User, UserRef> {
  const UserProvider._(
      {FutureOr<User> Function(
        UserRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'userProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<User> Function(
    UserRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$userHash();

  @$internal
  @override
  $FutureProviderElement<User> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  UserProvider $copyWithCreate(
    FutureOr<User> Function(
      UserRef ref,
    ) create,
  ) {
    return UserProvider._(create: create);
  }

  @override
  FutureOr<User> create(UserRef ref) {
    final _$cb = _createCb ?? user;
    return _$cb(ref);
  }
}

String _$userHash() => r'01b30f814d2a91385bc2279fd51d073a4a5b0f06';

typedef ExampleRef = Ref<Object?>;

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<Object?, Object?, ExampleRef>
    with $Provider<Object?, ExampleRef> {
  const ExampleProvider._(
      {Object? Function(
        ExampleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Object? Function(
    ExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ExampleProvider $copyWithCreate(
    Object? Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  Object? create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'1fccbdbec0e3585bc9d3a5709ac88a8919dd78fa';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
