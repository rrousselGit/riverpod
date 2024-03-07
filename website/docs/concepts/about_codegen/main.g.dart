// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FetchUserRef = Ref<AsyncValue<User>>;

@ProviderFor(fetchUser)
const fetchUserProvider = FetchUserFamily._();

final class FetchUserProvider
    extends $FunctionalProvider<AsyncValue<User>, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User, FetchUserRef> {
  const FetchUserProvider._(
      {required FetchUserFamily super.from,
      required int super.argument,
      FutureOr<User> Function(
        FetchUserRef ref, {
        required int userId,
      })? create})
      : _createCb = create,
        super(
          name: r'fetchUserProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<User> Function(
    FetchUserRef ref, {
    required int userId,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fetchUserHash();

  @override
  String toString() {
    return r'fetchUserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FetchUserProvider $copyWithCreate(
    FutureOr<User> Function(
      FetchUserRef ref,
    ) create,
  ) {
    return FetchUserProvider._(
        argument: argument as int,
        from: from! as FetchUserFamily,
        create: (
          ref, {
          required int userId,
        }) =>
            create(ref));
  }

  @override
  FutureOr<User> create(FetchUserRef ref) {
    final _$cb = _createCb ?? fetchUser;
    final argument = this.argument as int;
    return _$cb(
      ref,
      userId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchUserHash() => r'ff427bbb4130a8a6994fa623ae70997f7b0f6bdb';

final class FetchUserFamily extends Family {
  const FetchUserFamily._()
      : super(
          name: r'fetchUserProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FetchUserProvider call({
    required int userId,
  }) =>
      FetchUserProvider._(argument: userId, from: this);

  @override
  String debugGetCreateSourceHash() => _$fetchUserHash();

  @override
  String toString() => r'fetchUserProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<User> Function(
      FetchUserRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as FetchUserProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
