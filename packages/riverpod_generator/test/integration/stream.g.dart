// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<ItemT extends num> extends $FunctionalProvider<
        AsyncValue<List<ItemT>>, List<ItemT>, Stream<List<ItemT>>>
    with $FutureModifier<List<ItemT>>, $StreamProvider<List<ItemT>> {
  const GenericProvider._({required GenericFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  @override
  String toString() {
    return r'genericProvider'
        '<${ItemT}>'
        '()';
  }

  @$internal
  @override
  $StreamProviderElement<List<ItemT>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ItemT>> create(Ref ref) {
    return generic<ItemT>(ref);
  }

  $R _captureGenerics<$R>($R Function<ItemT extends num>() cb) {
    return cb<ItemT>();
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

String _$genericHash() => r'ba315b9569d7dade484b5736af8e613b91f83a03';

final class GenericFamily extends $Family {
  const GenericFamily._()
      : super(
          retry: null,
          name: r'genericProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericProvider<ItemT> call<ItemT extends num>() =>
      GenericProvider<ItemT>._(from: this);

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          Stream<List<ItemT>> Function<ItemT extends num>(Ref ref) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericProvider;
            return provider._captureGenerics(<ItemT extends num>() {
              provider as GenericProvider<ItemT>;
              return provider
                  .$view(create: create<ItemT>)
                  .$createElement(pointer);
            });
          });
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<StateT extends num>
    extends $StreamNotifierProvider<GenericClass<StateT>, List<StateT>> {
  const GenericClassProvider._({required GenericClassFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'genericClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericClassHash();

  @override
  String toString() {
    return r'genericClassProvider'
        '<${StateT}>'
        '()';
  }

  @$internal
  @override
  GenericClass<StateT> create() => GenericClass<StateT>();

  $R _captureGenerics<$R>($R Function<StateT extends num>() cb) {
    return cb<StateT>();
  }

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

String _$genericClassHash() => r'540bc5bceb8b9367e84d136e122abba5e8e358bb';

final class GenericClassFamily extends $Family {
  const GenericClassFamily._()
      : super(
          retry: null,
          name: r'genericClassProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericClassProvider<StateT> call<StateT extends num>() =>
      GenericClassProvider<StateT>._(from: this);

  @override
  String toString() => r'genericClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          GenericClass<StateT> Function<StateT extends num>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericClassProvider;
            return provider._captureGenerics(<StateT extends num>() {
              provider as GenericClassProvider<StateT>;
              return provider
                  .$view(create: create<StateT>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          Stream<List<StateT>> Function<StateT extends num>(
                  Ref ref, GenericClass<StateT> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericClassProvider;
            return provider._captureGenerics(<StateT extends num>() {
              provider as GenericClassProvider<StateT>;
              return provider
                  .$view(runNotifierBuildOverride: build<StateT>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$GenericClass<StateT extends num>
    extends $StreamNotifier<List<StateT>> {
  Stream<List<StateT>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<StateT>>, List<StateT>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<StateT>>, List<StateT>>,
        AsyncValue<List<StateT>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(public)
const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  const PublicProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return public(ref);
  }
}

String _$publicHash() => r'ed93527425175c4a2475e83a3f44223a2aa604d7';

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  const _PrivateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_privateHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return _private(ref);
  }
}

String _$_privateHash() => r'7915ccdd16751e7dc6274bb024d1b273d78dc78b';

@ProviderFor(family)
const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  const FamilyProvider._(
      {required FamilyFamily super.from,
      required (
        int, {
        String? second,
        double third,
        bool fourth,
        List<String>? fifth,
      })
          super.argument})
      : super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

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
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    final argument = this.argument as (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    });
    return family(
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

String _$familyHash() => r'ba1df8eab0af0f3f71ae29d23ccb7a491d8e2825';

final class FamilyFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<String>,
            (
              int, {
              String? second,
              double third,
              bool fourth,
              List<String>? fifth,
            })> {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
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
  String toString() => r'familyProvider';
}

@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider
    extends $StreamNotifierProvider<PublicClass, String> {
  const PublicClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$publicClassHash();

  @$internal
  @override
  PublicClass create() => PublicClass();
}

String _$publicClassHash() => r'b1526943c8ff0aaa20642bf78e744e5833cf9d02';

abstract class _$PublicClass extends $StreamNotifier<String> {
  Stream<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $StreamNotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_privateClassHash();

  @$internal
  @override
  _PrivateClass create() => _PrivateClass();
}

String _$_privateClassHash() => r'8c0d52b7ab79c0546d0c84c011bb3512609e029e';

abstract class _$PrivateClass extends $StreamNotifier<String> {
  Stream<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
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
          super.argument})
      : super(
          retry: null,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

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
  FamilyClass create() => FamilyClass();

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

final class FamilyClassFamily extends $Family
    with
        $ClassFamilyOverride<
            FamilyClass,
            AsyncValue<String>,
            String,
            Stream<String>,
            (
              int, {
              String? second,
              double third,
              bool fourth,
              List<String>? fifth,
            })> {
  const FamilyClassFamily._()
      : super(
          retry: null,
          name: r'familyClassProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
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
  String toString() => r'familyClassProvider';
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
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      second: _$args.second,
      third: _$args.third,
      fourth: _$args.fourth,
      fifth: _$args.fifth,
    );
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
