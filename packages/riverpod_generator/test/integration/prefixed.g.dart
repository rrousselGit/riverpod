// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefixed.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@r.ProviderFor(value)
final valueProvider = ValueProvider._();

final class ValueProvider extends r.$FunctionalProvider<int, int, int>
    with r.$Provider<int> {
  ValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'valueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$valueHash();

  @r.$internal
  @override
  r.$ProviderElement<int> $createElement(r.$ProviderPointer pointer) =>
      r.$ProviderElement(pointer);

  @override
  int create(r.Ref ref) {
    return value(ref);
  }

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(int value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<int>(value),
    );
  }
}

String _$valueHash() => r'ff8faccaf392cdf9857b6caa7ed2370d8b996676';

@r.ProviderFor(future)
final futureProvider = FutureProvider._();

final class FutureProvider
    extends r.$FunctionalProvider<r.AsyncValue<int>, int, r.FutureOr<int>>
    with r.$FutureModifier<int>, r.$FutureProvider<int> {
  FutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'futureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$futureHash();

  @r.$internal
  @override
  r.$FutureProviderElement<int> $createElement(r.$ProviderPointer pointer) =>
      r.$FutureProviderElement(pointer);

  @override
  r.FutureOr<int> create(r.Ref ref) {
    return future(ref);
  }
}

String _$futureHash() => r'e4a6d86946f91b02adefc608f407f8b261f85d39';

@r.ProviderFor(stream)
final streamProvider = StreamProvider._();

final class StreamProvider
    extends r.$FunctionalProvider<r.AsyncValue<int>, int, Stream<int>>
    with r.$FutureModifier<int>, r.$StreamProvider<int> {
  StreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamHash();

  @r.$internal
  @override
  r.$StreamProviderElement<int> $createElement(r.$ProviderPointer pointer) =>
      r.$StreamProviderElement(pointer);

  @override
  Stream<int> create(r.Ref ref) {
    return stream(ref);
  }
}

String _$streamHash() => r'2c97be10288e07249ba6d667361d3cfd94093b21';

@r.ProviderFor(family)
final familyProvider = FamilyFamily._();

final class FamilyProvider extends r.$FunctionalProvider<int, int, int>
    with r.$Provider<int> {
  FamilyProvider._({
    required FamilyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'familyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = valueProvider;

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '($argument)';
  }

  @r.$internal
  @override
  r.$ProviderElement<int> $createElement(r.$ProviderPointer pointer) =>
      r.$ProviderElement(pointer);

  @override
  int create(r.Ref ref) {
    final argument = this.argument as int;
    return family(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(int value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<int>(value),
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

String _$familyHash() => r'cb78bdedb4a24f7c972988eab86c0aab037d01a4';

final class FamilyFamily extends r.$Family
    with r.$FunctionalFamilyOverride<int, int> {
  FamilyFamily._()
    : super(
        retry: null,
        name: r'familyProvider',
        dependencies: <r.ProviderOrFamily>[valueProvider],
        $allTransitiveDependencies: <r.ProviderOrFamily>[
          FamilyProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  FamilyProvider call(int arg) => FamilyProvider._(argument: arg, from: this);

  @override
  String toString() => r'familyProvider';
}

@r.ProviderFor(genericFamily)
final genericFamilyProvider = GenericFamilyFamily._();

final class GenericFamilyProvider<ItemT>
    extends r.$FunctionalProvider<List<ItemT>, List<ItemT>, List<ItemT>>
    with r.$Provider<List<ItemT>> {
  GenericFamilyProvider._({
    required GenericFamilyFamily super.from,
    required ItemT super.argument,
  }) : super(
         retry: null,
         name: r'genericFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$genericFamilyHash();

  @override
  String toString() {
    return r'genericFamilyProvider'
        '<${ItemT}>'
        '($argument)';
  }

  @r.$internal
  @override
  r.$ProviderElement<List<ItemT>> $createElement(r.$ProviderPointer pointer) =>
      r.$ProviderElement(pointer);

  @override
  List<ItemT> create(r.Ref ref) {
    final argument = this.argument as ItemT;
    return genericFamily<ItemT>(ref, argument);
  }

  $R _captureGenerics<$R>($R Function<ItemT>() cb) {
    return cb<ItemT>();
  }

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(List<ItemT> value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<List<ItemT>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericFamilyProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericFamilyHash() => r'c6a7243a62b96fc6feb95f2802709ce87d23194c';

final class GenericFamilyFamily extends r.$Family {
  GenericFamilyFamily._()
    : super(
        retry: null,
        name: r'genericFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericFamilyProvider<ItemT> call<ItemT>(ItemT item) =>
      GenericFamilyProvider<ItemT>._(argument: item, from: this);

  @override
  String toString() => r'genericFamilyProvider';

  /// {@macro riverpod.override_with}
  r.Override overrideWith(
    List<ItemT> Function<ItemT>(r.Ref ref, ItemT args) create,
  ) => r.$FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericFamilyProvider;
      return provider._captureGenerics(<ItemT>() {
        provider as GenericFamilyProvider<ItemT>;
        final argument = provider.argument as ItemT;
        return provider
            .$view(create: (ref) => create(ref, argument))
            .$createElement(pointer);
      });
    },
  );
}

@r.ProviderFor(ValueClass)
final valueClassProvider = ValueClassProvider._();

final class ValueClassProvider extends r.$NotifierProvider<ValueClass, int> {
  ValueClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'valueClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$valueClassHash();

  @r.$internal
  @override
  ValueClass create() => ValueClass();

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(int value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<int>(value),
    );
  }
}

String _$valueClassHash() => r'85720e9a3e0fe6e954c18ba36ab3571ae32319c4';

abstract class _$ValueClass extends r.$Notifier<int> {
  int build();
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<int, int>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@r.ProviderFor(FutureClass)
final futureClassProvider = FutureClassProvider._();

final class FutureClassProvider
    extends r.$AsyncNotifierProvider<FutureClass, int> {
  FutureClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'futureClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$futureClassHash();

  @r.$internal
  @override
  FutureClass create() => FutureClass();
}

String _$futureClassHash() => r'744de61185702e77e4aadcfe3f2b5c4cb2268d14';

abstract class _$FutureClass extends r.$AsyncNotifier<int> {
  r.FutureOr<int> build();
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<r.AsyncValue<int>, int>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<r.AsyncValue<int>, int>,
              r.AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@r.ProviderFor(StreamClass)
final streamClassProvider = StreamClassProvider._();

final class StreamClassProvider
    extends r.$StreamNotifierProvider<StreamClass, int> {
  StreamClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamClassHash();

  @r.$internal
  @override
  StreamClass create() => StreamClass();
}

String _$streamClassHash() => r'970c19d9f81c8fecfbaa6ea0d0f2a335fcd8a419';

abstract class _$StreamClass extends r.$StreamNotifier<int> {
  Stream<int> build();
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<r.AsyncValue<int>, int>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<r.AsyncValue<int>, int>,
              r.AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@r.ProviderFor(FamilyClass)
final familyClassProvider = FamilyClassFamily._();

final class FamilyClassProvider extends r.$NotifierProvider<FamilyClass, int> {
  FamilyClassProvider._({
    required FamilyClassFamily super.from,
    required int super.argument,
  }) : super(
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
        '($argument)';
  }

  @r.$internal
  @override
  FamilyClass create() => FamilyClass();

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(int value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'68175a2363faeeeda19821acd272c6657d0c4832';

final class FamilyClassFamily extends r.$Family
    with r.$ClassFamilyOverride<FamilyClass, int, int, int, int> {
  FamilyClassFamily._()
    : super(
        retry: null,
        name: r'familyClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FamilyClassProvider call(int arg) =>
      FamilyClassProvider._(argument: arg, from: this);

  @override
  String toString() => r'familyClassProvider';
}

abstract class _$FamilyClass extends r.$Notifier<int> {
  late final _$args = ref.$arg as int;
  int get arg => _$args;

  int build(int arg);
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<int, int>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@r.ProviderFor(GenericClass)
final genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<ItemT>
    extends r.$NotifierProvider<GenericClass<ItemT>, List<ItemT>> {
  GenericClassProvider._({
    required GenericClassFamily super.from,
    required ItemT super.argument,
  }) : super(
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
        '<${ItemT}>'
        '($argument)';
  }

  @r.$internal
  @override
  GenericClass<ItemT> create() => GenericClass<ItemT>();

  $R _captureGenerics<$R>($R Function<ItemT>() cb) {
    return cb<ItemT>();
  }

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(List<ItemT> value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<List<ItemT>>(value),
    );
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

String _$genericClassHash() => r'8355c805989b15b2e41083a30c3d510e7f8ced42';

final class GenericClassFamily extends r.$Family {
  GenericClassFamily._()
    : super(
        retry: null,
        name: r'genericClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericClassProvider<ItemT> call<ItemT>(ItemT item) =>
      GenericClassProvider<ItemT>._(argument: item, from: this);

  @override
  String toString() => r'genericClassProvider';

  /// {@macro riverpod.override_with}
  r.Override overrideWith(GenericClass<ItemT> Function<ItemT>() create) =>
      r.$FamilyOverride(
        from: this,
        createElement: (pointer) {
          final provider = pointer.origin as GenericClassProvider;
          return provider._captureGenerics(<ItemT>() {
            provider as GenericClassProvider<ItemT>;
            return provider
                .$view(create: create<ItemT>)
                .$createElement(pointer);
          });
        },
      );

  /// {@macro riverpod.override_with_build}
  r.Override overrideWithBuild(
    List<ItemT> Function<ItemT>(r.Ref ref, GenericClass<ItemT> notifier) build,
  ) => r.$FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericClassProvider;
      return provider._captureGenerics(<ItemT>() {
        provider as GenericClassProvider<ItemT>;
        return provider
            .$view(runNotifierBuildOverride: build<ItemT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$GenericClass<ItemT> extends r.$Notifier<List<ItemT>> {
  late final _$args = ref.$arg as ItemT;
  ItemT get item => _$args;

  List<ItemT> build(ItemT item);
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<List<ItemT>, List<ItemT>>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<List<ItemT>, List<ItemT>>,
              List<ItemT>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@r.ProviderFor(Scoped)
final scopedProvider = ScopedProvider._();

final class ScopedProvider extends r.$NotifierProvider<Scoped, int> {
  ScopedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopedProvider',
        isAutoDispose: true,
        dependencies: <r.ProviderOrFamily>[],
        $allTransitiveDependencies: <r.ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$scopedHash();

  @r.$internal
  @override
  Scoped create() => Scoped();

  /// {@macro riverpod.override_with_value}
  r.Override overrideWithValue(int value) {
    return r.$ProviderOverride(
      origin: this,
      providerOverride: r.$SyncValueProvider<int>(value),
    );
  }
}

String _$scopedHash() => r'32013475126bac742437049ea1f8c31603bf9801';

abstract class _$Scoped extends r.$Notifier<int> {
  int build() => throw r.MissingScopeException(ref);
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref = this.ref as r.$Ref<int, int>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@r.ProviderFor(storage)
final storageProvider = StorageProvider._();

final class StorageProvider
    extends
        r.$FunctionalProvider<
          r.AsyncValue<r.Storage<String, String>>,
          r.Storage<String, String>,
          r.FutureOr<r.Storage<String, String>>
        >
    with
        r.$FutureModifier<r.Storage<String, String>>,
        r.$FutureProvider<r.Storage<String, String>> {
  StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @r.$internal
  @override
  r.$FutureProviderElement<r.Storage<String, String>> $createElement(
    r.$ProviderPointer pointer,
  ) => r.$FutureProviderElement(pointer);

  @override
  r.FutureOr<r.Storage<String, String>> create(r.Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'9b194265f2598b82dc9943a5951cb0336c8c0d34';

@r.ProviderFor(Json)
@r.JsonPersist()
final jsonProvider = JsonProvider._();

@r.JsonPersist()
final class JsonProvider
    extends r.$AsyncNotifierProvider<Json, Map<String, int>> {
  JsonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonHash();

  @r.$internal
  @override
  Json create() => Json();
}

String _$jsonHash() => r'553acd85e4165efbe3f50592b5c9d2d7087c3b45';

@r.JsonPersist()
abstract class _$JsonBase extends r.$AsyncNotifier<Map<String, int>> {
  r.FutureOr<Map<String, int>> build();
  @r.$mustCallSuper
  @override
  r.WhenComplete runBuild() {
    final ref =
        this.ref as r.$Ref<r.AsyncValue<Map<String, int>>, Map<String, int>>;
    final element =
        ref.element
            as r.$ClassProviderElement<
              r.AnyNotifier<r.AsyncValue<Map<String, int>>, Map<String, int>>,
              r.AsyncValue<Map<String, int>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

// **************************************************************************
// JsonGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
abstract class _$Json extends _$JsonBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "Json";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  r.PersistResult persist(
    r.FutureOr<r.Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, int> state)? encode,
    Map<String, int> Function(String encoded)? decode,
    r.StorageOptions options = const r.StorageOptions(),
  }) {
    return r.NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? r.$jsonCodex.encode,
      decode:
          decode ??
          (encoded) {
            final e = r.$jsonCodex.decode(encoded);
            return (e as Map).map((k, v) => MapEntry(k as String, v as int));
          },
      options: options,
    );
  }
}
