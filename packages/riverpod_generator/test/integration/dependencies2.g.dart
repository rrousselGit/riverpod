// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(providerWithDependencies2)
const providerWithDependencies2Provider = ProviderWithDependencies2Provider._();

final class ProviderWithDependencies2Provider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const ProviderWithDependencies2Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'providerWithDependencies2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            providerWithDependenciesProvider,
            _private2Provider,
            public2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
            ProviderWithDependencies2Provider.$allTransitiveDependencies0,
            ProviderWithDependencies2Provider.$allTransitiveDependencies1,
            ProviderWithDependencies2Provider.$allTransitiveDependencies2,
            ProviderWithDependencies2Provider.$allTransitiveDependencies3,
            ProviderWithDependencies2Provider.$allTransitiveDependencies4,
          },
        );

  static const $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static const $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = _private2Provider;
  static const $allTransitiveDependencies4 = public2Provider;

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$providerWithDependencies2Hash();

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
  ProviderWithDependencies2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return ProviderWithDependencies2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? providerWithDependencies2;
    return _$cb(ref);
  }
}

String _$providerWithDependencies2Hash() =>
    r'3a6100929120a9cf1ef7f1e0a5e9b8e4d4030ae2';

@ProviderFor(familyWithDependencies2)
const familyWithDependencies2Provider = FamilyWithDependencies2Family._();

final class FamilyWithDependencies2Provider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const FamilyWithDependencies2Provider._(
      {required FamilyWithDependencies2Family super.from,
      required int? super.argument,
      int Function(
        Ref ref, {
        int? id,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyWithDependencies2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static const $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = _private2Provider;
  static const $allTransitiveDependencies4 = public2Provider;

  final int Function(
    Ref ref, {
    int? id,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyWithDependencies2Hash();

  @override
  String toString() {
    return r'familyWithDependencies2Provider'
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
  FamilyWithDependencies2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return FamilyWithDependencies2Provider._(
        argument: argument as int?,
        from: from! as FamilyWithDependencies2Family,
        create: (
          ref, {
          int? id,
        }) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? familyWithDependencies2;
    final argument = this.argument as int?;
    return _$cb(
      ref,
      id: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyWithDependencies2Provider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyWithDependencies2Hash() =>
    r'd064c06ca5a85a62cbe2b47943e98fc2e858fb03';

final class FamilyWithDependencies2Family extends Family {
  const FamilyWithDependencies2Family._()
      : super(
          retry: null,
          name: r'familyWithDependencies2Provider',
          dependencies: const <ProviderOrFamily>[
            providerWithDependenciesProvider,
            _private2Provider,
            public2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
            FamilyWithDependencies2Provider.$allTransitiveDependencies0,
            FamilyWithDependencies2Provider.$allTransitiveDependencies1,
            FamilyWithDependencies2Provider.$allTransitiveDependencies2,
            FamilyWithDependencies2Provider.$allTransitiveDependencies3,
            FamilyWithDependencies2Provider.$allTransitiveDependencies4,
          },
          isAutoDispose: true,
        );

  FamilyWithDependencies2Provider call({
    int? id,
  }) =>
      FamilyWithDependencies2Provider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyWithDependencies2Hash();

  @override
  String toString() => r'familyWithDependencies2Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      int? args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyWithDependencies2Provider;

        final argument = provider.argument as int?;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(NotifierWithDependencies)
const notifierWithDependenciesProvider = NotifierWithDependenciesProvider._();

final class NotifierWithDependenciesProvider
    extends $NotifierProvider<NotifierWithDependencies, int> {
  const NotifierWithDependenciesProvider._(
      {super.runNotifierBuildOverride,
      NotifierWithDependencies Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'notifierWithDependenciesProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[
            providerWithDependenciesProvider,
            _private2Provider,
            public2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
            NotifierWithDependenciesProvider.$allTransitiveDependencies0,
            NotifierWithDependenciesProvider.$allTransitiveDependencies1,
            NotifierWithDependenciesProvider.$allTransitiveDependencies2,
            NotifierWithDependenciesProvider.$allTransitiveDependencies3,
            NotifierWithDependenciesProvider.$allTransitiveDependencies4,
          },
        );

  static const $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static const $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = _private2Provider;
  static const $allTransitiveDependencies4 = public2Provider;

  final NotifierWithDependencies Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notifierWithDependenciesHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  NotifierWithDependencies create() =>
      _createCb?.call() ?? NotifierWithDependencies();

  @$internal
  @override
  NotifierWithDependenciesProvider $copyWithCreate(
    NotifierWithDependencies Function() create,
  ) {
    return NotifierWithDependenciesProvider._(create: create);
  }

  @$internal
  @override
  NotifierWithDependenciesProvider $copyWithBuild(
    int Function(
      Ref,
      NotifierWithDependencies,
    ) build,
  ) {
    return NotifierWithDependenciesProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NotifierWithDependencies, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$notifierWithDependenciesHash() =>
    r'becc68e5a54b0cc2b8277a6d54b74edef93bfe89';

abstract class _$NotifierWithDependencies extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(NotifierFamilyWithDependencies)
const notifierFamilyWithDependenciesProvider =
    NotifierFamilyWithDependenciesFamily._();

final class NotifierFamilyWithDependenciesProvider
    extends $NotifierProvider<NotifierFamilyWithDependencies, int> {
  const NotifierFamilyWithDependenciesProvider._(
      {required NotifierFamilyWithDependenciesFamily super.from,
      required int? super.argument,
      super.runNotifierBuildOverride,
      NotifierFamilyWithDependencies Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'notifierFamilyWithDependenciesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static const $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = _private2Provider;
  static const $allTransitiveDependencies4 = public2Provider;

  final NotifierFamilyWithDependencies Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notifierFamilyWithDependenciesHash();

  @override
  String toString() {
    return r'notifierFamilyWithDependenciesProvider'
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
  NotifierFamilyWithDependencies create() =>
      _createCb?.call() ?? NotifierFamilyWithDependencies();

  @$internal
  @override
  NotifierFamilyWithDependenciesProvider $copyWithCreate(
    NotifierFamilyWithDependencies Function() create,
  ) {
    return NotifierFamilyWithDependenciesProvider._(
        argument: argument as int?,
        from: from! as NotifierFamilyWithDependenciesFamily,
        create: create);
  }

  @$internal
  @override
  NotifierFamilyWithDependenciesProvider $copyWithBuild(
    int Function(
      Ref,
      NotifierFamilyWithDependencies,
    ) build,
  ) {
    return NotifierFamilyWithDependenciesProvider._(
        argument: argument as int?,
        from: from! as NotifierFamilyWithDependenciesFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NotifierFamilyWithDependencies, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is NotifierFamilyWithDependenciesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notifierFamilyWithDependenciesHash() =>
    r'b185ba93857cd028964c1412e748ee887dbd45c8';

final class NotifierFamilyWithDependenciesFamily extends Family {
  const NotifierFamilyWithDependenciesFamily._()
      : super(
          retry: null,
          name: r'notifierFamilyWithDependenciesProvider',
          dependencies: const <ProviderOrFamily>[
            providerWithDependenciesProvider,
            _private2Provider,
            public2Provider
          ],
          allTransitiveDependencies: const <ProviderOrFamily>{
            NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies0,
            NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies1,
            NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies2,
            NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies3,
            NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies4,
          },
          isAutoDispose: true,
        );

  NotifierFamilyWithDependenciesProvider call({
    int? id,
  }) =>
      NotifierFamilyWithDependenciesProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$notifierFamilyWithDependenciesHash();

  @override
  String toString() => r'notifierFamilyWithDependenciesProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NotifierFamilyWithDependencies Function(
      int? args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider =
            pointer.origin as NotifierFamilyWithDependenciesProvider;

        final argument = provider.argument as int?;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(
            Ref ref, NotifierFamilyWithDependencies notifier, int? argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider =
            pointer.origin as NotifierFamilyWithDependenciesProvider;

        final argument = provider.argument as int?;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$NotifierFamilyWithDependencies extends $Notifier<int> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  int build({
    int? id,
  });
  @$internal
  @override
  int runBuild() => build(
        id: _$args,
      );
}

@ProviderFor(_private2)
const _private2Provider = _Private2Provider._();

final class _Private2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const _Private2Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'_private2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$private2Hash();

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
  _Private2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return _Private2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? _private2;
    return _$cb(ref);
  }
}

String _$private2Hash() => r'e420875c8fbd9bf33eff945f2b7276b585032a38';

@ProviderFor(public2)
const public2Provider = Public2Provider._();

final class Public2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Public2Provider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'public2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$public2Hash();

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
  Public2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return Public2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? public2;
    return _$cb(ref);
  }
}

String _$public2Hash() => r'20eb4f82e5f25fafc72775e7b86021d70ebb5579';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
