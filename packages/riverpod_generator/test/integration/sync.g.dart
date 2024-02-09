// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GenericRef<T extends num> = Ref<List<T>>;

const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $FunctionalProvider<List<T>, List<T>, GenericRef<T>>
    with $Provider<List<T>, GenericRef<T>> {
  const GenericProvider._(
      {required GenericFamily super.from,
      List<T> Function(
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

  final List<T> Function(
    GenericRef<T> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<T> _copyWithCreate(
    List<T> Function<T extends num>(
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

  @override
  $ProviderElement<List<T>> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  GenericProvider<T> $copyWithCreate(
    List<T> Function(
      GenericRef<T> ref,
    ) create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @override
  List<T> create(GenericRef<T> ref) {
    final fn = _createCb ?? generic<T>;
    return fn(ref);
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

String _$genericHash() => r'0fda19dd377694315cdffd7414d53f98569c655c';

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

  Override overrideWith(
    List<T> Function<T extends num>(GenericRef<T> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericProvider;

        return provider._copyWithCreate(create).createElement(container);
      },
    );
  }
}

typedef ComplexGenericRef<T extends num, Foo extends String?> = Ref<List<T>>;

const complexGenericProvider = ComplexGenericFamily._();

final class ComplexGenericProvider<T extends num, Foo extends String?>
    extends $FunctionalProvider<List<T>, List<T>, ComplexGenericRef<T, Foo>>
    with $Provider<List<T>, ComplexGenericRef<T, Foo>> {
  const ComplexGenericProvider._(
      {required ComplexGenericFamily super.from,
      required ({
        T param,
        Foo? otherParam,
      })
          super.argument,
      List<T> Function(
        ComplexGenericRef<T, Foo> ref, {
        required T param,
        Foo? otherParam,
      })? create})
      : _createCb = create,
        super(
          name: r'complexGenericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<T> Function(
    ComplexGenericRef<T, Foo> ref, {
    required T param,
    Foo? otherParam,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$complexGenericHash();

  ComplexGenericProvider<T, Foo> _copyWithCreate(
    List<T> Function<T extends num, Foo extends String?>(
      ComplexGenericRef<T, Foo> ref, {
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

  @override
  $ProviderElement<List<T>> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ComplexGenericProvider<T, Foo> $copyWithCreate(
    List<T> Function(
      ComplexGenericRef<T, Foo> ref,
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
  List<T> create(ComplexGenericRef<T, Foo> ref) {
    final fn = _createCb ?? complexGeneric<T, Foo>;
    final ({
      T param,
      Foo? otherParam,
    }) argument = this.argument as ({
      T param,
      Foo? otherParam,
    });
    return fn(
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

String _$complexGenericHash() => r'a5254e5552cd61bb8d65c018539ff2d8edfd5822';

final class ComplexGenericFamily extends Family {
  const ComplexGenericFamily._()
      : super(
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

  Override overrideWith(
    List<T> Function<T extends num, Foo extends String?>(
      ComplexGenericRef<T, Foo> ref,
      ({
        T param,
        Foo? otherParam,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ComplexGenericProvider;

        return provider._copyWithCreate(<T extends num, Foo extends String?>(
          ref, {
          required T param,
          Foo? otherParam,
        }) {
          return create(ref, (
            param: param,
            otherParam: otherParam,
          ));
        }).createElement(container);
      },
    );
  }
}

typedef RawFutureRef = Ref<Raw<Future<String>>>;

const rawFutureProvider = RawFutureProvider._();

final class RawFutureProvider extends $FunctionalProvider<
    Raw<Future<String>>,
    Raw<Future<String>>,
    RawFutureRef> with $Provider<Raw<Future<String>>, RawFutureRef> {
  const RawFutureProvider._(
      {Raw<Future<String>> Function(
        RawFutureRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawFutureProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Future<String>> Function(
    RawFutureRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFutureHash();

  @override
  $ProviderElement<Raw<Future<String>>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawFutureProvider $copyWithCreate(
    Raw<Future<String>> Function(
      RawFutureRef ref,
    ) create,
  ) {
    return RawFutureProvider._(create: create);
  }

  @override
  Raw<Future<String>> create(RawFutureRef ref) {
    final fn = _createCb ?? rawFuture;
    return fn(ref);
  }
}

String _$rawFutureHash() => r'5203a56065b768023770326281618e3229ccb530';

typedef RawStreamRef = Ref<Raw<Stream<String>>>;

const rawStreamProvider = RawStreamProvider._();

final class RawStreamProvider extends $FunctionalProvider<
    Raw<Stream<String>>,
    Raw<Stream<String>>,
    RawStreamRef> with $Provider<Raw<Stream<String>>, RawStreamRef> {
  const RawStreamProvider._(
      {Raw<Stream<String>> Function(
        RawStreamRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<String>> Function(
    RawStreamRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamHash();

  @override
  $ProviderElement<Raw<Stream<String>>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawStreamProvider $copyWithCreate(
    Raw<Stream<String>> Function(
      RawStreamRef ref,
    ) create,
  ) {
    return RawStreamProvider._(create: create);
  }

  @override
  Raw<Stream<String>> create(RawStreamRef ref) {
    final fn = _createCb ?? rawStream;
    return fn(ref);
  }
}

String _$rawStreamHash() => r'2b764189753a8b74f47ba557a79416f00ef5cebd';

typedef RawFamilyFutureRef = Ref<Raw<Future<String>>>;

const rawFamilyFutureProvider = RawFamilyFutureFamily._();

final class RawFamilyFutureProvider extends $FunctionalProvider<
        Raw<Future<String>>, Raw<Future<String>>, RawFamilyFutureRef>
    with $Provider<Raw<Future<String>>, RawFamilyFutureRef> {
  const RawFamilyFutureProvider._(
      {required RawFamilyFutureFamily super.from,
      required int super.argument,
      Raw<Future<String>> Function(
        RawFamilyFutureRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          name: r'rawFamilyFutureProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Future<String>> Function(
    RawFamilyFutureRef ref,
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

  @override
  $ProviderElement<Raw<Future<String>>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawFamilyFutureProvider $copyWithCreate(
    Raw<Future<String>> Function(
      RawFamilyFutureRef ref,
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
  Raw<Future<String>> create(RawFamilyFutureRef ref) {
    final fn = _createCb ?? rawFamilyFuture;
    final int argument = this.argument as int;
    return fn(
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

String _$rawFamilyFutureHash() => r'485f59512081852e51279658facc015309743864';

final class RawFamilyFutureFamily extends Family {
  const RawFamilyFutureFamily._()
      : super(
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

  Override overrideWith(
    Raw<Future<String>> Function(
      RawFamilyFutureRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyFutureProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

typedef RawFamilyStreamRef = Ref<Raw<Stream<String>>>;

const rawFamilyStreamProvider = RawFamilyStreamFamily._();

final class RawFamilyStreamProvider extends $FunctionalProvider<
        Raw<Stream<String>>, Raw<Stream<String>>, RawFamilyStreamRef>
    with $Provider<Raw<Stream<String>>, RawFamilyStreamRef> {
  const RawFamilyStreamProvider._(
      {required RawFamilyStreamFamily super.from,
      required int super.argument,
      Raw<Stream<String>> Function(
        RawFamilyStreamRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          name: r'rawFamilyStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<String>> Function(
    RawFamilyStreamRef ref,
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

  @override
  $ProviderElement<Raw<Stream<String>>> createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawFamilyStreamProvider $copyWithCreate(
    Raw<Stream<String>> Function(
      RawFamilyStreamRef ref,
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
  Raw<Stream<String>> create(RawFamilyStreamRef ref) {
    final fn = _createCb ?? rawFamilyStream;
    final int argument = this.argument as int;
    return fn(
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

String _$rawFamilyStreamHash() => r'e778e5cfcb8ab381e2412f5c73213aaa03b93012';

final class RawFamilyStreamFamily extends Family {
  const RawFamilyStreamFamily._()
      : super(
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

  Override overrideWith(
    Raw<Stream<String>> Function(
      RawFamilyStreamRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyStreamProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

typedef PublicRef = Ref<String>;

const publicProvider = PublicProvider._();

final class PublicProvider
    extends $FunctionalProvider<String, String, PublicRef>
    with $Provider<String, PublicRef> {
  const PublicProvider._(
      {String Function(
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

  final String Function(
    PublicRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  PublicProvider $copyWithCreate(
    String Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  String create(PublicRef ref) {
    final fn = _createCb ?? public;
    return fn(ref);
  }
}

String _$publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

typedef Supports$inNamesRef = Ref<String>;

const supports$inNamesProvider = Supports$inNamesProvider._();

final class Supports$inNamesProvider
    extends $FunctionalProvider<String, String, Supports$inNamesRef>
    with $Provider<String, Supports$inNamesRef> {
  const Supports$inNamesProvider._(
      {String Function(
        Supports$inNamesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'supports$inNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Supports$inNamesRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$inNamesHash();

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Supports$inNamesProvider $copyWithCreate(
    String Function(
      Supports$inNamesRef ref,
    ) create,
  ) {
    return Supports$inNamesProvider._(create: create);
  }

  @override
  String create(Supports$inNamesRef ref) {
    final fn = _createCb ?? supports$inNames;
    return fn(ref);
  }
}

String _$supports$inNamesHash() => r'cbf929802fcbd0aa949ad72743d096fb3ef5f28f';

typedef FamilyRef = Ref<String>;

const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<String, String, FamilyRef>
    with $Provider<String, FamilyRef> {
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

  final String Function(
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  FamilyProvider $copyWithCreate(
    String Function(
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
  String create(FamilyRef ref) {
    final fn = _createCb ?? family;
    final (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    }) argument = this.argument as (
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
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyHash() => r'14d1ee238ca608d547630d0e222ef4c5866e9e61';

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

  Override overrideWith(
    String Function(
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
            .createElement(container);
      },
    );
  }
}

typedef _PrivateRef = Ref<String>;

const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<String, String, _PrivateRef>
    with $Provider<String, _PrivateRef> {
  const _PrivateProvider._(
      {String Function(
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

  final String Function(
    _PrivateRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  _PrivateProvider $copyWithCreate(
    String Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  String create(_PrivateRef ref) {
    final fn = _createCb ?? _private;
    return fn(ref);
  }
}

String _$privateHash() => r'519561bc7e88e394d7f75ca2102a5c0acc832c66';

typedef Supports$InFnNameRef<And$InT> = Ref<String>;

const supports$InFnNameProvider = Supports$InFnNameFamily._();

final class Supports$InFnNameProvider<And$InT>
    extends $FunctionalProvider<String, String, Supports$InFnNameRef<And$InT>>
    with $Provider<String, Supports$InFnNameRef<And$InT>> {
  const Supports$InFnNameProvider._(
      {required Supports$InFnNameFamily super.from,
      String Function(
        Supports$InFnNameRef<And$InT> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'supports$InFnNameProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Supports$InFnNameRef<And$InT> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameHash();

  Supports$InFnNameProvider<And$InT> _copyWithCreate(
    String Function<And$InT>(
      Supports$InFnNameRef<And$InT> ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Supports$InFnNameProvider<And$InT> $copyWithCreate(
    String Function(
      Supports$InFnNameRef<And$InT> ref,
    ) create,
  ) {
    return Supports$InFnNameProvider<And$InT>._(
        from: from! as Supports$InFnNameFamily, create: create);
  }

  @override
  String create(Supports$InFnNameRef<And$InT> ref) {
    final fn = _createCb ?? supports$InFnName<And$InT>;
    return fn(ref);
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

String _$supports$InFnNameHash() => r'fec3daca655669a46760cc54921f098b9cbaac3d';

final class Supports$InFnNameFamily extends Family {
  const Supports$InFnNameFamily._()
      : super(
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

  Override overrideWith(
    String Function<And$InT>(Supports$InFnNameRef<And$InT> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as Supports$InFnNameProvider;

        return provider._copyWithCreate(create).createElement(container);
      },
    );
  }
}

typedef Supports$InFnNameFamilyRef<And$InT> = Ref<String>;

const supports$InFnNameFamilyProvider = Supports$InFnNameFamilyFamily._();

final class Supports$InFnNameFamilyProvider<And$InT>
    extends $FunctionalProvider<String, String,
        Supports$InFnNameFamilyRef<And$InT>>
    with $Provider<String, Supports$InFnNameFamilyRef<And$InT>> {
  const Supports$InFnNameFamilyProvider._(
      {required Supports$InFnNameFamilyFamily super.from,
      required (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      })
          super.argument,
      String Function(
        Supports$InFnNameFamilyRef<And$InT> ref,
        And$InT positional$arg, {
        required And$InT named$arg,
        String defaultArg,
      })? create})
      : _createCb = create,
        super(
          name: r'supports$InFnNameFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Supports$InFnNameFamilyRef<And$InT> ref,
    And$InT positional$arg, {
    required And$InT named$arg,
    String defaultArg,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InFnNameFamilyHash();

  Supports$InFnNameFamilyProvider<And$InT> _copyWithCreate(
    String Function<And$InT>(
      Supports$InFnNameFamilyRef<And$InT> ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Supports$InFnNameFamilyProvider<And$InT> $copyWithCreate(
    String Function(
      Supports$InFnNameFamilyRef<And$InT> ref,
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
  String create(Supports$InFnNameFamilyRef<And$InT> ref) {
    final fn = _createCb ?? supports$InFnNameFamily<And$InT>;
    final (
      And$InT, {
      And$InT named$arg,
      String defaultArg,
    }) argument = this.argument as (
      And$InT, {
      And$InT named$arg,
      String defaultArg,
    });
    return fn(
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
    r'1daa434fa2ad9ff37deade29ba3ca8155833df1b';

final class Supports$InFnNameFamilyFamily extends Family {
  const Supports$InFnNameFamilyFamily._()
      : super(
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

  Override overrideWith(
    String Function<And$InT>(
      Supports$InFnNameFamilyRef<And$InT> ref,
      (
        And$InT, {
        And$InT named$arg,
        String defaultArg,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as Supports$InFnNameFamilyProvider;

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
        }).createElement(container);
      },
    );
  }
}

typedef GeneratedRef = Ref<String>;

const generatedProvider = GeneratedProvider._();

final class GeneratedProvider
    extends $FunctionalProvider<String, String, GeneratedRef>
    with $Provider<String, GeneratedRef> {
  const GeneratedProvider._(
      {String Function(
        GeneratedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'generatedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    GeneratedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedHash();

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  GeneratedProvider $copyWithCreate(
    String Function(
      GeneratedRef ref,
    ) create,
  ) {
    return GeneratedProvider._(create: create);
  }

  @override
  String create(GeneratedRef ref) {
    final fn = _createCb ?? generated;
    return fn(ref);
  }
}

String _$generatedHash() => r'fecbc1d5d9a05fc996b452a57fd1975ff368af91';

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
      Ref<List<T>>,
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
    List<T> Function(
      Ref<List<T>>,
      GenericClass<T>,
    ) build,
  ) {
    return GenericClassProvider<T>._(
        from: from! as GenericClassFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GenericClass<T>, List<T>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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

String _$genericClassHash() => r'671e348a5abf8e00ab06c5f247defbca8af9677b';

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

  Override overrideWith(
    GenericClass<T> Function<T extends num>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericClassProvider;

        return provider._copyWithCreate(create).createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    List<T> Function<T extends num>(Ref<List<T>> ref, GenericClass<T> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GenericClassProvider;

        return provider._copyWithBuild(build).createElement(container);
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

const rawFutureClassProvider = RawFutureClassProvider._();

final class RawFutureClassProvider
    extends $NotifierProvider<RawFutureClass, Raw<Future<String>>> {
  const RawFutureClassProvider._(
      {super.runNotifierBuildOverride, RawFutureClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawFutureClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawFutureClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFutureClassHash();

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
      Ref<Raw<Future<String>>>,
      RawFutureClass,
    ) build,
  ) {
    return RawFutureClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawFutureClass, Raw<Future<String>>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$rawFutureClassHash() => r'bf66f1cdbd99118b8845d206e6a2611b3101f45c';

abstract class _$RawFutureClass extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();

  @$internal
  @override
  Raw<Future<String>> runBuild() => build();
}

const rawStreamClassProvider = RawStreamClassProvider._();

final class RawStreamClassProvider
    extends $NotifierProvider<RawStreamClass, Raw<Stream<String>>> {
  const RawStreamClassProvider._(
      {super.runNotifierBuildOverride, RawStreamClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawStreamClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final RawStreamClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamClassHash();

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
      Ref<Raw<Stream<String>>>,
      RawStreamClass,
    ) build,
  ) {
    return RawStreamClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<RawStreamClass, Raw<Stream<String>>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$rawStreamClassHash() => r'712cffcb2018cfb4ff45012c1aa6e43c8cbe9d5d';

abstract class _$RawStreamClass extends $Notifier<Raw<Stream<String>>> {
  Raw<Stream<String>> build();

  @$internal
  @override
  Raw<Stream<String>> runBuild() => build();
}

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
      Ref<Raw<Future<String>>>,
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
      createElement(ProviderContainer container) =>
          $NotifierProviderElement(this, container);

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

  Override overrideWith(
    RawFamilyFutureClass Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyFutureClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    Raw<Future<String>> Function(Ref<Raw<Future<String>>> ref,
            RawFamilyFutureClass notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyFutureClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .createElement(container);
      },
    );
  }
}

abstract class _$RawFamilyFutureClass extends $Notifier<Raw<Future<String>>> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;
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
      Ref<Raw<Stream<String>>>,
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
      createElement(ProviderContainer container) =>
          $NotifierProviderElement(this, container);

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

  Override overrideWith(
    RawFamilyStreamClass Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyStreamClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    Raw<Stream<String>> Function(Ref<Raw<Stream<String>>> ref,
            RawFamilyStreamClass notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RawFamilyStreamClassProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .createElement(container);
      },
    );
  }
}

abstract class _$RawFamilyStreamClass extends $Notifier<Raw<Stream<String>>> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;
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

const publicClassProvider = PublicClassProvider._();

final class PublicClassProvider extends $NotifierProvider<PublicClass, String> {
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
    String Function(
      Ref<String>,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PublicClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$publicClassHash() => r'c8e7eec9e202acf8394e02496857cbe49405bf62';

abstract class _$PublicClass extends $Notifier<String> {
  String build();

  @$internal
  @override
  String runBuild() => build();
}

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
  $NotifierProviderElement<_PrivateClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$privateClassHash() => r'6d41def3ffdc1f79e593beaefb3304ce4b211a77';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();

  @$internal
  @override
  String runBuild() => build();
}

const familyClassProvider = FamilyClassFamily._();

final class FamilyClassProvider extends $NotifierProvider<FamilyClass, String> {
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
    String Function(
      Ref<String>,
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
  $NotifierProviderElement<FamilyClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'01e3b9cb4d6d0bf12a2284761b1a11819d97d249';

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
            .createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    String Function(
            Ref<String> ref,
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
            .createElement(container);
      },
    );
  }
}

abstract class _$FamilyClass extends $Notifier<String> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as (
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
      Ref<String>,
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
      Ref<String>,
      Supports$InClassName<And$InT>,
    ) build,
  ) {
    return Supports$InClassNameProvider<And$InT>._(
        from: from! as Supports$InClassNameFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassName<And$InT>, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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
    r'9eeab74a85af26136dd698df79669df4cec4c42b';

final class Supports$InClassNameFamily extends Family {
  const Supports$InClassNameFamily._()
      : super(
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

  Override overrideWith(
    Supports$InClassName<And$InT> Function<And$InT>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as Supports$InClassNameProvider;

        return provider._copyWithCreate(create).createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    String Function<And$InT>(
            Ref<String> ref, Supports$InClassName<And$InT> notifier)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as Supports$InClassNameProvider;

        return provider._copyWithBuild(build).createElement(container);
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
      Ref<String>,
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
      Ref<String>,
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
      createElement(ProviderContainer container) =>
          $NotifierProviderElement(this, container);

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
      createElement: (container, provider) {
        provider as Supports$InClassFamilyNameProvider;

        return provider._copyWithCreate(<And$InT>() {
          final argument = provider.argument as (
            And$InT, {
            And$InT named$arg,
            String defaultArg,
          });

          return create(argument);
        }).createElement(container);
      },
    );
  }

  Override overrideWithBuild(
    String Function<And$InT>(
            Ref<String> ref,
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
      createElement: (container, provider) {
        provider as Supports$InClassFamilyNameProvider;

        return provider._copyWithBuild(<And$InT>(ref, notifier) {
          final argument = provider.argument as (
            And$InT, {
            And$InT named$arg,
            String defaultArg,
          });

          return build(ref, notifier, argument);
        }).createElement(container);
      },
    );
  }
}

abstract class _$Supports$InClassFamilyName<And$InT> extends $Notifier<String> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as (
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

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
