// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor($dynamic)
const $dynamicProvider = $DynamicProvider._();

final class $DynamicProvider
    extends $FunctionalProvider<dynamic, dynamic, dynamic>
    with $Provider<dynamic> {
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
  $ProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  dynamic create(Ref ref) {
    return $dynamic(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
    );
  }
}

String _$$dynamicHash() => r'1b4a1470c37babf1053660e3774de1a482c91269';

@ProviderFor($dynamicFamily)
const $dynamicFamilyProvider = $DynamicFamilyFamily._();

final class $DynamicFamilyProvider
    extends $FunctionalProvider<dynamic, dynamic, dynamic>
    with $Provider<dynamic> {
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
  $ProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  dynamic create(Ref ref) {
    final argument = this.argument as dynamic;
    return $dynamicFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
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

String _$$dynamicFamilyHash() => r'5cb3da6177d435e5a4fcfce446f0d3cd628fe6fb';

final class $DynamicFamilyFamily extends $Family
    with $FunctionalFamilyOverride<dynamic, dynamic> {
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
    extends $NotifierProvider<$DynamicClass, dynamic> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
    );
  }
}

String _$$dynamicClassHash() => r'3bf95c69912b3544963ca03056f2c10ca77f477f';

abstract class _$$DynamicClass extends $Notifier<dynamic> {
  dynamic build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<dynamic, dynamic>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<dynamic, dynamic>, dynamic, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor($DynamicClassFamily)
const $dynamicClassFamilyProvider = $DynamicClassFamilyFamily._();

final class $DynamicClassFamilyProvider
    extends $NotifierProvider<$DynamicClassFamily, dynamic> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
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
    r'07ca043ea90a433ef89499c0400894236cf79176';

final class $DynamicClassFamilyFamily extends $Family
    with
        $ClassFamilyOverride<$DynamicClassFamily, dynamic, dynamic, dynamic,
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

abstract class _$$DynamicClassFamily extends $Notifier<dynamic> {
  late final _$args = ref.$arg as dynamic;
  dynamic get test => _$args;

  dynamic build(
    dynamic test,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<dynamic, dynamic>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<dynamic, dynamic>, dynamic, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_dynamic)
const _dynamicProvider = _DynamicFamily._();

final class _DynamicProvider
    extends $FunctionalProvider<dynamic, dynamic, dynamic>
    with $Provider<dynamic> {
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
  String debugGetCreateSourceHash() => _$_dynamicHash();

  @override
  String toString() {
    return r'_dynamicProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  dynamic create(Ref ref) {
    final argument = this.argument as dynamic;
    return _dynamic(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
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

String _$_dynamicHash() => r'e08bd08481e4ea0d3da2ab7c38f940c34e96ba7f';

final class _DynamicFamily extends $Family
    with $FunctionalFamilyOverride<dynamic, dynamic> {
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
