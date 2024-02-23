// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
// expect_lint: provider_dependencies
typedef PlainAnnotationRef = Ref<int>;

////////////
// expect_lint: provider_dependencies
@ProviderFor(plainAnnotation)
const plainAnnotationProvider = PlainAnnotationProvider._();

////////////
// expect_lint: provider_dependencies
final class PlainAnnotationProvider
    extends $FunctionalProvider<int, int, PlainAnnotationRef>
    with $Provider<int, PlainAnnotationRef> {
  ////////////
// expect_lint: provider_dependencies
  const PlainAnnotationProvider._(
      {int Function(
        PlainAnnotationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'plainAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    PlainAnnotationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$plainAnnotationHash();

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
  PlainAnnotationProvider $copyWithCreate(
    int Function(
      PlainAnnotationRef ref,
    ) create,
  ) {
    return PlainAnnotationProvider._(create: create);
  }

  @override
  int create(PlainAnnotationRef ref) {
    final _$cb = _createCb ?? plainAnnotation;
    return _$cb(ref);
  }
}

String _$plainAnnotationHash() => r'ceeb01dfcbd115f3676c8e38ce35a03cff16246b';

typedef CustomAnnotationRef = Ref<int>;

@ProviderFor(customAnnotation)
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider
    extends $FunctionalProvider<int, int, CustomAnnotationRef>
    with $Provider<int, CustomAnnotationRef> {
  const CustomAnnotationProvider._(
      {int Function(
        CustomAnnotationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'customAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CustomAnnotationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$customAnnotationHash();

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
  CustomAnnotationProvider $copyWithCreate(
    int Function(
      CustomAnnotationRef ref,
    ) create,
  ) {
    return CustomAnnotationProvider._(create: create);
  }

  @override
  int create(CustomAnnotationRef ref) {
    final _$cb = _createCb ?? customAnnotation;
    return _$cb(ref);
  }
}

String _$customAnnotationHash() => r'04faed9b424be360e594870f91c4ef4689f05672';

typedef CustomAnnotationWithTrailingCommaRef = Ref<int>;

@ProviderFor(customAnnotationWithTrailingComma)
const customAnnotationWithTrailingCommaProvider =
    CustomAnnotationWithTrailingCommaProvider._();

final class CustomAnnotationWithTrailingCommaProvider
    extends $FunctionalProvider<int, int, CustomAnnotationWithTrailingCommaRef>
    with $Provider<int, CustomAnnotationWithTrailingCommaRef> {
  const CustomAnnotationWithTrailingCommaProvider._(
      {int Function(
        CustomAnnotationWithTrailingCommaRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'customAnnotationWithTrailingCommaProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CustomAnnotationWithTrailingCommaRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$customAnnotationWithTrailingCommaHash();

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
  CustomAnnotationWithTrailingCommaProvider $copyWithCreate(
    int Function(
      CustomAnnotationWithTrailingCommaRef ref,
    ) create,
  ) {
    return CustomAnnotationWithTrailingCommaProvider._(create: create);
  }

  @override
  int create(CustomAnnotationWithTrailingCommaRef ref) {
    final _$cb = _createCb ?? customAnnotationWithTrailingComma;
    return _$cb(ref);
  }
}

String _$customAnnotationWithTrailingCommaHash() =>
    r'b5c62d769dfc53d6d77e8fde9e0eb7d8a0ab9d18';

typedef ExistingDepRef = Ref<int>;

@ProviderFor(existingDep)
const existingDepProvider = ExistingDepProvider._();

final class ExistingDepProvider
    extends $FunctionalProvider<int, int, ExistingDepRef>
    with $Provider<int, ExistingDepRef> {
  const ExistingDepProvider._(
      {int Function(
        ExistingDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'existingDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    ExistingDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$existingDepHash();

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
  ExistingDepProvider $copyWithCreate(
    int Function(
      ExistingDepRef ref,
    ) create,
  ) {
    return ExistingDepProvider._(create: create);
  }

  @override
  int create(ExistingDepRef ref) {
    final _$cb = _createCb ?? existingDep;
    return _$cb(ref);
  }
}

String _$existingDepHash() => r'8d7866d1af7e350d7c792e43a542cd47b130b239';

typedef MultipleDepsRef = Ref<int>;

@ProviderFor(multipleDeps)
const multipleDepsProvider = MultipleDepsProvider._();

final class MultipleDepsProvider
    extends $FunctionalProvider<int, int, MultipleDepsRef>
    with $Provider<int, MultipleDepsRef> {
  const MultipleDepsProvider._(
      {int Function(
        MultipleDepsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'multipleDepsProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    MultipleDepsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$multipleDepsHash();

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
  MultipleDepsProvider $copyWithCreate(
    int Function(
      MultipleDepsRef ref,
    ) create,
  ) {
    return MultipleDepsProvider._(create: create);
  }

  @override
  int create(MultipleDepsRef ref) {
    final _$cb = _createCb ?? multipleDeps;
    return _$cb(ref);
  }
}

String _$multipleDepsHash() => r'9d08791636a0435ba115062a453d0d9e530ecf71';

typedef ExtraDepRef = Ref<int>;

@ProviderFor(extraDep)
const extraDepProvider = ExtraDepProvider._();

final class ExtraDepProvider extends $FunctionalProvider<int, int, ExtraDepRef>
    with $Provider<int, ExtraDepRef> {
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

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
