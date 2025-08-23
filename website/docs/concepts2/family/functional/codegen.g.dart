// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(user)
const userProvider = UserFamily._();

final class UserProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  const UserProvider._({
    required UserFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userHash();

  @override
  String toString() {
    return r'userProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    final argument = this.argument as String;
    return user(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userHash() => r'8d1ce92d62b70e2bde0d9c6977604c94a46a5c8f';

final class UserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<User>, String> {
  const UserFamily._()
    : super(
        retry: null,
        name: r'userProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProvider call(String id) => UserProvider._(argument: id, from: this);

  @override
  String toString() => r'userProvider';
}
