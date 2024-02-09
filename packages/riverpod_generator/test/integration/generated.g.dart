// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GeneratedRef = Ref<_Test>;

const generatedProvider = GeneratedProvider._();

final class GeneratedProvider
    extends $FunctionalProvider<_Test, _Test, GeneratedRef>
    with $Provider<_Test, GeneratedRef> {
  const GeneratedProvider._(
      {_Test Function(
        GeneratedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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

  @override
  $ProviderElement<_Test> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? generated;
    return fn(ref);
  }
}

String _$generatedHash() => r'e49f3520d06ed50d34a44de613fdcd20b19f48d4';

typedef GeneratedFamilyRef = Ref<_Test>;

const generatedFamilyProvider = GeneratedFamilyFamily._();

final class GeneratedFamilyProvider
    extends $FunctionalProvider<_Test, _Test, GeneratedFamilyRef>
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
  $ProviderElement<_Test> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? generatedFamily;
    final _Test argument = this.argument as _Test;
    return fn(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedFamilyProvider && other.argument == argument;
  }
}

String _$generatedFamilyHash() => r'ed284f58926c87acc81dab9168882d5d1c2cddf8';

final class GeneratedFamilyFamily extends Family {
  const GeneratedFamilyFamily._()
      : super(
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
  String toString() => r'generatedFamily';
}

typedef $DynamicRef = Ref<Object?>;

const $dynamicProvider = $DynamicProvider._();

final class $DynamicProvider
    extends $FunctionalProvider<Object?, Object?, $DynamicRef>
    with $Provider<Object?, $DynamicRef> {
  const $DynamicProvider._(
      {Object? Function(
        $DynamicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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

  @override
  $ProviderElement<Object?> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? $dynamic;
    return fn(ref);
  }
}

String _$$dynamicHash() => r'f62d63d9340f30b253e687f76deacd8205fed0e7';

typedef $DynamicFamilyRef = Ref<Object?>;

const $dynamicFamilyProvider = $DynamicFamilyFamily._();

final class $DynamicFamilyProvider
    extends $FunctionalProvider<Object?, Object?, $DynamicFamilyRef>
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
  $ProviderElement<Object?> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? $dynamicFamily;
    final dynamic argument = this.argument as dynamic;
    return fn(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is $DynamicFamilyProvider && other.argument == argument;
  }
}

String _$$dynamicFamilyHash() => r'b764133af8837b8321b08814892f198d4bc1aa18';

final class $DynamicFamilyFamily extends Family {
  const $DynamicFamilyFamily._()
      : super(
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
  String toString() => r'$dynamicFamily';
}

typedef _DynamicRef = Ref<Object?>;

const _dynamicProvider = _DynamicFamily._();

final class _DynamicProvider
    extends $FunctionalProvider<Object?, Object?, _DynamicRef>
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
  $ProviderElement<Object?> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? _dynamic;
    final dynamic argument = this.argument as dynamic;
    return fn(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _DynamicProvider && other.argument == argument;
  }
}

String _$dynamicHash() => r'da9dc07960139fff2cf5fe584dca5c524e4f2308';

final class _DynamicFamily extends Family {
  const _DynamicFamily._()
      : super(
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
  String toString() => r'_dynamic';
}

typedef AliasRef = Ref<r.AsyncValue<int>>;

const aliasProvider = AliasProvider._();

final class AliasProvider
    extends $FunctionalProvider<r.AsyncValue<int>, r.AsyncValue<int>, AliasRef>
    with $Provider<r.AsyncValue<int>, AliasRef> {
  const AliasProvider._(
      {r.AsyncValue<int> Function(
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

  final r.AsyncValue<int> Function(
    AliasRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasHash();

  @override
  $ProviderElement<r.AsyncValue<int>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AliasProvider $copyWithCreate(
    r.AsyncValue<int> Function(
      AliasRef ref,
    ) create,
  ) {
    return AliasProvider._(create: create);
  }

  @override
  r.AsyncValue<int> create(AliasRef ref) {
    final fn = _createCb ?? alias;
    return fn(ref);
  }
}

String _$aliasHash() => r'cc08ec4cc5ec0dc98bdb7f4dcbc035021b09bcf3';

typedef AliasFamilyRef = Ref<r.AsyncValue<int>>;

const aliasFamilyProvider = AliasFamilyFamily._();

final class AliasFamilyProvider extends $FunctionalProvider<
    r.AsyncValue<int>,
    r.AsyncValue<int>,
    AliasFamilyRef> with $Provider<r.AsyncValue<int>, AliasFamilyRef> {
  const AliasFamilyProvider._(
      {required AliasFamilyFamily super.from,
      required r.AsyncValue<int> super.argument,
      r.AsyncValue<int> Function(
        AliasFamilyRef ref,
        r.AsyncValue<int> test,
      )? create})
      : _createCb = create,
        super(
          name: r'aliasFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final r.AsyncValue<int> Function(
    AliasFamilyRef ref,
    r.AsyncValue<int> test,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasFamilyHash();

  @override
  $ProviderElement<r.AsyncValue<int>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AliasFamilyProvider $copyWithCreate(
    r.AsyncValue<int> Function(
      AliasFamilyRef ref,
    ) create,
  ) {
    return AliasFamilyProvider._(
        argument: argument as r.AsyncValue<int>,
        from: from! as AliasFamilyFamily,
        create: (
          ref,
          r.AsyncValue<int> test,
        ) =>
            create(ref));
  }

  @override
  r.AsyncValue<int> create(AliasFamilyRef ref) {
    final fn = _createCb ?? aliasFamily;
    final r.AsyncValue<int> argument = this.argument as r.AsyncValue<int>;
    return fn(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AliasFamilyProvider && other.argument == argument;
  }
}

String _$aliasFamilyHash() => r'f345937d5750132f629aef41646b119a301f750b';

final class AliasFamilyFamily extends Family {
  const AliasFamilyFamily._()
      : super(
          name: r'aliasFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasFamilyProvider call(
    r.AsyncValue<int> test,
  ) =>
      AliasFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$aliasFamilyHash();

  @override
  String toString() => r'aliasFamily';
}

const generatedClassProvider = GeneratedClassProvider._();

final class GeneratedClassProvider
    extends $NotifierProvider<GeneratedClass, _Test> {
  const GeneratedClassProvider._(
      {super.runNotifierBuildOverride, GeneratedClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'generatedClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GeneratedClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedClassHash();

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
    _Test Function(Ref<_Test>, GeneratedClass) build,
  ) {
    return GeneratedClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GeneratedClass, _Test> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$generatedClassHash() => r'984153f97e25de687d2f19756b277aabd56f6e72';

abstract class _$GeneratedClass extends $Notifier<_Test> {
  _Test build();

  @$internal
  @override
  _Test runBuild() => build();
}

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
          name: r'generatedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GeneratedClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedClassFamilyHash();

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
    _Test Function(Ref<_Test>, GeneratedClassFamily) build,
  ) {
    return GeneratedClassFamilyProvider._(
        argument: argument as _Test,
        from: from! as GeneratedClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GeneratedClassFamily, _Test> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is GeneratedClassFamilyProvider && other.argument == argument;
  }
}

String _$generatedClassFamilyHash() =>
    r'28d0a5a82af5b254f6ef07b492916e2feb7e6e63';

final class GeneratedClassFamilyFamily extends Family {
  const GeneratedClassFamilyFamily._()
      : super(
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
  String toString() => r'GeneratedClassFamily';
}

abstract class _$GeneratedClassFamily extends $Notifier<_Test> {
  late final _$args =
      (ref as $NotifierProviderElement).origin.argument as (_Test,);
  _Test get test => _$args.$1;

  _Test build(
    _Test test,
  );

  @$internal
  @override
  _Test runBuild() => build(
        _$args.$1,
      );
}

const $dynamicClassProvider = $DynamicClassProvider._();

final class $DynamicClassProvider
    extends $NotifierProvider<$DynamicClass, Object?> {
  const $DynamicClassProvider._(
      {super.runNotifierBuildOverride, $DynamicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'$dynamicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final $DynamicClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassHash();

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
    Object? Function(Ref<Object?>, $DynamicClass) build,
  ) {
    return $DynamicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<$DynamicClass, Object?> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$$dynamicClassHash() => r'c6d8e5191c3f060df3ce3eee66107433fd4c3292';

abstract class _$$DynamicClass extends $Notifier<Object?> {
  Object? build();

  @$internal
  @override
  Object? runBuild() => build();
}

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
          name: r'$dynamicClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final $DynamicClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$$dynamicClassFamilyHash();

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
    Object? Function(Ref<Object?>, $DynamicClassFamily) build,
  ) {
    return $DynamicClassFamilyProvider._(
        argument: argument as dynamic,
        from: from! as $DynamicClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<$DynamicClassFamily, Object?> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is $DynamicClassFamilyProvider && other.argument == argument;
  }
}

String _$$dynamicClassFamilyHash() =>
    r'bdda961386f3b647c071d79293a8da441580c470';

final class $DynamicClassFamilyFamily extends Family {
  const $DynamicClassFamilyFamily._()
      : super(
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
  String toString() => r'$DynamicClassFamily';
}

abstract class _$$DynamicClassFamily extends $Notifier<Object?> {
  late final _$args =
      (ref as $NotifierProviderElement).origin.argument as (dynamic,);
  dynamic get test => _$args.$1;

  Object? build(
    dynamic test,
  );

  @$internal
  @override
  Object? runBuild() => build(
        _$args.$1,
      );
}

const aliasClassProvider = AliasClassProvider._();

final class AliasClassProvider
    extends $NotifierProvider<AliasClass, r.AsyncValue<int>> {
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
    r.AsyncValue<int> Function(Ref<r.AsyncValue<int>>, AliasClass) build,
  ) {
    return AliasClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClass, r.AsyncValue<int>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$aliasClassHash() => r'a6c6d7594ebd09ba728e42d79b12af560d09c379';

abstract class _$AliasClass extends $Notifier<r.AsyncValue<int>> {
  r.AsyncValue<int> build();

  @$internal
  @override
  r.AsyncValue<int> runBuild() => build();
}

const aliasClassFamilyProvider = AliasClassFamilyFamily._();

final class AliasClassFamilyProvider
    extends $NotifierProvider<AliasClassFamily, r.AsyncValue<int>> {
  const AliasClassFamilyProvider._(
      {required AliasClassFamilyFamily super.from,
      required r.AsyncValue<int> super.argument,
      super.runNotifierBuildOverride,
      AliasClassFamily Function()? create})
      : _createCb = create,
        super(
          name: r'aliasClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AliasClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aliasClassFamilyHash();

  @$internal
  @override
  AliasClassFamily create() => _createCb?.call() ?? AliasClassFamily();

  @$internal
  @override
  AliasClassFamilyProvider $copyWithCreate(
    AliasClassFamily Function() create,
  ) {
    return AliasClassFamilyProvider._(
        argument: argument as r.AsyncValue<int>,
        from: from! as AliasClassFamilyFamily,
        create: create);
  }

  @$internal
  @override
  AliasClassFamilyProvider $copyWithBuild(
    r.AsyncValue<int> Function(Ref<r.AsyncValue<int>>, AliasClassFamily) build,
  ) {
    return AliasClassFamilyProvider._(
        argument: argument as r.AsyncValue<int>,
        from: from! as AliasClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AliasClassFamily, r.AsyncValue<int>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is AliasClassFamilyProvider && other.argument == argument;
  }
}

String _$aliasClassFamilyHash() => r'3f348beb95dae3a9890b4a4d0ce01481316fc66d';

final class AliasClassFamilyFamily extends Family {
  const AliasClassFamilyFamily._()
      : super(
          name: r'aliasClassFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AliasClassFamilyProvider call(
    r.AsyncValue<int> test,
  ) =>
      AliasClassFamilyProvider._(argument: test, from: this);

  @override
  String debugGetCreateSourceHash() => _$aliasClassFamilyHash();

  @override
  String toString() => r'AliasClassFamily';
}

abstract class _$AliasClassFamily extends $Notifier<r.AsyncValue<int>> {
  late final _$args =
      (ref as $NotifierProviderElement).origin.argument as (r.AsyncValue<int>,);
  r.AsyncValue<int> get test => _$args.$1;

  r.AsyncValue<int> build(
    r.AsyncValue<int> test,
  );

  @$internal
  @override
  r.AsyncValue<int> runBuild() => build(
        _$args.$1,
      );
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
