// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $FunctionalProvider<AsyncValue<List<T>>, List<T>, FutureOr<List<T>>>
    with $FutureModifier<List<T>>, $FutureProvider<List<T>> {
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
        '<${T}>'
        '()';
  }

  @$internal
  @override
  $FutureProviderElement<List<T>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<T>> create(Ref ref) {
    return generic<T>(ref);
  }

  $R _captureGenerics<$R>($R Function<T extends num>() cb) {
    return cb<T>();
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

String _$genericHash() => r'b7413a59722e9d62ae99c8a7ee0b4a24417fc3b4';

final class GenericFamily extends $Family {
  const GenericFamily._()
      : super(
          retry: null,
          name: r'genericProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericProvider<T> call<T extends num>() => GenericProvider<T>._(from: this);

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          FutureOr<List<T>> Function<T extends num>(Ref ref) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericProvider<T>;
              return provider.$view(create: create<T>).$createElement(pointer);
            });
          });
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<T extends num>
    extends $AsyncNotifierProvider<GenericClass<T>, List<T>> {
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
        '<${T}>'
        '()';
  }

  @$internal
  @override
  GenericClass<T> create() => GenericClass<T>();

  $R _captureGenerics<$R>($R Function<T extends num>() cb) {
    return cb<T>();
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

String _$genericClassHash() => r'd3c4acc9cdae12f6c666fbf1f89aee212bb086db';

final class GenericClassFamily extends $Family {
  const GenericClassFamily._()
      : super(
          retry: null,
          name: r'genericClassProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericClassProvider<T> call<T extends num>() =>
      GenericClassProvider<T>._(from: this);

  @override
  String toString() => r'genericClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(GenericClass<T> Function<T extends num>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericClassProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericClassProvider<T>;
              return provider.$view(create: create<T>).$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          FutureOr<List<T>> Function<T extends num>(
                  Ref ref, GenericClass<T> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericClassProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericClassProvider<T>;
              return provider
                  .$view(runNotifierBuildOverride: build<T>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$GenericClass<T extends num> extends $AsyncNotifier<List<T>> {
  FutureOr<List<T>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<T>>, List<T>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<T>>, List<T>>,
        AsyncValue<List<T>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GenericArg)
const genericArgProvider = GenericArgFamily._();

final class GenericArgProvider<T extends num>
    extends $AsyncNotifierProvider<GenericArg<T>, String> {
  const GenericArgProvider._(
      {required GenericArgFamily super.from, required T super.argument})
      : super(
          retry: null,
          name: r'genericArgProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericArgHash();

  @override
  String toString() {
    return r'genericArgProvider'
        '<${T}>'
        '($argument)';
  }

  @$internal
  @override
  GenericArg<T> create() => GenericArg<T>();

  $R _captureGenerics<$R>($R Function<T extends num>() cb) {
    return cb<T>();
  }

  @override
  bool operator ==(Object other) {
    return other is GenericArgProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericArgHash() => r'26ad32d0efc4b0ee9da2d1a34fd7b9e3473f8520';

final class GenericArgFamily extends $Family {
  const GenericArgFamily._()
      : super(
          retry: null,
          name: r'genericArgProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericArgProvider<T> call<T extends num>(
    T arg,
  ) =>
      GenericArgProvider<T>._(argument: arg, from: this);

  @override
  String toString() => r'genericArgProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(GenericArg<T> Function<T extends num>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericArgProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericArgProvider<T>;
              return provider.$view(create: create<T>).$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          FutureOr<String> Function<T extends num>(
                  Ref ref, GenericArg<T> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericArgProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericArgProvider<T>;
              return provider
                  .$view(runNotifierBuildOverride: build<T>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$GenericArg<T extends num> extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as T;
  T get arg => _$args;

  FutureOr<String> build(
    T arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
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

@ProviderFor(public)
const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
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
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return public(ref);
  }
}

String _$publicHash() => r'19bceccf795e4c3a26ad1e613fd6f41aad949e2b';

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
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
  String debugGetCreateSourceHash() => _$privateHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return _private(ref);
  }
}

String _$privateHash() => r'7f0d1ff55a21e520b8471bbabc4649b5336221d4';

@ProviderFor(familyOr)
const familyOrProvider = FamilyOrFamily._();

final class FamilyOrProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const FamilyOrProvider._(
      {required FamilyOrFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'familyOrProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

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
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as int;
    return familyOr(
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

final class FamilyOrFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, int> {
  const FamilyOrFamily._()
      : super(
          retry: null,
          name: r'familyOrProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyOrProvider call(
    int first,
  ) =>
      FamilyOrProvider._(argument: first, from: this);

  @override
  String toString() => r'familyOrProvider';
}

@ProviderFor(family)
const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
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
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
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

String _$familyHash() => r'1da6c928ee85a03729a1c147f33e018521bb9c89';

final class FamilyFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<String>,
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
    extends $AsyncNotifierProvider<PublicClass, String> {
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

String _$publicClassHash() => r'e9bc69e44b72e8ed77d423524c0d74ad460d629d';

abstract class _$PublicClass extends $AsyncNotifier<String> {
  FutureOr<String> build();
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
    extends $AsyncNotifierProvider<_PrivateClass, String> {
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
  String debugGetCreateSourceHash() => _$privateClassHash();

  @$internal
  @override
  _PrivateClass create() => _PrivateClass();
}

String _$privateClassHash() => r'7e69cffe8315999710e4cb6bb3de9f179d3f2f5d';

abstract class _$PrivateClass extends $AsyncNotifier<String> {
  FutureOr<String> build();
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

@ProviderFor(FamilyOrClass)
const familyOrClassProvider = FamilyOrClassFamily._();

final class FamilyOrClassProvider
    extends $AsyncNotifierProvider<FamilyOrClass, String> {
  const FamilyOrClassProvider._(
      {required FamilyOrClassFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'familyOrClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

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
  FamilyOrClass create() => FamilyOrClass();

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

final class FamilyOrClassFamily extends $Family
    with
        $ClassFamilyOverride<FamilyOrClass, AsyncValue<String>, String,
            FutureOr<String>, int> {
  const FamilyOrClassFamily._()
      : super(
          retry: null,
          name: r'familyOrClassProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FamilyOrClassProvider call(
    int first,
  ) =>
      FamilyOrClassProvider._(argument: first, from: this);

  @override
  String toString() => r'familyOrClassProvider';
}

abstract class _$FamilyOrClass extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as int;
  int get first => _$args;

  FutureOr<String> build(
    int first,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
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

String _$familyClassHash() => r'b7e3ca6091f12bbc99972e961acd885e05f42a15';

final class FamilyClassFamily extends $Family
    with
        $ClassFamilyOverride<
            FamilyClass,
            AsyncValue<String>,
            String,
            FutureOr<String>,
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

@ProviderFor(Regression3490)
const regression3490Provider = Regression3490Family._();

final class Regression3490Provider<Model, Sort, Cursor>
    extends $NotifierProvider<Regression3490<Model, Sort, Cursor>, void> {
  const Regression3490Provider._(
      {required Regression3490Family super.from,
      required ({
        String type,
        Regression3490Cb<Model, Sort, Cursor> getData,
        String? parentId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'regression3490Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$regression3490Hash();

  @override
  String toString() {
    return r'regression3490Provider'
        '<${Model}, ${Sort}, ${Cursor}>'
        '$argument';
  }

  @$internal
  @override
  Regression3490<Model, Sort, Cursor> create() =>
      Regression3490<Model, Sort, Cursor>();

  $R _captureGenerics<$R>($R Function<Model, Sort, Cursor>() cb) {
    return cb<Model, Sort, Cursor>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Regression3490Provider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$regression3490Hash() => r'9d5d48cbde589961d0cdac395f68111ec17b194a';

final class Regression3490Family extends $Family {
  const Regression3490Family._()
      : super(
          retry: null,
          name: r'regression3490Provider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Regression3490Provider<Model, Sort, Cursor> call<Model, Sort, Cursor>({
    required String type,
    required Regression3490Cb<Model, Sort, Cursor> getData,
    String? parentId,
  }) =>
      Regression3490Provider<Model, Sort, Cursor>._(argument: (
        type: type,
        getData: getData,
        parentId: parentId,
      ), from: this);

  @override
  String toString() => r'regression3490Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          Regression3490<Model, Sort, Cursor> Function<Model, Sort, Cursor>()
              create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as Regression3490Provider;
            return provider._captureGenerics(<Model, Sort, Cursor>() {
              provider as Regression3490Provider<Model, Sort, Cursor>;
              return provider
                  .$view(create: create<Model, Sort, Cursor>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          void Function<Model, Sort, Cursor>(
                  Ref ref, Regression3490<Model, Sort, Cursor> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as Regression3490Provider;
            return provider._captureGenerics(<Model, Sort, Cursor>() {
              provider as Regression3490Provider<Model, Sort, Cursor>;
              return provider
                  .$view(runNotifierBuildOverride: build<Model, Sort, Cursor>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$Regression3490<Model, Sort, Cursor> extends $Notifier<void> {
  late final _$args = ref.$arg as ({
    String type,
    Regression3490Cb<Model, Sort, Cursor> getData,
    String? parentId,
  });
  String get type => _$args.type;
  Regression3490Cb<Model, Sort, Cursor> get getData => _$args.getData;
  String? get parentId => _$args.parentId;

  void build({
    required String type,
    required Regression3490Cb<Model, Sort, Cursor> getData,
    String? parentId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    build(
      type: _$args.type,
      getData: _$args.getData,
      parentId: _$args.parentId,
    );
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
