// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GenericRef<T extends num> = Ref<AsyncValue<List<T>>>;

const genericProvider = GenericFamily._();

final class GenericProvider<T extends num> extends $FunctionalProvider<
        AsyncValue<List<T>>, FutureOr<List<T>>, GenericRef<T>>
    with $FutureModifier<List<T>>, $FutureProvider<List<T>, GenericRef<T>> {
  const GenericProvider._({
    FutureOr<List<T>> Function(
      GenericRef<T> ref,
    )? create,
    required GenericFamily super.from,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$genericHash,
          name: r'generic',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          argument: null,
        );

  final FutureOr<List<T>> Function(
    GenericRef<T> ref,
  )? _createCb;

  @override
  $FutureProviderElement<List<T>> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureOr<List<T>> create(GenericRef<T> ref) {
    final fn = _createCb ?? generic<T>;

    return fn(
      ref,
    );
  }

  @override
  GenericProvider<T> copyWithCreate(
    FutureOr<List<T>> Function(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(
      create: create,
      from: from! as GenericFamily,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }
}

String _$genericHash() => r'6ee5473ece745b00328c1e048f6967c160343620';

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
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>, PublicRef>
    with $FutureModifier<String>, $FutureProvider<String, PublicRef> {
  const PublicProvider._({
    FutureOr<String> Function(
      PublicRef ref,
    )? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$publicHash,
          name: r'public',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final FutureOr<String> Function(
    PublicRef ref,
  )? _createCb;

  @override
  $FutureProviderElement<String> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureOr<String> create(PublicRef ref) {
    final fn = _createCb ?? public;

    return fn(
      ref,
    );
  }

  @override
  PublicProvider copyWithCreate(
    FutureOr<String> Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(
      create: create,
    );
  }
}

String _$publicHash() => r'9d99b79c013da13926d4ad89c72ebca4fc1cc257';

typedef _PrivateRef = Ref<AsyncValue<String>>;

const _privateProvider = _PrivateProvider._();

final class _PrivateProvider extends $FunctionalProvider<AsyncValue<String>,
        FutureOr<String>, _PrivateRef>
    with $FutureModifier<String>, $FutureProvider<String, _PrivateRef> {
  const _PrivateProvider._({
    FutureOr<String> Function(
      _PrivateRef ref,
    )? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$privateHash,
          name: r'_private',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final FutureOr<String> Function(
    _PrivateRef ref,
  )? _createCb;

  @override
  $FutureProviderElement<String> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureOr<String> create(_PrivateRef ref) {
    final fn = _createCb ?? _private;

    return fn(
      ref,
    );
  }

  @override
  _PrivateProvider copyWithCreate(
    FutureOr<String> Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(
      create: create,
    );
  }
}

String _$privateHash() => r'bc0469a9315de114a0ccd82c7db4980844d0009f';

typedef FamilyOrRef = Ref<AsyncValue<String>>;

const familyOrProvider = FamilyOrFamily._();

final class FamilyOrProvider extends $FunctionalProvider<AsyncValue<String>,
        FutureOr<String>, FamilyOrRef>
    with $FutureModifier<String>, $FutureProvider<String, FamilyOrRef> {
  const FamilyOrProvider._({
    FutureOr<String> Function(
      FamilyOrRef ref,
      int first,
    )? create,
    required FamilyOrFamily super.from,
    required (int,) super.argument,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$familyOrHash,
          name: r'familyOr',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    FamilyOrRef ref,
    int first,
  )? _createCb;

  @override
  $FutureProviderElement<String> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureOr<String> create(FamilyOrRef ref) {
    final fn = _createCb ?? familyOr;
    final (int,) argument = this.argument! as (int,);
    return fn(
      ref,
      argument.$1,
    );
  }

  @override
  FamilyOrProvider copyWithCreate(
    FutureOr<String> Function(
      FamilyOrRef ref,
    ) create,
  ) {
    return FamilyOrProvider._(
      create: (
        ref,
        int first,
      ) =>
          create(ref),
      argument: argument! as (int,),
      from: from! as FamilyOrFamily,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyOrProvider && other.argument == argument;
  }
}

String _$familyOrHash() => r'1c3217e296b0ce52c07c18769d1fffb95850f482';

final class FamilyOrFamily extends Family {
  const FamilyOrFamily._()
      : super(
          name: r'familyOr',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$familyOrHash,
          isAutoDispose: true,
        );

  FamilyOrProvider call(
    int first,
  ) =>
      FamilyOrProvider._(argument: (first,), from: this);

  @override
  String toString() => r'familyOr';
}

typedef FamilyRef = Ref<AsyncValue<String>>;

const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>, FamilyRef>
    with $FutureModifier<String>, $FutureProvider<String, FamilyRef> {
  const FamilyProvider._({
    FutureOr<String> Function(
      FamilyRef ref,
      int first, {
      String? second,
      required double third,
      bool fourth,
      List<String>? fifth,
    })? create,
    required FamilyFamily super.from,
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$familyHash,
          name: r'family',
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
  $FutureProviderElement<String> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureOr<String> create(FamilyRef ref) {
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
    FutureOr<String> Function(
      FamilyRef ref,
    ) create,
  ) {
    return FamilyProvider._(
      create: (
        ref,
        int first, {
        String? second,
        required double third,
        bool fourth = true,
        List<String>? fifth,
      }) =>
          create(ref),
      argument: argument! as (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      }),
      from: from! as FamilyFamily,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }
}

String _$familyHash() => r'eb6fad35a94d4238b621c2100253ee2c700bee77';

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
    extends $AsyncNotifierProvider<GenericClass<T>, List<T>> {
  const GenericClassProvider._({
    FutureOr<List<T>> Function()? create,
    required GenericClassFamily super.from,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$genericClassHash,
          name: r'GenericClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          argument: null,
        );

  final FutureOr<List<T>> Function()? _createCb;

  @override
  $AsyncNotifierProviderElement<GenericClass<T>, List<T>> createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is GenericClassProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }
}

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

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

abstract class _$GenericClass<T extends num> extends $AsyncNotifier<List<T>> {
  FutureOr<List<T>> build();

  @$internal
  @override
  void runBuild() {}
}

const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider
    extends $AsyncNotifierProvider<PublicClass, String> {
  const PublicClassProvider._({
    FutureOr<String> Function()? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$publicClassHash,
          name: r'PublicClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final FutureOr<String> Function()? _createCb;

  @override
  $AsyncNotifierProviderElement<PublicClass, String> createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);
}

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

abstract class _$PublicClass extends $AsyncNotifier<String> {
  FutureOr<String> build();

  @$internal
  @override
  void runBuild() {}
}

const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $AsyncNotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._({
    FutureOr<String> Function()? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$privateClassHash,
          name: r'_PrivateClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final FutureOr<String> Function()? _createCb;

  @override
  $AsyncNotifierProviderElement<_PrivateClass, String> createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);
}

String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

abstract class _$PrivateClass extends $AsyncNotifier<String> {
  FutureOr<String> build();

  @$internal
  @override
  void runBuild() {}
}

const familyOrClassProvider = FamilyOrClassFamily._();

final class FamilyOrClassProvider
    extends $AsyncNotifierProvider<FamilyOrClass, String> {
  const FamilyOrClassProvider._({
    FutureOr<String> Function()? create,
    required FamilyOrClassFamily super.from,
    required (int,) super.argument,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$familyOrClassHash,
          name: r'FamilyOrClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function()? _createCb;

  @override
  $AsyncNotifierProviderElement<FamilyOrClass, String> createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is FamilyOrClassProvider && other.argument == argument;
  }
}

String _$familyOrClassHash() => r'b4882d4e79a03c63005d35eb7a021c9c4373a8d9';

final class FamilyOrClassFamily extends Family {
  const FamilyOrClassFamily._()
      : super(
          name: r'FamilyOrClass',
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: _$familyOrClassHash,
          isAutoDispose: true,
        );

  FamilyOrClassProvider call(
    int first,
  ) =>
      FamilyOrClassProvider._(argument: (first,), from: this);

  @override
  String toString() => r'FamilyOrClass';
}

abstract class _$FamilyOrClass extends $AsyncNotifier<String> {
  FutureOr<String> build(
    int first,
  );

  @$internal
  @override
  void runBuild() {}
}

const familyClassProvider = FamilyClassFamily._();

final class FamilyClassProvider
    extends $AsyncNotifierProvider<FamilyClass, String> {
  const FamilyClassProvider._({
    FutureOr<String> Function()? create,
    required FamilyClassFamily super.from,
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
        super.argument,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$familyClassHash,
          name: r'FamilyClass',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function()? _createCb;

  @override
  $AsyncNotifierProviderElement<FamilyClass, String> createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }
}

String _$familyClassHash() => r'b7e3ca6091f12bbc99972e961acd885e05f42a15';

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

abstract class _$FamilyClass extends $AsyncNotifier<String> {
  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });

  @$internal
  @override
  void runBuild() {}
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
