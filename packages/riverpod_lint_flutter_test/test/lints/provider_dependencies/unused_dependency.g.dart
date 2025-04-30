// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unused_dependency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(root)
const rootProvider = RootProvider._();

final class RootProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RootProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'rootProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rootHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return root(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$rootHash() => r'dda8bbb46cb4d7c658597669e3be92e2447dcfb0';

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DepProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'depProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          $allTransitiveDependencies: const <ProviderOrFamily>[],
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
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

@ProviderFor(dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Dep2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dep2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          $allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dep2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
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
  const ExtraDepProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'extraDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider, dep2Provider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            ExtraDepProvider.$allTransitiveDependencies0,
            ExtraDepProvider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = dep2Provider;

  @override
  String debugGetCreateSourceHash() => _$extraDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return extraDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$extraDepHash() => r'586c1a0f0ac120f8608c025a6a47fe5282b80320';

@ProviderFor(noDep)
const noDepProvider = NoDepProvider._();

final class NoDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  @override
  String debugGetCreateSourceHash() => _$noDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return noDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$noDepHash() => r'99022366e7dd3e19464747d1e2f23184691aa134';

@ProviderFor(dependenciesFirstThenKeepAlive)
const dependenciesFirstThenKeepAliveProvider =
    DependenciesFirstThenKeepAliveProvider._();

final class DependenciesFirstThenKeepAliveProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const DependenciesFirstThenKeepAliveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dependenciesFirstThenKeepAliveProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            DependenciesFirstThenKeepAliveProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  @override
  String debugGetCreateSourceHash() => _$dependenciesFirstThenKeepAliveHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dependenciesFirstThenKeepAlive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$dependenciesFirstThenKeepAliveHash() =>
    r'b9bd9082ce9a72feea33f9327b26e7b428cadfd3';

@ProviderFor(noDepNoParam)
const noDepNoParamProvider = NoDepNoParamProvider._();

final class NoDepNoParamProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepNoParamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepNoParamProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepNoParamProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  @override
  String debugGetCreateSourceHash() => _$noDepNoParamHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return noDepNoParam(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$noDepNoParamHash() => r'ea3e66e28bbfb716adf89cea37a1607c78283e06';

@ProviderFor(noDepWithoutComma)
const noDepWithoutCommaProvider = NoDepWithoutCommaProvider._();

final class NoDepWithoutCommaProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NoDepWithoutCommaProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noDepWithoutCommaProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            NoDepWithoutCommaProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  @override
  String debugGetCreateSourceHash() => _$noDepWithoutCommaHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return noDepWithoutComma(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$noDepWithoutCommaHash() => r'a3b07e526b4829ee4ed1848de4ff64c3b05c1a30';

@ProviderFor(rootDep)
const rootDepProvider = RootDepProvider._();

final class RootDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RootDepProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'rootDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[rootProvider],
          $allTransitiveDependencies: const <ProviderOrFamily>[
            RootDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = rootProvider;

  @override
  String debugGetCreateSourceHash() => _$rootDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return rootDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$rootDepHash() => r'c406dc7e58c18bc46ed722a81208bc13fe62654a';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
