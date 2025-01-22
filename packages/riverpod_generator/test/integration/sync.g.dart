// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(generic)
const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $FunctionalProvider<List<T>, List<T>> with $Provider<List<T>> {
  const GenericProvider._(
      {required GenericFamily super.from,
      List<T> Function(
        Ref ref,
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

  final List<T> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<T> _copyWithCreate(
    List<T> Function<T extends num>(
      Ref ref,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<T> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<T>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<T>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GenericProvider<T> $copyWithCreate(
    List<T> Function(
      Ref ref,
    ) create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @override
  List<T> create(Ref ref) {
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

String _$genericHash() => r'4a2a38e246fc4ef25c46d93477010b66de01ff30';

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
    List<T> Function<T extends num>(Ref ref) create,
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

@ProviderFor(complexGeneric)
const complexGenericProvider = ComplexGenericFamily._();

final class ComplexGenericProvider<T extends num, Foo extends String?>
    extends $FunctionalProvider<List<T>, List<T>> with $Provider<List<T>> {
  const ComplexGenericProvider._(
      {required ComplexGenericFamily super.from,
      required ({
        T param,
        Foo? otherParam,
      })
          super.argument,
      List<T> Function(
        Ref ref, {
        required T param,
        Foo? otherParam,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'complexGenericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<T> Function(
    Ref ref, {
    required T param,
    Foo? otherParam,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$complexGenericHash();

  ComplexGenericProvider<T, Foo> _copyWithCreate(
    List<T> Function<T extends num, Foo extends String?>(
      Ref ref, {
      required T param,
      Foo? otherParam,
    }) create,
  ) {
    return ComplexGenericProvider<T, Foo>._(
        argument: argument as ({
          T param,
          Foo? otherParam,
        }),
        from: from! as ComplexGenericFamily,
        create: create<T, Foo>);
  }

  @override
  String toString() {
    return r'complexGenericProvider'
        '<${T}, ${Foo}>'
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<T> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<T>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<T>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ComplexGenericProvider<T, Foo> $copyWithCreate(
    List<T> Function(
      Ref ref,
    ) create,
  ) {
    return ComplexGenericProvider<T, Foo>._(
        argument: argument as ({
          T param,
          Foo? otherParam,
        }),
        from: from! as ComplexGenericFamily,
        create: (
          ref, {
          required T param,
          Foo? otherParam,
        }) =>
            create(ref));
  }

  @override
  List<T> create(Ref ref) {
    final _$cb = _createCb ?? complexGeneric<T, Foo>;
    final argument = this.argument as ({
      T param,
      Foo? otherParam,
    });
    return _$cb(
      ref,
      param: argument.param,
      otherParam: argument.otherParam,
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

String _$complexGenericHash() => r'bc3433c913396a238e833722a2dc3a78bdf844a4';

final class ComplexGenericFamily extends Family {
  const ComplexGenericFamily._()
      : super(
          retry: null,
          name: r'complexGenericProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ComplexGenericProvider<T, Foo> call<T extends num, Foo extends String?>({
    required T param,
    Foo? otherParam,
  }) =>
      ComplexGenericProvider<T, Foo>._(argument: (
        param: param,
        otherParam: otherParam,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$complexGenericHash();

  @override
  String toString() => r'complexGenericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    List<T> Function<T extends num, Foo extends String?>(
      Ref ref,
      ({
        T param,
        Foo? otherParam,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ComplexGenericProvider;

        return provider._copyWithCreate(<T extends num, Foo extends String?>(
          ref, {
          required T param,
          Foo? otherParam,
        }) {
          return create(ref, (
            param: param,
            otherParam: otherParam,
          ));
        }).$createElement(pointer);
      },
    );
  }
}

@ProviderFor(GenericClass)
const genericClassProvider = GenericClassFamily._();

final class GenericClassProvider<T extends num>
    extends $NotifierProvider<GenericClass<T>, List<T>> {
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
    List<T> Function<T extends num>(
      Ref,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<T> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<T>>(value),
    );
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
    List<T> Function(
      Ref,
      GenericClass<T>,
    ) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GenericClass<T>, List<T>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

String _$genericClassHash() => r'fc46bb737f8812a28db6435d3605e8ac491f23d0';

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
    List<T> Function<T extends num>(Ref ref, GenericClass<T> notifier) build,
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

abstract class _$GenericClass<T extends num> extends $Notifier<List<T>> {
  List<T> build();
  @$internal
  @override
  List<T> runBuild() => build();
}

@ProviderFor(rawFuture)
const rawFutureProvider = RawFutureProvider._();

final class RawFutureProvider
    extends $FunctionalProvider<Raw<Future<String>>, Raw<Future<String>>>
    with $Provider<Raw<Future<String>>> {
  const RawFutureProvider._(
      {Raw<Future<String>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rawFutureProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Future<String>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFutureHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Future<String>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RawFutureProvider $copyWithCreate(
    Raw<Future<String>> Function(
      Ref ref,
    ) create,
  ) {
    return RawFutureProvider._(create: create);
  }

  @override
  Raw<Future<String>> create(Ref ref) {
    final _$cb = _createCb ?? rawFuture;
    return _$cb(ref);
  }
}

String _$rawFutureHash() => r'9d397f4c0a578a2741610f9ca6f17438ee8e5a34';

@ProviderFor(rawStream)
const rawStreamProvider = RawStreamProvider._();

final class RawStreamProvider
    extends $FunctionalProvider<Raw<Stream<String>>, Raw<Stream<String>>>
    with $Provider<Raw<Stream<String>>> {
  const RawStreamProvider._(
      {Raw<Stream<String>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rawStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<String>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Stream<String>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RawStreamProvider $copyWithCreate(
    Raw<Stream<String>> Function(
      Ref ref,
    ) create,
  ) {
    return RawStreamProvider._(create: create);
  }

  @override
  Raw<Stream<String>> create(Ref ref) {
    final _$cb = _createCb ?? rawStream;
    return _$cb(ref);
  }
}

String _$rawStreamHash() => r'c7d6cd22f1f325827c866c3ec757d08315fd9858';

@ProviderFor(RawFutureClass)
const rawFutureClassProvider = RawFutureClassProvider._();

final class RawFutureClassProvider
    extends $NotifierProvider<RawFutureClass, Raw<Future<String>>> {
  const RawFutureClassProvider._(
      {super.runNotifierBuildOverride, RawFutureClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rawFutureClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawFutureClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFutureClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  RawFutureClass create() => _createCb?.call() ?? RawFutureClass();

  @$internal
  @override
  RawFutureClassProvider $copyWithCreate(
    RawFutureClass Function() create,
  ) {
    return RawFutureClassProvider._(create: create);
  }

  @$internal
  @override
  RawFutureClassProvider $copyWithBuild(
    Raw<Future<String>> Function(
      Ref,
      RawFutureClass,
    ) build,
  ) {
    return RawFutureClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawFutureClass, Raw<Future<String>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

abstract class _$RawFutureClass extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  Raw<Future<String>> runBuild() => build();
}

@ProviderFor(RawStreamClass)
const rawStreamClassProvider = RawStreamClassProvider._();

final class RawStreamClassProvider
    extends $NotifierProvider<RawStreamClass, Raw<Stream<String>>> {
  const RawStreamClassProvider._(
      {super.runNotifierBuildOverride, RawStreamClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rawStreamClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawStreamClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @$internal
  @override
  RawStreamClass create() => _createCb?.call() ?? RawStreamClass();

  @$internal
  @override
  RawStreamClassProvider $copyWithCreate(
    RawStreamClass Function() create,
  ) {
    return RawStreamClassProvider._(create: create);
  }

  @$internal
  @override
  RawStreamClassProvider $copyWithBuild(
    Raw<Stream<String>> Function(
      Ref,
      RawStreamClass,
    ) build,
  ) {
    return RawStreamClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawStreamClass, Raw<Stream<String>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

abstract class _$RawStreamClass extends $Notifier<Raw<Stream<String>>> {
  Raw<Stream<String>> build();
  @$internal
  @override
  Raw<Stream<String>> runBuild() => build();
}

@ProviderFor(rawFamilyFuture)
const rawFamilyFutureProvider = RawFamilyFutureFamily._();

final class RawFamilyFutureProvider
    extends $FunctionalProvider<Raw<Future<String>>, Raw<Future<String>>>
    with $Provider<Raw<Future<String>>> {
  const RawFamilyFutureProvider._(
      {required RawFamilyFutureFamily super.from,
      required int super.argument,
      Raw<Future<String>> Function(
        Ref ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'rawFamilyFutureProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Future<String>> Function(
    Ref ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureHash();

  @override
  String toString() {
    return r'rawFamilyFutureProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Future<String>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RawFamilyFutureProvider $copyWithCreate(
    Raw<Future<String>> Function(
      Ref ref,
    ) create,
  ) {
    return RawFamilyFutureProvider._(
        argument: argument as int,
        from: from! as RawFamilyFutureFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  Raw<Future<String>> create(Ref ref) {
    final _$cb = _createCb ?? rawFamilyFuture;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

final class RawFamilyFutureFamily extends Family {
  const RawFamilyFutureFamily._()
      : super(
          retry: null,
          name: r'rawFamilyFutureProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RawFamilyFutureProvider call(
    int id,
  ) =>
      RawFamilyFutureProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureHash();

  @override
  String toString() => r'rawFamilyFutureProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Raw<Future<String>> Function(
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyFutureProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(rawFamilyStream)
const rawFamilyStreamProvider = RawFamilyStreamFamily._();

final class RawFamilyStreamProvider
    extends $FunctionalProvider<Raw<Stream<String>>, Raw<Stream<String>>>
    with $Provider<Raw<Stream<String>>> {
  const RawFamilyStreamProvider._(
      {required RawFamilyStreamFamily super.from,
      required int super.argument,
      Raw<Stream<String>> Function(
        Ref ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'rawFamilyStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<String>> Function(
    Ref ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamHash();

  @override
  String toString() {
    return r'rawFamilyStreamProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Stream<String>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RawFamilyStreamProvider $copyWithCreate(
    Raw<Stream<String>> Function(
      Ref ref,
    ) create,
  ) {
    return RawFamilyStreamProvider._(
        argument: argument as int,
        from: from! as RawFamilyStreamFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  Raw<Stream<String>> create(Ref ref) {
    final _$cb = _createCb ?? rawFamilyStream;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

final class RawFamilyStreamFamily extends Family {
  const RawFamilyStreamFamily._()
      : super(
          retry: null,
          name: r'rawFamilyStreamProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RawFamilyStreamProvider call(
    int id,
  ) =>
      RawFamilyStreamProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamHash();

  @override
  String toString() => r'rawFamilyStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Raw<Stream<String>> Function(
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyStreamProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(RawFamilyFutureClass)
const rawFamilyFutureClassProvider = RawFamilyFutureClassFamily._();

final class RawFamilyFutureClassProvider
    extends $NotifierProvider<RawFamilyFutureClass, Raw<Future<String>>> {
  const RawFamilyFutureClassProvider._(
      {required RawFamilyFutureClassFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      RawFamilyFutureClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'rawFamilyFutureClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawFamilyFutureClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureClassHash();

  @override
  String toString() {
    return r'rawFamilyFutureClassProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  RawFamilyFutureClass create() => _createCb?.call() ?? RawFamilyFutureClass();

  @$internal
  @override
  RawFamilyFutureClassProvider $copyWithCreate(
    RawFamilyFutureClass Function() create,
  ) {
    return RawFamilyFutureClassProvider._(
        argument: argument as int,
        from: from! as RawFamilyFutureClassFamily,
        create: create);
  }

  @$internal
  @override
  RawFamilyFutureClassProvider $copyWithBuild(
    Raw<Future<String>> Function(
      Ref,
      RawFamilyFutureClass,
    ) build,
  ) {
    return RawFamilyFutureClassProvider._(
        argument: argument as int,
        from: from! as RawFamilyFutureClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawFamilyFutureClass, Raw<Future<String>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);

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

final class RawFamilyFutureClassFamily extends Family {
  const RawFamilyFutureClassFamily._()
      : super(
          retry: null,
          name: r'rawFamilyFutureClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RawFamilyFutureClassProvider call(
    int id,
  ) =>
      RawFamilyFutureClassProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$rawFamilyFutureClassHash();

  @override
  String toString() => r'rawFamilyFutureClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    RawFamilyFutureClass Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyFutureClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Raw<Future<String>> Function(
            Ref ref, RawFamilyFutureClass notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyFutureClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$RawFamilyFutureClass extends $Notifier<Raw<Future<String>>> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Raw<Future<String>> build(
    int id,
  );
  @$internal
  @override
  Raw<Future<String>> runBuild() => build(
        _$args,
      );
}

@ProviderFor(RawFamilyStreamClass)
const rawFamilyStreamClassProvider = RawFamilyStreamClassFamily._();

final class RawFamilyStreamClassProvider
    extends $NotifierProvider<RawFamilyStreamClass, Raw<Stream<String>>> {
  const RawFamilyStreamClassProvider._(
      {required RawFamilyStreamClassFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      RawFamilyStreamClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'rawFamilyStreamClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawFamilyStreamClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamClassHash();

  @override
  String toString() {
    return r'rawFamilyStreamClassProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<String>>>(value),
    );
  }

  @$internal
  @override
  RawFamilyStreamClass create() => _createCb?.call() ?? RawFamilyStreamClass();

  @$internal
  @override
  RawFamilyStreamClassProvider $copyWithCreate(
    RawFamilyStreamClass Function() create,
  ) {
    return RawFamilyStreamClassProvider._(
        argument: argument as int,
        from: from! as RawFamilyStreamClassFamily,
        create: create);
  }

  @$internal
  @override
  RawFamilyStreamClassProvider $copyWithBuild(
    Raw<Stream<String>> Function(
      Ref,
      RawFamilyStreamClass,
    ) build,
  ) {
    return RawFamilyStreamClassProvider._(
        argument: argument as int,
        from: from! as RawFamilyStreamClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawFamilyStreamClass, Raw<Stream<String>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);

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

final class RawFamilyStreamClassFamily extends Family {
  const RawFamilyStreamClassFamily._()
      : super(
          retry: null,
          name: r'rawFamilyStreamClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RawFamilyStreamClassProvider call(
    int id,
  ) =>
      RawFamilyStreamClassProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$rawFamilyStreamClassHash();

  @override
  String toString() => r'rawFamilyStreamClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    RawFamilyStreamClass Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyStreamClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Raw<Stream<String>> Function(
            Ref ref, RawFamilyStreamClass notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RawFamilyStreamClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$RawFamilyStreamClass extends $Notifier<Raw<Stream<String>>> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Raw<Stream<String>> build(
    int id,
  );
  @$internal
  @override
  Raw<Stream<String>> runBuild() => build(
        _$args,
      );
}

/// This is some documentation
@ProviderFor(public)
const publicProvider = PublicProvider._();

/// This is some documentation
final class PublicProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  /// This is some documentation
  const PublicProvider._(
      {String Function(
        Ref ref,
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

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  PublicProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? public;
    return _$cb(ref);
  }
}

String _$publicHash() => r'94bee36125844f9fe521363bb228632b9f3bfbc7';

@ProviderFor(supports$inNames)
const supports$inNamesProvider = Supports$inNamesProvider._();

final class Supports$inNamesProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const Supports$inNamesProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'supports$inNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$inNamesHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Supports$inNamesProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return Supports$inNamesProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? supports$inNames;
    return _$cb(ref);
  }
}

String _$supports$inNamesHash() => r'8da1f9329f302ce75e38d03c96595de3260b4d2d';

/// This is some documentation
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// This is some documentation
final class FamilyProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  /// This is some documentation
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
      String Function(
        Ref ref,
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

  final String Function(
    Ref ref,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FamilyProvider $copyWithCreate(
    String Function(
      Ref ref,
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
  String create(Ref ref) {
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

String _$familyHash() => r'f58149448f80f10ec054f2f8a6f37bae61e38f49';

/// This is some documentation
final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// This is some documentation
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
    String Function(
      Ref ref,
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

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const _PrivateProvider._(
      {String Function(
        Ref ref,
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

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  _PrivateProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? _private;
    return _$cb(ref);
  }
}

String _$privateHash() => r'834affaed42662bf46ce7f6203ac2495e1e8974b';

/// This is some documentation
@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

/// This is some documentation
final class PublicClassProvider extends $NotifierProvider<PublicClass, String> {
  /// This is some documentation
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

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
    String Function(
      Ref,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PublicClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$publicClassHash() => r'92fd83ba5c01942344a9fa94e170629da3588946';

abstract class _$PublicClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
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
          retry: null,
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
      Ref,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<_PrivateClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$privateClassHash() => r'be63bcdd570d32ecebb62262f4f04215ea0b3ab2';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

/// This is some documentation
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily._();

/// This is some documentation
final class FamilyClassProvider extends $NotifierProvider<FamilyClass, String> {
  /// This is some documentation
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
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
    String Function(
      Ref,
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
  $NotifierProviderElement<FamilyClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'f49696c6caf3cd8e3661369c43c4d61c4024fe93';

/// This is some documentation
final class FamilyClassFamily extends Family {
  const FamilyClassFamily._()
      : super(
          retry: null,
          name: r'familyClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// This is some documentation
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
    String Function(
            Ref ref,
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

abstract class _$FamilyClass extends $Notifier<String> {
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

  String build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  });
  @$internal
  @override
  String runBuild() => build(
        _$args.$1,
        second: _$args.second,
        third: _$args.third,
        fourth: _$args.fourth,
        fifth: _$args.fifth,
      );
}

@ProviderFor(supports$InFnName)
const supports$InFnNameProvider = Supports$InFnNameFamily._();

final class Supports$InFnNameProvider<And$InT>
    extends $FunctionalProvider<String, String> with $Provider<String> {
  const Supports$InFnNameProvider._(
      {required Supports$InFnNameFamily super.from,
      String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'supports$InFnNameProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameHash();

  Supports$InFnNameProvider<And$InT> _copyWithCreate(
    String Function<And$InT>(
      Ref ref,
    ) create,
  ) {
    return Supports$InFnNameProvider<And$InT>._(
        from: from! as Supports$InFnNameFamily, create: create<And$InT>);
  }

  @override
  String toString() {
    return r'supports$InFnNameProvider'
        '<${And$InT}>'
        '()';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Supports$InFnNameProvider<And$InT> $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return Supports$InFnNameProvider<And$InT>._(
        from: from! as Supports$InFnNameFamily, create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? supports$InFnName<And$InT>;
    return _$cb(ref);
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

final class Supports$InFnNameFamily extends Family {
  const Supports$InFnNameFamily._()
      : super(
          retry: null,
          name: r'supports$InFnNameProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Supports$InFnNameProvider<And$InT> call<And$InT>() =>
      Supports$InFnNameProvider<And$InT>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameHash();

  @override
  String toString() => r'supports$InFnNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function<And$InT>(Ref ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InFnNameProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}

@ProviderFor(supports$InFnNameFamily)
const supports$InFnNameFamilyProvider = Supports$InFnNameFamilyFamily._();

final class Supports$InFnNameFamilyProvider<And$InT>
    extends $FunctionalProvider<String, String> with $Provider<String> {
  const Supports$InFnNameFamilyProvider._(
      {required Supports$InFnNameFamilyFamily super.from,
      required (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      })
          super.argument,
      String Function(
        Ref ref,
        And$InT positional$arg, {
        required And$InT named$arg,
        String defaultArg,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'supports$InFnNameFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameFamilyHash();

  Supports$InFnNameFamilyProvider<And$InT> _copyWithCreate(
    String Function<And$InT>(
      Ref ref,
      And$InT positional$arg, {
      required And$InT named$arg,
      String defaultArg,
    }) create,
  ) {
    return Supports$InFnNameFamilyProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InFnNameFamilyFamily,
        create: create<And$InT>);
  }

  @override
  String toString() {
    return r'supports$InFnNameFamilyProvider'
        '<${And$InT}>'
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Supports$InFnNameFamilyProvider<And$InT> $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return Supports$InFnNameFamilyProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InFnNameFamilyFamily,
        create: (
          ref,
          And$InT positional$arg, {
          required And$InT named$arg,
          String defaultArg = default$value,
        }) =>
            create(ref));
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? supports$InFnNameFamily<And$InT>;
    final argument = this.argument as (
      And$InT, {
      And$InT named$arg,
      String defaultArg,
    });
    return _$cb(
      ref,
      argument.$1,
      named$arg: argument.named$arg,
      defaultArg: argument.defaultArg,
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

final class Supports$InFnNameFamilyFamily extends Family {
  const Supports$InFnNameFamilyFamily._()
      : super(
          retry: null,
          name: r'supports$InFnNameFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Supports$InFnNameFamilyProvider<And$InT> call<And$InT>(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  }) =>
      Supports$InFnNameFamilyProvider<And$InT>._(argument: (
        positional$arg,
        named$arg: named$arg,
        defaultArg: defaultArg,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameFamilyHash();

  @override
  String toString() => r'supports$InFnNameFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function<And$InT>(
      Ref ref,
      (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InFnNameFamilyProvider;

        return provider._copyWithCreate(<And$InT>(
          ref,
          And$InT positional$arg, {
          required And$InT named$arg,
          String defaultArg = default$value,
        }) {
          return create(ref, (
            positional$arg,
            named$arg: named$arg,
            defaultArg: defaultArg,
          ));
        }).$createElement(pointer);
      },
    );
  }
}

@ProviderFor(Supports$InClassName)
const supports$InClassNameProvider = Supports$InClassNameFamily._();

final class Supports$InClassNameProvider<And$InT>
    extends $NotifierProvider<Supports$InClassName<And$InT>, String> {
  const Supports$InClassNameProvider._(
      {required Supports$InClassNameFamily super.from,
      super.runNotifierBuildOverride,
      Supports$InClassName<And$InT> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'supports$InClassNameProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Supports$InClassName<And$InT> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InClassNameHash();

  Supports$InClassNameProvider<And$InT> _copyWithCreate(
    Supports$InClassName<And$InT> Function<And$InT>() create,
  ) {
    return Supports$InClassNameProvider<And$InT>._(
        from: from! as Supports$InClassNameFamily, create: create<And$InT>);
  }

  Supports$InClassNameProvider<And$InT> _copyWithBuild(
    String Function<And$InT>(
      Ref,
      Supports$InClassName<And$InT>,
    ) build,
  ) {
    return Supports$InClassNameProvider<And$InT>._(
        from: from! as Supports$InClassNameFamily,
        runNotifierBuildOverride: build<And$InT>);
  }

  @override
  String toString() {
    return r'supports$InClassNameProvider'
        '<${And$InT}>'
        '()';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  Supports$InClassName<And$InT> create() =>
      _createCb?.call() ?? Supports$InClassName<And$InT>();

  @$internal
  @override
  Supports$InClassNameProvider<And$InT> $copyWithCreate(
    Supports$InClassName<And$InT> Function() create,
  ) {
    return Supports$InClassNameProvider<And$InT>._(
        from: from! as Supports$InClassNameFamily, create: create);
  }

  @$internal
  @override
  Supports$InClassNameProvider<And$InT> $copyWithBuild(
    String Function(
      Ref,
      Supports$InClassName<And$InT>,
    ) build,
  ) {
    return Supports$InClassNameProvider<And$InT>._(
        from: from! as Supports$InClassNameFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassName<And$InT>, String>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);

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
    r'79073b0c9b8588ef04125e8e54ce03b5740a7d59';

final class Supports$InClassNameFamily extends Family {
  const Supports$InClassNameFamily._()
      : super(
          retry: null,
          name: r'supports$InClassNameProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Supports$InClassNameProvider<And$InT> call<And$InT>() =>
      Supports$InClassNameProvider<And$InT>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$supports$InClassNameHash();

  @override
  String toString() => r'supports$InClassNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Supports$InClassName<And$InT> Function<And$InT>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InClassNameProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function<And$InT>(Ref ref, Supports$InClassName<And$InT> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InClassNameProvider;

        return provider._copyWithBuild(build).$createElement(pointer);
      },
    );
  }
}

abstract class _$Supports$InClassName<And$InT> extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

@ProviderFor(Supports$InClassFamilyName)
const supports$InClassFamilyNameProvider = Supports$InClassFamilyNameFamily._();

final class Supports$InClassFamilyNameProvider<And$InT>
    extends $NotifierProvider<Supports$InClassFamilyName<And$InT>, String> {
  const Supports$InClassFamilyNameProvider._(
      {required Supports$InClassFamilyNameFamily super.from,
      required (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      })
          super.argument,
      super.runNotifierBuildOverride,
      Supports$InClassFamilyName<And$InT> Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'supports$InClassFamilyNameProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Supports$InClassFamilyName<And$InT> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InClassFamilyNameHash();

  Supports$InClassFamilyNameProvider<And$InT> _copyWithCreate(
    Supports$InClassFamilyName<And$InT> Function<And$InT>() create,
  ) {
    return Supports$InClassFamilyNameProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InClassFamilyNameFamily,
        create: create<And$InT>);
  }

  Supports$InClassFamilyNameProvider<And$InT> _copyWithBuild(
    String Function<And$InT>(
      Ref,
      Supports$InClassFamilyName<And$InT>,
    ) build,
  ) {
    return Supports$InClassFamilyNameProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InClassFamilyNameFamily,
        runNotifierBuildOverride: build<And$InT>);
  }

  @override
  String toString() {
    return r'supports$InClassFamilyNameProvider'
        '<${And$InT}>'
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  Supports$InClassFamilyName<And$InT> create() =>
      _createCb?.call() ?? Supports$InClassFamilyName<And$InT>();

  @$internal
  @override
  Supports$InClassFamilyNameProvider<And$InT> $copyWithCreate(
    Supports$InClassFamilyName<And$InT> Function() create,
  ) {
    return Supports$InClassFamilyNameProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InClassFamilyNameFamily,
        create: create);
  }

  @$internal
  @override
  Supports$InClassFamilyNameProvider<And$InT> $copyWithBuild(
    String Function(
      Ref,
      Supports$InClassFamilyName<And$InT>,
    ) build,
  ) {
    return Supports$InClassFamilyNameProvider<And$InT>._(
        argument: argument as (
          And$InT, {
          And$InT named$arg,
          String defaultArg,
        }),
        from: from! as Supports$InClassFamilyNameFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassFamilyName<And$InT>, String>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);

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

final class Supports$InClassFamilyNameFamily extends Family {
  const Supports$InClassFamilyNameFamily._()
      : super(
          retry: null,
          name: r'supports$InClassFamilyNameProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Supports$InClassFamilyNameProvider<And$InT> call<And$InT>(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  }) =>
      Supports$InClassFamilyNameProvider<And$InT>._(argument: (
        positional$arg,
        named$arg: named$arg,
        defaultArg: defaultArg,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$supports$InClassFamilyNameHash();

  @override
  String toString() => r'supports$InClassFamilyNameProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Supports$InClassFamilyName<And$InT> Function<And$InT>(
      (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InClassFamilyNameProvider;

        return provider._copyWithCreate(<And$InT>() {
          final argument = provider.argument as (
            And$InT, {
            And$InT named$arg,
            String defaultArg,
          });

          return create(argument);
        }).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function<And$InT>(
            Ref ref,
            Supports$InClassFamilyName<And$InT> notifier,
            (
              And$InT, {
              And$InT named$arg,
              String defaultArg,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Supports$InClassFamilyNameProvider;

        return provider._copyWithBuild(<And$InT>(ref, notifier) {
          final argument = provider.argument as (
            And$InT, {
            And$InT named$arg,
            String defaultArg,
          });

          return build(ref, notifier, argument);
        }).$createElement(pointer);
      },
    );
  }
}

abstract class _$Supports$InClassFamilyName<And$InT> extends $Notifier<String> {
  late final _$args = ref.$arg as (
    And$InT, {
    And$InT named$arg,
    String defaultArg,
  });
  And$InT get positional$arg => _$args.$1;
  And$InT get named$arg => _$args.named$arg;
  String get defaultArg => _$args.defaultArg;

  String build(
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg = default$value,
  });
  @$internal
  @override
  String runBuild() => build(
        _$args.$1,
        named$arg: _$args.named$arg,
        defaultArg: _$args.defaultArg,
      );
}

@ProviderFor(generated)
const generatedProvider = GeneratedProvider._();

final class GeneratedProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const GeneratedProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'generatedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  GeneratedProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return GeneratedProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? generated;
    return _$cb(ref);
  }
}

String _$generatedHash() => r'24bfb5df4dc529258ab568372e90a1cbfc2d8c24';

@ProviderFor(unnecessaryCast)
const unnecessaryCastProvider = UnnecessaryCastFamily._();

final class UnnecessaryCastProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const UnnecessaryCastProvider._(
      {required UnnecessaryCastFamily super.from,
      required Object? super.argument,
      String Function(
        Ref ref,
        Object? arg,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'unnecessaryCastProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
    Object? arg,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastHash();

  @override
  String toString() {
    return r'unnecessaryCastProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  UnnecessaryCastProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return UnnecessaryCastProvider._(
        argument: argument,
        from: from! as UnnecessaryCastFamily,
        create: (
          ref,
          Object? arg,
        ) =>
            create(ref));
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? unnecessaryCast;
    final argument = this.argument;
    return _$cb(
      ref,
      argument,
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

final class UnnecessaryCastFamily extends Family {
  const UnnecessaryCastFamily._()
      : super(
          retry: null,
          name: r'unnecessaryCastProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UnnecessaryCastProvider call(
    Object? arg,
  ) =>
      UnnecessaryCastProvider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastHash();

  @override
  String toString() => r'unnecessaryCastProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      Ref ref,
      Object? args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as UnnecessaryCastProvider;

        final argument = provider.argument;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(UnnecessaryCastClass)
const unnecessaryCastClassProvider = UnnecessaryCastClassFamily._();

final class UnnecessaryCastClassProvider
    extends $NotifierProvider<UnnecessaryCastClass, String> {
  const UnnecessaryCastClassProvider._(
      {required UnnecessaryCastClassFamily super.from,
      required Object? super.argument,
      super.runNotifierBuildOverride,
      UnnecessaryCastClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'unnecessaryCastClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final UnnecessaryCastClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastClassHash();

  @override
  String toString() {
    return r'unnecessaryCastClassProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  UnnecessaryCastClass create() => _createCb?.call() ?? UnnecessaryCastClass();

  @$internal
  @override
  UnnecessaryCastClassProvider $copyWithCreate(
    UnnecessaryCastClass Function() create,
  ) {
    return UnnecessaryCastClassProvider._(
        argument: argument,
        from: from! as UnnecessaryCastClassFamily,
        create: create);
  }

  @$internal
  @override
  UnnecessaryCastClassProvider $copyWithBuild(
    String Function(
      Ref,
      UnnecessaryCastClass,
    ) build,
  ) {
    return UnnecessaryCastClassProvider._(
        argument: argument,
        from: from! as UnnecessaryCastClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<UnnecessaryCastClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class UnnecessaryCastClassFamily extends Family {
  const UnnecessaryCastClassFamily._()
      : super(
          retry: null,
          name: r'unnecessaryCastClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UnnecessaryCastClassProvider call(
    Object? arg,
  ) =>
      UnnecessaryCastClassProvider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$unnecessaryCastClassHash();

  @override
  String toString() => r'unnecessaryCastClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    UnnecessaryCastClass Function(
      Object? args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as UnnecessaryCastClassProvider;

        final argument = provider.argument;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(Ref ref, UnnecessaryCastClass notifier, Object? argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as UnnecessaryCastClassProvider;

        final argument = provider.argument;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$UnnecessaryCastClass extends $Notifier<String> {
  late final _$args = ref.$arg;
  Object? get arg => _$args;

  String build(
    Object? arg,
  );
  @$internal
  @override
  String runBuild() => build(
        _$args,
      );
}

@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily._();

final class ManyDataStreamProvider<T extends Object, S extends Object>
    extends $FunctionalProvider<AsyncValue<List<T>>, Stream<List<T>>>
    with $FutureModifier<List<T>>, $StreamProvider<List<T>> {
  const ManyDataStreamProvider._(
      {required ManyDataStreamFamily super.from,
      required ManyProviderData<T, S> super.argument,
      Stream<List<T>> Function(
        Ref ref,
        ManyProviderData<T, S> pData,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'manyDataStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<List<T>> Function(
    Ref ref,
    ManyProviderData<T, S> pData,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  ManyDataStreamProvider<T, S> _copyWithCreate(
    Stream<List<T>> Function<T extends Object, S extends Object>(
      Ref ref,
      ManyProviderData<T, S> pData,
    ) create,
  ) {
    return ManyDataStreamProvider<T, S>._(
        argument: argument as ManyProviderData<T, S>,
        from: from! as ManyDataStreamFamily,
        create: create<T, S>);
  }

  @override
  String toString() {
    return r'manyDataStreamProvider'
        '<${T}, ${S}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<T>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  ManyDataStreamProvider<T, S> $copyWithCreate(
    Stream<List<T>> Function(
      Ref ref,
    ) create,
  ) {
    return ManyDataStreamProvider<T, S>._(
        argument: argument as ManyProviderData<T, S>,
        from: from! as ManyDataStreamFamily,
        create: (
          ref,
          ManyProviderData<T, S> pData,
        ) =>
            create(ref));
  }

  @override
  Stream<List<T>> create(Ref ref) {
    final _$cb = _createCb ?? manyDataStream<T, S>;
    final argument = this.argument as ManyProviderData<T, S>;
    return _$cb(
      ref,
      argument,
    );
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

String _$manyDataStreamHash() => r'5f389757cba176868a47b89b14b1f96afe20d728';

final class ManyDataStreamFamily extends Family {
  const ManyDataStreamFamily._()
      : super(
          retry: null,
          name: r'manyDataStreamProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ManyDataStreamProvider<T, S> call<T extends Object, S extends Object>(
    ManyProviderData<T, S> pData,
  ) =>
      ManyDataStreamProvider<T, S>._(argument: pData, from: this);

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  @override
  String toString() => r'manyDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<List<T>> Function<T extends Object, S extends Object>(
      Ref ref,
      ManyProviderData<T, S> args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ManyDataStreamProvider;

        return provider._copyWithCreate(<T extends Object, S extends Object>(
          ref,
          ManyProviderData<T, S> pData,
        ) {
          return create(ref, pData);
        }).$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
