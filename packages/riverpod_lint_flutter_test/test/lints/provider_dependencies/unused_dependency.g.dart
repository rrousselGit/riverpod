// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unused_dependency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(root)
const rootProvider = RootProvider._();

final class RootProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RootProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RootProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return RootProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? root;
    return _$cb(ref);
  }
}

String _$rootHash() => r'dda8bbb46cb4d7c658597669e3be92e2447dcfb0';

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DepProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'depProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DepProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return DepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? dep;
    return _$cb(ref);
  }
}

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

@ProviderFor(dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Dep2Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'dep2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Dep2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return Dep2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? dep2;
    return _$cb(ref);
  }
}

String _$dep2Hash() => r'97901e825cdcf5b1ac455b0fe8a2111662ce9f13';

////////////
@ProviderFor(extraDep)
const extraDepProvider = ExtraDepProvider._();

////////////
final class ExtraDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  ////////////
  const ExtraDepProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ExtraDepProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return ExtraDepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? extraDep;
    return _$cb(ref);
  }
}

String _$extraDepHash() => r'586c1a0f0ac120f8608c025a6a47fe5282b80320';

@ProviderFor(noDep)
const noDepProvider = NoDepProvider._();

final class NoDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  NoDepProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return NoDepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? noDep;
    return _$cb(ref);
  }
}

String _$noDepHash() => r'99022366e7dd3e19464747d1e2f23184691aa134';

@ProviderFor(dependenciesFirstThenKeepAlive)
const dependenciesFirstThenKeepAliveProvider =
    DependenciesFirstThenKeepAliveProvider._();

final class DependenciesFirstThenKeepAliveProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const DependenciesFirstThenKeepAliveProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'dependenciesFirstThenKeepAliveProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            DependenciesFirstThenKeepAliveProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DependenciesFirstThenKeepAliveProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return DependenciesFirstThenKeepAliveProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? dependenciesFirstThenKeepAlive;
    return _$cb(ref);
  }
}

String _$dependenciesFirstThenKeepAliveHash() =>
    r'b9bd9082ce9a72feea33f9327b26e7b428cadfd3';

@ProviderFor(noDepNoParam)
const noDepNoParamProvider = NoDepNoParamProvider._();

final class NoDepNoParamProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepNoParamProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepNoParamProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepNoParamProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  NoDepNoParamProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return NoDepNoParamProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? noDepNoParam;
    return _$cb(ref);
  }
}

String _$noDepNoParamHash() => r'ea3e66e28bbfb716adf89cea37a1607c78283e06';

@ProviderFor(noDepWithoutComma)
const noDepWithoutCommaProvider = NoDepWithoutCommaProvider._();

final class NoDepWithoutCommaProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepWithoutCommaProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepWithoutCommaProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepWithoutCommaProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  NoDepWithoutCommaProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return NoDepWithoutCommaProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? noDepWithoutComma;
    return _$cb(ref);
  }
}

String _$noDepWithoutCommaHash() => r'a3b07e526b4829ee4ed1848de4ff64c3b05c1a30';

@ProviderFor(rootDep)
const rootDepProvider = RootDepProvider._();

final class RootDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RootDepProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rootDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[rootProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            RootDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = rootProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RootDepProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return RootDepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? rootDep;
    return _$cb(ref);
  }
}

String _$rootDepHash() => r'c406dc7e58c18bc46ed722a81208bc13fe62654a';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
