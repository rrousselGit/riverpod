// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(user)
const userProvider = UserProvider._();

final class UserProvider
    extends $FunctionalProvider<AsyncValue<User>, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  const UserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userHash();

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    return user(ref);
  }
}

String _$userHash() => r'b83ca110a6fae2341d1bfca73fb3d89c4d12723d';

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<Object?, Object?>
    with $Provider<Object?> {
  const ExampleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Object? create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }
}

String _$exampleHash() => r'05abb7bf29fe43807cb1a31a17eb23c821529a69';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
