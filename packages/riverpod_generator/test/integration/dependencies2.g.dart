// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providerWithDependencies2)
final providerWithDependencies2Provider = ProviderWithDependencies2Provider._();

final class ProviderWithDependencies2Provider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ProviderWithDependencies2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerWithDependencies2Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          providerWithDependenciesProvider,
          _private2Provider,
          public2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ProviderWithDependencies2Provider.$allTransitiveDependencies0,
          ProviderWithDependencies2Provider.$allTransitiveDependencies1,
          ProviderWithDependencies2Provider.$allTransitiveDependencies2,
          ProviderWithDependencies2Provider.$allTransitiveDependencies3,
          ProviderWithDependencies2Provider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static final $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _private2Provider;
  static final $allTransitiveDependencies4 = public2Provider;

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
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$providerWithDependencies2Hash() =>
    r'3a6100929120a9cf1ef7f1e0a5e9b8e4d4030ae2';

@ProviderFor(familyWithDependencies2)
final familyWithDependencies2Provider = FamilyWithDependencies2Family._();

final class FamilyWithDependencies2Provider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  FamilyWithDependencies2Provider._({
    required FamilyWithDependencies2Family super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'familyWithDependencies2Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static final $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _private2Provider;
  static final $allTransitiveDependencies4 = public2Provider;

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
    return familyWithDependencies2(ref, id: argument);
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

final class FamilyWithDependencies2Family extends $Family
    with $FunctionalFamilyOverride<int, int?> {
  FamilyWithDependencies2Family._()
    : super(
        retry: null,
        name: r'familyWithDependencies2Provider',
        dependencies: <ProviderOrFamily>[
          providerWithDependenciesProvider,
          _private2Provider,
          public2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          FamilyWithDependencies2Provider.$allTransitiveDependencies0,
          FamilyWithDependencies2Provider.$allTransitiveDependencies1,
          FamilyWithDependencies2Provider.$allTransitiveDependencies2,
          FamilyWithDependencies2Provider.$allTransitiveDependencies3,
          FamilyWithDependencies2Provider.$allTransitiveDependencies4,
        },
        isAutoDispose: true,
      );

  FamilyWithDependencies2Provider call({int? id}) =>
      FamilyWithDependencies2Provider._(argument: id, from: this);

  @override
  String toString() => r'familyWithDependencies2Provider';
}

@ProviderFor(NotifierWithDependencies)
final notifierWithDependenciesProvider = NotifierWithDependenciesProvider._();

final class NotifierWithDependenciesProvider
    extends $NotifierProvider<NotifierWithDependencies, int> {
  NotifierWithDependenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notifierWithDependenciesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          providerWithDependenciesProvider,
          _private2Provider,
          public2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          NotifierWithDependenciesProvider.$allTransitiveDependencies0,
          NotifierWithDependenciesProvider.$allTransitiveDependencies1,
          NotifierWithDependenciesProvider.$allTransitiveDependencies2,
          NotifierWithDependenciesProvider.$allTransitiveDependencies3,
          NotifierWithDependenciesProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static final $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _private2Provider;
  static final $allTransitiveDependencies4 = public2Provider;

  @override
  String debugGetCreateSourceHash() => _$notifierWithDependenciesHash();

  @$internal
  @override
  NotifierWithDependencies create() => NotifierWithDependencies();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notifierWithDependenciesHash() =>
    r'becc68e5a54b0cc2b8277a6d54b74edef93bfe89';

abstract class _$NotifierWithDependencies extends $Notifier<int> {
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

@ProviderFor(NotifierFamilyWithDependencies)
final notifierFamilyWithDependenciesProvider =
    NotifierFamilyWithDependenciesFamily._();

final class NotifierFamilyWithDependenciesProvider
    extends $NotifierProvider<NotifierFamilyWithDependencies, int> {
  NotifierFamilyWithDependenciesProvider._({
    required NotifierFamilyWithDependenciesFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'notifierFamilyWithDependenciesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = providerWithDependenciesProvider;
  static final $allTransitiveDependencies1 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ProviderWithDependenciesProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _private2Provider;
  static final $allTransitiveDependencies4 = public2Provider;

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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

final class NotifierFamilyWithDependenciesFamily extends $Family
    with
        $ClassFamilyOverride<
          NotifierFamilyWithDependencies,
          int,
          int,
          int,
          int?
        > {
  NotifierFamilyWithDependenciesFamily._()
    : super(
        retry: null,
        name: r'notifierFamilyWithDependenciesProvider',
        dependencies: <ProviderOrFamily>[
          providerWithDependenciesProvider,
          _private2Provider,
          public2Provider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies0,
          NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies1,
          NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies2,
          NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies3,
          NotifierFamilyWithDependenciesProvider.$allTransitiveDependencies4,
        },
        isAutoDispose: true,
      );

  NotifierFamilyWithDependenciesProvider call({int? id}) =>
      NotifierFamilyWithDependenciesProvider._(argument: id, from: this);

  @override
  String toString() => r'notifierFamilyWithDependenciesProvider';
}

abstract class _$NotifierFamilyWithDependencies extends $Notifier<int> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  int build({int? id});
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
    element.handleCreate(ref, () => build(id: _$args));
  }
}

@ProviderFor(_private2)
final _private2Provider = _Private2Provider._();

final class _Private2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  _Private2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_private2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_private2Hash();

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
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$_private2Hash() => r'e420875c8fbd9bf33eff945f2b7276b585032a38';

@ProviderFor(public2)
final public2Provider = Public2Provider._();

final class Public2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  Public2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'public2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
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
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$public2Hash() => r'20eb4f82e5f25fafc72775e7b86021d70ebb5579';
