// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GeneratedRef = Ref<_Test>;

@ProviderFor(generated)
const generatedProvider = GeneratedProvider._();

final class GeneratedProvider extends $FunctionalProvider<_Test, _Test>
    with $Provider<_Test, GeneratedRef> {
  const GeneratedProvider._(
      {_Test Function(
        GeneratedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _Test Function(
    GeneratedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<_Test>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<_Test> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GeneratedProvider $copyWithCreate(
    _Test Function(
      GeneratedRef ref,
    ) create,
  ) {
    return GeneratedProvider._(create: create);
  }

  @override
  _Test create(GeneratedRef ref) {
    final _$cb = _createCb ?? generated;
    return _$cb(ref);
  }
}

String _$generatedHash() => r'0332eb232658688654514ff241ff380edbf4dbf6';

typedef GeneratedFamilyRef = Ref<_Test>;

@ProviderFor(generatedFamily)
const generatedFamilyProvider = GeneratedFamilyFamily._();

final class GeneratedFamilyProvider extends $FunctionalProvider<_Test, _Test>
    with $Provider<_Test, GeneratedFamilyRef> {
  const GeneratedFamilyProvider._(
      {required GeneratedFamilyFamily super.from,
      required _Test super.argument,
      _Test Function(
        GeneratedFamilyRef ref,
        _Test test,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'generatedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _Test Function(
    GeneratedFamilyRef ref,
    _Test test,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedFamilyHash();

  @override
  String toString() {
    return r'generatedFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<_Test>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<_Test> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GeneratedFamilyProvider $copyWithCreate(
    _Test Function(
      GeneratedFamilyRef ref,
    ) create,
  ) {
    return GeneratedFamilyProvider._(
        argument: argument as _Test,
        from: from! as GeneratedFamilyFamily,
        create: (
          ref,
          _Test test,
        ) =>
            create(ref));
  }

  @override
  _Test create(GeneratedFamilyRef ref) {
    final _$cb = _createCb ?? generatedFamily;
    final argument = this.argument as _Test;
    return _$cb(
      ref,
      argument,
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

final class GeneratedFamilyFamily extends Family {
  const GeneratedFamilyFamily._()
      : super(
          retry: null,
          name: r'generatedFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeneratedFamilyProvider call(
    _Test test,
  ) =>
      GeneratedFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$generatedFamilyHash();

  @override
  String toString() => r'generatedFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    _Test Function(
      GeneratedFamilyRef ref,
      _Test args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GeneratedFamilyProvider;

        final argument = provider.argument as _Test;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(GeneratedClass)
const generatedClassProvider = GeneratedClassProvider._();

final class GeneratedClassProvider
    extends $NotifierProvider<GeneratedClass, _Test> {
  const GeneratedClassProvider._(
      {super.runNotifierBuildOverride, GeneratedClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GeneratedClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<_Test>(value),
    );
  }

  @$internal
  @override
  GeneratedClass create() => _createCb?.call() ?? GeneratedClass();

  @$internal
  @override
  GeneratedClassProvider $copyWithCreate(
    GeneratedClass Function() create,
  ) {
    return GeneratedClassProvider._(create: create);
  }

  @$internal
  @override
  GeneratedClassProvider $copyWithBuild(
    _Test Function(
      Ref<_Test>,
      GeneratedClass,
    ) build,
  ) {
    return GeneratedClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GeneratedClass, _Test> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$generatedClassHash() => r'984153f97e25de687d2f19756b277aabd56f6e72';

abstract class _$GeneratedClass extends $Notifier<_Test> {
  _Test build();
  @$internal
  @override
  _Test runBuild() => build();
}

@ProviderFor(GeneratedClassFamily)
const generatedClassFamilyProvider = GeneratedClassFamilyFamily._();

final class GeneratedClassFamilyProvider
    extends $NotifierProvider<GeneratedClassFamily, _Test> {
  const GeneratedClassFamilyProvider._(
      {required GeneratedClassFamilyFamily super.from,
      required _Test super.argument,
      super.runNotifierBuildOverride,
      GeneratedClassFamily Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'generatedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GeneratedClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedClassFamilyHash();

  @override
  String toString() {
    return r'generatedClassFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_Test value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<_Test>(value),
    );
  }

  @$internal
  @override
  GeneratedClassFamily create() => _createCb?.call() ?? GeneratedClassFamily();

  @$internal
  @override
  GeneratedClassFamilyProvider $copyWithCreate(
    GeneratedClassFamily Function() create,
  ) {
    return GeneratedClassFamilyProvider._(
        argument: argument as _Test,
        from: from! as GeneratedClassFamilyFamily,
        create: create);
  }

  @$internal
  @override
  GeneratedClassFamilyProvider $copyWithBuild(
    _Test Function(
      Ref<_Test>,
      GeneratedClassFamily,
    ) build,
  ) {
    return GeneratedClassFamilyProvider._(
        argument: argument as _Test,
        from: from! as GeneratedClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GeneratedClassFamily, _Test> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class GeneratedClassFamilyFamily extends Family {
  const GeneratedClassFamilyFamily._()
      : super(
          retry: null,
          name: r'generatedClassFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeneratedClassFamilyProvider call(
    _Test test,
  ) =>
      GeneratedClassFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$generatedClassFamilyHash();

  @override
  String toString() => r'generatedClassFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    GeneratedClassFamily Function(
      _Test args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GeneratedClassFamilyProvider;

        final argument = provider.argument as _Test;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    _Test Function(
            Ref<_Test> ref, GeneratedClassFamily notifier, _Test argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GeneratedClassFamilyProvider;

        final argument = provider.argument as _Test;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$GeneratedClassFamily extends $Notifier<_Test> {
  late final _$args = ref.$arg as _Test;
  _Test get test => _$args;

  _Test build(
    _Test test,
  );
  @$internal
  @override
  _Test runBuild() => build(
        _$args,
      );
}

typedef $DynamicRef = Ref<Object?>;

@ProviderFor($dynamic)
const $dynamicProvider = $DynamicProvider._();

final class $DynamicProvider extends $FunctionalProvider<Object?, Object?>
    with $Provider<Object?, $DynamicRef> {
  const $DynamicProvider._(
      {Object? Function(
        $DynamicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'$dynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Object? Function(
    $DynamicRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  $DynamicProvider $copyWithCreate(
    Object? Function(
      $DynamicRef ref,
    ) create,
  ) {
    return $DynamicProvider._(create: create);
  }

  @override
  Object? create($DynamicRef ref) {
    final _$cb = _createCb ?? $dynamic;
    return _$cb(ref);
  }
}

String _$$dynamicHash() => r'17c8e140446da2e3c026ebb51c4b074d2894b7ff';

typedef $DynamicFamilyRef = Ref<Object?>;

@ProviderFor($dynamicFamily)
const $dynamicFamilyProvider = $DynamicFamilyFamily._();

final class $DynamicFamilyProvider extends $FunctionalProvider<Object?, Object?>
    with $Provider<Object?, $DynamicFamilyRef> {
  const $DynamicFamilyProvider._(
      {required $DynamicFamilyFamily super.from,
      required dynamic super.argument,
      Object? Function(
        $DynamicFamilyRef ref,
        dynamic test,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'$dynamicFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Object? Function(
    $DynamicFamilyRef ref,
    dynamic test,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicFamilyHash();

  @override
  String toString() {
    return r'$dynamicFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  $DynamicFamilyProvider $copyWithCreate(
    Object? Function(
      $DynamicFamilyRef ref,
    ) create,
  ) {
    return $DynamicFamilyProvider._(
        argument: argument as dynamic,
        from: from! as $DynamicFamilyFamily,
        create: (
          ref,
          dynamic test,
        ) =>
            create(ref));
  }

  @override
  Object? create($DynamicFamilyRef ref) {
    final _$cb = _createCb ?? $dynamicFamily;
    final argument = this.argument as dynamic;
    return _$cb(
      ref,
      argument,
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

final class $DynamicFamilyFamily extends Family {
  const $DynamicFamilyFamily._()
      : super(
          retry: null,
          name: r'$dynamicFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  $DynamicFamilyProvider call(
    dynamic test,
  ) =>
      $DynamicFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$$dynamicFamilyHash();

  @override
  String toString() => r'$dynamicFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Object? Function(
      $DynamicFamilyRef ref,
      dynamic args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as $DynamicFamilyProvider;

        final argument = provider.argument as dynamic;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor($DynamicClass)
const $dynamicClassProvider = $DynamicClassProvider._();

final class $DynamicClassProvider
    extends $NotifierProvider<$DynamicClass, Object?> {
  const $DynamicClassProvider._(
      {super.runNotifierBuildOverride, $DynamicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'$dynamicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final $DynamicClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $DynamicClass create() => _createCb?.call() ?? $DynamicClass();

  @$internal
  @override
  $DynamicClassProvider $copyWithCreate(
    $DynamicClass Function() create,
  ) {
    return $DynamicClassProvider._(create: create);
  }

  @$internal
  @override
  $DynamicClassProvider $copyWithBuild(
    Object? Function(
      Ref<Object?>,
      $DynamicClass,
    ) build,
  ) {
    return $DynamicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<$DynamicClass, Object?> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$$dynamicClassHash() => r'c6d8e5191c3f060df3ce3eee66107433fd4c3292';

abstract class _$$DynamicClass extends $Notifier<Object?> {
  Object? build();
  @$internal
  @override
  Object? runBuild() => build();
}

@ProviderFor($DynamicClassFamily)
const $dynamicClassFamilyProvider = $DynamicClassFamilyFamily._();

final class $DynamicClassFamilyProvider
    extends $NotifierProvider<$DynamicClassFamily, Object?> {
  const $DynamicClassFamilyProvider._(
      {required $DynamicClassFamilyFamily super.from,
      required dynamic super.argument,
      super.runNotifierBuildOverride,
      $DynamicClassFamily Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'$dynamicClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final $DynamicClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassFamilyHash();

  @override
  String toString() {
    return r'$dynamicClassFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $DynamicClassFamily create() => _createCb?.call() ?? $DynamicClassFamily();

  @$internal
  @override
  $DynamicClassFamilyProvider $copyWithCreate(
    $DynamicClassFamily Function() create,
  ) {
    return $DynamicClassFamilyProvider._(
        argument: argument as dynamic,
        from: from! as $DynamicClassFamilyFamily,
        create: create);
  }

  @$internal
  @override
  $DynamicClassFamilyProvider $copyWithBuild(
    Object? Function(
      Ref<Object?>,
      $DynamicClassFamily,
    ) build,
  ) {
    return $DynamicClassFamilyProvider._(
        argument: argument as dynamic,
        from: from! as $DynamicClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<$DynamicClassFamily, Object?> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class $DynamicClassFamilyFamily extends Family {
  const $DynamicClassFamilyFamily._()
      : super(
          retry: null,
          name: r'$dynamicClassFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  $DynamicClassFamilyProvider call(
    dynamic test,
  ) =>
      $DynamicClassFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassFamilyHash();

  @override
  String toString() => r'$dynamicClassFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    $DynamicClassFamily Function(
      dynamic args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as $DynamicClassFamilyProvider;

        final argument = provider.argument as dynamic;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Object? Function(
            Ref<Object?> ref, $DynamicClassFamily notifier, dynamic argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as $DynamicClassFamilyProvider;

        final argument = provider.argument as dynamic;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$$DynamicClassFamily extends $Notifier<Object?> {
  late final _$args = ref.$arg as dynamic;
  dynamic get test => _$args;

  Object? build(
    dynamic test,
  );
  @$internal
  @override
  Object? runBuild() => build(
        _$args,
      );
}

typedef _DynamicRef = Ref<Object?>;

@ProviderFor(_dynamic)
const _dynamicProvider = _DynamicFamily._();

final class _DynamicProvider extends $FunctionalProvider<Object?, Object?>
    with $Provider<Object?, _DynamicRef> {
  const _DynamicProvider._(
      {required _DynamicFamily super.from,
      required dynamic super.argument,
      Object? Function(
        _DynamicRef ref,
        dynamic test,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'_dynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Object? Function(
    _DynamicRef ref,
    dynamic test,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dynamicHash();

  @override
  String toString() {
    return r'_dynamicProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  _DynamicProvider $copyWithCreate(
    Object? Function(
      _DynamicRef ref,
    ) create,
  ) {
    return _DynamicProvider._(
        argument: argument as dynamic,
        from: from! as _DynamicFamily,
        create: (
          ref,
          dynamic test,
        ) =>
            create(ref));
  }

  @override
  Object? create(_DynamicRef ref) {
    final _$cb = _createCb ?? _dynamic;
    final argument = this.argument as dynamic;
    return _$cb(
      ref,
      argument,
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

String _$dynamicHash() => r'da9dc07960139fff2cf5fe584dca5c524e4f2308';

final class _DynamicFamily extends Family {
  const _DynamicFamily._()
      : super(
          retry: null,
          name: r'_dynamicProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _DynamicProvider call(
    dynamic test,
  ) =>
      _DynamicProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$dynamicHash();

  @override
  String toString() => r'_dynamicProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Object? Function(
      _DynamicRef ref,
      dynamic args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as _DynamicProvider;

        final argument = provider.argument as dynamic;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

typedef AliasRef = Ref<AsyncValue<int>>;

@ProviderFor(alias)
const aliasProvider = AliasProvider._();

final class AliasProvider
    extends $FunctionalProvider<AsyncValue<int>, AsyncValue<int>>
    with $Provider<AsyncValue<int>, AliasRef> {
  const AliasProvider._(
      {AsyncValue<int> Function(
        AliasRef ref,
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

  final AsyncValue<int> Function(
    AliasRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<int>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AliasProvider $copyWithCreate(
    AsyncValue<int> Function(
      AliasRef ref,
    ) create,
  ) {
    return AliasProvider._(create: create);
  }

  @override
  AsyncValue<int> create(AliasRef ref) {
    final _$cb = _createCb ?? alias;
    return _$cb(ref);
  }
}

String _$aliasHash() => r'ed56b34397f397d33434be16d3a6bab96d24c45b';

typedef AliasFamilyRef = Ref<AsyncValue<int>>;

@ProviderFor(aliasFamily)
const aliasFamilyProvider = AliasFamilyFamily._();

final class AliasFamilyProvider
    extends $FunctionalProvider<AsyncValue<int>, AsyncValue<int>>
    with $Provider<AsyncValue<int>, AliasFamilyRef> {
  const AliasFamilyProvider._(
      {required AliasFamilyFamily super.from,
      required AsyncValue<int> super.argument,
      AsyncValue<int> Function(
        AliasFamilyRef ref,
        AsyncValue<int> test,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'aliasFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AsyncValue<int> Function(
    AliasFamilyRef ref,
    AsyncValue<int> test,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasFamilyHash();

  @override
  String toString() {
    return r'aliasFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<int>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AliasFamilyProvider $copyWithCreate(
    AsyncValue<int> Function(
      AliasFamilyRef ref,
    ) create,
  ) {
    return AliasFamilyProvider._(
        argument: argument as AsyncValue<int>,
        from: from! as AliasFamilyFamily,
        create: (
          ref,
          AsyncValue<int> test,
        ) =>
            create(ref));
  }

  @override
  AsyncValue<int> create(AliasFamilyRef ref) {
    final _$cb = _createCb ?? aliasFamily;
    final argument = this.argument as AsyncValue<int>;
    return _$cb(
      ref,
      argument,
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

String _$aliasFamilyHash() => r'21f22a6042a649e2de33b829bb85ea54eb6983a2';

final class AliasFamilyFamily extends Family {
  const AliasFamilyFamily._()
      : super(
          retry: null,
          name: r'aliasFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasFamilyProvider call(
    AsyncValue<int> test,
  ) =>
      AliasFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$aliasFamilyHash();

  @override
  String toString() => r'aliasFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    AsyncValue<int> Function(
      AliasFamilyRef ref,
      AsyncValue<int> args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as AliasFamilyProvider;

        final argument = provider.argument as AsyncValue<int>;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(AliasClass)
const aliasClassProvider = AliasClassProvider._();

final class AliasClassProvider
    extends $NotifierProvider<AliasClass, AsyncValue<int>> {
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
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<int>>(value),
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
    AsyncValue<int> Function(
      Ref<AsyncValue<int>>,
      AliasClass,
    ) build,
  ) {
    return AliasClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClass, AsyncValue<int>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$aliasClassHash() => r'aac83936c14520c015f0fe8a0120d353c0baf602';

abstract class _$AliasClass extends $Notifier<AsyncValue<int>> {
  AsyncValue<int> build();
  @$internal
  @override
  AsyncValue<int> runBuild() => build();
}

@ProviderFor(AliasClassFamily)
const aliasClassFamilyProvider = AliasClassFamilyFamily._();

final class AliasClassFamilyProvider
    extends $NotifierProvider<AliasClassFamily, AsyncValue<int>> {
  const AliasClassFamilyProvider._(
      {required AliasClassFamilyFamily super.from,
      required AsyncValue<int> super.argument,
      super.runNotifierBuildOverride,
      AliasClassFamily Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'aliasClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AliasClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasClassFamilyHash();

  @override
  String toString() {
    return r'aliasClassFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<int>>(value),
    );
  }

  @$internal
  @override
  AliasClassFamily create() => _createCb?.call() ?? AliasClassFamily();

  @$internal
  @override
  AliasClassFamilyProvider $copyWithCreate(
    AliasClassFamily Function() create,
  ) {
    return AliasClassFamilyProvider._(
        argument: argument as AsyncValue<int>,
        from: from! as AliasClassFamilyFamily,
        create: create);
  }

  @$internal
  @override
  AliasClassFamilyProvider $copyWithBuild(
    AsyncValue<int> Function(
      Ref<AsyncValue<int>>,
      AliasClassFamily,
    ) build,
  ) {
    return AliasClassFamilyProvider._(
        argument: argument as AsyncValue<int>,
        from: from! as AliasClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClassFamily, AsyncValue<int>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class AliasClassFamilyFamily extends Family {
  const AliasClassFamilyFamily._()
      : super(
          retry: null,
          name: r'aliasClassFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasClassFamilyProvider call(
    AsyncValue<int> test,
  ) =>
      AliasClassFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$aliasClassFamilyHash();

  @override
  String toString() => r'aliasClassFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    AliasClassFamily Function(
      AsyncValue<int> args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as AliasClassFamilyProvider;

        final argument = provider.argument as AsyncValue<int>;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    AsyncValue<int> Function(Ref<AsyncValue<int>> ref,
            AliasClassFamily notifier, AsyncValue<int> argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as AliasClassFamilyProvider;

        final argument = provider.argument as AsyncValue<int>;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$AliasClassFamily extends $Notifier<AsyncValue<int>> {
  late final _$args = ref.$arg as AsyncValue<int>;
  AsyncValue<int> get test => _$args;

  AsyncValue<int> build(
    AsyncValue<int> test,
  );
  @$internal
  @override
  AsyncValue<int> runBuild() => build(
        _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
