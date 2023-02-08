// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutate_in_create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNotifierHash() => r'776dac1b8cf04992a7ad0e1f43a96bf9b4659f0b';

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

abstract class _$MyNotifier extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int i;
  late final String b;

  Future<String> build(
    int i,
    String b,
  );
}

/// See also [MyNotifier].
@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierFamily();

/// See also [MyNotifier].
class MyNotifierFamily extends Family<AsyncValue<String>> {
  /// See also [MyNotifier].
  const MyNotifierFamily();

  /// See also [MyNotifier].
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
  MyNotifierProvider getProviderOverride(
    covariant MyNotifierProvider provider,
  ) {
    return call(
      provider.i,
      provider.b,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myNotifierProvider';
}

/// See also [MyNotifier].
class MyNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MyNotifier, String> {
  /// See also [MyNotifier].
  MyNotifierProvider(
    this.i,
    this.b,
  ) : super.internal(
          () => MyNotifier()
            ..i = i
            ..b = b,
          from: myNotifierProvider,
          name: r'myNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myNotifierHash,
          dependencies: MyNotifierFamily._dependencies,
          allTransitiveDependencies:
              MyNotifierFamily._allTransitiveDependencies,
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
  Future<String> runNotifierBuild(
    covariant MyNotifier notifier,
  ) {
    return notifier.build(
      i,
      b,
    );
  }
}

String _$myNotifier2Hash() => r'86bcf4b54298ca620d50ca3f2cfdce843739e6d1';

abstract class _$MyNotifier2 extends BuildlessAutoDisposeNotifier<String> {
  late final int i;
  late final String b;

  String build(
    int i,
    String b,
  );
}

/// See also [MyNotifier2].
@ProviderFor(MyNotifier2)
const myNotifier2Provider = MyNotifier2Family();

/// See also [MyNotifier2].
class MyNotifier2Family extends Family<String> {
  /// See also [MyNotifier2].
  const MyNotifier2Family();

  /// See also [MyNotifier2].
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
  MyNotifier2Provider getProviderOverride(
    covariant MyNotifier2Provider provider,
  ) {
    return call(
      provider.i,
      provider.b,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myNotifier2Provider';
}

/// See also [MyNotifier2].
class MyNotifier2Provider
    extends AutoDisposeNotifierProviderImpl<MyNotifier2, String> {
  /// See also [MyNotifier2].
  MyNotifier2Provider(
    this.i,
    this.b,
  ) : super.internal(
          () => MyNotifier2()
            ..i = i
            ..b = b,
          from: myNotifier2Provider,
          name: r'myNotifier2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myNotifier2Hash,
          dependencies: MyNotifier2Family._dependencies,
          allTransitiveDependencies:
              MyNotifier2Family._allTransitiveDependencies,
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
    covariant MyNotifier2 notifier,
  ) {
    return notifier.build(
      i,
      b,
    );
  }
}

String _$generatedHash() => r'cf482f785592d96d90763d228d1c29d6ab0915ac';
typedef GeneratedRef = AutoDisposeFutureProviderRef<String>;

/// See also [generated].
@ProviderFor(generated)
const generatedProvider = GeneratedFamily();

/// See also [generated].
class GeneratedFamily extends Family<AsyncValue<String>> {
  /// See also [generated].
  const GeneratedFamily();

  /// See also [generated].
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
  GeneratedProvider getProviderOverride(
    covariant GeneratedProvider provider,
  ) {
    return call(
      provider.value,
      provider.otherValue,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'generatedProvider';
}

/// See also [generated].
class GeneratedProvider extends AutoDisposeFutureProvider<String> {
  /// See also [generated].
  GeneratedProvider(
    this.value,
    this.otherValue,
  ) : super.internal(
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
                  : _$generatedHash,
          dependencies: GeneratedFamily._dependencies,
          allTransitiveDependencies: GeneratedFamily._allTransitiveDependencies,
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

String _$generatedSyncHash() => r'15f2d152e33b46338ee523743b2be3415d7fa48f';
typedef GeneratedSyncRef = AutoDisposeProviderRef<String>;

/// See also [generatedSync].
@ProviderFor(generatedSync)
const generatedSyncProvider = GeneratedSyncFamily();

/// See also [generatedSync].
class GeneratedSyncFamily extends Family<String> {
  /// See also [generatedSync].
  const GeneratedSyncFamily();

  /// See also [generatedSync].
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
  GeneratedSyncProvider getProviderOverride(
    covariant GeneratedSyncProvider provider,
  ) {
    return call(
      provider.value,
      provider.otherValue,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'generatedSyncProvider';
}

/// See also [generatedSync].
class GeneratedSyncProvider extends AutoDisposeProvider<String> {
  /// See also [generatedSync].
  GeneratedSyncProvider(
    this.value,
    this.otherValue,
  ) : super.internal(
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
                  : _$generatedSyncHash,
          dependencies: GeneratedSyncFamily._dependencies,
          allTransitiveDependencies:
              GeneratedSyncFamily._allTransitiveDependencies,
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
