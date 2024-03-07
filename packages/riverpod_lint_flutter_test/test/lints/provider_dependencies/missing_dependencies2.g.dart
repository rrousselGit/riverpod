// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef DepRef = Ref<int>;

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int>
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

typedef GeneratedScopedRef = Ref<int>;

@ProviderFor(generatedScoped)
const generatedScopedProvider = GeneratedScopedProvider._();

final class GeneratedScopedProvider extends $FunctionalProvider<int, int>
    with $Provider<int, GeneratedScopedRef> {
  const GeneratedScopedProvider._(
      {int Function(
        GeneratedScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'generatedScopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    GeneratedScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedScopedHash();

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
  GeneratedScopedProvider $copyWithCreate(
    int Function(
      GeneratedScopedRef ref,
    ) create,
  ) {
    return GeneratedScopedProvider._(create: create);
  }

  @override
  int create(GeneratedScopedRef ref) {
    final _$cb = _createCb ?? generatedScoped;
    return _$cb(ref);
  }
}

String _$generatedScopedHash() => r'2eefb4cc872ddccfeb862142fd5f7e6d8bd82159';

typedef GeneratedRootRef = Ref<int>;

@ProviderFor(generatedRoot)
const generatedRootProvider = GeneratedRootProvider._();

final class GeneratedRootProvider extends $FunctionalProvider<int, int>
    with $Provider<int, GeneratedRootRef> {
  const GeneratedRootProvider._(
      {int Function(
        GeneratedRootRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'generatedRootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    GeneratedRootRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedRootHash();

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
  GeneratedRootProvider $copyWithCreate(
    int Function(
      GeneratedRootRef ref,
    ) create,
  ) {
    return GeneratedRootProvider._(create: create);
  }

  @override
  int create(GeneratedRootRef ref) {
    final _$cb = _createCb ?? generatedRoot;
    return _$cb(ref);
  }
}

String _$generatedRootHash() => r'080e3393566db0f44add3607e28a5a2980948704';

typedef WatchScopedButNoDependenciesRef = Ref<int>;

@ProviderFor(watchScopedButNoDependencies)
const watchScopedButNoDependenciesProvider =
    WatchScopedButNoDependenciesProvider._();

final class WatchScopedButNoDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchScopedButNoDependenciesRef> {
  const WatchScopedButNoDependenciesProvider._(
      {int Function(
        WatchScopedButNoDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchScopedButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    WatchScopedButNoDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$watchScopedButNoDependenciesHash();

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
  WatchScopedButNoDependenciesProvider $copyWithCreate(
    int Function(
      WatchScopedButNoDependenciesRef ref,
    ) create,
  ) {
    return WatchScopedButNoDependenciesProvider._(create: create);
  }

  @override
  int create(WatchScopedButNoDependenciesRef ref) {
    final _$cb = _createCb ?? watchScopedButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchScopedButNoDependenciesHash() =>
    r'3ec52c4ab2ea2b3204b7aa049d1756c01c014ff0';

typedef WatchGeneratedScopedButNoDependenciesRef = Ref<int>;

@ProviderFor(watchGeneratedScopedButNoDependencies)
const watchGeneratedScopedButNoDependenciesProvider =
    WatchGeneratedScopedButNoDependenciesProvider._();

final class WatchGeneratedScopedButNoDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchGeneratedScopedButNoDependenciesRef> {
  const WatchGeneratedScopedButNoDependenciesProvider._(
      {int Function(
        WatchGeneratedScopedButNoDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchGeneratedScopedButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    WatchGeneratedScopedButNoDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedScopedButNoDependenciesHash();

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
  WatchGeneratedScopedButNoDependenciesProvider $copyWithCreate(
    int Function(
      WatchGeneratedScopedButNoDependenciesRef ref,
    ) create,
  ) {
    return WatchGeneratedScopedButNoDependenciesProvider._(create: create);
  }

  @override
  int create(WatchGeneratedScopedButNoDependenciesRef ref) {
    final _$cb = _createCb ?? watchGeneratedScopedButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedButNoDependenciesHash() =>
    r'2a4aba824078fe2c999260b4138939dee96c4fba';

typedef WatchRootButNoDependenciesRef = Ref<int>;

@ProviderFor(watchRootButNoDependencies)
const watchRootButNoDependenciesProvider =
    WatchRootButNoDependenciesProvider._();

final class WatchRootButNoDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchRootButNoDependenciesRef> {
  const WatchRootButNoDependenciesProvider._(
      {int Function(
        WatchRootButNoDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchRootButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    WatchRootButNoDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$watchRootButNoDependenciesHash();

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
  WatchRootButNoDependenciesProvider $copyWithCreate(
    int Function(
      WatchRootButNoDependenciesRef ref,
    ) create,
  ) {
    return WatchRootButNoDependenciesProvider._(create: create);
  }

  @override
  int create(WatchRootButNoDependenciesRef ref) {
    final _$cb = _createCb ?? watchRootButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchRootButNoDependenciesHash() =>
    r'037187e333a5bd5d11d00147d179640b8a0f18dd';

typedef WatchGeneratedRootButNoDependenciesRef = Ref<int>;

@ProviderFor(watchGeneratedRootButNoDependencies)
const watchGeneratedRootButNoDependenciesProvider =
    WatchGeneratedRootButNoDependenciesProvider._();

final class WatchGeneratedRootButNoDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchGeneratedRootButNoDependenciesRef> {
  const WatchGeneratedRootButNoDependenciesProvider._(
      {int Function(
        WatchGeneratedRootButNoDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchGeneratedRootButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    WatchGeneratedRootButNoDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedRootButNoDependenciesHash();

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
  WatchGeneratedRootButNoDependenciesProvider $copyWithCreate(
    int Function(
      WatchGeneratedRootButNoDependenciesRef ref,
    ) create,
  ) {
    return WatchGeneratedRootButNoDependenciesProvider._(create: create);
  }

  @override
  int create(WatchGeneratedRootButNoDependenciesRef ref) {
    final _$cb = _createCb ?? watchGeneratedRootButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootButNoDependenciesHash() =>
    r'ecf43cc257376d2828638ce937813d2b72b46967';

typedef WatchScopedButEmptyDependenciesRef = Ref<int>;

@ProviderFor(watchScopedButEmptyDependencies)
const watchScopedButEmptyDependenciesProvider =
    WatchScopedButEmptyDependenciesProvider._();

final class WatchScopedButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchScopedButEmptyDependenciesRef> {
  const WatchScopedButEmptyDependenciesProvider._(
      {int Function(
        WatchScopedButEmptyDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchScopedButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    WatchScopedButEmptyDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$watchScopedButEmptyDependenciesHash();

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
  WatchScopedButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      WatchScopedButEmptyDependenciesRef ref,
    ) create,
  ) {
    return WatchScopedButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(WatchScopedButEmptyDependenciesRef ref) {
    final _$cb = _createCb ?? watchScopedButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchScopedButEmptyDependenciesHash() =>
    r'6b7526eb9dfd70c8249c71efffc60d612ca92f16';

typedef WatchGeneratedScopedButEmptyDependenciesRef = Ref<int>;

@ProviderFor(watchGeneratedScopedButEmptyDependencies)
const watchGeneratedScopedButEmptyDependenciesProvider =
    WatchGeneratedScopedButEmptyDependenciesProvider._();

final class WatchGeneratedScopedButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchGeneratedScopedButEmptyDependenciesRef> {
  const WatchGeneratedScopedButEmptyDependenciesProvider._(
      {int Function(
        WatchGeneratedScopedButEmptyDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchGeneratedScopedButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    WatchGeneratedScopedButEmptyDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedScopedButEmptyDependenciesHash();

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
  WatchGeneratedScopedButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      WatchGeneratedScopedButEmptyDependenciesRef ref,
    ) create,
  ) {
    return WatchGeneratedScopedButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(WatchGeneratedScopedButEmptyDependenciesRef ref) {
    final _$cb = _createCb ?? watchGeneratedScopedButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedButEmptyDependenciesHash() =>
    r'5dc6791ab2f661a378de3e8335943a48e8305435';

typedef WatchRootButEmptyDependenciesRef = Ref<int>;

@ProviderFor(watchRootButEmptyDependencies)
const watchRootButEmptyDependenciesProvider =
    WatchRootButEmptyDependenciesProvider._();

final class WatchRootButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchRootButEmptyDependenciesRef> {
  const WatchRootButEmptyDependenciesProvider._(
      {int Function(
        WatchRootButEmptyDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchRootButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    WatchRootButEmptyDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$watchRootButEmptyDependenciesHash();

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
  WatchRootButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      WatchRootButEmptyDependenciesRef ref,
    ) create,
  ) {
    return WatchRootButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(WatchRootButEmptyDependenciesRef ref) {
    final _$cb = _createCb ?? watchRootButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchRootButEmptyDependenciesHash() =>
    r'c95800f6aec446737168ac8dc3e6edcaeeed3bc0';

typedef WatchGeneratedRootButEmptyDependenciesRef = Ref<int>;

@ProviderFor(watchGeneratedRootButEmptyDependencies)
const watchGeneratedRootButEmptyDependenciesProvider =
    WatchGeneratedRootButEmptyDependenciesProvider._();

final class WatchGeneratedRootButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchGeneratedRootButEmptyDependenciesRef> {
  const WatchGeneratedRootButEmptyDependenciesProvider._(
      {int Function(
        WatchGeneratedRootButEmptyDependenciesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchGeneratedRootButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    WatchGeneratedRootButEmptyDependenciesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedRootButEmptyDependenciesHash();

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
  WatchGeneratedRootButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      WatchGeneratedRootButEmptyDependenciesRef ref,
    ) create,
  ) {
    return WatchGeneratedRootButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(WatchGeneratedRootButEmptyDependenciesRef ref) {
    final _$cb = _createCb ?? watchGeneratedRootButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootButEmptyDependenciesHash() =>
    r'9fb97c1fa207a18870cd23c682305dcef413a706';

typedef WatchGeneratedScopedAndContainsDependencyRef = Ref<int>;

@ProviderFor(watchGeneratedScopedAndContainsDependency)
const watchGeneratedScopedAndContainsDependencyProvider =
    WatchGeneratedScopedAndContainsDependencyProvider._();

final class WatchGeneratedScopedAndContainsDependencyProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, WatchGeneratedScopedAndContainsDependencyRef> {
  const WatchGeneratedScopedAndContainsDependencyProvider._(
      {int Function(
        WatchGeneratedScopedAndContainsDependencyRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'watchGeneratedScopedAndContainsDependencyProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[generatedScopedProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchGeneratedScopedAndContainsDependencyProvider
                .$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = generatedScopedProvider;

  final int Function(
    WatchGeneratedScopedAndContainsDependencyRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedScopedAndContainsDependencyHash();

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
  WatchGeneratedScopedAndContainsDependencyProvider $copyWithCreate(
    int Function(
      WatchGeneratedScopedAndContainsDependencyRef ref,
    ) create,
  ) {
    return WatchGeneratedScopedAndContainsDependencyProvider._(create: create);
  }

  @override
  int create(WatchGeneratedScopedAndContainsDependencyRef ref) {
    final _$cb = _createCb ?? watchGeneratedScopedAndContainsDependency;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedAndContainsDependencyHash() =>
    r'320592737e763091c1229a79ae07fe961e7aab72';

@ProviderFor(ClassWatchGeneratedRootButMissingDependencies)
const classWatchGeneratedRootButMissingDependenciesProvider =
    ClassWatchGeneratedRootButMissingDependenciesProvider._();

final class ClassWatchGeneratedRootButMissingDependenciesProvider
    extends $NotifierProvider<ClassWatchGeneratedRootButMissingDependencies,
        int> {
  const ClassWatchGeneratedRootButMissingDependenciesProvider._(
      {super.runNotifierBuildOverride,
      ClassWatchGeneratedRootButMissingDependencies Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'classWatchGeneratedRootButMissingDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final ClassWatchGeneratedRootButMissingDependencies Function()? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$classWatchGeneratedRootButMissingDependenciesHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  ClassWatchGeneratedRootButMissingDependencies create() =>
      _createCb?.call() ?? ClassWatchGeneratedRootButMissingDependencies();

  @$internal
  @override
  ClassWatchGeneratedRootButMissingDependenciesProvider $copyWithCreate(
    ClassWatchGeneratedRootButMissingDependencies Function() create,
  ) {
    return ClassWatchGeneratedRootButMissingDependenciesProvider._(
        create: create);
  }

  @$internal
  @override
  ClassWatchGeneratedRootButMissingDependenciesProvider $copyWithBuild(
    int Function(
      Ref<int>,
      ClassWatchGeneratedRootButMissingDependencies,
    ) build,
  ) {
    return ClassWatchGeneratedRootButMissingDependenciesProvider._(
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ClassWatchGeneratedRootButMissingDependencies, int>
      $createElement(ProviderContainer container) =>
          $NotifierProviderElement(this, container);
}

String _$classWatchGeneratedRootButMissingDependenciesHash() =>
    r'e36d7126a86ea9ded6dc66a6f33eabb2724455a9';

abstract class _$ClassWatchGeneratedRootButMissingDependencies
    extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

typedef Regression2348Ref = Ref<int>;

@ProviderFor(regression2348)
const regression2348Provider = Regression2348Provider._();

final class Regression2348Provider extends $FunctionalProvider<int, int>
    with $Provider<int, Regression2348Ref> {
  const Regression2348Provider._(
      {int Function(
        Regression2348Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'regression2348Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[generatedScopedProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            Regression2348Provider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = generatedScopedProvider;

  final int Function(
    Regression2348Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$regression2348Hash();

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
  Regression2348Provider $copyWithCreate(
    int Function(
      Regression2348Ref ref,
    ) create,
  ) {
    return Regression2348Provider._(create: create);
  }

  @override
  int create(Regression2348Ref ref) {
    final _$cb = _createCb ?? regression2348;
    return _$cb(ref);
  }
}

String _$regression2348Hash() => r'72fbbe420e9835c9843c28b7c9375ca3d99ca4b7';

@ProviderFor(Regression2417)
const regression2417Provider = Regression2417Provider._();

final class Regression2417Provider
    extends $NotifierProvider<Regression2417, int> {
  const Regression2417Provider._(
      {super.runNotifierBuildOverride, Regression2417 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'regression2417Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[generatedScopedProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            Regression2417Provider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = generatedScopedProvider;

  final Regression2417 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$regression2417Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Regression2417 create() => _createCb?.call() ?? Regression2417();

  @$internal
  @override
  Regression2417Provider $copyWithCreate(
    Regression2417 Function() create,
  ) {
    return Regression2417Provider._(create: create);
  }

  @$internal
  @override
  Regression2417Provider $copyWithBuild(
    int Function(
      Ref<int>,
      Regression2417,
    ) build,
  ) {
    return Regression2417Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Regression2417, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$regression2417Hash() => r'c9ac0ba44e849ea1460c79c1f676feba1b5400da';

abstract class _$Regression2417 extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

typedef FamilyDepRef = Ref<int>;

@ProviderFor(familyDep)
const familyDepProvider = FamilyDepFamily._();

final class FamilyDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int, FamilyDepRef> {
  const FamilyDepProvider._(
      {required FamilyDepFamily super.from,
      required int super.argument,
      int Function(
        FamilyDepRef ref,
        int p,
      )? create})
      : _createCb = create,
        super(
          name: r'familyDepProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    FamilyDepRef ref,
    int p,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyDepHash();

  @override
  String toString() {
    return r'familyDepProvider'
        ''
        '($argument)';
  }

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
  FamilyDepProvider $copyWithCreate(
    int Function(
      FamilyDepRef ref,
    ) create,
  ) {
    return FamilyDepProvider._(
        argument: argument as int,
        from: from! as FamilyDepFamily,
        create: (
          ref,
          int p,
        ) =>
            create(ref));
  }

  @override
  int create(FamilyDepRef ref) {
    final _$cb = _createCb ?? familyDep;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyDepProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyDepHash() => r'1c152873ed2b3e88da09d8e1fc53a33635cbe3b3';

final class FamilyDepFamily extends Family {
  const FamilyDepFamily._()
      : super(
          name: r'familyDepProvider',
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            FamilyDepProvider.$allTransitiveDependencies0,
          ],
          isAutoDispose: true,
        );

  FamilyDepProvider call(
    int p,
  ) =>
      FamilyDepProvider._(argument: p, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyDepHash();

  @override
  String toString() => r'familyDepProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      FamilyDepRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as FamilyDepProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

typedef FamilyDep2Ref = Ref<int>;

@ProviderFor(familyDep2)
const familyDep2Provider = FamilyDep2Family._();

final class FamilyDep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int, FamilyDep2Ref> {
  const FamilyDep2Provider._(
      {required FamilyDep2Family super.from,
      required int super.argument,
      int Function(
        FamilyDep2Ref ref,
        int p,
      )? create})
      : _createCb = create,
        super(
          name: r'familyDep2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = familyDepProvider;
  static const $allTransitiveDependencies1 =
      FamilyDepProvider.$allTransitiveDependencies0;

  final int Function(
    FamilyDep2Ref ref,
    int p,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyDep2Hash();

  @override
  String toString() {
    return r'familyDep2Provider'
        ''
        '($argument)';
  }

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
  FamilyDep2Provider $copyWithCreate(
    int Function(
      FamilyDep2Ref ref,
    ) create,
  ) {
    return FamilyDep2Provider._(
        argument: argument as int,
        from: from! as FamilyDep2Family,
        create: (
          ref,
          int p,
        ) =>
            create(ref));
  }

  @override
  int create(FamilyDep2Ref ref) {
    final _$cb = _createCb ?? familyDep2;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyDep2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyDep2Hash() => r'd81e2e56d75dd08a695b834853a3a6cea99ea305';

final class FamilyDep2Family extends Family {
  const FamilyDep2Family._()
      : super(
          name: r'familyDep2Provider',
          dependencies: const <ProviderOrFamily>[familyDepProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            FamilyDep2Provider.$allTransitiveDependencies0,
            FamilyDep2Provider.$allTransitiveDependencies1,
          ],
          isAutoDispose: true,
        );

  FamilyDep2Provider call(
    int p,
  ) =>
      FamilyDep2Provider._(argument: p, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyDep2Hash();

  @override
  String toString() => r'familyDep2Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      FamilyDep2Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as FamilyDep2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

typedef AliasRef = Ref<int>;

@ProviderFor(alias)
const aliasProvider = AliasProvider._();

final class AliasProvider extends $FunctionalProvider<int, int>
    with $Provider<int, AliasRef> {
  const AliasProvider._(
      {int Function(
        AliasRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'aliasProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    AliasRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasHash();

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
  AliasProvider $copyWithCreate(
    int Function(
      AliasRef ref,
    ) create,
  ) {
    return AliasProvider._(create: create);
  }

  @override
  int create(AliasRef ref) {
    final _$cb = _createCb ?? alias;
    return _$cb(ref);
  }
}

String _$aliasHash() => r'871c6c7ab22e4bbed2dc46917daf42e7fc1b9d88';

@ProviderFor(AliasClass)
const aliasClassProvider = AliasClassProvider._();

final class AliasClassProvider extends $NotifierProvider<AliasClass, int> {
  const AliasClassProvider._(
      {super.runNotifierBuildOverride, AliasClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'aliasClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AliasClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  AliasClass create() => _createCb?.call() ?? AliasClass();

  @$internal
  @override
  AliasClassProvider $copyWithCreate(
    AliasClass Function() create,
  ) {
    return AliasClassProvider._(create: create);
  }

  @$internal
  @override
  AliasClassProvider $copyWithBuild(
    int Function(
      Ref<int>,
      AliasClass,
    ) build,
  ) {
    return AliasClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClass, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$aliasClassHash() => r'f5c1f43e7541638274ca7dc334a713763c9c8071';

abstract class _$AliasClass extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(RiverpodDependencies)
const riverpodDependenciesProvider = RiverpodDependenciesProvider._();

final class RiverpodDependenciesProvider
    extends $NotifierProvider<RiverpodDependencies, int> {
  const RiverpodDependenciesProvider._(
      {super.runNotifierBuildOverride, RiverpodDependencies Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'riverpodDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            RiverpodDependenciesProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final RiverpodDependencies Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$riverpodDependenciesHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  RiverpodDependencies create() => _createCb?.call() ?? RiverpodDependencies();

  @$internal
  @override
  RiverpodDependenciesProvider $copyWithCreate(
    RiverpodDependencies Function() create,
  ) {
    return RiverpodDependenciesProvider._(create: create);
  }

  @$internal
  @override
  RiverpodDependenciesProvider $copyWithBuild(
    int Function(
      Ref<int>,
      RiverpodDependencies,
    ) build,
  ) {
    return RiverpodDependenciesProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RiverpodDependencies, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$riverpodDependenciesHash() =>
    r'a0a94e21f6d98df529e4e8a469ed3aec5af37061';

abstract class _$RiverpodDependencies extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

typedef FooRef = Ref<int>;

@ProviderFor(foo)
const fooProvider = FooProvider._();

final class FooProvider extends $FunctionalProvider<int, int>
    with $Provider<int, FooRef> {
  const FooProvider._(
      {int Function(
        FooRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'fooProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    FooRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fooHash();

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
  FooProvider $copyWithCreate(
    int Function(
      FooRef ref,
    ) create,
  ) {
    return FooProvider._(create: create);
  }

  @override
  int create(FooRef ref) {
    final _$cb = _createCb ?? foo;
    return _$cb(ref);
  }
}

String _$fooHash() => r'f9ce60fe868c2c54aa282702554861a13e8871cd';

typedef CrossFileDependencyRef = Ref<int>;

@ProviderFor(crossFileDependency)
const crossFileDependencyProvider = CrossFileDependencyProvider._();

final class CrossFileDependencyProvider extends $FunctionalProvider<int, int>
    with $Provider<int, CrossFileDependencyRef> {
  const CrossFileDependencyProvider._(
      {int Function(
        CrossFileDependencyRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'crossFileDependencyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CrossFileDependencyRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$crossFileDependencyHash();

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
  CrossFileDependencyProvider $copyWithCreate(
    int Function(
      CrossFileDependencyRef ref,
    ) create,
  ) {
    return CrossFileDependencyProvider._(create: create);
  }

  @override
  int create(CrossFileDependencyRef ref) {
    final _$cb = _createCb ?? crossFileDependency;
    return _$cb(ref);
  }
}

String _$crossFileDependencyHash() =>
    r'9ca6b69de674377c6906fb835cbe04d01851d088';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
