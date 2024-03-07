// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GenericRef<T extends num> = Ref<AsyncValue<List<T>>>;

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $FunctionalProvider<AsyncValue<List<T>>, Stream<List<T>>>
    with $FutureModifier<List<T>>, $StreamProvider<List<T>, GenericRef<T>> {
  const GenericProvider._(
      {required GenericFamily super.from,
      Stream<List<T>> Function(
        GenericRef<T> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<List<T>> Function(
    GenericRef<T> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<T> _copyWithCreate(
    Stream<List<T>> Function<T extends num>(
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
  $StreamProviderElement<List<T>> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  GenericProvider<T> $copyWithCreate(
    Stream<List<T>> Function(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @override
  Stream<List<T>> create(GenericRef<T> ref) {
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

String _$genericHash() => r'c1122edf55163d47de8d871ed5d15e0a7edddc05';

final class GenericFamily extends Family {
  const GenericFamily._()
      : super(
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
    Stream<List<T>> Function<T extends num>(GenericRef<T> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<T extends num>
    extends $StreamNotifierProvider<GenericClass<T>, List<T>> {
  const GenericClassProvider._(
      {required GenericClassFamily super.from,
      super.runNotifierBuildOverride,
      GenericClass<T> Function()? create})
      : _createCb = create,
        super(
          argument: null,
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
    Stream<List<T>> Function<T extends num>(
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
    Stream<List<T>> Function(
      Ref<AsyncValue<List<T>>>,
      GenericClass<T>,
    ) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<GenericClass<T>, List<T>> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

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

String _$genericClassHash() => r'401ae1cfd97a4291dfd135a69ff8e1c436866e5a';

final class GenericClassFamily extends Family {
  const GenericClassFamily._()
      : super(
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
      createElement: (container, provider) {
        provider as GenericClassProvider;

        return provider._copyWithCreate(create).$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<List<T>> Function<T extends num>(
            Ref<AsyncValue<List<T>>> ref, GenericClass<T> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericClassProvider;

        return provider._copyWithBuild(build).$createElement(container);
      },
    );
  }
}

abstract class _$GenericClass<T extends num> extends $StreamNotifier<List<T>> {
  Stream<List<T>> build();
  @$internal
  @override
  Stream<List<T>> runBuild() => build();
}

typedef PublicRef = Ref<AsyncValue<String>>;

@ProviderFor(public)
const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String, PublicRef> {
  const PublicProvider._(
      {Stream<String> Function(
        PublicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
    PublicRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  PublicProvider $copyWithCreate(
    Stream<String> Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  Stream<String> create(PublicRef ref) {
    final _$cb = _createCb ?? public;
    return _$cb(ref);
  }
}

String _$publicHash() => r'c5cc0eac434371901cf6ab159a81bba49c58da12';

typedef _PrivateRef = Ref<AsyncValue<String>>;

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String, _PrivateRef> {
  const _PrivateProvider._(
      {Stream<String> Function(
        _PrivateRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
    _PrivateRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  _PrivateProvider $copyWithCreate(
    Stream<String> Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  Stream<String> create(_PrivateRef ref) {
    final _$cb = _createCb ?? _private;
    return _$cb(ref);
  }
}

String _$privateHash() => r'bbee0c7e27bda81346b5f52c96b23b2e48f83077';

typedef FamilyRef = Ref<AsyncValue<String>>;

@ProviderFor(family)
const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String, FamilyRef> {
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
      Stream<String> Function(
        FamilyRef ref,
        int first, {
        String? second,
        required double third,
        bool fourth,
        List<String>? fifth,
      })? create})
      : _createCb = create,
        super(
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
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
  $StreamProviderElement<String> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  FamilyProvider $copyWithCreate(
    Stream<String> Function(
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
  Stream<String> create(FamilyRef ref) {
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

String _$familyHash() => r'6896fac2f6e3ccd7c38ecaa0d538cbd3577936b2';

final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
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
    Stream<String> Function(
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
      createElement: (container, provider) {
        provider as FamilyProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider
    extends $StreamNotifierProvider<PublicClass, String> {
  const PublicClassProvider._(
      {super.runNotifierBuildOverride, PublicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
    Stream<String> Function(
      Ref<AsyncValue<String>>,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<PublicClass, String> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);
}

String _$publicClassHash() => r'b1526943c8ff0aaa20642bf78e744e5833cf9d02';

abstract class _$PublicClass extends $StreamNotifier<String> {
  Stream<String> build();
  @$internal
  @override
  Stream<String> runBuild() => build();
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $StreamNotifierProvider<_PrivateClass, String> {
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
    Stream<String> Function(
      Ref<AsyncValue<String>>,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<_PrivateClass, String> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);
}

String _$privateClassHash() => r'8c0d52b7ab79c0546d0c84c011bb3512609e029e';

abstract class _$PrivateClass extends $StreamNotifier<String> {
  Stream<String> build();
  @$internal
  @override
  Stream<String> runBuild() => build();
}

@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily._();

final class FamilyClassProvider
    extends $StreamNotifierProvider<FamilyClass, String> {
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
    Stream<String> Function(
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
  $StreamNotifierProviderElement<FamilyClass, String> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'6ec16ca23da8df4c010ecb5eed72e3e655504460';

final class FamilyClassFamily extends Family {
  const FamilyClassFamily._()
      : super(
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
      createElement: (container, provider) {
        provider as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<String> Function(
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
      createElement: (container, provider) {
        provider as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool fourth,
          List<String>? fifth,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$FamilyClass extends $StreamNotifier<String> {
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

  Stream<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
  @$internal
  @override
  Stream<String> runBuild() => build(
        _$args.$1,
        second: _$args.second,
        third: _$args.third,
        fourth: _$args.fourth,
        fifth: _$args.fifth,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
