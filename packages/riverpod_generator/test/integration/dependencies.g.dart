// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef DepRef = Ref<int>;

const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int, DepRef>
    with $Provider<int, DepRef> {
  const DepProvider._(
      {int Function(
        DepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'depProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$depHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(DepRef ref) {
    final fn = _createCb ?? dep;

    return fn(
      ref,
    );
  }

  @override
  DepProvider copyWithCreate(
    int Function(
      DepRef ref,
    ) create,
  ) {
    return DepProvider._(create: create);
  }
}

String _$depHash() => r'2213a401e03a1a914579b4a3a7707b783de9efba';

typedef FamilyRef = Ref<int>;

const familyProvider = FamilyFamily._();

final class FamilyProvider extends $FunctionalProvider<int, int, FamilyRef>
    with $Provider<int, FamilyRef> {
  const FamilyProvider._(
      {required FamilyFamily super.from,
      required (int,) super.argument,
      int Function(
        FamilyRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    FamilyRef ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(FamilyRef ref) {
    final fn = _createCb ?? family;
    final (int,) argument = this.argument! as (int,);
    return fn(
      ref,
      argument.$1,
    );
  }

  @override
  FamilyProvider copyWithCreate(
    int Function(
      FamilyRef ref,
    ) create,
  ) {
    return FamilyProvider._(
        argument: argument! as (int,),
        from: from! as FamilyFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }
}

String _$familyHash() => r'8c228ff14b8c6cf1f3d4d6266232d64b5057c440';

final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyProvider call(
    int id,
  ) =>
      FamilyProvider._(argument: (id,), from: this);

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() => r'family';
}

typedef ProviderRef = Ref<int>;

const providerProvider = ProviderProvider._();

final class ProviderProvider extends $FunctionalProvider<int, int, ProviderRef>
    with $Provider<int, ProviderRef> {
  const ProviderProvider._(
      {int Function(
        ProviderRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'providerProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            depProvider,
            familyProvider,
            dep2Provider,
            family2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
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

  final int Function(
    ProviderRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$providerHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(ProviderRef ref) {
    final fn = _createCb ?? provider;

    return fn(
      ref,
    );
  }

  @override
  ProviderProvider copyWithCreate(
    int Function(
      ProviderRef ref,
    ) create,
  ) {
    return ProviderProvider._(create: create);
  }
}

String _$providerHash() => r'6c9184ef4c6a410a2132e1ecc13a2e646e936d37';

typedef Provider2Ref = Ref<int>;

const provider2Provider = Provider2Provider._();

final class Provider2Provider
    extends $FunctionalProvider<int, int, Provider2Ref>
    with $Provider<int, Provider2Ref> {
  const Provider2Provider._(
      {int Function(
        Provider2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'provider2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            depProvider,
            familyProvider,
            dep2Provider,
            family2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
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

  final int Function(
    Provider2Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$provider2Hash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(Provider2Ref ref) {
    final fn = _createCb ?? provider2;

    return fn(
      ref,
    );
  }

  @override
  Provider2Provider copyWithCreate(
    int Function(
      Provider2Ref ref,
    ) create,
  ) {
    return Provider2Provider._(create: create);
  }
}

String _$provider2Hash() => r'70d908579c5e64ce6558b42f433adfb80f4dc79b';

typedef TransitiveDependenciesRef = Ref<int>;

const transitiveDependenciesProvider = TransitiveDependenciesProvider._();

final class TransitiveDependenciesProvider
    extends $FunctionalProvider<int, int, TransitiveDependenciesRef>
    with $Provider<int, TransitiveDependenciesRef> {
  const TransitiveDependenciesProvider._(
      {int Function(
        TransitiveDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'transitiveDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[providerProvider],
          allTransitiveDependencies: const <ProviderOrFamily>{
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

  final int Function(
    TransitiveDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$transitiveDependenciesHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(TransitiveDependenciesRef ref) {
    final fn = _createCb ?? transitiveDependencies;

    return fn(
      ref,
    );
  }

  @override
  TransitiveDependenciesProvider copyWithCreate(
    int Function(
      TransitiveDependenciesRef ref,
    ) create,
  ) {
    return TransitiveDependenciesProvider._(create: create);
  }
}

String _$transitiveDependenciesHash() =>
    r'9c81823224bb28a5dc482328c04ce76293370877';

typedef SmallTransitiveDependencyCountRef = Ref<int>;

const smallTransitiveDependencyCountProvider =
    SmallTransitiveDependencyCountProvider._();

final class SmallTransitiveDependencyCountProvider
    extends $FunctionalProvider<int, int, SmallTransitiveDependencyCountRef>
    with $Provider<int, SmallTransitiveDependencyCountRef> {
  const SmallTransitiveDependencyCountProvider._(
      {int Function(
        SmallTransitiveDependencyCountRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'smallTransitiveDependencyCountProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            depProvider,
            familyProvider,
            dep2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>[
            SmallTransitiveDependencyCountProvider.$allTransitiveDependencies0,
            SmallTransitiveDependencyCountProvider.$allTransitiveDependencies1,
            SmallTransitiveDependencyCountProvider.$allTransitiveDependencies2,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;

  final int Function(
    SmallTransitiveDependencyCountRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$smallTransitiveDependencyCountHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(SmallTransitiveDependencyCountRef ref) {
    final fn = _createCb ?? smallTransitiveDependencyCount;

    return fn(
      ref,
    );
  }

  @override
  SmallTransitiveDependencyCountProvider copyWithCreate(
    int Function(
      SmallTransitiveDependencyCountRef ref,
    ) create,
  ) {
    return SmallTransitiveDependencyCountProvider._(create: create);
  }
}

String _$smallTransitiveDependencyCountHash() =>
    r'34689e1ba57e2959975cbf8ebd6c9483f4652a73';

typedef EmptyDependenciesFunctionalRef = Ref<int>;

const emptyDependenciesFunctionalProvider =
    EmptyDependenciesFunctionalProvider._();

final class EmptyDependenciesFunctionalProvider
    extends $FunctionalProvider<int, int, EmptyDependenciesFunctionalRef>
    with $Provider<int, EmptyDependenciesFunctionalRef> {
  const EmptyDependenciesFunctionalProvider._(
      {int Function(
        EmptyDependenciesFunctionalRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'emptyDependenciesFunctionalProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    EmptyDependenciesFunctionalRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$emptyDependenciesFunctionalHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(EmptyDependenciesFunctionalRef ref) {
    final fn = _createCb ?? emptyDependenciesFunctional;

    return fn(
      ref,
    );
  }

  @override
  EmptyDependenciesFunctionalProvider copyWithCreate(
    int Function(
      EmptyDependenciesFunctionalRef ref,
    ) create,
  ) {
    return EmptyDependenciesFunctionalProvider._(create: create);
  }
}

String _$emptyDependenciesFunctionalHash() =>
    r'592bebd079450e2071fb12d68c3ae333d5c28359';

typedef ProviderWithDependenciesRef = Ref<int>;

const providerWithDependenciesProvider = ProviderWithDependenciesProvider._();

final class ProviderWithDependenciesProvider
    extends $FunctionalProvider<int, int, ProviderWithDependenciesRef>
    with $Provider<int, ProviderWithDependenciesRef> {
  const ProviderWithDependenciesProvider._(
      {int Function(
        ProviderWithDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'providerWithDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            _privateDepProvider,
            publicDepProvider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>[
            ProviderWithDependenciesProvider.$allTransitiveDependencies0,
            ProviderWithDependenciesProvider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = _privateDepProvider;
  static const $allTransitiveDependencies1 = publicDepProvider;

  final int Function(
    ProviderWithDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$providerWithDependenciesHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(ProviderWithDependenciesRef ref) {
    final fn = _createCb ?? providerWithDependencies;

    return fn(
      ref,
    );
  }

  @override
  ProviderWithDependenciesProvider copyWithCreate(
    int Function(
      ProviderWithDependenciesRef ref,
    ) create,
  ) {
    return ProviderWithDependenciesProvider._(create: create);
  }
}

String _$providerWithDependenciesHash() =>
    r'beecbe7a41b647ab92367dbcc12055bcd6345af7';

typedef _PrivateDepRef = Ref<int>;

const _privateDepProvider = _PrivateDepProvider._();

final class _PrivateDepProvider
    extends $FunctionalProvider<int, int, _PrivateDepRef>
    with $Provider<int, _PrivateDepRef> {
  const _PrivateDepProvider._(
      {int Function(
        _PrivateDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'_privateDepProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    _PrivateDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateDepHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(_PrivateDepRef ref) {
    final fn = _createCb ?? _privateDep;

    return fn(
      ref,
    );
  }

  @override
  _PrivateDepProvider copyWithCreate(
    int Function(
      _PrivateDepRef ref,
    ) create,
  ) {
    return _PrivateDepProvider._(create: create);
  }
}

String _$privateDepHash() => r'f610d91bd39e0dcffe6ff4e74160964a291289d9';

typedef PublicDepRef = Ref<int>;

const publicDepProvider = PublicDepProvider._();

final class PublicDepProvider
    extends $FunctionalProvider<int, int, PublicDepRef>
    with $Provider<int, PublicDepRef> {
  const PublicDepProvider._(
      {int Function(
        PublicDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'publicDepProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    PublicDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicDepHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(PublicDepRef ref) {
    final fn = _createCb ?? publicDep;

    return fn(
      ref,
    );
  }

  @override
  PublicDepProvider copyWithCreate(
    int Function(
      PublicDepRef ref,
    ) create,
  ) {
    return PublicDepProvider._(create: create);
  }
}

String _$publicDepHash() => r'bcb69aace017c86c3c4b8eccf59fa22d010834bc';

typedef DuplicateDependenciesRef = Ref<int>;

const duplicateDependenciesProvider = DuplicateDependenciesProvider._();

final class DuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, DuplicateDependenciesRef>
    with $Provider<int, DuplicateDependenciesRef> {
  const DuplicateDependenciesProvider._(
      {int Function(
        DuplicateDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'duplicateDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider, dep2Provider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            DuplicateDependenciesProvider.$allTransitiveDependencies0,
            DuplicateDependenciesProvider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = dep2Provider;

  final int Function(
    DuplicateDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$duplicateDependenciesHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(DuplicateDependenciesRef ref) {
    final fn = _createCb ?? duplicateDependencies;

    return fn(
      ref,
    );
  }

  @override
  DuplicateDependenciesProvider copyWithCreate(
    int Function(
      DuplicateDependenciesRef ref,
    ) create,
  ) {
    return DuplicateDependenciesProvider._(create: create);
  }
}

String _$duplicateDependenciesHash() =>
    r'8e4c4b40d7500e97e8490874d48cc960c64af712';

typedef DuplicateDependencies2Ref = Ref<int>;

const duplicateDependencies2Provider = DuplicateDependencies2Provider._();

final class DuplicateDependencies2Provider
    extends $FunctionalProvider<int, int, DuplicateDependencies2Ref>
    with $Provider<int, DuplicateDependencies2Ref> {
  const DuplicateDependencies2Provider._(
      {int Function(
        DuplicateDependencies2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'duplicateDependencies2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            familyProvider,
            family2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>[
            DuplicateDependencies2Provider.$allTransitiveDependencies0,
            DuplicateDependencies2Provider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = familyProvider;
  static const $allTransitiveDependencies1 = family2Provider;

  final int Function(
    DuplicateDependencies2Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$duplicateDependencies2Hash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(DuplicateDependencies2Ref ref) {
    final fn = _createCb ?? duplicateDependencies2;

    return fn(
      ref,
    );
  }

  @override
  DuplicateDependencies2Provider copyWithCreate(
    int Function(
      DuplicateDependencies2Ref ref,
    ) create,
  ) {
    return DuplicateDependencies2Provider._(create: create);
  }
}

String _$duplicateDependencies2Hash() =>
    r'43a4ff16a760fc697426a5b1ebc1f8882c816cfb';

typedef TransitiveDuplicateDependenciesRef = Ref<int>;

const transitiveDuplicateDependenciesProvider =
    TransitiveDuplicateDependenciesProvider._();

final class TransitiveDuplicateDependenciesProvider
    extends $FunctionalProvider<int, int, TransitiveDuplicateDependenciesRef>
    with $Provider<int, TransitiveDuplicateDependenciesRef> {
  const TransitiveDuplicateDependenciesProvider._(
      {int Function(
        TransitiveDuplicateDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'transitiveDuplicateDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            duplicateDependenciesProvider,
            duplicateDependencies2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
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

  final int Function(
    TransitiveDuplicateDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$transitiveDuplicateDependenciesHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  int create(TransitiveDuplicateDependenciesRef ref) {
    final fn = _createCb ?? transitiveDuplicateDependencies;

    return fn(
      ref,
    );
  }

  @override
  TransitiveDuplicateDependenciesProvider copyWithCreate(
    int Function(
      TransitiveDuplicateDependenciesRef ref,
    ) create,
  ) {
    return TransitiveDuplicateDependenciesProvider._(create: create);
  }
}

String _$transitiveDuplicateDependenciesHash() =>
    r'aba44b6c1cf82eea782ad260f2e95d9f771f12ac';

const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $NotifierProvider<Dep2, int> {
  const Dep2Provider._(
      {super.runNotifierBuildOverride, Dep2 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'dep2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Dep2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

  @$internal
  @override
  Dep2 create() => _createCb?.call() ?? Dep2();

  @$internal
  @override
  Dep2Provider copyWithCreate(
    Dep2 Function() create,
  ) {
    return Dep2Provider._(create: create);
  }

  @$internal
  @override
  Dep2Provider copyWithBuild(
    int Function(Ref<int>, Dep2) build,
  ) {
    return Dep2Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Dep2, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$dep2Hash() => r'2778537df77f6431148c2ce400724da3e2ab4b94';

abstract class _$Dep2 extends $Notifier<int> {
  int build();

  @$internal
  @override
  int runBuild() => build();
}

const family2Provider = Family2Family._();

final class Family2Provider extends $NotifierProvider<Family2, int> {
  const Family2Provider._(
      {required Family2Family super.from,
      required (int,) super.argument,
      super.runNotifierBuildOverride,
      Family2 Function()? create})
      : _createCb = create,
        super(
          name: r'family2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Family2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$family2Hash();

  @$internal
  @override
  Family2 create() => _createCb?.call() ?? Family2();

  @$internal
  @override
  Family2Provider copyWithCreate(
    Family2 Function() create,
  ) {
    return Family2Provider._(
        argument: argument! as (int,),
        from: from! as Family2Family,
        create: create);
  }

  @$internal
  @override
  Family2Provider copyWithBuild(
    int Function(Ref<int>, Family2) build,
  ) {
    return Family2Provider._(
        argument: argument! as (int,),
        from: from! as Family2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Family2, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is Family2Provider && other.argument == argument;
  }
}

String _$family2Hash() => r'ce727b262aae067b0d4f703f03670abb70ad8977';

final class Family2Family extends Family {
  const Family2Family._()
      : super(
          name: r'family2Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Family2Provider call(
    int id,
  ) =>
      Family2Provider._(argument: (id,), from: this);

  @override
  String debugGetCreateSourceHash() => _$family2Hash();

  @override
  String toString() => r'Family2';
}

abstract class _$Family2 extends $Notifier<int> {
  late final _$args =
      (ref as $NotifierProviderElement).origin.argument as (int,);
  int get id => _$args.$1;

  int build(
    int id,
  );

  @$internal
  @override
  int runBuild() => build(
        _$args.$1,
      );
}

const provider3Provider = Provider3Provider._();

final class Provider3Provider extends $NotifierProvider<Provider3, int> {
  const Provider3Provider._(
      {super.runNotifierBuildOverride, Provider3 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'provider3Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            depProvider,
            familyProvider,
            dep2Provider,
            family2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
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

  final Provider3 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$provider3Hash();

  @$internal
  @override
  Provider3 create() => _createCb?.call() ?? Provider3();

  @$internal
  @override
  Provider3Provider copyWithCreate(
    Provider3 Function() create,
  ) {
    return Provider3Provider._(create: create);
  }

  @$internal
  @override
  Provider3Provider copyWithBuild(
    int Function(Ref<int>, Provider3) build,
  ) {
    return Provider3Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Provider3, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$provider3Hash() => r'dfdd6dec6cfee543c73d99593ce98d68f4db385c';

abstract class _$Provider3 extends $Notifier<int> {
  int build();

  @$internal
  @override
  int runBuild() => build();
}

const provider4Provider = Provider4Family._();

final class Provider4Provider extends $NotifierProvider<Provider4, int> {
  const Provider4Provider._(
      {required Provider4Family super.from,
      required (int,) super.argument,
      super.runNotifierBuildOverride,
      Provider4 Function()? create})
      : _createCb = create,
        super(
          name: r'provider4Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = familyProvider;
  static const $allTransitiveDependencies2 = dep2Provider;
  static const $allTransitiveDependencies3 = family2Provider;

  final Provider4 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$provider4Hash();

  @$internal
  @override
  Provider4 create() => _createCb?.call() ?? Provider4();

  @$internal
  @override
  Provider4Provider copyWithCreate(
    Provider4 Function() create,
  ) {
    return Provider4Provider._(
        argument: argument! as (int,),
        from: from! as Provider4Family,
        create: create);
  }

  @$internal
  @override
  Provider4Provider copyWithBuild(
    int Function(Ref<int>, Provider4) build,
  ) {
    return Provider4Provider._(
        argument: argument! as (int,),
        from: from! as Provider4Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Provider4, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is Provider4Provider && other.argument == argument;
  }
}

String _$provider4Hash() => r'1c955214d99695bb694c96374b277aac58e734df';

final class Provider4Family extends Family {
  const Provider4Family._()
      : super(
          name: r'provider4Provider',
          dependencies: const <ProviderOrFamily>[
            depProvider,
            familyProvider,
            dep2Provider,
            family2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
            Provider4Provider.$allTransitiveDependencies0,
            Provider4Provider.$allTransitiveDependencies1,
            Provider4Provider.$allTransitiveDependencies2,
            Provider4Provider.$allTransitiveDependencies3,
          },
          isAutoDispose: true,
        );

  Provider4Provider call(
    int id,
  ) =>
      Provider4Provider._(argument: (id,), from: this);

  @override
  String debugGetCreateSourceHash() => _$provider4Hash();

  @override
  String toString() => r'Provider4';
}

abstract class _$Provider4 extends $Notifier<int> {
  late final _$args =
      (ref as $NotifierProviderElement).origin.argument as (int,);
  int get id => _$args.$1;

  int build(
    int id,
  );

  @$internal
  @override
  int runBuild() => build(
        _$args.$1,
      );
}

const emptyDependenciesClassBasedProvider =
    EmptyDependenciesClassBasedProvider._();

final class EmptyDependenciesClassBasedProvider
    extends $NotifierProvider<EmptyDependenciesClassBased, int> {
  const EmptyDependenciesClassBasedProvider._(
      {super.runNotifierBuildOverride,
      EmptyDependenciesClassBased Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'emptyDependenciesClassBasedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final EmptyDependenciesClassBased Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$emptyDependenciesClassBasedHash();

  @$internal
  @override
  EmptyDependenciesClassBased create() =>
      _createCb?.call() ?? EmptyDependenciesClassBased();

  @$internal
  @override
  EmptyDependenciesClassBasedProvider copyWithCreate(
    EmptyDependenciesClassBased Function() create,
  ) {
    return EmptyDependenciesClassBasedProvider._(create: create);
  }

  @$internal
  @override
  EmptyDependenciesClassBasedProvider copyWithBuild(
    int Function(Ref<int>, EmptyDependenciesClassBased) build,
  ) {
    return EmptyDependenciesClassBasedProvider._(
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<EmptyDependenciesClassBased, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$emptyDependenciesClassBasedHash() =>
    r'e20c18353984a81977b656e9879b3841dbaedc6c';

abstract class _$EmptyDependenciesClassBased extends $Notifier<int> {
  int build();

  @$internal
  @override
  int runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
