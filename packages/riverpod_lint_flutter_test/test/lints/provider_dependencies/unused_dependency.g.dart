// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unused_dependency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RootRef = Ref<int>;

@ProviderFor(root)
const rootProvider = RootProvider._();

final class RootProvider extends $FunctionalProvider<int, int, RootRef>
    with $Provider<int, RootRef> {
  const RootProvider._(
      {int Function(
        RootRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    RootRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rootHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RootProvider $copyWithCreate(
    int Function(
      RootRef ref,
    ) create,
  ) {
    return RootProvider._(create: create);
  }

  @override
  int create(RootRef ref) {
    final _$cb = _createCb ?? root;
    return _$cb(ref);
  }
}

String _$rootHash() => r'1cd85d73316aad02169ff0f5e7af5cf1423410ff';

typedef DepRef = Ref<int>;

@ProviderFor(dep)
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
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    DepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$depHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  DepProvider $copyWithCreate(
    int Function(
      DepRef ref,
    ) create,
  ) {
    return DepProvider._(create: create);
  }

  @override
  int create(DepRef ref) {
    final _$cb = _createCb ?? dep;
    return _$cb(ref);
  }
}

String _$depHash() => r'749c4d696d29c72686cabcabd6fa7855f5cbf4db';

typedef Dep2Ref = Ref<int>;

@ProviderFor(dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int, Dep2Ref>
    with $Provider<int, Dep2Ref> {
  const Dep2Provider._(
      {int Function(
        Dep2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'dep2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Dep2Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Dep2Provider $copyWithCreate(
    int Function(
      Dep2Ref ref,
    ) create,
  ) {
    return Dep2Provider._(create: create);
  }

  @override
  int create(Dep2Ref ref) {
    final _$cb = _createCb ?? dep2;
    return _$cb(ref);
  }
}

String _$dep2Hash() => r'13cd909366c79168e3d9cd95f529ddbcee6de7dc';

////////////
typedef ExtraDepRef = Ref<int>;

////////////
@ProviderFor(extraDep)
const extraDepProvider = ExtraDepProvider._();

////////////
final class ExtraDepProvider extends $FunctionalProvider<int, int, ExtraDepRef>
    with $Provider<int, ExtraDepRef> {
  ////////////
  const ExtraDepProvider._(
      {int Function(
        ExtraDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'extraDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider, dep2Provider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            ExtraDepProvider.$allTransitiveDependencies0,
            ExtraDepProvider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = dep2Provider;

  final int Function(
    ExtraDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$extraDepHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ExtraDepProvider $copyWithCreate(
    int Function(
      ExtraDepRef ref,
    ) create,
  ) {
    return ExtraDepProvider._(create: create);
  }

  @override
  int create(ExtraDepRef ref) {
    final _$cb = _createCb ?? extraDep;
    return _$cb(ref);
  }
}

String _$extraDepHash() => r'038d9c819b5d91eb1f7166194d8e646f17ea24d7';

typedef NoDepRef = Ref<int>;

@ProviderFor(noDep)
const noDepProvider = NoDepProvider._();

final class NoDepProvider extends $FunctionalProvider<int, int, NoDepRef>
    with $Provider<int, NoDepRef> {
  const NoDepProvider._(
      {int Function(
        NoDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'noDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    NoDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noDepHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  NoDepProvider $copyWithCreate(
    int Function(
      NoDepRef ref,
    ) create,
  ) {
    return NoDepProvider._(create: create);
  }

  @override
  int create(NoDepRef ref) {
    final _$cb = _createCb ?? noDep;
    return _$cb(ref);
  }
}

String _$noDepHash() => r'38d78ded1eba491968c0200cc0b51969fcf3ec9a';

typedef DependenciesFirstThenKeepAliveRef = Ref<int>;

@ProviderFor(dependenciesFirstThenKeepAlive)
const dependenciesFirstThenKeepAliveProvider =
    DependenciesFirstThenKeepAliveProvider._();

final class DependenciesFirstThenKeepAliveProvider
    extends $FunctionalProvider<int, int, DependenciesFirstThenKeepAliveRef>
    with $Provider<int, DependenciesFirstThenKeepAliveRef> {
  const DependenciesFirstThenKeepAliveProvider._(
      {int Function(
        DependenciesFirstThenKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'dependenciesFirstThenKeepAliveProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            DependenciesFirstThenKeepAliveProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    DependenciesFirstThenKeepAliveRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dependenciesFirstThenKeepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  DependenciesFirstThenKeepAliveProvider $copyWithCreate(
    int Function(
      DependenciesFirstThenKeepAliveRef ref,
    ) create,
  ) {
    return DependenciesFirstThenKeepAliveProvider._(create: create);
  }

  @override
  int create(DependenciesFirstThenKeepAliveRef ref) {
    final _$cb = _createCb ?? dependenciesFirstThenKeepAlive;
    return _$cb(ref);
  }
}

String _$dependenciesFirstThenKeepAliveHash() =>
    r'15604dafd167408515dfb4e846fab0af46e7e566';

typedef NoDepNoParamRef = Ref<int>;

@ProviderFor(noDepNoParam)
const noDepNoParamProvider = NoDepNoParamProvider._();

final class NoDepNoParamProvider
    extends $FunctionalProvider<int, int, NoDepNoParamRef>
    with $Provider<int, NoDepNoParamRef> {
  const NoDepNoParamProvider._(
      {int Function(
        NoDepNoParamRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'noDepNoParamProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepNoParamProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    NoDepNoParamRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noDepNoParamHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  NoDepNoParamProvider $copyWithCreate(
    int Function(
      NoDepNoParamRef ref,
    ) create,
  ) {
    return NoDepNoParamProvider._(create: create);
  }

  @override
  int create(NoDepNoParamRef ref) {
    final _$cb = _createCb ?? noDepNoParam;
    return _$cb(ref);
  }
}

String _$noDepNoParamHash() => r'fe52f15a4d98159beafe8b9a177073f6b6cbae6d';

typedef NoDepWithoutCommaRef = Ref<int>;

@ProviderFor(noDepWithoutComma)
const noDepWithoutCommaProvider = NoDepWithoutCommaProvider._();

final class NoDepWithoutCommaProvider
    extends $FunctionalProvider<int, int, NoDepWithoutCommaRef>
    with $Provider<int, NoDepWithoutCommaRef> {
  const NoDepWithoutCommaProvider._(
      {int Function(
        NoDepWithoutCommaRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'noDepWithoutCommaProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepWithoutCommaProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    NoDepWithoutCommaRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noDepWithoutCommaHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  NoDepWithoutCommaProvider $copyWithCreate(
    int Function(
      NoDepWithoutCommaRef ref,
    ) create,
  ) {
    return NoDepWithoutCommaProvider._(create: create);
  }

  @override
  int create(NoDepWithoutCommaRef ref) {
    final _$cb = _createCb ?? noDepWithoutComma;
    return _$cb(ref);
  }
}

String _$noDepWithoutCommaHash() => r'59d5a7874da40605b1b187766ebb4927d2eaae81';

typedef RootDepRef = Ref<int>;

@ProviderFor(rootDep)
const rootDepProvider = RootDepProvider._();

final class RootDepProvider extends $FunctionalProvider<int, int, RootDepRef>
    with $Provider<int, RootDepRef> {
  const RootDepProvider._(
      {int Function(
        RootDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rootDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[rootProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            RootDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = rootProvider;

  final int Function(
    RootDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rootDepHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RootDepProvider $copyWithCreate(
    int Function(
      RootDepRef ref,
    ) create,
  ) {
    return RootDepProvider._(create: create);
  }

  @override
  int create(RootDepRef ref) {
    final _$cb = _createCb ?? rootDep;
    return _$cb(ref);
  }
}

String _$rootDepHash() => r'a57728bf865d5a9a73f40f08b038946418cdcf52';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
