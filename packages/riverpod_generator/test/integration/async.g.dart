// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericHash() => r'6ee5473ece745b00328c1e048f6967c160343620';

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

/// See also [generic].
@ProviderFor(generic)
const genericProvider = GenericFamily();

/// See also [generic].
final class GenericFamily extends Family {
  /// See also [generic].
  const GenericFamily()
      : super(
          name: r'genericProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [generic].
  GenericProvider<T> call<T extends num>() {
    return GenericProvider<T>();
  }

  @override
  String toString() => 'genericProvider';
}

/// See also [generic].
final class GenericProvider<T extends num> extends FutureProvider<List<T>> {
  /// See also [generic].
  GenericProvider()
      : this._internal(
          (ref) => generic<T>(
            ref as GenericRef<T>,
          ),
          argument: (),
        );

  GenericProvider._internal(
    super.create, {
    required () super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericHash,
          from: genericProvider,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _GenericProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericProviderElement(this, container);
  }

  @internal
  @override
  GenericProvider<T> copyWithCreate(
    covariant FutureOr<List<T>> Function(GenericRef<T> ref) create,
  ) {
    return GenericProvider._internal(
      (ref) => create(ref as GenericRef<T>),
      argument: argument as (),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'genericProvider<$T>$argument';
}

mixin GenericRef<T extends num> on Ref<AsyncValue<List<T>>> {}

class _GenericProviderElement<T extends num>
    extends FutureProviderElement<List<T>> with GenericRef<T> {
  _GenericProviderElement(super.provider, super.container);
}

String _$publicHash() => r'9d99b79c013da13926d4ad89c72ebca4fc1cc257';

/// See also [public].
@ProviderFor(public)
final publicProvider = FutureProvider<String>.internal(
  public,
  name: r'publicProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PublicRef = Ref<AsyncValue<String>>;
String _$privateHash() => r'bc0469a9315de114a0ccd82c7db4980844d0009f';

/// See also [_private].
@ProviderFor(_private)
final _privateProvider = FutureProvider<String>.internal(
  _private,
  name: r'_privateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _PrivateRef = Ref<AsyncValue<String>>;
String _$familyOrHash() => r'1c3217e296b0ce52c07c18769d1fffb95850f482';

/// See also [familyOr].
@ProviderFor(familyOr)
const familyOrProvider = FamilyOrFamily();

/// See also [familyOr].
final class FamilyOrFamily extends Family {
  /// See also [familyOr].
  const FamilyOrFamily()
      : super(
          name: r'familyOrProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [familyOr].
  FamilyOrProvider call(
    int first,
  ) {
    return FamilyOrProvider(
      first,
    );
  }

  @override
  String toString() => 'familyOrProvider';
}

/// See also [familyOr].
final class FamilyOrProvider extends FutureProvider<String> {
  /// See also [familyOr].
  FamilyOrProvider(
    int first,
  ) : this._internal(
          (ref) => familyOr(
            ref as FamilyOrRef,
            first,
          ),
          argument: (first,),
        );

  FamilyOrProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrHash,
          from: familyOrProvider,
          name: r'familyOrProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _FamilyOrProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyOrProviderElement(this, container);
  }

  @internal
  @override
  FamilyOrProvider copyWithCreate(
    FutureOr<String> Function(FamilyOrRef ref) create,
  ) {
    return FamilyOrProvider._internal(
      (ref) => create(ref as FamilyOrRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyOrProvider$argument';
}

mixin FamilyOrRef on Ref<AsyncValue<String>> {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrProviderElement extends FutureProviderElement<String>
    with FamilyOrRef {
  _FamilyOrProviderElement(super.provider, super.container);

  @override
  int get first => (origin as FamilyOrProvider).first;
}

String _$familyHash() => r'eb6fad35a94d4238b621c2100253ee2c700bee77';

/// See also [family].
@ProviderFor(family)
const familyProvider = FamilyFamily();

/// See also [family].
final class FamilyFamily extends Family {
  /// See also [family].
  const FamilyFamily()
      : super(
          name: r'familyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [family].
  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  String toString() => 'familyProvider';
}

/// See also [family].
final class FamilyProvider extends FutureProvider<String> {
  /// See also [family].
  FamilyProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
          (ref) => family(
            ref as FamilyRef,
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
          argument: (
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
        );

  FamilyProvider._internal(
    super.create, {
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          from: familyProvider,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyProviderElement(this, container);
  }

  @internal
  @override
  FamilyProvider copyWithCreate(
    FutureOr<String> Function(FamilyRef ref) create,
  ) {
    return FamilyProvider._internal(
      (ref) => create(ref as FamilyRef),
      argument: argument as (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyProvider$argument';
}

mixin FamilyRef on Ref<AsyncValue<String>> {
  /// The parameter `first` of this provider.
  int get first;

  /// The parameter `second` of this provider.
  String? get second;

  /// The parameter `third` of this provider.
  double get third;

  /// The parameter `fourth` of this provider.
  bool get fourth;

  /// The parameter `fifth` of this provider.
  List<String>? get fifth;
}

class _FamilyProviderElement extends FutureProviderElement<String>
    with FamilyRef {
  _FamilyProviderElement(super.provider, super.container);

  @override
  int get first => (origin as FamilyProvider).first;
  @override
  String? get second => (origin as FamilyProvider).second;
  @override
  double get third => (origin as FamilyProvider).third;
  @override
  bool get fourth => (origin as FamilyProvider).fourth;
  @override
  List<String>? get fifth => (origin as FamilyProvider).fifth;
}

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

abstract class _$GenericClass<T extends num>
    extends BuildlessAutoDisposeAsyncNotifier<List<T>> {
  FutureOr<List<T>> build();
}

/// See also [GenericClass].
@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily();

/// See also [GenericClass].
final class GenericClassFamily extends Family {
  /// See also [GenericClass].
  const GenericClassFamily()
      : super(
          name: r'genericClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [GenericClass].
  GenericClassProvider<T> call<T extends num>() {
    return GenericClassProvider<T>();
  }

  @override
  String toString() => 'genericClassProvider';
}

/// See also [GenericClass].
final class GenericClassProvider<T extends num>
    extends AutoDisposeAsyncNotifierProviderImpl<GenericClass<T>, List<T>> {
  /// See also [GenericClass].
  GenericClassProvider()
      : this._internal(
          GenericClass<T>.new,
          argument: (),
        );

  GenericClassProvider._internal(
    super.create, {
    required () super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericClassHash,
          from: genericClassProvider,
          name: r'genericClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  FutureOr<List<T>> runNotifierBuild(
    covariant GenericClass<T> notifier,
  ) {
    return notifier.build();
  }

  @internal
  @override
  AutoDisposeAsyncNotifierProviderImpl copyWithBuild(
    GenericClass Function() create,
  ) {
    return AutoDisposeAsyncNotifierProviderImpl._internal(
      create,
    );
  }

  @override
  _GenericClassProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return _GenericClassProviderElement(this, container);
  }

  @internal
  @override
  GenericClassProvider copyWithCreate(
    GenericClass Function() create,
  ) {
    return GenericClassProvider._internal(
      () => create(),
      argument: argument as (),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'genericClassProvider<$T>$argument';
}

mixin GenericClassRef<T extends num> on AutoDisposeAsyncNotifierProviderRef {}

class _GenericClassProviderElement<T extends num>
    extends AutoDisposeAsyncNotifierProviderElement<GenericClass<T>, List<T>>
    with GenericClassRef<T> {
  _GenericClassProviderElement(super.provider, super.container);
}

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

/// See also [PublicClass].
@ProviderFor(PublicClass)
final publicClassProvider = AsyncNotifierProvider<PublicClass, String>.internal(
  PublicClass.new,
  name: r'publicClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$publicClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicClass = AsyncNotifier<String>;
String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

/// See also [_PrivateClass].
@ProviderFor(_PrivateClass)
final _privateClassProvider =
    AsyncNotifierProvider<_PrivateClass, String>.internal(
  _PrivateClass.new,
  name: r'_privateClassProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$privateClassHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivateClass = AsyncNotifier<String>;
String _$familyOrClassHash() => r'b4882d4e79a03c63005d35eb7a021c9c4373a8d9';

abstract class _$FamilyOrClass
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int first;

  FutureOr<String> build(
    int first,
  );
}

/// See also [FamilyOrClass].
@ProviderFor(FamilyOrClass)
const familyOrClassProvider = FamilyOrClassFamily();

/// See also [FamilyOrClass].
final class FamilyOrClassFamily extends Family {
  /// See also [FamilyOrClass].
  const FamilyOrClassFamily()
      : super(
          name: r'familyOrClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [FamilyOrClass].
  FamilyOrClassProvider call(
    int first,
  ) {
    return FamilyOrClassProvider(
      first,
    );
  }

  @override
  String toString() => 'familyOrClassProvider';
}

/// See also [FamilyOrClass].
final class FamilyOrClassProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyOrClass, String> {
  /// See also [FamilyOrClass].
  FamilyOrClassProvider(
    int first,
  ) : this._internal(
          () => FamilyOrClass()..first = first,
          argument: (first,),
        );

  FamilyOrClassProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyOrClassHash,
          from: familyOrClassProvider,
          name: r'familyOrClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  FutureOr<String> runNotifierBuild(
    covariant FamilyOrClass notifier,
  ) {
    return notifier.build(
      first,
    );
  }

  @internal
  @override
  AutoDisposeAsyncNotifierProviderImpl copyWithBuild(
    FamilyOrClass Function() create,
  ) {
    return AutoDisposeAsyncNotifierProviderImpl._internal(
      create,
      first: first,
    );
  }

  @override
  _FamilyOrClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyOrClassProviderElement(this, container);
  }

  @internal
  @override
  FamilyOrClassProvider copyWithCreate(
    FamilyOrClass Function() create,
  ) {
    return FamilyOrClassProvider._internal(
      () => create()..first = first,
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrClassProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyOrClassProvider$argument';
}

mixin FamilyOrClassRef on AutoDisposeAsyncNotifierProviderRef {
  /// The parameter `first` of this provider.
  int get first;
}

class _FamilyOrClassProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FamilyOrClass, String>
    with FamilyOrClassRef {
  _FamilyOrClassProviderElement(super.provider, super.container);

  @override
  int get first => (origin as FamilyOrClassProvider).first;
}

String _$familyClassHash() => r'b7e3ca6091f12bbc99972e961acd885e05f42a15';

abstract class _$FamilyClass extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool fourth;
  late final List<String>? fifth;

  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
}

/// See also [FamilyClass].
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily();

/// See also [FamilyClass].
final class FamilyClassFamily extends Family {
  /// See also [FamilyClass].
  const FamilyClassFamily()
      : super(
          name: r'familyClassProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [FamilyClass].
  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    return FamilyClassProvider(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  String toString() => 'familyClassProvider';
}

/// See also [FamilyClass].
final class FamilyClassProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String> {
  /// See also [FamilyClass].
  FamilyClassProvider(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) : this._internal(
          () => FamilyClass()
            ..first = first
            ..second = second
            ..third = third
            ..fourth = fourth
            ..fifth = fifth,
          argument: (
            first,
            second: second,
            third: third,
            fourth: fourth,
            fifth: fifth,
          ),
        );

  FamilyClassProvider._internal(
    super.create, {
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyClassHash,
          from: familyClassProvider,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  FutureOr<String> runNotifierBuild(
    covariant FamilyClass notifier,
  ) {
    return notifier.build(
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @internal
  @override
  AutoDisposeAsyncNotifierProviderImpl copyWithBuild(
    FamilyClass Function() create,
  ) {
    return AutoDisposeAsyncNotifierProviderImpl._internal(
      create,
      first: first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    );
  }

  @override
  _FamilyClassProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyClassProviderElement(this, container);
  }

  @internal
  @override
  FamilyClassProvider copyWithCreate(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._internal(
      () => create()
        ..first = first
        ..second = second
        ..third = third
        ..fourth = fourth
        ..fifth = fifth,
      argument: argument as (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyClassProvider$argument';
}

mixin FamilyClassRef on AutoDisposeAsyncNotifierProviderRef {
  /// The parameter `first` of this provider.
  int get first;

  /// The parameter `second` of this provider.
  String? get second;

  /// The parameter `third` of this provider.
  double get third;

  /// The parameter `fourth` of this provider.
  bool get fourth;

  /// The parameter `fifth` of this provider.
  List<String>? get fifth;
}

class _FamilyClassProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FamilyClass, String>
    with FamilyClassRef {
  _FamilyClassProviderElement(super.provider, super.container);

  @override
  int get first => (origin as FamilyClassProvider).first;
  @override
  String? get second => (origin as FamilyClassProvider).second;
  @override
  double get third => (origin as FamilyClassProvider).third;
  @override
  bool get fourth => (origin as FamilyClassProvider).fourth;
  @override
  List<String>? get fifth => (origin as FamilyClassProvider).fifth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
