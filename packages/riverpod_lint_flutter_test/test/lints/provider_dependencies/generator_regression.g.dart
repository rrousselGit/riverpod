// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_regression.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dep)
final depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  DepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'depProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

@ProviderFor(family)
final familyProvider = FamilyFamily._();

final class FamilyProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  FamilyProvider._({
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

String _$familyHash() => r'ffb627fd3584515ea855b8b9c6468fe4e362293f';

final class FamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  FamilyFamily._()
    : super(
        retry: null,
        name: r'familyProvider',
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
        isAutoDispose: true,
      );

  FamilyProvider call(int id) => FamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'familyProvider';
}

@ProviderFor(Dep2)
final dep2Provider = Dep2Provider._();

final class Dep2Provider extends $NotifierProvider<Dep2, int> {
  Dep2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dep2Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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

String _$dep2Hash() => r'029d32c758a8af63194193e01b04d7a8240c0053';

abstract class _$Dep2 extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Family2)
final family2Provider = Family2Family._();

final class Family2Provider extends $NotifierProvider<Family2, int> {
  Family2Provider._({
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

String _$family2Hash() => r'328ff9faf39a29b8d0da15dd5bb215e4c33e9dc3';

final class Family2Family extends $Family
    with $ClassFamilyOverride<Family2, int, int, int, int> {
  Family2Family._()
    : super(
        retry: null,
        name: r'family2Provider',
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(provider)
final providerProvider = ProviderProvider._();

final class ProviderProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ProviderProvider.$allTransitiveDependencies0,
          ProviderProvider.$allTransitiveDependencies1,
          ProviderProvider.$allTransitiveDependencies2,
          ProviderProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = familyProvider;
  static final $allTransitiveDependencies2 = dep2Provider;
  static final $allTransitiveDependencies3 = family2Provider;

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

String _$providerHash() => r'c1b2db25d69b2c833eaf60bf49544b8db9e3b8b4';

@ProviderFor(provider2)
final provider2Provider = Provider2Provider._();

final class Provider2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  Provider2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provider2Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          Provider2Provider.$allTransitiveDependencies0,
          Provider2Provider.$allTransitiveDependencies1,
          Provider2Provider.$allTransitiveDependencies2,
          Provider2Provider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = familyProvider;
  static final $allTransitiveDependencies2 = dep2Provider;
  static final $allTransitiveDependencies3 = family2Provider;

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

String _$provider2Hash() => r'54652bf3cc2cbf7b70f95f8635ecc423f7e0c502';

@ProviderFor(Provider3)
final provider3Provider = Provider3Provider._();

final class Provider3Provider extends $NotifierProvider<Provider3, int> {
  Provider3Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provider3Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          Provider3Provider.$allTransitiveDependencies0,
          Provider3Provider.$allTransitiveDependencies1,
          Provider3Provider.$allTransitiveDependencies2,
          Provider3Provider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = familyProvider;
  static final $allTransitiveDependencies2 = dep2Provider;
  static final $allTransitiveDependencies3 = family2Provider;

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

String _$provider3Hash() => r'4991c48a5026b8aa2ac4ebcbc9537de3cd893d3d';

abstract class _$Provider3 extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Provider4)
final provider4Provider = Provider4Family._();

final class Provider4Provider extends $NotifierProvider<Provider4, int> {
  Provider4Provider._({
    required Provider4Family super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'provider4Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = familyProvider;
  static final $allTransitiveDependencies2 = dep2Provider;
  static final $allTransitiveDependencies3 = family2Provider;

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

String _$provider4Hash() => r'c6f19ea7f8b8e095f73a91ed019118150d2f9d23';

final class Provider4Family extends $Family
    with $ClassFamilyOverride<Provider4, int, int, int, int> {
  Provider4Family._()
    : super(
        retry: null,
        name: r'provider4Provider',
        dependencies: <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
          family2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
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
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(transitiveDependencies)
final transitiveDependenciesProvider = TransitiveDependenciesProvider._();

final class TransitiveDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TransitiveDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transitiveDependenciesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[providerProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          TransitiveDependenciesProvider.$allTransitiveDependencies0,
          TransitiveDependenciesProvider.$allTransitiveDependencies1,
          TransitiveDependenciesProvider.$allTransitiveDependencies2,
          TransitiveDependenciesProvider.$allTransitiveDependencies3,
          TransitiveDependenciesProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = providerProvider;
  static final $allTransitiveDependencies1 =
      ProviderProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ProviderProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      ProviderProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 =
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
    r'75f3934b0adc2234d2d914c4edfafd512b21d2f0';

@ProviderFor(smallTransitiveDependencyCount)
final smallTransitiveDependencyCountProvider =
    SmallTransitiveDependencyCountProvider._();

final class SmallTransitiveDependencyCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  SmallTransitiveDependencyCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smallTransitiveDependencyCountProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          depProvider,
          familyProvider,
          dep2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies0,
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies1,
          SmallTransitiveDependencyCountProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = familyProvider;
  static final $allTransitiveDependencies2 = dep2Provider;

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
    r'cace8c2f2c52e7b0be30f24a3b0fdc720996c387';

@ProviderFor(emptyDependenciesFunctional)
final emptyDependenciesFunctionalProvider =
    EmptyDependenciesFunctionalProvider._();

final class EmptyDependenciesFunctionalProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  EmptyDependenciesFunctionalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emptyDependenciesFunctionalProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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
final emptyDependenciesClassBasedProvider =
    EmptyDependenciesClassBasedProvider._();

final class EmptyDependenciesClassBasedProvider
    extends $NotifierProvider<EmptyDependenciesClassBased, int> {
  EmptyDependenciesClassBasedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emptyDependenciesClassBasedProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(providerWithDependencies)
final providerWithDependenciesProvider = ProviderWithDependenciesProvider._();

final class ProviderWithDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ProviderWithDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerWithDependenciesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          _privateDepProvider,
          publicDepProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ProviderWithDependenciesProvider.$allTransitiveDependencies0,
          ProviderWithDependenciesProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = _privateDepProvider;
  static final $allTransitiveDependencies1 = publicDepProvider;

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
    r'36bdbad7b38d2885e2de0eb23356f60fbfc96446';

@ProviderFor(_privateDep)
final _privateDepProvider = _PrivateDepProvider._();

final class _PrivateDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  _PrivateDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_privateDepProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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

String _$_privateDepHash() => r'31ca72b16ab288f9e786d629e6d86b29d4ea1cbc';

@ProviderFor(publicDep)
final publicDepProvider = PublicDepProvider._();

final class PublicDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  PublicDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicDepProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
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

String _$publicDepHash() => r'd331a446354abfee78cd8b452feb63a19a25d4d0';

@ProviderFor(duplicateDependencies)
final duplicateDependenciesProvider = DuplicateDependenciesProvider._();

final class DuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  DuplicateDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duplicateDependenciesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[depProvider, dep2Provider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DuplicateDependenciesProvider.$allTransitiveDependencies0,
          DuplicateDependenciesProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = depProvider;
  static final $allTransitiveDependencies1 = dep2Provider;

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
    r'7b939d97fa85cc936c02706f135d1952fb4886f5';

@ProviderFor(duplicateDependencies2)
final duplicateDependencies2Provider = DuplicateDependencies2Provider._();

final class DuplicateDependencies2Provider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  DuplicateDependencies2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duplicateDependencies2Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[familyProvider, family2Provider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DuplicateDependencies2Provider.$allTransitiveDependencies0,
          DuplicateDependencies2Provider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = familyProvider;
  static final $allTransitiveDependencies1 = family2Provider;

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
    r'a525dd6d10ae5b1cc78f26bb5a4e5e92473fde2e';

@ProviderFor(transitiveDuplicateDependencies)
final transitiveDuplicateDependenciesProvider =
    TransitiveDuplicateDependenciesProvider._();

final class TransitiveDuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TransitiveDuplicateDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transitiveDuplicateDependenciesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          duplicateDependenciesProvider,
          duplicateDependencies2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies0,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies1,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies2,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies3,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies4,
          TransitiveDuplicateDependenciesProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = duplicateDependenciesProvider;
  static final $allTransitiveDependencies1 =
      DuplicateDependenciesProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      DuplicateDependenciesProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = duplicateDependencies2Provider;
  static final $allTransitiveDependencies4 =
      DuplicateDependencies2Provider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies5 =
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
    r'dbd17facce57b38386d0544d19816bb45a54b6c4';
