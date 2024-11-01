// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fetchUser)
const fetchUserProvider = FetchUserFamily._();

final class FetchUserProvider
    extends $FunctionalProvider<AsyncValue<User>, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  const FetchUserProvider._(
      {required FetchUserFamily super.from,
      required int super.argument,
      FutureOr<User> Function(
        Ref ref, {
        required int userId,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'fetchUserProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<User> Function(
    Ref ref, {
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
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  FetchUserProvider $copyWithCreate(
    FutureOr<User> Function(
      Ref ref,
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
  FutureOr<User> create(Ref ref) {
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

String _$fetchUserHash() => r'0ea61464a124f8af2cf15b830a1a012d4272eb47';

final class FetchUserFamily extends Family {
  const FetchUserFamily._()
      : super(
          retry: null,
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
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FetchUserProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
