// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

@ProviderFor(generatedScoped)
const generatedScopedProvider = GeneratedScopedProvider._();

final class GeneratedScopedProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const GeneratedScopedProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedScopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GeneratedScopedProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return GeneratedScopedProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? generatedScoped;
    return _$cb(ref);
  }
}

String _$generatedScopedHash() => r'f8e5b6926ce13765c83dbb7f8c8458c9c5fe7d69';

@ProviderFor(generatedRoot)
const generatedRootProvider = GeneratedRootProvider._();

final class GeneratedRootProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const GeneratedRootProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedRootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GeneratedRootProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return GeneratedRootProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? generatedRoot;
    return _$cb(ref);
  }
}

String _$generatedRootHash() => r'179253a56503f28bb616c602d8af9ad3b23d438f';

@ProviderFor(watchScopedButNoDependencies)
const watchScopedButNoDependenciesProvider =
    WatchScopedButNoDependenciesProvider._();

final class WatchScopedButNoDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchScopedButNoDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchScopedButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchScopedButNoDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchScopedButNoDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchScopedButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchScopedButNoDependenciesHash() =>
    r'e326226fdc19ea7a4430900154c071f5a1a98e40';

@ProviderFor(watchGeneratedScopedButNoDependencies)
const watchGeneratedScopedButNoDependenciesProvider =
    WatchGeneratedScopedButNoDependenciesProvider._();

final class WatchGeneratedScopedButNoDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedScopedButNoDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedScopedButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchGeneratedScopedButNoDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedScopedButNoDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedScopedButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedButNoDependenciesHash() =>
    r'2109f8ccbc13632e45f18ccb93bc3059c431eba1';

@ProviderFor(watchRootButNoDependencies)
const watchRootButNoDependenciesProvider =
    WatchRootButNoDependenciesProvider._();

final class WatchRootButNoDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchRootButNoDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchRootButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchRootButNoDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchRootButNoDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchRootButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchRootButNoDependenciesHash() =>
    r'cfecc8aeb539e82c46276f9e4dd78c323b4bef12';

@ProviderFor(watchGeneratedRootButNoDependencies)
const watchGeneratedRootButNoDependenciesProvider =
    WatchGeneratedRootButNoDependenciesProvider._();

final class WatchGeneratedRootButNoDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedRootButNoDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedRootButNoDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchGeneratedRootButNoDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedRootButNoDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedRootButNoDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootButNoDependenciesHash() =>
    r'c839dab901f606c11c78f9c8761931027d3db1d1';

@ProviderFor(watchScopedButEmptyDependencies)
const watchScopedButEmptyDependenciesProvider =
    WatchScopedButEmptyDependenciesProvider._();

final class WatchScopedButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchScopedButEmptyDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchScopedButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchScopedButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchScopedButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchScopedButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchScopedButEmptyDependenciesHash() =>
    r'a194f52730f635e9c92b3467b33b8c302c93b1ab';

@ProviderFor(watchGeneratedScopedButEmptyDependencies)
const watchGeneratedScopedButEmptyDependenciesProvider =
    WatchGeneratedScopedButEmptyDependenciesProvider._();

final class WatchGeneratedScopedButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedScopedButEmptyDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedScopedButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchGeneratedScopedButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedScopedButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedScopedButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedButEmptyDependenciesHash() =>
    r'fa4cb564341e7b3f0dd10f70e17381c67859c643';

@ProviderFor(watchRootButEmptyDependencies)
const watchRootButEmptyDependenciesProvider =
    WatchRootButEmptyDependenciesProvider._();

final class WatchRootButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchRootButEmptyDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchRootButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchRootButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchRootButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchRootButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchRootButEmptyDependenciesHash() =>
    r'8669a421efcd8caadc0d070f0c88043668610bbb';

@ProviderFor(watchGeneratedRootButEmptyDependencies)
const watchGeneratedRootButEmptyDependenciesProvider =
    WatchGeneratedRootButEmptyDependenciesProvider._();

final class WatchGeneratedRootButEmptyDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedRootButEmptyDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedRootButEmptyDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchGeneratedRootButEmptyDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedRootButEmptyDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedRootButEmptyDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootButEmptyDependenciesHash() =>
    r'80581ac491e25ae8c6ee7b7f25dff9939f8de37c';

@ProviderFor(watchScopedButMissingDependencies)
const watchScopedButMissingDependenciesProvider =
    WatchScopedButMissingDependenciesProvider._();

final class WatchScopedButMissingDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchScopedButMissingDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchScopedButMissingDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchScopedButMissingDependenciesProvider
                .$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchScopedButMissingDependenciesHash();

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
  WatchScopedButMissingDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchScopedButMissingDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchScopedButMissingDependencies;
    return _$cb(ref);
  }
}

String _$watchScopedButMissingDependenciesHash() =>
    r'c890e4845b1fca73ee02442eb7a203734605173c';

@ProviderFor(watchGeneratedScopedButMissingDependencies)
const watchGeneratedScopedButMissingDependenciesProvider =
    WatchGeneratedScopedButMissingDependenciesProvider._();

final class WatchGeneratedScopedButMissingDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedScopedButMissingDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedScopedButMissingDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchGeneratedScopedButMissingDependenciesProvider
                .$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedScopedButMissingDependenciesHash();

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
  WatchGeneratedScopedButMissingDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedScopedButMissingDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedScopedButMissingDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedButMissingDependenciesHash() =>
    r'fbbb5f1ea3725a7554dc05073f47a6b9ce5d913d';

@ProviderFor(watchRootButMissingDependencies)
const watchRootButMissingDependenciesProvider =
    WatchRootButMissingDependenciesProvider._();

final class WatchRootButMissingDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchRootButMissingDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchRootButMissingDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchRootButMissingDependenciesProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$watchRootButMissingDependenciesHash();

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
  WatchRootButMissingDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchRootButMissingDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchRootButMissingDependencies;
    return _$cb(ref);
  }
}

String _$watchRootButMissingDependenciesHash() =>
    r'cc9c5e6c3a1c34e291a63c429fb031e0cc701499';

@ProviderFor(watchGeneratedRootButMissingDependencies)
const watchGeneratedRootButMissingDependenciesProvider =
    WatchGeneratedRootButMissingDependenciesProvider._();

final class WatchGeneratedRootButMissingDependenciesProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedRootButMissingDependenciesProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedRootButMissingDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchGeneratedRootButMissingDependenciesProvider
                .$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedRootButMissingDependenciesHash();

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
  WatchGeneratedRootButMissingDependenciesProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedRootButMissingDependenciesProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedRootButMissingDependencies;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootButMissingDependenciesHash() =>
    r'10d01aea2b6b0772e98172f410bdbfce85786243';

@ProviderFor(watchGeneratedScopedAndContainsDependency)
const watchGeneratedScopedAndContainsDependencyProvider =
    WatchGeneratedScopedAndContainsDependencyProvider._();

final class WatchGeneratedScopedAndContainsDependencyProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedScopedAndContainsDependencyProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  WatchGeneratedScopedAndContainsDependencyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedScopedAndContainsDependencyProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedScopedAndContainsDependency;
    return _$cb(ref);
  }
}

String _$watchGeneratedScopedAndContainsDependencyHash() =>
    r'948e75e097500b33ee2fdbd3dc9fdecafa5f3d10';

@ProviderFor(watchGeneratedRootAndContainsDependency)
const watchGeneratedRootAndContainsDependencyProvider =
    WatchGeneratedRootAndContainsDependencyProvider._();

final class WatchGeneratedRootAndContainsDependencyProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const WatchGeneratedRootAndContainsDependencyProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'watchGeneratedRootAndContainsDependencyProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[generatedRootProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            WatchGeneratedRootAndContainsDependencyProvider
                .$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = generatedRootProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$watchGeneratedRootAndContainsDependencyHash();

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
  WatchGeneratedRootAndContainsDependencyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return WatchGeneratedRootAndContainsDependencyProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? watchGeneratedRootAndContainsDependency;
    return _$cb(ref);
  }
}

String _$watchGeneratedRootAndContainsDependencyHash() =>
    r'780392b647f1606186ee0f70c81dd5b03f506284';

@ProviderFor(specifiedDependencyButNeverUsed)
const specifiedDependencyButNeverUsedProvider =
    SpecifiedDependencyButNeverUsedProvider._();

final class SpecifiedDependencyButNeverUsedProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const SpecifiedDependencyButNeverUsedProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'specifiedDependencyButNeverUsedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            depProvider,
            generatedRootProvider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>[
            SpecifiedDependencyButNeverUsedProvider.$allTransitiveDependencies0,
            SpecifiedDependencyButNeverUsedProvider.$allTransitiveDependencies1,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;
  static const $allTransitiveDependencies1 = generatedRootProvider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$specifiedDependencyButNeverUsedHash();

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
  SpecifiedDependencyButNeverUsedProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return SpecifiedDependencyButNeverUsedProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? specifiedDependencyButNeverUsed;
    return _$cb(ref);
  }
}

String _$specifiedDependencyButNeverUsedHash() =>
    r'cca97d259bcacbff290f0d459e0de3a9b5b6a510';

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
          retry: null,
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
      Ref,
      ClassWatchGeneratedRootButMissingDependencies,
    ) build,
  ) {
    return ClassWatchGeneratedRootButMissingDependenciesProvider._(
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ClassWatchGeneratedRootButMissingDependencies, int>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$classWatchGeneratedRootButMissingDependenciesHash() =>
    r'e36d7126a86ea9ded6dc66a6f33eabb2724455a9';

abstract class _$ClassWatchGeneratedRootButMissingDependencies
    extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(regression2348)
const regression2348Provider = Regression2348Provider._();

final class Regression2348Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Regression2348Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'regression2348Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[generatedScopedProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            Regression2348Provider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = generatedScopedProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Regression2348Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return Regression2348Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? regression2348;
    return _$cb(ref);
  }
}

String _$regression2348Hash() => r'6ad005595ee202c8b0188562ed8c4a33d01260e2';

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
          retry: null,
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
      Ref,
      Regression2417,
    ) build,
  ) {
    return Regression2417Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Regression2417, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$regression2417Hash() => r'c9ac0ba44e849ea1460c79c1f676feba1b5400da';

abstract class _$Regression2417 extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(familyDep)
const familyDepProvider = FamilyDepFamily._();

final class FamilyDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const FamilyDepProvider._(
      {required FamilyDepFamily super.from,
      required int super.argument,
      int Function(
        Ref ref,
        int p,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyDepProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FamilyDepProvider $copyWithCreate(
    int Function(
      Ref ref,
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
  int create(Ref ref) {
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

String _$familyDepHash() => r'ed674a44492b3871b72b4fbc68180ea0839723e5';

final class FamilyDepFamily extends Family {
  const FamilyDepFamily._()
      : super(
          retry: null,
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
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyDepProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(familyDep2)
const familyDep2Provider = FamilyDep2Family._();

final class FamilyDep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const FamilyDep2Provider._(
      {required FamilyDep2Family super.from,
      required int super.argument,
      int Function(
        Ref ref,
        int p,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyDep2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = familyDepProvider;
  static const $allTransitiveDependencies1 =
      FamilyDepProvider.$allTransitiveDependencies0;

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FamilyDep2Provider $copyWithCreate(
    int Function(
      Ref ref,
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
  int create(Ref ref) {
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

String _$familyDep2Hash() => r'ee9c96f7a1d65e1b66c29aa8d8c030146995504c';

final class FamilyDep2Family extends Family {
  const FamilyDep2Family._()
      : super(
          retry: null,
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
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyDep2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(alias)
const aliasProvider = AliasProvider._();

final class AliasProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const AliasProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'aliasProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AliasProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return AliasProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? alias;
    return _$cb(ref);
  }
}

String _$aliasHash() => r'b410585ad56c66160898a05647e09e1a606aa9d2';

@ProviderFor(AliasClass)
const aliasClassProvider = AliasClassProvider._();

final class AliasClassProvider extends $NotifierProvider<AliasClass, int> {
  const AliasClassProvider._(
      {super.runNotifierBuildOverride, AliasClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      AliasClass,
    ) build,
  ) {
    return AliasClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClass, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$aliasClassHash() => r'f5c1f43e7541638274ca7dc334a713763c9c8071';

abstract class _$AliasClass extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
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
          retry: null,
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
      Ref,
      RiverpodDependencies,
    ) build,
  ) {
    return RiverpodDependenciesProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RiverpodDependencies, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$riverpodDependenciesHash() =>
    r'a0a94e21f6d98df529e4e8a469ed3aec5af37061';

abstract class _$RiverpodDependencies extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(foo)
const fooProvider = FooProvider._();

final class FooProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const FooProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'fooProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FooProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return FooProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? foo;
    return _$cb(ref);
  }
}

String _$fooHash() => r'a390b7b969bb0eec183426bfc85bec32750e9475';

@ProviderFor(crossFileDependency)
const crossFileDependencyProvider = CrossFileDependencyProvider._();

final class CrossFileDependencyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CrossFileDependencyProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'crossFileDependencyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CrossFileDependencyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return CrossFileDependencyProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? crossFileDependency;
    return _$cb(ref);
  }
}

String _$crossFileDependencyHash() =>
    r'3ab740fe1903f2c126412df43ee34eed87a6f4fe';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
