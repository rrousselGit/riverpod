// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_extends.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._(
      {super.runNotifierBuildOverride, MyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  MyNotifier create() => _createCb?.call() ?? MyNotifier();

  @$internal
  @override
  MyNotifierProvider $copyWithCreate(
    MyNotifier Function() create,
  ) {
    return MyNotifierProvider._(create: create);
  }

  @$internal
  @override
  MyNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$myNotifierHash() => r'58f5439a3b1036ba7804f63a5a6ebe0114125039';

abstract class _$MyNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(NoExtends)
const noExtendsProvider = NoExtendsProvider._();

final class NoExtendsProvider extends $NotifierProvider<NoExtends, int> {
  const NoExtendsProvider._(
      {super.runNotifierBuildOverride, NoExtends Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'noExtendsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final NoExtends Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noExtendsHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  NoExtends create() => _createCb?.call() ?? NoExtends();

  @$internal
  @override
  NoExtendsProvider $copyWithCreate(
    NoExtends Function() create,
  ) {
    return NoExtendsProvider._(create: create);
  }

  @$internal
  @override
  NoExtendsProvider $copyWithBuild(
    int Function(
      Ref<int>,
      NoExtends,
    ) build,
  ) {
    return NoExtendsProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NoExtends, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$noExtendsHash() => r'3f1276999a9a6d3676c628c25ed853cbefb21ce9';

abstract class _$NoExtends extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(WrongExtends)
const wrongExtendsProvider = WrongExtendsProvider._();

final class WrongExtendsProvider extends $NotifierProvider<WrongExtends, int> {
  const WrongExtendsProvider._(
      {super.runNotifierBuildOverride, WrongExtends Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'wrongExtendsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final WrongExtends Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$wrongExtendsHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  WrongExtends create() => _createCb?.call() ?? WrongExtends();

  @$internal
  @override
  WrongExtendsProvider $copyWithCreate(
    WrongExtends Function() create,
  ) {
    return WrongExtendsProvider._(create: create);
  }

  @$internal
  @override
  WrongExtendsProvider $copyWithBuild(
    int Function(
      Ref<int>,
      WrongExtends,
    ) build,
  ) {
    return WrongExtendsProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WrongExtends, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$wrongExtendsHash() => r'6479055793af10a34e225373a67f7eaac4d7c0de';

abstract class _$WrongExtends extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $NotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._(
      {super.runNotifierBuildOverride, _PrivateClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'_privateClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _PrivateClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  _PrivateClass create() => _createCb?.call() ?? _PrivateClass();

  @$internal
  @override
  _PrivateClassProvider $copyWithCreate(
    _PrivateClass Function() create,
  ) {
    return _PrivateClassProvider._(create: create);
  }

  @$internal
  @override
  _PrivateClassProvider $copyWithBuild(
    String Function(
      Ref<String>,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<_PrivateClass, String> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$privateClassHash() => r'ba68a29a609566bb8bc0792391f842762356e124';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

@ProviderFor(Generics)
const genericsProvider = GenericsFamily._();

final class GenericsProvider<A extends num, B>
    extends $NotifierProvider<Generics<A, B>, int> {
  const GenericsProvider._(
      {required GenericsFamily super.from,
      super.runNotifierBuildOverride,
      Generics<A, B> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'genericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Generics<A, B> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  GenericsProvider<A, B> _copyWithCreate(
    Generics<A, B> Function<A extends num, B>() create,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, create: create<A, B>);
  }

  GenericsProvider<A, B> _copyWithBuild(
    int Function<A extends num, B>(
      Ref<int>,
      Generics<A, B>,
    ) build,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, runNotifierBuildOverride: build<A, B>);
  }

  @override
  String toString() {
    return r'genericsProvider'
        '<${A}, ${B}>'
        '()';
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
  Generics<A, B> create() => _createCb?.call() ?? Generics<A, B>();

  @$internal
  @override
  GenericsProvider<A, B> $copyWithCreate(
    Generics<A, B> Function() create,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, create: create);
  }

  @$internal
  @override
  GenericsProvider<A, B> $copyWithBuild(
    int Function(
      Ref<int>,
      Generics<A, B>,
    ) build,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Generics<A, B>, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is GenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericsHash() => r'0a1bf00e0610ccb1fb5615460e1bc4afb2555f69';

final class GenericsFamily extends Family {
  const GenericsFamily._()
      : super(
          name: r'genericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericsProvider<A, B> call<A extends num, B>() =>
      GenericsProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Generics<A, B> Function<A extends num, B>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericsProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A extends num, B>(Ref<int> ref, Generics<A, B> notifier) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericsProvider;

        return provider._copyWithBuild(build).$createElement(container);
      },
    );
  }
}

abstract class _$Generics<A extends num, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(NoGenerics)
const noGenericsProvider = NoGenericsFamily._();

final class NoGenericsProvider<A extends num, B>
    extends $NotifierProvider<NoGenerics<A, B>, int> {
  const NoGenericsProvider._(
      {required NoGenericsFamily super.from,
      super.runNotifierBuildOverride,
      NoGenerics<A, B> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'noGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final NoGenerics<A, B> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  NoGenericsProvider<A, B> _copyWithCreate(
    NoGenerics<A, B> Function<A extends num, B>() create,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, create: create<A, B>);
  }

  NoGenericsProvider<A, B> _copyWithBuild(
    int Function<A extends num, B>(
      Ref<int>,
      NoGenerics<A, B>,
    ) build,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, runNotifierBuildOverride: build<A, B>);
  }

  @override
  String toString() {
    return r'noGenericsProvider'
        '<${A}, ${B}>'
        '()';
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
  NoGenerics<A, B> create() => _createCb?.call() ?? NoGenerics<A, B>();

  @$internal
  @override
  NoGenericsProvider<A, B> $copyWithCreate(
    NoGenerics<A, B> Function() create,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, create: create);
  }

  @$internal
  @override
  NoGenericsProvider<A, B> $copyWithBuild(
    int Function(
      Ref<int>,
      NoGenerics<A, B>,
    ) build,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NoGenerics<A, B>, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is NoGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$noGenericsHash() => r'30d5d20092f43cb17ede1f619773757df7cecb30';

final class NoGenericsFamily extends Family {
  const NoGenericsFamily._()
      : super(
          name: r'noGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NoGenericsProvider<A, B> call<A extends num, B>() =>
      NoGenericsProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  @override
  String toString() => r'noGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NoGenerics<A, B> Function<A extends num, B>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as NoGenericsProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A extends num, B>(Ref<int> ref, NoGenerics<A, B> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as NoGenericsProvider;

        return provider._copyWithBuild(build).$createElement(container);
      },
    );
  }
}

abstract class _$NoGenerics<A extends num, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(MissingGenerics)
const missingGenericsProvider = MissingGenericsFamily._();

final class MissingGenericsProvider<A, B>
    extends $NotifierProvider<MissingGenerics<A, B>, int> {
  const MissingGenericsProvider._(
      {required MissingGenericsFamily super.from,
      super.runNotifierBuildOverride,
      MissingGenerics<A, B> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'missingGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MissingGenerics<A, B> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  MissingGenericsProvider<A, B> _copyWithCreate(
    MissingGenerics<A, B> Function<A, B>() create,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily, create: create<A, B>);
  }

  MissingGenericsProvider<A, B> _copyWithBuild(
    int Function<A, B>(
      Ref<int>,
      MissingGenerics<A, B>,
    ) build,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily,
        runNotifierBuildOverride: build<A, B>);
  }

  @override
  String toString() {
    return r'missingGenericsProvider'
        '<${A}, ${B}>'
        '()';
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
  MissingGenerics<A, B> create() =>
      _createCb?.call() ?? MissingGenerics<A, B>();

  @$internal
  @override
  MissingGenericsProvider<A, B> $copyWithCreate(
    MissingGenerics<A, B> Function() create,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily, create: create);
  }

  @$internal
  @override
  MissingGenericsProvider<A, B> $copyWithBuild(
    int Function(
      Ref<int>,
      MissingGenerics<A, B>,
    ) build,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MissingGenerics<A, B>, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is MissingGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$missingGenericsHash() => r'b611c76d5fb87fdde78b5fc017912e0569762c23';

final class MissingGenericsFamily extends Family {
  const MissingGenericsFamily._()
      : super(
          name: r'missingGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MissingGenericsProvider<A, B> call<A, B>() =>
      MissingGenericsProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  @override
  String toString() => r'missingGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    MissingGenerics<A, B> Function<A, B>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as MissingGenericsProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A, B>(Ref<int> ref, MissingGenerics<A, B> notifier) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as MissingGenericsProvider;

        return provider._copyWithBuild(build).$createElement(container);
      },
    );
  }
}

abstract class _$MissingGenerics<A, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(WrongOrder)
const wrongOrderProvider = WrongOrderFamily._();

final class WrongOrderProvider<A, B>
    extends $NotifierProvider<WrongOrder<A, B>, int> {
  const WrongOrderProvider._(
      {required WrongOrderFamily super.from,
      super.runNotifierBuildOverride,
      WrongOrder<A, B> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'wrongOrderProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final WrongOrder<A, B> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  WrongOrderProvider<A, B> _copyWithCreate(
    WrongOrder<A, B> Function<A, B>() create,
  ) {
    return WrongOrderProvider<A, B>._(
        from: from! as WrongOrderFamily, create: create<A, B>);
  }

  WrongOrderProvider<A, B> _copyWithBuild(
    int Function<A, B>(
      Ref<int>,
      WrongOrder<A, B>,
    ) build,
  ) {
    return WrongOrderProvider<A, B>._(
        from: from! as WrongOrderFamily, runNotifierBuildOverride: build<A, B>);
  }

  @override
  String toString() {
    return r'wrongOrderProvider'
        '<${A}, ${B}>'
        '()';
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
  WrongOrder<A, B> create() => _createCb?.call() ?? WrongOrder<A, B>();

  @$internal
  @override
  WrongOrderProvider<A, B> $copyWithCreate(
    WrongOrder<A, B> Function() create,
  ) {
    return WrongOrderProvider<A, B>._(
        from: from! as WrongOrderFamily, create: create);
  }

  @$internal
  @override
  WrongOrderProvider<A, B> $copyWithBuild(
    int Function(
      Ref<int>,
      WrongOrder<A, B>,
    ) build,
  ) {
    return WrongOrderProvider<A, B>._(
        from: from! as WrongOrderFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WrongOrder<A, B>, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is WrongOrderProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$wrongOrderHash() => r'7757670a2f67406ebc96c87edf088deb9cb248a1';

final class WrongOrderFamily extends Family {
  const WrongOrderFamily._()
      : super(
          name: r'wrongOrderProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WrongOrderProvider<A, B> call<A, B>() =>
      WrongOrderProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  @override
  String toString() => r'wrongOrderProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    WrongOrder<A, B> Function<A, B>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as WrongOrderProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A, B>(Ref<int> ref, WrongOrder<A, B> notifier) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as WrongOrderProvider;

        return provider._copyWithBuild(build).$createElement(container);
      },
    );
  }
}

abstract class _$WrongOrder<A, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
