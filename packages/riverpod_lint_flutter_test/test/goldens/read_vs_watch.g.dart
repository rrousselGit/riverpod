// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_vs_watch.dart';

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

String $MyNotifierHash() => r'61802219610d8b855bdacda5bf14b6161c69131c';

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

String $generatedHash() => r'40e3f3497855d0f3422139505af4a3e06bd5cc95';

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
