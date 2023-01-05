// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $fetchUserHash() => r'ff427bbb4130a8a6994fa623ae70997f7b0f6bdb';

/// See also [fetchUser].
class FetchUserProvider extends AutoDisposeFutureProvider<User> {
  FetchUserProvider({
    required this.userId,
  }) : super(
          (ref) => fetchUser(
            ref,
            userId: userId,
          ),
          from: fetchUserProvider,
          name: r'fetchUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $fetchUserHash,
        );

  final int userId;

  @override
  bool operator ==(Object other) {
    return other is FetchUserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef FetchUserRef = AutoDisposeFutureProviderRef<User>;

/// See also [fetchUser].
final fetchUserProvider = FetchUserFamily();

class FetchUserFamily extends Family<AsyncValue<User>> {
  FetchUserFamily();

  FetchUserProvider call({
    required int userId,
  }) {
    return FetchUserProvider(
      userId: userId,
    );
  }

  @override
  AutoDisposeFutureProvider<User> getProviderOverride(
    covariant FetchUserProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'fetchUserProvider';
}
