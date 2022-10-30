// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutate_in_create.dart';

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

String $MyNotifierHash() => r'776dac1b8cf04992a7ad0e1f43a96bf9b4659f0b';

/// See also [MyNotifier].
class MyNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MyNotifier, String> {
  MyNotifierProvider(
    this.i,
    this.b,
  ) : super(
          () => MyNotifier()
            ..i = i
            ..b = b,
          from: myNotifierProvider,
          name: r'myNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $MyNotifierHash,
        );

  final int i;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is MyNotifierProvider && other.i == i && other.b == b;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, i.hashCode);
    hash = _SystemHash.combine(hash, b.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<String> runNotifierBuild(
    covariant _$MyNotifier notifier,
  ) {
    return notifier.build(
      i,
      b,
    );
  }
}

typedef MyNotifierRef = AutoDisposeAsyncNotifierProviderRef<String>;

/// See also [MyNotifier].
final myNotifierProvider = MyNotifierFamily();

class MyNotifierFamily extends Family<AsyncValue<String>> {
  MyNotifierFamily();

  MyNotifierProvider call(
    int i,
    String b,
  ) {
    return MyNotifierProvider(
      i,
      b,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderImpl<MyNotifier, String> getProviderOverride(
    covariant MyNotifierProvider provider,
  ) {
    return call(
      provider.i,
      provider.b,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'myNotifierProvider';
}

abstract class _$MyNotifier extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int i;
  late final String b;

  FutureOr<String> build(
    int i,
    String b,
  );
}

String $MyNotifier2Hash() => r'86bcf4b54298ca620d50ca3f2cfdce843739e6d1';

/// See also [MyNotifier2].
class MyNotifier2Provider
    extends AutoDisposeNotifierProviderImpl<MyNotifier2, String> {
  MyNotifier2Provider(
    this.i,
    this.b,
  ) : super(
          () => MyNotifier2()
            ..i = i
            ..b = b,
          from: myNotifier2Provider,
          name: r'myNotifier2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $MyNotifier2Hash,
        );

  final int i;
  final String b;

  @override
  bool operator ==(Object other) {
    return other is MyNotifier2Provider && other.i == i && other.b == b;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, i.hashCode);
    hash = _SystemHash.combine(hash, b.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant _$MyNotifier2 notifier,
  ) {
    return notifier.build(
      i,
      b,
    );
  }
}

typedef MyNotifier2Ref = AutoDisposeNotifierProviderRef<String>;

/// See also [MyNotifier2].
final myNotifier2Provider = MyNotifier2Family();

class MyNotifier2Family extends Family<String> {
  MyNotifier2Family();

  MyNotifier2Provider call(
    int i,
    String b,
  ) {
    return MyNotifier2Provider(
      i,
      b,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<MyNotifier2, String> getProviderOverride(
    covariant MyNotifier2Provider provider,
  ) {
    return call(
      provider.i,
      provider.b,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'myNotifier2Provider';
}

abstract class _$MyNotifier2 extends BuildlessAutoDisposeNotifier<String> {
  late final int i;
  late final String b;

  String build(
    int i,
    String b,
  );
}

String $generatedHash() => r'cf482f785592d96d90763d228d1c29d6ab0915ac';

/// See also [generated].
class GeneratedProvider extends AutoDisposeFutureProvider<String> {
  GeneratedProvider(
    this.value,
    this.otherValue,
  ) : super(
          (ref) => generated(
            ref,
            value,
            otherValue,
          ),
          from: generatedProvider,
          name: r'generatedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $generatedHash,
        );

  final String value;
  final int otherValue;

  @override
  bool operator ==(Object other) {
    return other is GeneratedProvider &&
        other.value == value &&
        other.otherValue == otherValue;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);
    hash = _SystemHash.combine(hash, otherValue.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef GeneratedRef = AutoDisposeFutureProviderRef<String>;

/// See also [generated].
final generatedProvider = GeneratedFamily();

class GeneratedFamily extends Family<AsyncValue<String>> {
  GeneratedFamily();

  GeneratedProvider call(
    String value,
    int otherValue,
  ) {
    return GeneratedProvider(
      value,
      otherValue,
    );
  }

  @override
  AutoDisposeFutureProvider<String> getProviderOverride(
    covariant GeneratedProvider provider,
  ) {
    return call(
      provider.value,
      provider.otherValue,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'generatedProvider';
}

String $generatedSyncHash() => r'15f2d152e33b46338ee523743b2be3415d7fa48f';

/// See also [generatedSync].
class GeneratedSyncProvider extends AutoDisposeProvider<String> {
  GeneratedSyncProvider(
    this.value,
    this.otherValue,
  ) : super(
          (ref) => generatedSync(
            ref,
            value,
            otherValue,
          ),
          from: generatedSyncProvider,
          name: r'generatedSyncProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $generatedSyncHash,
        );

  final String value;
  final int otherValue;

  @override
  bool operator ==(Object other) {
    return other is GeneratedSyncProvider &&
        other.value == value &&
        other.otherValue == otherValue;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);
    hash = _SystemHash.combine(hash, otherValue.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef GeneratedSyncRef = AutoDisposeProviderRef<String>;

/// See also [generatedSync].
final generatedSyncProvider = GeneratedSyncFamily();

class GeneratedSyncFamily extends Family<String> {
  GeneratedSyncFamily();

  GeneratedSyncProvider call(
    String value,
    int otherValue,
  ) {
    return GeneratedSyncProvider(
      value,
      otherValue,
    );
  }

  @override
  AutoDisposeProvider<String> getProviderOverride(
    covariant GeneratedSyncProvider provider,
  ) {
    return call(
      provider.value,
      provider.otherValue,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'generatedSyncProvider';
}
