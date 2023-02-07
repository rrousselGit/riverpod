// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_vs_watch.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNotifierHash() => r'61802219610d8b855bdacda5bf14b6161c69131c';

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

String _$generatedHash() => r'40e3f3497855d0f3422139505af4a3e06bd5cc95';
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
