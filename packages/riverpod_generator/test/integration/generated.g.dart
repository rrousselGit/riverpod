// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(generated)
const generatedProvider = GeneratedProvider._();

final class GeneratedProvider extends $FunctionalProvider<_Test, _Test, _Test>
    with $Provider<_Test> {
  const GeneratedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedHash();

  @$internal
  @override
  $ProviderElement<_Test> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  _Test create(Ref ref) {
    return generated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_Test>(value),
    );
  }
}

String _$generatedHash() => r'0332eb232658688654514ff241ff380edbf4dbf6';

@ProviderFor(generatedFamily)
const generatedFamilyProvider = GeneratedFamilyFamily._();

final class GeneratedFamilyProvider
    extends $FunctionalProvider<_Test, _Test, _Test> with $Provider<_Test> {
  const GeneratedFamilyProvider._(
      {required GeneratedFamilyFamily super.from,
      required _Test super.argument})
      : super(
          retry: null,
          name: r'generatedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedFamilyHash();

  @override
  String toString() {
    return r'generatedFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<_Test> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  _Test create(Ref ref) {
    final argument = this.argument as _Test;
    return generatedFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_Test>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generatedFamilyHash() => r'8ac3b633763cb8dbad6e0686a732df3a081a0d64';

final class GeneratedFamilyFamily extends $Family
    with $FunctionalFamilyOverride<_Test, _Test> {
  const GeneratedFamilyFamily._()
      : super(
          retry: null,
          name: r'generatedFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeneratedFamilyProvider call(
    _Test test,
  ) =>
      GeneratedFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'generatedFamilyProvider';
}

@ProviderFor(GeneratedClass)
const generatedClassProvider = GeneratedClassProvider._();

final class GeneratedClassProvider
    extends $NotifierProvider<GeneratedClass, _Test> {
  const GeneratedClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedClassHash();

  @$internal
  @override
  GeneratedClass create() => GeneratedClass();

  @$internal
  @override
  $NotifierProviderElement<GeneratedClass, _Test> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_Test>(value),
    );
  }
}

String _$generatedClassHash() => r'984153f97e25de687d2f19756b277aabd56f6e72';

abstract class _$GeneratedClass extends $Notifier<_Test> {
  _Test build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<_Test, _Test>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_Test, _Test>, _Test, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GeneratedClassFamily)
const generatedClassFamilyProvider = GeneratedClassFamilyFamily._();

final class GeneratedClassFamilyProvider
    extends $NotifierProvider<GeneratedClassFamily, _Test> {
  const GeneratedClassFamilyProvider._(
      {required GeneratedClassFamilyFamily super.from,
      required _Test super.argument})
      : super(
          retry: null,
          name: r'generatedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedClassFamilyHash();

  @override
  String toString() {
    return r'generatedClassFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GeneratedClassFamily create() => GeneratedClassFamily();

  @$internal
  @override
  $NotifierProviderElement<GeneratedClassFamily, _Test> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_Test>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generatedClassFamilyHash() =>
    r'28d0a5a82af5b254f6ef07b492916e2feb7e6e63';

final class GeneratedClassFamilyFamily extends $Family
    with
        $ClassFamilyOverride<GeneratedClassFamily, _Test, _Test, _Test, _Test> {
  const GeneratedClassFamilyFamily._()
      : super(
          retry: null,
          name: r'generatedClassFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeneratedClassFamilyProvider call(
    _Test test,
  ) =>
      GeneratedClassFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'generatedClassFamilyProvider';
}

abstract class _$GeneratedClassFamily extends $Notifier<_Test> {
  late final _$args = ref.$arg as _Test;
  _Test get test => _$args;

  _Test build(
    _Test test,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<_Test, _Test>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<_Test, _Test>, _Test, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor($dynamic)
const $dynamicProvider = $DynamicProvider._();

final class $DynamicProvider
    extends $FunctionalProvider<Object?, Object?, Object?>
    with $Provider<Object?> {
  const $DynamicProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'$dynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$$dynamicHash();

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Object? create(Ref ref) {
    return $dynamic(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }
}

String _$$dynamicHash() => r'17c8e140446da2e3c026ebb51c4b074d2894b7ff';

@ProviderFor($dynamicFamily)
const $dynamicFamilyProvider = $DynamicFamilyFamily._();

final class $DynamicFamilyProvider
    extends $FunctionalProvider<Object?, Object?, Object?>
    with $Provider<Object?> {
  const $DynamicFamilyProvider._(
      {required $DynamicFamilyFamily super.from,
      required dynamic super.argument})
      : super(
          retry: null,
          name: r'$dynamicFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$$dynamicFamilyHash();

  @override
  String toString() {
    return r'$dynamicFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Object? create(Ref ref) {
    final argument = this.argument as dynamic;
    return $dynamicFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$$dynamicFamilyHash() => r'6897846251c8b4b5b2fa72d8d3e14ae3381c0c0f';

final class $DynamicFamilyFamily extends $Family
    with $FunctionalFamilyOverride<Object?, dynamic> {
  const $DynamicFamilyFamily._()
      : super(
          retry: null,
          name: r'$dynamicFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  $DynamicFamilyProvider call(
    dynamic test,
  ) =>
      $DynamicFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'$dynamicFamilyProvider';
}

@ProviderFor($DynamicClass)
const $dynamicClassProvider = $DynamicClassProvider._();

final class $DynamicClassProvider
    extends $NotifierProvider<$DynamicClass, Object?> {
  const $DynamicClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'$dynamicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassHash();

  @$internal
  @override
  $DynamicClass create() => $DynamicClass();

  @$internal
  @override
  $NotifierProviderElement<$DynamicClass, Object?> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }
}

String _$$dynamicClassHash() => r'c6d8e5191c3f060df3ce3eee66107433fd4c3292';

abstract class _$$DynamicClass extends $Notifier<Object?> {
  Object? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Object?, Object?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Object?, Object?>, Object?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor($DynamicClassFamily)
const $dynamicClassFamilyProvider = $DynamicClassFamilyFamily._();

final class $DynamicClassFamilyProvider
    extends $NotifierProvider<$DynamicClassFamily, Object?> {
  const $DynamicClassFamilyProvider._(
      {required $DynamicClassFamilyFamily super.from,
      required dynamic super.argument})
      : super(
          retry: null,
          name: r'$dynamicClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassFamilyHash();

  @override
  String toString() {
    return r'$dynamicClassFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $DynamicClassFamily create() => $DynamicClassFamily();

  @$internal
  @override
  $NotifierProviderElement<$DynamicClassFamily, Object?> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$$dynamicClassFamilyHash() =>
    r'bdda961386f3b647c071d79293a8da441580c470';

final class $DynamicClassFamilyFamily extends $Family
    with
        $ClassFamilyOverride<$DynamicClassFamily, Object?, Object?, Object?,
            dynamic> {
  const $DynamicClassFamilyFamily._()
      : super(
          retry: null,
          name: r'$dynamicClassFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  $DynamicClassFamilyProvider call(
    dynamic test,
  ) =>
      $DynamicClassFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'$dynamicClassFamilyProvider';
}

abstract class _$$DynamicClassFamily extends $Notifier<Object?> {
  late final _$args = ref.$arg as dynamic;
  dynamic get test => _$args;

  Object? build(
    dynamic test,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<Object?, Object?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Object?, Object?>, Object?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_dynamic)
const _dynamicProvider = _DynamicFamily._();

final class _DynamicProvider
    extends $FunctionalProvider<Object?, Object?, Object?>
    with $Provider<Object?> {
  const _DynamicProvider._(
      {required _DynamicFamily super.from, required dynamic super.argument})
      : super(
          retry: null,
          name: r'_dynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dynamicHash();

  @override
  String toString() {
    return r'_dynamicProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Object? create(Ref ref) {
    final argument = this.argument as dynamic;
    return _dynamic(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _DynamicProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dynamicHash() => r'e08bd08481e4ea0d3da2ab7c38f940c34e96ba7f';

final class _DynamicFamily extends $Family
    with $FunctionalFamilyOverride<Object?, dynamic> {
  const _DynamicFamily._()
      : super(
          retry: null,
          name: r'_dynamicProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _DynamicProvider call(
    dynamic test,
  ) =>
      _DynamicProvider._(argument: test, from: this);

  @override
  String toString() => r'_dynamicProvider';
}

@ProviderFor(alias)
const aliasProvider = AliasProvider._();

final class AliasProvider extends $FunctionalProvider<AsyncValue<int>,
    AsyncValue<int>, AsyncValue<int>> with $Provider<AsyncValue<int>> {
  const AliasProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aliasProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aliasHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<int> create(Ref ref) {
    return alias(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<int>>(value),
    );
  }
}

String _$aliasHash() => r'3feb548aa9a314142b5c5e3c9c7664a316a10d11';

@ProviderFor(aliasFamily)
const aliasFamilyProvider = AliasFamilyFamily._();

final class AliasFamilyProvider extends $FunctionalProvider<AsyncValue<int>,
    AsyncValue<int>, AsyncValue<int>> with $Provider<AsyncValue<int>> {
  const AliasFamilyProvider._(
      {required AliasFamilyFamily super.from,
      required AsyncValue<int> super.argument})
      : super(
          retry: null,
          name: r'aliasFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aliasFamilyHash();

  @override
  String toString() {
    return r'aliasFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<int> create(Ref ref) {
    final argument = this.argument as AsyncValue<int>;
    return aliasFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AliasFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aliasFamilyHash() => r'6afe0afc21cfd2f0f26862e9d8c1095eca5f6e42';

final class AliasFamilyFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<int>, AsyncValue<int>> {
  const AliasFamilyFamily._()
      : super(
          retry: null,
          name: r'aliasFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasFamilyProvider call(
    AsyncValue<int> test,
  ) =>
      AliasFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'aliasFamilyProvider';
}

@ProviderFor(AliasClass)
const aliasClassProvider = AliasClassProvider._();

final class AliasClassProvider
    extends $NotifierProvider<AliasClass, AsyncValue<int>> {
  const AliasClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aliasClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aliasClassHash();

  @$internal
  @override
  AliasClass create() => AliasClass();

  @$internal
  @override
  $NotifierProviderElement<AliasClass, AsyncValue<int>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<int>>(value),
    );
  }
}

String _$aliasClassHash() => r'aac83936c14520c015f0fe8a0120d353c0baf602';

abstract class _$AliasClass extends $Notifier<AsyncValue<int>> {
  AsyncValue<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, AsyncValue<int>>,
        AsyncValue<int>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AliasClassFamily)
const aliasClassFamilyProvider = AliasClassFamilyFamily._();

final class AliasClassFamilyProvider
    extends $NotifierProvider<AliasClassFamily, AsyncValue<int>> {
  const AliasClassFamilyProvider._(
      {required AliasClassFamilyFamily super.from,
      required AsyncValue<int> super.argument})
      : super(
          retry: null,
          name: r'aliasClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aliasClassFamilyHash();

  @override
  String toString() {
    return r'aliasClassFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AliasClassFamily create() => AliasClassFamily();

  @$internal
  @override
  $NotifierProviderElement<AliasClassFamily, AsyncValue<int>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AliasClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aliasClassFamilyHash() => r'd4374c0ffbbca9d65fb967255129b3ceddaa764e';

final class AliasClassFamilyFamily extends $Family
    with
        $ClassFamilyOverride<AliasClassFamily, AsyncValue<int>, AsyncValue<int>,
            AsyncValue<int>, AsyncValue<int>> {
  const AliasClassFamilyFamily._()
      : super(
          retry: null,
          name: r'aliasClassFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasClassFamilyProvider call(
    AsyncValue<int> test,
  ) =>
      AliasClassFamilyProvider._(argument: test, from: this);

  @override
  String toString() => r'aliasClassFamilyProvider';
}

abstract class _$AliasClassFamily extends $Notifier<AsyncValue<int>> {
  late final _$args = ref.$arg as AsyncValue<int>;
  AsyncValue<int> get test => _$args;

  AsyncValue<int> build(
    AsyncValue<int> test,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>, AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, AsyncValue<int>>,
        AsyncValue<int>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
