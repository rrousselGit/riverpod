// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GenericRef<T extends num> = Ref<AsyncValue<List<T>>>;

const genericProvider = GenericFamily._();

final class GenericProvider<T extends num> extends $FunctionalProvider<
        AsyncValue<List<T>>, Stream<List<T>>, GenericRef<T>>
    with $FutureModifier<List<T>>, $StreamProvider<List<T>, GenericRef<T>> {
  const GenericProvider._(
      {required GenericFamily super.from,
      Stream<List<T>> Function(
        GenericRef<T> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          debugGetCreateSourceHash: _$genericHash,
          name: r'generic',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<List<T>> Function(
    GenericRef<T> ref,
  )? _createCb;

  @override
  void $unimplemented() {}

  @override
  $StreamProviderElement<List<T>> createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  Stream<List<T>> create(GenericRef<T> ref) {
    final fn = _createCb ?? generic<T>;

    return fn(
      ref,
    );
  }

  @override
  GenericProvider<T> copyWithCreate(
    Stream<List<T>> Function(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }
}

String _$genericHash() => r'c1122edf55163d47de8d871ed5d15e0a7edddc05';

final class GenericFamily extends Family {
  const GenericFamily._()
      : super(
          name: r'generic',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$genericHash,
          isAutoDispose: true,
        );

  GenericProvider<T> call<T extends num>() => GenericProvider._(from: this);

  @override
  String toString() => r'generic';
}

typedef PublicRef = Ref<AsyncValue<String>>;

const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>, PublicRef>
    with $FutureModifier<String>, $StreamProvider<String, PublicRef> {
  const PublicProvider._(
      {Stream<String> Function(
        PublicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$publicHash,
          name: r'public',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
    PublicRef ref,
  )? _createCb;

  @override
  void $unimplemented() {}

  @override
  $StreamProviderElement<String> createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  Stream<String> create(PublicRef ref) {
    final fn = _createCb ?? public;

    return fn(
      ref,
    );
  }

  @override
  PublicProvider copyWithCreate(
    Stream<String> Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }
}

String _$publicHash() => r'c5cc0eac434371901cf6ab159a81bba49c58da12';

typedef _PrivateRef = Ref<AsyncValue<String>>;

const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>, _PrivateRef>
    with $FutureModifier<String>, $StreamProvider<String, _PrivateRef> {
  const _PrivateProvider._(
      {Stream<String> Function(
        _PrivateRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$privateHash,
          name: r'_private',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
    _PrivateRef ref,
  )? _createCb;

  @override
  void $unimplemented() {}

  @override
  $StreamProviderElement<String> createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  Stream<String> create(_PrivateRef ref) {
    final fn = _createCb ?? _private;

    return fn(
      ref,
    );
  }

  @override
  _PrivateProvider copyWithCreate(
    Stream<String> Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }
}

String _$privateHash() => r'bbee0c7e27bda81346b5f52c96b23b2e48f83077';

typedef FamilyRef = Ref<AsyncValue<String>>;

const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>, FamilyRef>
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
          debugGetCreateSourceHash: _$familyHash,
          name: r'family',
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
  void $unimplemented() {}

  @override
  $StreamProviderElement<String> createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  Stream<String> create(FamilyRef ref) {
    final fn = _createCb ?? family;
    final (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    }) argument = this.argument! as (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    });
    return fn(
      ref,
      argument.$1,
      second: argument.second,
      third: argument.third,
      fourth: argument.fourth,
      fifth: argument.fifth,
    );
  }

  @override
  FamilyProvider copyWithCreate(
    Stream<String> Function(
      FamilyRef ref,
    ) create,
  ) {
    return FamilyProvider._(
        argument: argument! as (
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
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }
}

String _$familyHash() => r'6896fac2f6e3ccd7c38ecaa0d538cbd3577936b2';

final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          name: r'family',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$familyHash,
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
  String toString() => r'family';
}

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
          debugGetCreateSourceHash: _$genericClassHash,
          name: r'GenericClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GenericClass<T> Function()? _createCb;

  @override
  void $unimplemented() {}

  @$internal
  @override
  GenericClass<T> create() => _createCb?.call() ?? GenericClass<T>();

  @$internal
  @override
  GenericClassProvider<T> copyWithCreate(
    GenericClass<T> Function() create,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, create: create);
  }

  @$internal
  @override
  GenericClassProvider<T> copyWithBuild(
    Stream<List<T>> Function(Ref<AsyncValue<List<T>>>, GenericClass<T>) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<GenericClass<T>, List<T>> createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }
}

String _$genericClassHash() => r'401ae1cfd97a4291dfd135a69ff8e1c436866e5a';

final class GenericClassFamily extends Family {
  const GenericClassFamily._()
      : super(
          name: r'GenericClass',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$genericClassHash,
          isAutoDispose: true,
        );

  GenericClassProvider<T> call<T extends num>() =>
      GenericClassProvider._(from: this);

  @override
  String toString() => r'GenericClass';
}

abstract class _$GenericClass<T extends num> extends $StreamNotifier<List<T>> {
  Stream<List<T>> build();

  @$internal
  @override
  Stream<List<T>> runBuild() => build();
}

const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider
    extends $StreamNotifierProvider<PublicClass, String> {
  const PublicClassProvider._(
      {super.runNotifierBuildOverride, PublicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$publicClassHash,
          name: r'PublicClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PublicClass Function()? _createCb;

  @override
  void $unimplemented() {}

  @$internal
  @override
  PublicClass create() => _createCb?.call() ?? PublicClass();

  @$internal
  @override
  PublicClassProvider copyWithCreate(
    PublicClass Function() create,
  ) {
    return PublicClassProvider._(create: create);
  }

  @$internal
  @override
  PublicClassProvider copyWithBuild(
    Stream<String> Function(Ref<AsyncValue<String>>, PublicClass) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<PublicClass, String> createElement(
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

const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $StreamNotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._(
      {super.runNotifierBuildOverride, _PrivateClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          debugGetCreateSourceHash: _$privateClassHash,
          name: r'_PrivateClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _PrivateClass Function()? _createCb;

  @override
  void $unimplemented() {}

  @$internal
  @override
  _PrivateClass create() => _createCb?.call() ?? _PrivateClass();

  @$internal
  @override
  _PrivateClassProvider copyWithCreate(
    _PrivateClass Function() create,
  ) {
    return _PrivateClassProvider._(create: create);
  }

  @$internal
  @override
  _PrivateClassProvider copyWithBuild(
    Stream<String> Function(Ref<AsyncValue<String>>, _PrivateClass) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<_PrivateClass, String> createElement(
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
          debugGetCreateSourceHash: _$familyClassHash,
          name: r'FamilyClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FamilyClass Function()? _createCb;

  @override
  void $unimplemented() {}

  @$internal
  @override
  FamilyClass create() => _createCb?.call() ?? FamilyClass();

  @$internal
  @override
  FamilyClassProvider copyWithCreate(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._(
        argument: argument! as (
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
  FamilyClassProvider copyWithBuild(
    Stream<String> Function(Ref<AsyncValue<String>>, FamilyClass) build,
  ) {
    return FamilyClassProvider._(
        argument: argument! as (
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
  $StreamNotifierProviderElement<FamilyClass, String> createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }
}

String _$familyClassHash() => r'6ec16ca23da8df4c010ecb5eed72e3e655504460';

final class FamilyClassFamily extends Family {
  const FamilyClassFamily._()
      : super(
          name: r'FamilyClass',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$familyClassHash,
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
  String toString() => r'FamilyClass';
}

abstract class _$FamilyClass extends $StreamNotifier<String> {
  late final _$args =
      (ref as $StreamNotifierProviderElement).origin.argument as (
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

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
