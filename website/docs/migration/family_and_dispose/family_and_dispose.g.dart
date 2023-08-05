// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diceNotifierHash() => r'8db76f099f429adb27719619fd9d55c7901c1c77';

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

abstract class _$DiceNotifier extends BuildlessAutoDisposeNotifier<int> {
  late final String arg;

  int build(
    String arg,
  );
}

/// See also [DiceNotifier].
@ProviderFor(DiceNotifier)
const diceNotifierProvider = DiceNotifierFamily();

/// See also [DiceNotifier].
class DiceNotifierFamily extends Family<int> {
  /// See also [DiceNotifier].
  const DiceNotifierFamily();

  /// See also [DiceNotifier].
  DiceNotifierProvider call(
    String arg,
  ) {
    return DiceNotifierProvider(
      arg,
    );
  }

  @override
  DiceNotifierProvider getProviderOverride(
    covariant DiceNotifierProvider provider,
  ) {
    return call(
      provider.arg,
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
  String? get name => r'diceNotifierProvider';
}

/// See also [DiceNotifier].
class DiceNotifierProvider
    extends AutoDisposeNotifierProviderImpl<DiceNotifier, int> {
  /// See also [DiceNotifier].
  DiceNotifierProvider(
    this.arg,
  ) : super.internal(
          () => DiceNotifier()..arg = arg,
          from: diceNotifierProvider,
          name: r'diceNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$diceNotifierHash,
          dependencies: DiceNotifierFamily._dependencies,
          allTransitiveDependencies:
              DiceNotifierFamily._allTransitiveDependencies,
        );

  final String arg;

  @override
  bool operator ==(Object other) {
    return other is DiceNotifierProvider && other.arg == arg;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, arg.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant DiceNotifier notifier,
  ) {
    return notifier.build(
      arg,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
