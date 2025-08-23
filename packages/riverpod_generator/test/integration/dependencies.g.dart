// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const DepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'depProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$depHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$depHash() => r'1b3ec5231cd2328602151de9ceacdcd102a1d2e2';

@ProviderFor(family)
const familyProvider = FamilyFamily._();

final class FamilyProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const FamilyProvider._({
    required FamilyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'familyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return family(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyHash() => r'940eb87eb11206499f73f05791a6266b38cda88a';

final class FamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const FamilyFamily._()
    : super(
        retry: null,
        name: r'familyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FamilyProvider call(int id) => FamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'familyProvider';
}

@ProviderFor(Dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $NotifierProvider<Dep2, int> {
  const Dep2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dep2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

  @$internal
  @override
  Dep2 create() => Dep2();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$dep2Hash() => r'2778537df77f6431148c2ce400724da3e2ab4b94';

abstract class _$Dep2 extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Family2)
const family2Provider = Family2Family._();

final class Family2Provider extends $NotifierProvider<Family2, int> {
  const Family2Provider._({
    required Family2Family super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'family2Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$family2Hash();

  @override
  String toString() {
    return r'family2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Family2 create() => Family2();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Family2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$family2Hash() => r'ce727b262aae067b0d4f703f03670abb70ad8977';

final class Family2Family extends $Family
    with $ClassFamilyOverride<Family2, int, int, int, int> {
  const Family2Family._()
    : super(
        retry: null,
        name: r'family2Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Family2Provider call(int id) => Family2Provider._(argument: id, from: this);

  @override
  String toString() => r'family2Provider';
}

abstract class _$Family2 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  int build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(provider)
const providerProvider = ProviderProvider._();

final class ProviderProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const ProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          ProviderProvider.$allTransitiveDependencies0,
          ProviderProvider.$allTransitiveDependencies1,
          ProviderProvider.$allTransitiveDependencies2,
          ProviderProvider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;
  static const $allTransitiveDependencies3 = family2Provider;

  @override
  String debugGetCreateSourceHash() => _$providerHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return provider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$providerHash() => r'1be7ae7ac2100d39b949af50ec50fce48b26cdd1';

@ProviderFor(provider2)
const provider2Provider = Provider2Provider._();

final class Provider2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const Provider2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provider2Provider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          Provider2Provider.$allTransitiveDependencies0,
          Provider2Provider.$allTransitiveDependencies1,
          Provider2Provider.$allTransitiveDependencies2,
          Provider2Provider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;
  static const $allTransitiveDependencies3 = family2Provider;

  @override
  String debugGetCreateSourceHash() => _$provider2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return provider2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$provider2Hash() => r'30f81430b57f0116f621a4a309c458fce0536378';

@ProviderFor(Provider3)
const provider3Provider = Provider3Provider._();

final class Provider3Provider extends $NotifierProvider<Provider3, int> {
  const Provider3Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provider3Provider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          Provider3Provider.$allTransitiveDependencies0,
          Provider3Provider.$allTransitiveDependencies1,
          Provider3Provider.$allTransitiveDependencies2,
          Provider3Provider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;
  static const $allTransitiveDependencies3 = family2Provider;

  @override
  String debugGetCreateSourceHash() => _$provider3Hash();

  @$internal
  @override
  Provider3 create() => Provider3();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$provider3Hash() => r'dfdd6dec6cfee543c73d99593ce98d68f4db385c';

abstract class _$Provider3 extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Provider4)
const provider4Provider = Provider4Family._();

final class Provider4Provider extends $NotifierProvider<Provider4, int> {
  const Provider4Provider._({
    required Provider4Family super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'provider4Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;
  static const $allTransitiveDependencies3 = family2Provider;

  @override
  String debugGetCreateSourceHash() => _$provider4Hash();

  @override
  String toString() {
    return r'provider4Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Provider4 create() => Provider4();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Provider4Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$provider4Hash() => r'1c955214d99695bb694c96374b277aac58e734df';

final class Provider4Family extends $Family
    with $ClassFamilyOverride<Provider4, int, int, int, int> {
  const Provider4Family._()
    : super(
        retry: null,
        name: r'provider4Provider',
        dependencies: const <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          Provider4Provider.$allTransitiveDependencies0,
          Provider4Provider.$allTransitiveDependencies1,
          Provider4Provider.$allTransitiveDependencies2,
          Provider4Provider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  Provider4Provider call(int id) =>
      Provider4Provider._(argument: id, from: this);

  @override
  String toString() => r'provider4Provider';
}

abstract class _$Provider4 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  int build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(transitiveDependencies)
const transitiveDependenciesProvider = TransitiveDependenciesProvider._();

final class TransitiveDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TransitiveDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transitiveDependenciesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[providerProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          TransitiveDependenciesProvider.$allTransitiveDependencies0,
          TransitiveDependenciesProvider.$allTransitiveDependencies1,
          TransitiveDependenciesProvider.$allTransitiveDependencies2,
          TransitiveDependenciesProvider.$allTransitiveDependencies3,
          TransitiveDependenciesProvider.$allTransitiveDependencies4,
        },
      );

  static const $allTransitiveDependencies0 = providerProvider;
  static const $allTransitiveDependencies1 =
      ProviderProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ProviderProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 =
      ProviderProvider.$allTransitiveDependencies2;
  static const $allTransitiveDependencies4 =
      ProviderProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$transitiveDependenciesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return transitiveDependencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$transitiveDependenciesHash() =>
    r'909d45403831b521177ec15b1dd78554e261d3be';

@ProviderFor(smallTransitiveDependencyCount)
const smallTransitiveDependencyCountProvider =
    SmallTransitiveDependencyCountProvider._();

final class SmallTransitiveDependencyCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const SmallTransitiveDependencyCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smallTransitiveDependencyCountProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies0,
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies1,
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;

  @override
  String debugGetCreateSourceHash() => _$smallTransitiveDependencyCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return smallTransitiveDependencyCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$smallTransitiveDependencyCountHash() =>
    r'f67b369dd99e35a6e6211004b45c87c5ba4ac1c7';

@ProviderFor(emptyDependenciesFunctional)
const emptyDependenciesFunctionalProvider =
    EmptyDependenciesFunctionalProvider._();

final class EmptyDependenciesFunctionalProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const EmptyDependenciesFunctionalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emptyDependenciesFunctionalProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$emptyDependenciesFunctionalHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return emptyDependenciesFunctional(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$emptyDependenciesFunctionalHash() =>
    r'77289071cab8a10da8f5b7b40932864510a1ee38';

@ProviderFor(EmptyDependenciesClassBased)
const emptyDependenciesClassBasedProvider =
    EmptyDependenciesClassBasedProvider._();

final class EmptyDependenciesClassBasedProvider
    extends $NotifierProvider<EmptyDependenciesClassBased, int> {
  const EmptyDependenciesClassBasedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emptyDependenciesClassBasedProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$emptyDependenciesClassBasedHash();

  @$internal
  @override
  EmptyDependenciesClassBased create() => EmptyDependenciesClassBased();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$emptyDependenciesClassBasedHash() =>
    r'e20c18353984a81977b656e9879b3841dbaedc6c';

abstract class _$EmptyDependenciesClassBased extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(providerWithDependencies)
const providerWithDependenciesProvider = ProviderWithDependenciesProvider._();

final class ProviderWithDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const ProviderWithDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerWithDependenciesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          _privateDepProvider,
          publicDepProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ProviderWithDependenciesProvider.$allTransitiveDependencies0,
          ProviderWithDependenciesProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = _privateDepProvider;
  static const $allTransitiveDependencies1 = publicDepProvider;

  @override
  String debugGetCreateSourceHash() => _$providerWithDependenciesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return providerWithDependencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$providerWithDependenciesHash() =>
    r'7d40c994fc2d4ba9e6a0bb4a3d100f8da874eb5e';

@ProviderFor(_privateDep)
const _privateDepProvider = _PrivateDepProvider._();

final class _PrivateDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const _PrivateDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_privateDepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_privateDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return _privateDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$_privateDepHash() => r'92ff5cc515ecf2455cb04773f1b49f23b17ea2e2';

@ProviderFor(publicDep)
const publicDepProvider = PublicDepProvider._();

final class PublicDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const PublicDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicDepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return publicDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$publicDepHash() => r'a9c461ae174577183ab4c0ff8d8267cc7a64a2c5';

@ProviderFor(duplicateDependencies)
const duplicateDependenciesProvider = DuplicateDependenciesProvider._();

final class DuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const DuplicateDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duplicateDependenciesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[depProvider, dep2Provider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          DuplicateDependenciesProvider.$allTransitiveDependencies0,
          DuplicateDependenciesProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = dep2Provider;

  @override
  String debugGetCreateSourceHash() => _$duplicateDependenciesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return duplicateDependencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$duplicateDependenciesHash() =>
    r'ad48ecca57899ee55c69793c84a01235d6a49834';

@ProviderFor(duplicateDependencies2)
const duplicateDependencies2Provider = DuplicateDependencies2Provider._();

final class DuplicateDependencies2Provider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const DuplicateDependencies2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duplicateDependencies2Provider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[familyProvider, family2Provider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          DuplicateDependencies2Provider.$allTransitiveDependencies0,
          DuplicateDependencies2Provider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = familyProvider;
  static const $allTransitiveDependencies1 = family2Provider;

  @override
  String debugGetCreateSourceHash() => _$duplicateDependencies2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return duplicateDependencies2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$duplicateDependencies2Hash() =>
    r'6e065325922dc36f408f85998cf2d7ba7a80ba56';

@ProviderFor(transitiveDuplicateDependencies)
const transitiveDuplicateDependenciesProvider =
    TransitiveDuplicateDependenciesProvider._();

final class TransitiveDuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TransitiveDuplicateDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transitiveDuplicateDependenciesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          duplicateDependenciesProvider,
          duplicateDependencies2Provider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies0,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies1,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies2,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies3,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies4,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies5,
        },
      );

  static const $allTransitiveDependencies0 = duplicateDependenciesProvider;
  static const $allTransitiveDependencies1 =
      DuplicateDependenciesProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      DuplicateDependenciesProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = duplicateDependencies2Provider;
  static const $allTransitiveDependencies4 =
      DuplicateDependencies2Provider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies5 =
      DuplicateDependencies2Provider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$transitiveDuplicateDependenciesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return transitiveDuplicateDependencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$transitiveDuplicateDependenciesHash() =>
    r'be6a85098fc66be440b6b201f58a6ce1c526caf6';
