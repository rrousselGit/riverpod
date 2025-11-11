// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<ItemT extends num>
    extends $FunctionalProvider<List<ItemT>, List<ItemT>, List<ItemT>>
    with $Provider<List<ItemT>> {
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
  $ProviderElement<List<ItemT>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ItemT> create(Ref ref) {
    return generic<ItemT>(ref);
  }

  $R _captureGenerics<$R>($R Function<ItemT extends num>() cb) {
    return cb<ItemT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ItemT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ItemT>>(value),
    );
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

String _$genericHash() => r'560436def511aa3619152db2325771684296d7e5';

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
    List<ItemT> Function<ItemT extends num>(Ref ref) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericProvider;
      return provider._captureGenerics(<ItemT extends num>() {
        provider as GenericProvider<ItemT>;
        return provider.$view(create: create<ItemT>).$createElement(pointer);
      });
    },
  );
}

@ProviderFor(complexGeneric)
const complexGenericProvider = ComplexGenericFamily._();

final class ComplexGenericProvider<ItemT extends num, OtherT extends String?>
    extends $FunctionalProvider<List<ItemT>, List<ItemT>, List<ItemT>>
    with $Provider<List<ItemT>> {
  const ComplexGenericProvider._({
    required ComplexGenericFamily super.from,
    required ({ItemT param, OtherT? otherParam}) super.argument,
  }) : super(
         retry: null,
         name: r'complexGenericProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$complexGenericHash();

  @override
  String toString() {
    return r'complexGenericProvider'
        '<${ItemT}, ${OtherT}>'
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<ItemT>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ItemT> create(Ref ref) {
    final argument = this.argument as ({ItemT param, OtherT? otherParam});
    return complexGeneric<ItemT, OtherT>(
      ref,
      param: argument.param,
      otherParam: argument.otherParam,
    );
  }

  $R _captureGenerics<$R>(
    $R Function<ItemT extends num, OtherT extends String?>() cb,
  ) {
    return cb<ItemT, OtherT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ItemT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ItemT>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ComplexGenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$complexGenericHash() => r'02fe9175ec1a496c21379692efe6b11a7286ae55';

final class ComplexGenericFamily extends $Family {
  const ComplexGenericFamily._()
    : super(
        retry: null,
        name: r'complexGenericProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ComplexGenericProvider<ItemT, OtherT> call<
    ItemT extends num,
    OtherT extends String?
  >({required ItemT param, OtherT? otherParam}) =>
      ComplexGenericProvider<ItemT, OtherT>._(
        argument: (param: param, otherParam: otherParam),
        from: this,
      );

  @override
  String toString() => r'complexGenericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    List<ItemT> Function<ItemT extends num, OtherT extends String?>(
      Ref ref,
      ({ItemT param, OtherT? otherParam}) args,
    )
    create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as ComplexGenericProvider;
      return provider._captureGenerics(
        <ItemT extends num, OtherT extends String?>() {
          provider as ComplexGenericProvider<ItemT, OtherT>;
          final argument =
              provider.argument as ({ItemT param, OtherT? otherParam});
          return provider
              .$view(create: (ref) => create(ref, argument))
              .$createElement(pointer);
        },
      );
    },
  );
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<ValueT extends num>
    extends $NotifierProvider<GenericClass<ValueT>, List<ValueT>> {
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
        '<${ValueT}>'
        '()';
  }

  @$internal
  @override
  GenericClass<ValueT> create() => GenericClass<ValueT>();

  $R _captureGenerics<$R>($R Function<ValueT extends num>() cb) {
    return cb<ValueT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ValueT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ValueT>>(value),
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

String _$genericClassHash() => r'6e0c2b5d8d270649213bcc5df9d99a16a41e4fe0';

final class GenericClassFamily extends $Family {
  const GenericClassFamily._()
    : super(
        retry: null,
        name: r'genericClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericClassProvider<ValueT> call<ValueT extends num>() =>
      GenericClassProvider<ValueT>._(from: this);

  @override
  String toString() => r'genericClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    GenericClass<ValueT> Function<ValueT extends num>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericClassProvider;
      return provider._captureGenerics(<ValueT extends num>() {
        provider as GenericClassProvider<ValueT>;
        return provider.$view(create: create<ValueT>).$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    List<ValueT> Function<ValueT extends num>(
      Ref ref,
      GenericClass<ValueT> notifier,
    )
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericClassProvider;
      return provider._captureGenerics(<ValueT extends num>() {
        provider as GenericClassProvider<ValueT>;
        return provider
            .$view(runNotifierBuildOverride: build<ValueT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$GenericClass<ValueT extends num>
    extends $Notifier<List<ValueT>> {
  List<ValueT> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ValueT>, List<ValueT>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ValueT>, List<ValueT>>,
              List<ValueT>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(rawFuture)
const rawFutureProvider = RawFutureProvider._();

final class RawFutureProvider
    extends
        $FunctionalProvider<
          Raw<Future<String>>,
          Raw<Future<String>>,
          Raw<Future<String>>
        >
    with $Provider<Raw<Future<String>>> {
  const RawFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawFutureHash();

  @$internal
  @override
  $ProviderElement<Raw<Future<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Future<String>> create(Ref ref) {
    return rawFuture(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<String>>>(value),
    );
  }
}

String _$rawFutureHash() => r'9d397f4c0a578a2741610f9ca6f17438ee8e5a34';

@ProviderFor(rawStream)
const rawStreamProvider = RawStreamProvider._();

final class RawStreamProvider
    extends
        $FunctionalProvider<
          Raw<Stream<String>>,
          Raw<Stream<String>>,
          Raw<Stream<String>>
        >
    with $Provider<Raw<Stream<String>>> {
  const RawStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawStreamHash();

  @$internal
  @override
  $ProviderElement<Raw<Stream<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Stream<String>> create(Ref ref) {
    return rawStream(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Stream<String>>>(value),
    );
  }
}

String _$rawStreamHash() => r'c7d6cd22f1f325827c866c3ec757d08315fd9858';

@ProviderFor(RawFutureClass)
const rawFutureClassProvider = RawFutureClassProvider._();

final class RawFutureClassProvider
    extends $NotifierProvider<RawFutureClass, Raw<Future<String>>> {
  const RawFutureClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawFutureClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawFutureClassHash();

  @$internal
  @override
  RawFutureClass create() => RawFutureClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<String>>>(value),
    );
  }
}

String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

abstract class _$RawFutureClass extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Raw<Future<String>>, Raw<Future<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String>>, Raw<Future<String>>>,
              Raw<Future<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(RawStreamClass)
const rawStreamClassProvider = RawStreamClassProvider._();

final class RawStreamClassProvider
    extends $NotifierProvider<RawStreamClass, Raw<Stream<String>>> {
  const RawStreamClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawStreamClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawStreamClassHash();

  @$internal
  @override
  RawStreamClass create() => RawStreamClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Stream<String>>>(value),
    );
  }
}

String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

abstract class _$RawStreamClass extends $Notifier<Raw<Stream<String>>> {
  Raw<Stream<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Raw<Stream<String>>, Raw<Stream<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Stream<String>>, Raw<Stream<String>>>,
              Raw<Stream<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(rawFamilyFuture)
const rawFamilyFutureProvider = RawFamilyFutureFamily._();

final class RawFamilyFutureProvider
    extends
        $FunctionalProvider<
          Raw<Future<String>>,
          Raw<Future<String>>,
          Raw<Future<String>>
        >
    with $Provider<Raw<Future<String>>> {
  const RawFamilyFutureProvider._({
    required RawFamilyFutureFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rawFamilyFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureHash();

  @override
  String toString() {
    return r'rawFamilyFutureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Raw<Future<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Future<String>> create(Ref ref) {
    final argument = this.argument as int;
    return rawFamilyFuture(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<String>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rawFamilyFutureHash() => r'0ac70d7a2133691f1a9a38cedaeeb6b3bc667ade';

final class RawFamilyFutureFamily extends $Family
    with $FunctionalFamilyOverride<Raw<Future<String>>, int> {
  const RawFamilyFutureFamily._()
    : super(
        retry: null,
        name: r'rawFamilyFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RawFamilyFutureProvider call(int id) =>
      RawFamilyFutureProvider._(argument: id, from: this);

  @override
  String toString() => r'rawFamilyFutureProvider';
}

@ProviderFor(rawFamilyStream)
const rawFamilyStreamProvider = RawFamilyStreamFamily._();

final class RawFamilyStreamProvider
    extends
        $FunctionalProvider<
          Raw<Stream<String>>,
          Raw<Stream<String>>,
          Raw<Stream<String>>
        >
    with $Provider<Raw<Stream<String>>> {
  const RawFamilyStreamProvider._({
    required RawFamilyStreamFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rawFamilyStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamHash();

  @override
  String toString() {
    return r'rawFamilyStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Raw<Stream<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Stream<String>> create(Ref ref) {
    final argument = this.argument as int;
    return rawFamilyStream(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rawFamilyStreamHash() => r'6eacfa3a3576d884099c08c298751a3d395271be';

final class RawFamilyStreamFamily extends $Family
    with $FunctionalFamilyOverride<Raw<Stream<String>>, int> {
  const RawFamilyStreamFamily._()
    : super(
        retry: null,
        name: r'rawFamilyStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RawFamilyStreamProvider call(int id) =>
      RawFamilyStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'rawFamilyStreamProvider';
}

@ProviderFor(RawFamilyFutureClass)
const rawFamilyFutureClassProvider = RawFamilyFutureClassFamily._();

final class RawFamilyFutureClassProvider
    extends $NotifierProvider<RawFamilyFutureClass, Raw<Future<String>>> {
  const RawFamilyFutureClassProvider._({
    required RawFamilyFutureClassFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rawFamilyFutureClassProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureClassHash();

  @override
  String toString() {
    return r'rawFamilyFutureClassProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RawFamilyFutureClass create() => RawFamilyFutureClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<String>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyFutureClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rawFamilyFutureClassHash() =>
    r'd7cacb0f2c51697d107de6daa68b242c04085dca';

final class RawFamilyFutureClassFamily extends $Family
    with
        $ClassFamilyOverride<
          RawFamilyFutureClass,
          Raw<Future<String>>,
          Raw<Future<String>>,
          Raw<Future<String>>,
          int
        > {
  const RawFamilyFutureClassFamily._()
    : super(
        retry: null,
        name: r'rawFamilyFutureClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RawFamilyFutureClassProvider call(int id) =>
      RawFamilyFutureClassProvider._(argument: id, from: this);

  @override
  String toString() => r'rawFamilyFutureClassProvider';
}

abstract class _$RawFamilyFutureClass extends $Notifier<Raw<Future<String>>> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Raw<Future<String>> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Raw<Future<String>>, Raw<Future<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String>>, Raw<Future<String>>>,
              Raw<Future<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(RawFamilyStreamClass)
const rawFamilyStreamClassProvider = RawFamilyStreamClassFamily._();

final class RawFamilyStreamClassProvider
    extends $NotifierProvider<RawFamilyStreamClass, Raw<Stream<String>>> {
  const RawFamilyStreamClassProvider._({
    required RawFamilyStreamClassFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rawFamilyStreamClassProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamClassHash();

  @override
  String toString() {
    return r'rawFamilyStreamClassProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RawFamilyStreamClass create() => RawFamilyStreamClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RawFamilyStreamClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rawFamilyStreamClassHash() =>
    r'321796a0befc43fb83f7ccfdcb6b011fc8c7c599';

final class RawFamilyStreamClassFamily extends $Family
    with
        $ClassFamilyOverride<
          RawFamilyStreamClass,
          Raw<Stream<String>>,
          Raw<Stream<String>>,
          Raw<Stream<String>>,
          int
        > {
  const RawFamilyStreamClassFamily._()
    : super(
        retry: null,
        name: r'rawFamilyStreamClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RawFamilyStreamClassProvider call(int id) =>
      RawFamilyStreamClassProvider._(argument: id, from: this);

  @override
  String toString() => r'rawFamilyStreamClassProvider';
}

abstract class _$RawFamilyStreamClass extends $Notifier<Raw<Stream<String>>> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Raw<Stream<String>> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Raw<Stream<String>>, Raw<Stream<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Stream<String>>, Raw<Stream<String>>>,
              Raw<Stream<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// This is some documentation

@ProviderFor(public)
const publicProvider = PublicProvider._();

/// This is some documentation

final class PublicProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// This is some documentation
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return public(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$publicHash() => r'94bee36125844f9fe521363bb228632b9f3bfbc7';

@ProviderFor(supports$inNames)
const supports$inNamesProvider = Supports$inNamesProvider._();

final class Supports$inNamesProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Supports$inNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supports$inNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supports$inNamesHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return supports$inNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$supports$inNamesHash() => r'8da1f9329f302ce75e38d03c96595de3260b4d2d';

/// This is some documentation

@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// This is some documentation

final class FamilyProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// This is some documentation
  const FamilyProvider._({
    required FamilyFamily super.from,
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
    super.argument,
  }) : super(
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument =
        this.argument
            as (
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
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

String _$familyHash() => r'f58149448f80f10ec054f2f8a6f37bae61e38f49';

/// This is some documentation

final class FamilyFamily extends $Family
    with
        $FunctionalFamilyOverride<
          String,
          (
            int, {
            String? second,
            double third,
            bool fourth,
            List<String>? fifth,
          })
        > {
  const FamilyFamily._()
    : super(
        retry: null,
        name: r'familyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// This is some documentation

  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) => FamilyProvider._(
    argument: (
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    ),
    from: this,
  );

  @override
  String toString() => r'familyProvider';
}

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return _private(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$_privateHash() => r'834affaed42662bf46ce7f6203ac2495e1e8974b';

/// This is some documentation

@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

/// This is some documentation
final class PublicClassProvider extends $NotifierProvider<PublicClass, String> {
  /// This is some documentation
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$publicClassHash() => r'd261f9eb927ca71440a5e1bdb24558c25fae4833';

/// This is some documentation

abstract class _$PublicClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $NotifierProvider<_PrivateClass, String> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$_privateClassHash() => r'796e16abb79d7ad77728f9288d24566e429643f2';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// This is some documentation

@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily._();

/// This is some documentation
final class FamilyClassProvider extends $NotifierProvider<FamilyClass, String> {
  /// This is some documentation
  const FamilyClassProvider._({
    required FamilyClassFamily super.from,
    required (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    })
    super.argument,
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
        '$argument';
  }

  @$internal
  @override
  FamilyClass create() => FamilyClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
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

String _$familyClassHash() => r'ac5aba6b9cbee66236d6e1fa3d18b9b6ffb2c5f1';

/// This is some documentation

final class FamilyClassFamily extends $Family
    with
        $ClassFamilyOverride<
          FamilyClass,
          String,
          String,
          String,
          (
            int, {
            String? second,
            double third,
            bool fourth,
            List<String>? fifth,
          })
        > {
  const FamilyClassFamily._()
    : super(
        retry: null,
        name: r'familyClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// This is some documentation

  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) => FamilyClassProvider._(
    argument: (
      first,
      second: second,
      third: third,
      fourth: fourth,
      fifth: fifth,
    ),
    from: this,
  );

  @override
  String toString() => r'familyClassProvider';
}

/// This is some documentation

abstract class _$FamilyClass extends $Notifier<String> {
  late final _$args =
      ref.$arg
          as (
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

  String build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        second: _$args.second,
        third: _$args.third,
        fourth: _$args.fourth,
        fifth: _$args.fifth,
      ),
    );
  }
}

@ProviderFor(LocalStaticDefault)
const localStaticDefaultProvider = LocalStaticDefaultFamily._();

final class LocalStaticDefaultProvider
    extends $NotifierProvider<LocalStaticDefault, String> {
  const LocalStaticDefaultProvider._({
    required LocalStaticDefaultFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'localStaticDefaultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$localStaticDefaultHash();

  @override
  String toString() {
    return r'localStaticDefaultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LocalStaticDefault create() => LocalStaticDefault();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LocalStaticDefaultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$localStaticDefaultHash() =>
    r'e538b32aeefabdbeb30da7d8a12c74ab88c9c84b';

final class LocalStaticDefaultFamily extends $Family
    with
        $ClassFamilyOverride<
          LocalStaticDefault,
          String,
          String,
          String,
          String
        > {
  const LocalStaticDefaultFamily._()
    : super(
        retry: null,
        name: r'localStaticDefaultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LocalStaticDefaultProvider call({String arg = LocalStaticDefault.value}) =>
      LocalStaticDefaultProvider._(argument: arg, from: this);

  @override
  String toString() => r'localStaticDefaultProvider';
}

abstract class _$LocalStaticDefault extends $Notifier<String> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  String build({String arg = LocalStaticDefault.value});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(arg: _$args));
  }
}

@ProviderFor(supports$InFnName)
const supports$InFnNameProvider = Supports$InFnNameFamily._();

final class Supports$InFnNameProvider<And$InT>
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Supports$InFnNameProvider._({
    required Supports$InFnNameFamily super.from,
  }) : super(
         argument: null,
         retry: null,
         name: r'supports$InFnNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameHash();

  @override
  String toString() {
    return r'supports$InFnNameProvider'
        '<${And$InT}>'
        '()';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return supports$InFnName<And$InT>(ref);
  }

  $R _captureGenerics<$R>($R Function<And$InT>() cb) {
    return cb<And$InT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Supports$InFnNameProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$supports$InFnNameHash() => r'09636911da6a98293c260aad55b89bea5296136b';

final class Supports$InFnNameFamily extends $Family {
  const Supports$InFnNameFamily._()
    : super(
        retry: null,
        name: r'supports$InFnNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Supports$InFnNameProvider<And$InT> call<And$InT>() =>
      Supports$InFnNameProvider<And$InT>._(from: this);

  @override
  String toString() => r'supports$InFnNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(String Function<And$InT>(Ref ref) create) =>
      $FamilyOverride(
        from: this,
        createElement: (pointer) {
          final provider = pointer.origin as Supports$InFnNameProvider;
          return provider._captureGenerics(<And$InT>() {
            provider as Supports$InFnNameProvider<And$InT>;
            return provider
                .$view(create: create<And$InT>)
                .$createElement(pointer);
          });
        },
      );
}

@ProviderFor(supports$InFnNameFamily)
const supports$InFnNameFamilyProvider = Supports$InFnNameFamilyFamily._();

final class Supports$InFnNameFamilyProvider<And$InT>
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Supports$InFnNameFamilyProvider._({
    required Supports$InFnNameFamilyFamily super.from,
    required (And$InT, {And$InT named$arg, String defaultArg}) super.argument,
  }) : super(
         retry: null,
         name: r'supports$InFnNameFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameFamilyHash();

  @override
  String toString() {
    return r'supports$InFnNameFamilyProvider'
        '<${And$InT}>'
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument =
        this.argument as (And$InT, {And$InT named$arg, String defaultArg});
    return supports$InFnNameFamily<And$InT>(
      ref,
      argument.$1,
      named$arg: argument.named$arg,
      defaultArg: argument.defaultArg,
    );
  }

  $R _captureGenerics<$R>($R Function<And$InT>() cb) {
    return cb<And$InT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Supports$InFnNameFamilyProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$supports$InFnNameFamilyHash() =>
    r'3124634e8535d4db655d6384b0827f0f195a75ef';

final class Supports$InFnNameFamilyFamily extends $Family {
  const Supports$InFnNameFamilyFamily._()
    : super(
        retry: null,
        name: r'supports$InFnNameFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Supports$InFnNameFamilyProvider<And$InT> call<And$InT>(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  }) => Supports$InFnNameFamilyProvider<And$InT>._(
    argument: (positional$arg, named$arg: named$arg, defaultArg: defaultArg),
    from: this,
  );

  @override
  String toString() => r'supports$InFnNameFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function<And$InT>(
      Ref ref,
      (And$InT, {And$InT named$arg, String defaultArg}) args,
    )
    create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as Supports$InFnNameFamilyProvider;
      return provider._captureGenerics(<And$InT>() {
        provider as Supports$InFnNameFamilyProvider<And$InT>;
        final argument =
            provider.argument
                as (And$InT, {And$InT named$arg, String defaultArg});
        return provider
            .$view(create: (ref) => create(ref, argument))
            .$createElement(pointer);
      });
    },
  );
}

@ProviderFor(Supports$InClassName)
const supports$InClassNameProvider = Supports$InClassNameFamily._();

final class Supports$InClassNameProvider<And$InT>
    extends $NotifierProvider<Supports$InClassName<And$InT>, String> {
  const Supports$InClassNameProvider._({
    required Supports$InClassNameFamily super.from,
  }) : super(
         argument: null,
         retry: null,
         name: r'supports$InClassNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supports$InClassNameHash();

  @override
  String toString() {
    return r'supports$InClassNameProvider'
        '<${And$InT}>'
        '()';
  }

  @$internal
  @override
  Supports$InClassName<And$InT> create() => Supports$InClassName<And$InT>();

  $R _captureGenerics<$R>($R Function<And$InT>() cb) {
    return cb<And$InT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Supports$InClassNameProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$supports$InClassNameHash() =>
    r'848e57774639582ed170dce5765340e1c1cb89b3';

final class Supports$InClassNameFamily extends $Family {
  const Supports$InClassNameFamily._()
    : super(
        retry: null,
        name: r'supports$InClassNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Supports$InClassNameProvider<And$InT> call<And$InT>() =>
      Supports$InClassNameProvider<And$InT>._(from: this);

  @override
  String toString() => r'supports$InClassNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Supports$InClassName<And$InT> Function<And$InT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as Supports$InClassNameProvider;
      return provider._captureGenerics(<And$InT>() {
        provider as Supports$InClassNameProvider<And$InT>;
        return provider.$view(create: create<And$InT>).$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function<And$InT>(Ref ref, Supports$InClassName<And$InT> notifier)
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as Supports$InClassNameProvider;
      return provider._captureGenerics(<And$InT>() {
        provider as Supports$InClassNameProvider<And$InT>;
        return provider
            .$view(runNotifierBuildOverride: build<And$InT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$Supports$InClassName<And$InT> extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Supports$InClassFamilyName)
const supports$InClassFamilyNameProvider = Supports$InClassFamilyNameFamily._();

final class Supports$InClassFamilyNameProvider<And$InT>
    extends $NotifierProvider<Supports$InClassFamilyName<And$InT>, String> {
  const Supports$InClassFamilyNameProvider._({
    required Supports$InClassFamilyNameFamily super.from,
    required (And$InT, {And$InT named$arg, String defaultArg}) super.argument,
  }) : super(
         retry: null,
         name: r'supports$InClassFamilyNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supports$InClassFamilyNameHash();

  @override
  String toString() {
    return r'supports$InClassFamilyNameProvider'
        '<${And$InT}>'
        '$argument';
  }

  @$internal
  @override
  Supports$InClassFamilyName<And$InT> create() =>
      Supports$InClassFamilyName<And$InT>();

  $R _captureGenerics<$R>($R Function<And$InT>() cb) {
    return cb<And$InT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Supports$InClassFamilyNameProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$supports$InClassFamilyNameHash() =>
    r'39e844561e4f4727011bb2f97169d0334c928b20';

final class Supports$InClassFamilyNameFamily extends $Family {
  const Supports$InClassFamilyNameFamily._()
    : super(
        retry: null,
        name: r'supports$InClassFamilyNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Supports$InClassFamilyNameProvider<And$InT> call<And$InT>(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  }) => Supports$InClassFamilyNameProvider<And$InT>._(
    argument: (positional$arg, named$arg: named$arg, defaultArg: defaultArg),
    from: this,
  );

  @override
  String toString() => r'supports$InClassFamilyNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Supports$InClassFamilyName<And$InT> Function<And$InT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as Supports$InClassFamilyNameProvider;
      return provider._captureGenerics(<And$InT>() {
        provider as Supports$InClassFamilyNameProvider<And$InT>;
        return provider.$view(create: create<And$InT>).$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function<And$InT>(
      Ref ref,
      Supports$InClassFamilyName<And$InT> notifier,
    )
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as Supports$InClassFamilyNameProvider;
      return provider._captureGenerics(<And$InT>() {
        provider as Supports$InClassFamilyNameProvider<And$InT>;
        return provider
            .$view(runNotifierBuildOverride: build<And$InT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$Supports$InClassFamilyName<And$InT> extends $Notifier<String> {
  late final _$args =
      ref.$arg as (And$InT, {And$InT named$arg, String defaultArg});
  And$InT get positional$arg => _$args.$1;
  And$InT get named$arg => _$args.named$arg;
  String get defaultArg => _$args.defaultArg;

  String build(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        named$arg: _$args.named$arg,
        defaultArg: _$args.defaultArg,
      ),
    );
  }
}

@ProviderFor(generated)
const generatedProvider = GeneratedProvider._();

final class GeneratedProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const GeneratedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generatedHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return generated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$generatedHash() => r'24bfb5df4dc529258ab568372e90a1cbfc2d8c24';

@ProviderFor(unnecessaryCast)
const unnecessaryCastProvider = UnnecessaryCastFamily._();

final class UnnecessaryCastProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const UnnecessaryCastProvider._({
    required UnnecessaryCastFamily super.from,
    required Object? super.argument,
  }) : super(
         retry: null,
         name: r'unnecessaryCastProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastHash();

  @override
  String toString() {
    return r'unnecessaryCastProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Object?;
    return unnecessaryCast(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnnecessaryCastProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unnecessaryCastHash() => r'c64330124f4b03a3e6757e787f62966a32bf83ad';

final class UnnecessaryCastFamily extends $Family
    with $FunctionalFamilyOverride<String, Object?> {
  const UnnecessaryCastFamily._()
    : super(
        retry: null,
        name: r'unnecessaryCastProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnnecessaryCastProvider call(Object? arg) =>
      UnnecessaryCastProvider._(argument: arg, from: this);

  @override
  String toString() => r'unnecessaryCastProvider';
}

@ProviderFor(UnnecessaryCastClass)
const unnecessaryCastClassProvider = UnnecessaryCastClassFamily._();

final class UnnecessaryCastClassProvider
    extends $NotifierProvider<UnnecessaryCastClass, String> {
  const UnnecessaryCastClassProvider._({
    required UnnecessaryCastClassFamily super.from,
    required Object? super.argument,
  }) : super(
         retry: null,
         name: r'unnecessaryCastClassProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastClassHash();

  @override
  String toString() {
    return r'unnecessaryCastClassProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnnecessaryCastClass create() => UnnecessaryCastClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnnecessaryCastClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unnecessaryCastClassHash() =>
    r'8cbf80b29c4edf7f5401e4447feca553e921e734';

final class UnnecessaryCastClassFamily extends $Family
    with
        $ClassFamilyOverride<
          UnnecessaryCastClass,
          String,
          String,
          String,
          Object?
        > {
  const UnnecessaryCastClassFamily._()
    : super(
        retry: null,
        name: r'unnecessaryCastClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnnecessaryCastClassProvider call(Object? arg) =>
      UnnecessaryCastClassProvider._(argument: arg, from: this);

  @override
  String toString() => r'unnecessaryCastClassProvider';
}

abstract class _$UnnecessaryCastClass extends $Notifier<String> {
  late final _$args = ref.$arg as Object?;
  Object? get arg => _$args;

  String build(Object? arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily._();

final class ManyDataStreamProvider<ItemT extends Object, OtherT extends Object>
    extends
        $FunctionalProvider<
          AsyncValue<List<ItemT>>,
          List<ItemT>,
          Stream<List<ItemT>>
        >
    with $FutureModifier<List<ItemT>>, $StreamProvider<List<ItemT>> {
  const ManyDataStreamProvider._({
    required ManyDataStreamFamily super.from,
    required ManyProviderData<ItemT, OtherT> super.argument,
  }) : super(
         retry: null,
         name: r'manyDataStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  @override
  String toString() {
    return r'manyDataStreamProvider'
        '<${ItemT}, ${OtherT}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ItemT>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ItemT>> create(Ref ref) {
    final argument = this.argument as ManyProviderData<ItemT, OtherT>;
    return manyDataStream<ItemT, OtherT>(ref, argument);
  }

  $R _captureGenerics<$R>(
    $R Function<ItemT extends Object, OtherT extends Object>() cb,
  ) {
    return cb<ItemT, OtherT>();
  }

  @override
  bool operator ==(Object other) {
    return other is ManyDataStreamProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$manyDataStreamHash() => r'57682645596b340352f90a6b2c29d490ce30806b';

final class ManyDataStreamFamily extends $Family {
  const ManyDataStreamFamily._()
    : super(
        retry: null,
        name: r'manyDataStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ManyDataStreamProvider<ItemT, OtherT>
  call<ItemT extends Object, OtherT extends Object>(
    ManyProviderData<ItemT, OtherT> pData,
  ) => ManyDataStreamProvider<ItemT, OtherT>._(argument: pData, from: this);

  @override
  String toString() => r'manyDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<List<ItemT>> Function<ItemT extends Object, OtherT extends Object>(
      Ref ref,
      ManyProviderData<ItemT, OtherT> args,
    )
    create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as ManyDataStreamProvider;
      return provider._captureGenerics(
        <ItemT extends Object, OtherT extends Object>() {
          provider as ManyDataStreamProvider<ItemT, OtherT>;
          final argument = provider.argument as ManyProviderData<ItemT, OtherT>;
          return provider
              .$view(create: (ref) => create(ref, argument))
              .$createElement(pointer);
        },
      );
    },
  );
}

@ProviderFor(issue4113)
const issue4113Provider = Issue4113Provider._();

final class Issue4113Provider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const Issue4113Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issue4113Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$issue4113Hash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return issue4113(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$issue4113Hash() => r'3800dad2a71076827951824e347e324306cf29da';

@ProviderFor(_issue4113)
const _issue4113Provider = _Issue4113Provider._();

final class _Issue4113Provider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const _Issue4113Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_issue4113Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_issue4113Hash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return _issue4113(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$_issue4113Hash() => r'9dedddc3d06343015a3a768628a23adb9294fcf1';

@ProviderFor(fn)
const manualRename = FnProvider._();

final class FnProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const FnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manualRename',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fnHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return fn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$fnHash() => r'af32cc34953e77edd986478ab61d3dbe947b2c3e';

@ProviderFor(fn2)
const manualRename2 = Fn2Family._();

final class Fn2Provider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const Fn2Provider._({
    required Fn2Family super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'manualRename2',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fn2Hash();

  @override
  String toString() {
    return r'manualRename2'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as int;
    return fn2(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Fn2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fn2Hash() => r'529fc50b1f92a884650b5d023b2f58f49598a695';

final class Fn2Family extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const Fn2Family._()
    : super(
        retry: null,
        name: r'manualRename2',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Fn2Provider call(int a) => Fn2Provider._(argument: a, from: this);

  @override
  String toString() => r'manualRename2';
}

@ProviderFor(voidFunctional)
const voidFunctionalProvider = VoidFunctionalProvider._();

final class VoidFunctionalProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const VoidFunctionalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voidFunctionalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voidFunctionalHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return voidFunctional(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$voidFunctionalHash() => r'520f9212a7364acb565dc676e189bdbfa898b05a';

@ProviderFor(voidFunctionalWithArgs)
const voidFunctionalWithArgsProvider = VoidFunctionalWithArgsFamily._();

final class VoidFunctionalWithArgsProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const VoidFunctionalWithArgsProvider._({
    required VoidFunctionalWithArgsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'voidFunctionalWithArgsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$voidFunctionalWithArgsHash();

  @override
  String toString() {
    return r'voidFunctionalWithArgsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as int;
    return voidFunctionalWithArgs(ref, argument);
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
    return other is VoidFunctionalWithArgsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$voidFunctionalWithArgsHash() =>
    r'ad4ca78db96afc32953c39203ff29e490ec0f2ad';

final class VoidFunctionalWithArgsFamily extends $Family
    with $FunctionalFamilyOverride<void, int> {
  const VoidFunctionalWithArgsFamily._()
    : super(
        retry: null,
        name: r'voidFunctionalWithArgsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VoidFunctionalWithArgsProvider call(int a) =>
      VoidFunctionalWithArgsProvider._(argument: a, from: this);

  @override
  String toString() => r'voidFunctionalWithArgsProvider';
}

@ProviderFor(VoidClass)
const voidClassProvider = VoidClassProvider._();

final class VoidClassProvider extends $NotifierProvider<VoidClass, void> {
  const VoidClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voidClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voidClassHash();

  @$internal
  @override
  VoidClass create() => VoidClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$voidClassHash() => r'18c6860ccefbab8551e6a718563cfc618528c97c';

abstract class _$VoidClass extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(VoidClassWithArgs)
const voidClassWithArgsProvider = VoidClassWithArgsFamily._();

final class VoidClassWithArgsProvider
    extends $NotifierProvider<VoidClassWithArgs, void> {
  const VoidClassWithArgsProvider._({
    required VoidClassWithArgsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'voidClassWithArgsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$voidClassWithArgsHash();

  @override
  String toString() {
    return r'voidClassWithArgsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VoidClassWithArgs create() => VoidClassWithArgs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VoidClassWithArgsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$voidClassWithArgsHash() => r'f5356413fda00368fb84893fc0cd6acc50476118';

final class VoidClassWithArgsFamily extends $Family
    with $ClassFamilyOverride<VoidClassWithArgs, void, void, void, int> {
  const VoidClassWithArgsFamily._()
    : super(
        retry: null,
        name: r'voidClassWithArgsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VoidClassWithArgsProvider call(int a) =>
      VoidClassWithArgsProvider._(argument: a, from: this);

  @override
  String toString() => r'voidClassWithArgsProvider';
}

abstract class _$VoidClassWithArgs extends $Notifier<void> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  void build(int a);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
