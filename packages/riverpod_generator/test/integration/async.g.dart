// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GenericRef<T extends num> = Ref<AsyncValue<List<T>>>;

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $FunctionalProvider<AsyncValue<List<T>>, FutureOr<List<T>>>
    with $FutureModifier<List<T>>, $FutureProvider<List<T>, GenericRef<T>> {
  const GenericProvider._(
      {required GenericFamily super.from,
      FutureOr<List<T>> Function(
        GenericRef<T> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<T>> Function(
    GenericRef<T> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<T> _copyWithCreate(
    FutureOr<List<T>> Function<T extends num>(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(
        from: from! as GenericFamily, create: create<T>);
  }

  @override
  String toString() {
    return r'genericProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  $FutureProviderElement<List<T>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  GenericProvider<T> $copyWithCreate(
    FutureOr<List<T>> Function(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @override
  FutureOr<List<T>> create(GenericRef<T> ref) {
    final _$cb = _createCb ?? generic<T>;
    return _$cb(ref);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericHash() => r'5fb4a4ebeb69c6841722c3a021554648db095009';

final class GenericFamily extends Family {
  const GenericFamily._()
      : super(
          retry: null,
          name: r'genericProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericProvider<T> call<T extends num>() => GenericProvider<T>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<List<T>> Function<T extends num>(GenericRef<T> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<T extends num>
    extends $AsyncNotifierProvider<GenericClass<T>, List<T>> {
  const GenericClassProvider._(
      {required GenericClassFamily super.from,
      super.runNotifierBuildOverride,
      GenericClass<T> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'genericClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GenericClass<T> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericClassHash();

  GenericClassProvider<T> _copyWithCreate(
    GenericClass<T> Function<T extends num>() create,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, create: create<T>);
  }

  GenericClassProvider<T> _copyWithBuild(
    FutureOr<List<T>> Function<T extends num>(
      Ref<AsyncValue<List<T>>>,
      GenericClass<T>,
    ) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build<T>);
  }

  @override
  String toString() {
    return r'genericClassProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  GenericClass<T> create() => _createCb?.call() ?? GenericClass<T>();

  @$internal
  @override
  GenericClassProvider<T> $copyWithCreate(
    GenericClass<T> Function() create,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, create: create);
  }

  @$internal
  @override
  GenericClassProvider<T> $copyWithBuild(
    FutureOr<List<T>> Function(
      Ref<AsyncValue<List<T>>>,
      GenericClass<T>,
    ) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<GenericClass<T>, List<T>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

final class GenericClassFamily extends Family {
  const GenericClassFamily._()
      : super(
          retry: null,
          name: r'genericClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericClassProvider<T> call<T extends num>() =>
      GenericClassProvider<T>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$genericClassHash();

  @override
  String toString() => r'genericClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    GenericClass<T> Function<T extends num>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericClassProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<List<T>> Function<T extends num>(
            Ref<AsyncValue<List<T>>> ref, GenericClass<T> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericClassProvider;

        return provider._copyWithBuild(build).$createElement(pointer);
      },
    );
  }
}

abstract class _$GenericClass<T extends num> extends $AsyncNotifier<List<T>> {
  FutureOr<List<T>> build();
  @$internal
  @override
  FutureOr<List<T>> runBuild() => build();
}

typedef PublicRef = Ref<AsyncValue<String>>;

@ProviderFor(public)
const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String, PublicRef> {
  const PublicProvider._(
      {FutureOr<String> Function(
        PublicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    PublicRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  PublicProvider $copyWithCreate(
    FutureOr<String> Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  FutureOr<String> create(PublicRef ref) {
    final _$cb = _createCb ?? public;
    return _$cb(ref);
  }
}

String _$publicHash() => r'19bceccf795e4c3a26ad1e613fd6f41aad949e2b';

typedef _PrivateRef = Ref<AsyncValue<String>>;

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String, _PrivateRef> {
  const _PrivateProvider._(
      {FutureOr<String> Function(
        _PrivateRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    _PrivateRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  _PrivateProvider $copyWithCreate(
    FutureOr<String> Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  FutureOr<String> create(_PrivateRef ref) {
    final _$cb = _createCb ?? _private;
    return _$cb(ref);
  }
}

String _$privateHash() => r'7f0d1ff55a21e520b8471bbabc4649b5336221d4';

typedef FamilyOrRef = Ref<AsyncValue<String>>;

@ProviderFor(familyOr)
const familyOrProvider = FamilyOrFamily._();

final class FamilyOrProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String, FamilyOrRef> {
  const FamilyOrProvider._(
      {required FamilyOrFamily super.from,
      required int super.argument,
      FutureOr<String> Function(
        FamilyOrRef ref,
        int first,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyOrProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    FamilyOrRef ref,
    int first,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyOrHash();

  @override
  String toString() {
    return r'familyOrProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  FamilyOrProvider $copyWithCreate(
    FutureOr<String> Function(
      FamilyOrRef ref,
    ) create,
  ) {
    return FamilyOrProvider._(
        argument: argument as int,
        from: from! as FamilyOrFamily,
        create: (
          ref,
          int first,
        ) =>
            create(ref));
  }

  @override
  FutureOr<String> create(FamilyOrRef ref) {
    final _$cb = _createCb ?? familyOr;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyOrHash() => r'97cce80a626e228202fa30b87c07ae8319b48023';

final class FamilyOrFamily extends Family {
  const FamilyOrFamily._()
      : super(
          retry: null,
          name: r'familyOrProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyOrProvider call(
    int first,
  ) =>
      FamilyOrProvider._(argument: first, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyOrHash();

  @override
  String toString() => r'familyOrProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<String> Function(
      FamilyOrRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyOrProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

typedef FamilyRef = Ref<AsyncValue<String>>;

@ProviderFor(family)
const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String, FamilyRef> {
  const FamilyProvider._(
      {required FamilyFamily super.from,
      required (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      })
          super.argument,
      FutureOr<String> Function(
        FamilyRef ref,
        int first, {
        String? second,
        required double third,
        bool fourth,
        List<String>? fifth,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    FamilyRef ref,
    int first, {
    String? second,
    required double third,
    bool fourth,
    List<String>? fifth,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  FamilyProvider $copyWithCreate(
    FutureOr<String> Function(
      FamilyRef ref,
    ) create,
  ) {
    return FamilyProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        }),
        from: from! as FamilyFamily,
        create: (
          ref,
          int first, {
          String? second,
          required double third,
          bool fourth = true,
          List<String>? fifth,
        }) =>
            create(ref));
  }

  @override
  FutureOr<String> create(FamilyRef ref) {
    final _$cb = _createCb ?? family;
    final argument = this.argument as (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    });
    return _$cb(
      ref,
      argument.$1,
      second: argument.second,
      third: argument.third,
      fourth: argument.fourth,
      fifth: argument.fifth,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyHash() => r'1da6c928ee85a03729a1c147f33e018521bb9c89';

final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) =>
      FamilyProvider._(argument: (
        first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() => r'familyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<String> Function(
      FamilyRef ref,
      (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider
    extends $AsyncNotifierProvider<PublicClass, String> {
  const PublicClassProvider._(
      {super.runNotifierBuildOverride, PublicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PublicClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicClassHash();

  @$internal
  @override
  PublicClass create() => _createCb?.call() ?? PublicClass();

  @$internal
  @override
  PublicClassProvider $copyWithCreate(
    PublicClass Function() create,
  ) {
    return PublicClassProvider._(create: create);
  }

  @$internal
  @override
  PublicClassProvider $copyWithBuild(
    FutureOr<String> Function(
      Ref<AsyncValue<String>>,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<PublicClass, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

abstract class _$PublicClass extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$internal
  @override
  FutureOr<String> runBuild() => build();
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $AsyncNotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._(
      {super.runNotifierBuildOverride, _PrivateClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _PrivateClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateClassHash();

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
    FutureOr<String> Function(
      Ref<AsyncValue<String>>,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<_PrivateClass, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

abstract class _$PrivateClass extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$internal
  @override
  FutureOr<String> runBuild() => build();
}

@ProviderFor(FamilyOrClass)
const familyOrClassProvider = FamilyOrClassFamily._();

final class FamilyOrClassProvider
    extends $AsyncNotifierProvider<FamilyOrClass, String> {
  const FamilyOrClassProvider._(
      {required FamilyOrClassFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      FamilyOrClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyOrClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FamilyOrClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyOrClassHash();

  @override
  String toString() {
    return r'familyOrClassProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FamilyOrClass create() => _createCb?.call() ?? FamilyOrClass();

  @$internal
  @override
  FamilyOrClassProvider $copyWithCreate(
    FamilyOrClass Function() create,
  ) {
    return FamilyOrClassProvider._(
        argument: argument as int,
        from: from! as FamilyOrClassFamily,
        create: create);
  }

  @$internal
  @override
  FamilyOrClassProvider $copyWithBuild(
    FutureOr<String> Function(
      Ref<AsyncValue<String>>,
      FamilyOrClass,
    ) build,
  ) {
    return FamilyOrClassProvider._(
        argument: argument as int,
        from: from! as FamilyOrClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<FamilyOrClass, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is FamilyOrClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyOrClassHash() => r'b4882d4e79a03c63005d35eb7a021c9c4373a8d9';

final class FamilyOrClassFamily extends Family {
  const FamilyOrClassFamily._()
      : super(
          retry: null,
          name: r'familyOrClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyOrClassProvider call(
    int first,
  ) =>
      FamilyOrClassProvider._(argument: first, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyOrClassHash();

  @override
  String toString() => r'familyOrClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FamilyOrClass Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyOrClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<String> Function(
            Ref<AsyncValue<String>> ref, FamilyOrClass notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyOrClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$FamilyOrClass extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as int;
  int get first => _$args;

  FutureOr<String> build(
    int first,
  );
  @$internal
  @override
  FutureOr<String> runBuild() => build(
        _$args,
      );
}

@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily._();

final class FamilyClassProvider
    extends $AsyncNotifierProvider<FamilyClass, String> {
  const FamilyClassProvider._(
      {required FamilyClassFamily super.from,
      required (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      })
          super.argument,
      super.runNotifierBuildOverride,
      FamilyClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FamilyClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyClassHash();

  @override
  String toString() {
    return r'familyClassProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FamilyClass create() => _createCb?.call() ?? FamilyClass();

  @$internal
  @override
  FamilyClassProvider $copyWithCreate(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        }),
        from: from! as FamilyClassFamily,
        create: create);
  }

  @$internal
  @override
  FamilyClassProvider $copyWithBuild(
    FutureOr<String> Function(
      Ref<AsyncValue<String>>,
      FamilyClass,
    ) build,
  ) {
    return FamilyClassProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        }),
        from: from! as FamilyClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<FamilyClass, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'b7e3ca6091f12bbc99972e961acd885e05f42a15';

final class FamilyClassFamily extends Family {
  const FamilyClassFamily._()
      : super(
          retry: null,
          name: r'familyClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) =>
      FamilyClassProvider._(argument: (
        first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$familyClassHash();

  @override
  String toString() => r'familyClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FamilyClass Function(
      (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<String> Function(
            Ref<AsyncValue<String>> ref,
            FamilyClass notifier,
            (
              int, {
              String? second,
              double third,
              bool fourth,
              List<String>? fifth,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$FamilyClass extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as (
    int, {
    String? second,
    double third,
    bool fourth,
    List<String>? fifth,
  });
  int get first => _$args.$1;
  String? get second => _$args.second;
  double get third => _$args.third;
  bool get fourth => _$args.fourth;
  List<String>? get fifth => _$args.fifth;

  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
  @$internal
  @override
  FutureOr<String> runBuild() => build(
        _$args.$1,
        second: _$args.second,
        third: _$args.third,
        fourth: _$args.fourth,
        fifth: _$args.fifth,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
