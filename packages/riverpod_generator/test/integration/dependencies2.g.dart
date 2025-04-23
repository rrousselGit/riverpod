// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(providerWithDependencies2)
const providerWithDependencies2Provider = ProviderWithDependencies2Provider._();

final class ProviderWithDependencies2Provider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const ProviderWithDependencies2Provider._()
      : super(
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

  @override
  String debugGetCreateSourceHash() => _$providerWithDependencies2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return providerWithDependencies2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
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
      required int? super.argument})
      : super(
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

  @override
  String debugGetCreateSourceHash() => _$familyWithDependencies2Hash();

  @override
  String toString() {
    return r'familyWithDependencies2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int?;
    return familyWithDependencies2(
      ref,
      id: argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
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
  String toString() => r'familyWithDependencies2Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          int Function(
            Ref ref,
            int? args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as FamilyWithDependencies2Provider;
            final argument = provider.argument as int?;
            return provider
                .$view(create: (ref) => create(ref, argument))
                .$createElement(pointer);
          });
}

@ProviderFor(NotifierWithDependencies)
const notifierWithDependenciesProvider = NotifierWithDependenciesProvider._();

final class NotifierWithDependenciesProvider
    extends $NotifierProvider<NotifierWithDependencies, int> {
  const NotifierWithDependenciesProvider._()
      : super(
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

  @override
  String debugGetCreateSourceHash() => _$notifierWithDependenciesHash();

  @$internal
  @override
  NotifierWithDependencies create() => NotifierWithDependencies();

  @$internal
  @override
  $NotifierProviderElement<NotifierWithDependencies, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$notifierWithDependenciesHash() =>
    r'becc68e5a54b0cc2b8277a6d54b74edef93bfe89';

abstract class _$NotifierWithDependencies extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NotifierFamilyWithDependencies)
const notifierFamilyWithDependenciesProvider =
    NotifierFamilyWithDependenciesFamily._();

final class NotifierFamilyWithDependenciesProvider
    extends $NotifierProvider<NotifierFamilyWithDependencies, int> {
  const NotifierFamilyWithDependenciesProvider._(
      {required NotifierFamilyWithDependenciesFamily super.from,
      required int? super.argument})
      : super(
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

  @override
  String debugGetCreateSourceHash() => _$notifierFamilyWithDependenciesHash();

  @override
  String toString() {
    return r'notifierFamilyWithDependenciesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NotifierFamilyWithDependencies create() => NotifierFamilyWithDependencies();

  @$internal
  @override
  $NotifierProviderElement<NotifierFamilyWithDependencies, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

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
  String toString() => r'notifierFamilyWithDependenciesProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          NotifierFamilyWithDependencies Function(
            int? args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider =
                pointer.origin as NotifierFamilyWithDependenciesProvider;
            final argument = provider.argument as int?;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function(Ref ref, NotifierFamilyWithDependencies notifier,
                  int? argument)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider =
                pointer.origin as NotifierFamilyWithDependenciesProvider;
            final argument = provider.argument as int?;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$NotifierFamilyWithDependencies extends $Notifier<int> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  int build({
    int? id,
  });
  @$internal
  @override
  void runBuild() {
    final created = build(
      id: _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_private2)
const _private2Provider = _Private2Provider._();

final class _Private2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const _Private2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_private2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$private2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return _private2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$private2Hash() => r'e420875c8fbd9bf33eff945f2b7276b585032a38';

@ProviderFor(public2)
const public2Provider = Public2Provider._();

final class Public2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Public2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'public2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$public2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return public2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$public2Hash() => r'20eb4f82e5f25fafc72775e7b86021d70ebb5579';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
