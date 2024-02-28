// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CountRef = Ref<int>;

@ProviderFor(count)
const myCountPod = CountProvider._();

final class CountProvider extends $FunctionalProvider<int, int, CountRef>
    with $Provider<int, CountRef> {
  const CountProvider._(
      {int Function(
        CountRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountPod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CountRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CountProvider $copyWithCreate(
    int Function(
      CountRef ref,
    ) create,
  ) {
    return CountProvider._(create: create);
  }

  @override
  int create(CountRef ref) {
    final _$cb = _createCb ?? count;
    return _$cb(ref);
  }
}

String _$countHash() => r'4c7e72b275767a60ece5e8662ab1e28f73cf7e44';

typedef CountFutureRef = Ref<AsyncValue<int>>;

@ProviderFor(countFuture)
const myCountFuturePod = CountFutureProvider._();

final class CountFutureProvider
    extends $FunctionalProvider<AsyncValue<int>, FutureOr<int>, CountFutureRef>
    with $FutureModifier<int>, $FutureProvider<int, CountFutureRef> {
  const CountFutureProvider._(
      {FutureOr<int> Function(
        CountFutureRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountFuturePod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<int> Function(
    CountFutureRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countFutureHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  CountFutureProvider $copyWithCreate(
    FutureOr<int> Function(
      CountFutureRef ref,
    ) create,
  ) {
    return CountFutureProvider._(create: create);
  }

  @override
  FutureOr<int> create(CountFutureRef ref) {
    final _$cb = _createCb ?? countFuture;
    return _$cb(ref);
  }
}

String _$countFutureHash() => r'ec7cc31ce1c1a10607f1dcb35dd217acd2877729';

typedef CountStreamRef = Ref<AsyncValue<int>>;

@ProviderFor(countStream)
const myCountStreamPod = CountStreamProvider._();

final class CountStreamProvider
    extends $FunctionalProvider<AsyncValue<int>, Stream<int>, CountStreamRef>
    with $FutureModifier<int>, $StreamProvider<int, CountStreamRef> {
  const CountStreamProvider._(
      {Stream<int> Function(
        CountStreamRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountStreamPod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<int> Function(
    CountStreamRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countStreamHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  CountStreamProvider $copyWithCreate(
    Stream<int> Function(
      CountStreamRef ref,
    ) create,
  ) {
    return CountStreamProvider._(create: create);
  }

  @override
  Stream<int> create(CountStreamRef ref) {
    final _$cb = _createCb ?? countStream;
    return _$cb(ref);
  }
}

String _$countStreamHash() => r'1dbe49244ea19e8dbc3af0534429bb323720c07a';

@ProviderFor(CountNotifier)
const myCountNotifierPod = CountNotifierProvider._();

final class CountNotifierProvider
    extends $NotifierProvider<CountNotifier, int> {
  const CountNotifierProvider._(
      {super.runNotifierBuildOverride, CountNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  CountNotifier create() => _createCb?.call() ?? CountNotifier();

  @$internal
  @override
  CountNotifierProvider $copyWithCreate(
    CountNotifier Function() create,
  ) {
    return CountNotifierProvider._(create: create);
  }

  @$internal
  @override
  CountNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      CountNotifier,
    ) build,
  ) {
    return CountNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<CountNotifier, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$countNotifierHash() => r'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

abstract class _$CountNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(CountAsyncNotifier)
const myCountAsyncNotifierPod = CountAsyncNotifierProvider._();

final class CountAsyncNotifierProvider
    extends $AsyncNotifierProvider<CountAsyncNotifier, int> {
  const CountAsyncNotifierProvider._(
      {super.runNotifierBuildOverride, CountAsyncNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountAsyncNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountAsyncNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countAsyncNotifierHash();

  @$internal
  @override
  CountAsyncNotifier create() => _createCb?.call() ?? CountAsyncNotifier();

  @$internal
  @override
  CountAsyncNotifierProvider $copyWithCreate(
    CountAsyncNotifier Function() create,
  ) {
    return CountAsyncNotifierProvider._(create: create);
  }

  @$internal
  @override
  CountAsyncNotifierProvider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      CountAsyncNotifier,
    ) build,
  ) {
    return CountAsyncNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<CountAsyncNotifier, int> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);
}

String _$countAsyncNotifierHash() =>
    r'2a7049d864bf396e44a5937b4001efb4774a5f29';

abstract class _$CountAsyncNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$internal
  @override
  FutureOr<int> runBuild() => build();
}

@ProviderFor(CountStreamNotifier)
const myCountStreamNotifierPod = CountStreamNotifierProvider._();

final class CountStreamNotifierProvider
    extends $StreamNotifierProvider<CountStreamNotifier, int> {
  const CountStreamNotifierProvider._(
      {super.runNotifierBuildOverride, CountStreamNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myCountStreamNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountStreamNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countStreamNotifierHash();

  @$internal
  @override
  CountStreamNotifier create() => _createCb?.call() ?? CountStreamNotifier();

  @$internal
  @override
  CountStreamNotifierProvider $copyWithCreate(
    CountStreamNotifier Function() create,
  ) {
    return CountStreamNotifierProvider._(create: create);
  }

  @$internal
  @override
  CountStreamNotifierProvider $copyWithBuild(
    Stream<int> Function(
      Ref<AsyncValue<int>>,
      CountStreamNotifier,
    ) build,
  ) {
    return CountStreamNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<CountStreamNotifier, int> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);
}

String _$countStreamNotifierHash() =>
    r'61d2cd311c4808f8d7e8b2d67f5c7b85337666c6';

abstract class _$CountStreamNotifier extends $StreamNotifier<int> {
  Stream<int> build();
  @$internal
  @override
  Stream<int> runBuild() => build();
}

typedef Count2Ref = Ref<int>;

@ProviderFor(count2)
const myFamilyCount2ProviderFamily = Count2Family._();

final class Count2Provider extends $FunctionalProvider<int, int, Count2Ref>
    with $Provider<int, Count2Ref> {
  const Count2Provider._(
      {required Count2Family super.from,
      required int super.argument,
      int Function(
        Count2Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'myFamilyCount2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Count2Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$count2Hash();

  @override
  String toString() {
    return r'myFamilyCount2ProviderFamily'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Count2Provider $copyWithCreate(
    int Function(
      Count2Ref ref,
    ) create,
  ) {
    return Count2Provider._(
        argument: argument as int,
        from: from! as Count2Family,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  int create(Count2Ref ref) {
    final _$cb = _createCb ?? count2;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Count2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$count2Hash() => r'6256825480d83bb13acde282cf3c9d9524cc3a6c';

final class Count2Family extends Family {
  const Count2Family._()
      : super(
          name: r'myFamilyCount2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Count2Provider call(
    int a,
  ) =>
      Count2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$count2Hash();

  @override
  String toString() => r'myFamilyCount2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Count2Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as Count2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

typedef CountFuture2Ref = Ref<AsyncValue<int>>;

@ProviderFor(countFuture2)
const myFamilyCountFuture2ProviderFamily = CountFuture2Family._();

final class CountFuture2Provider
    extends $FunctionalProvider<AsyncValue<int>, FutureOr<int>, CountFuture2Ref>
    with $FutureModifier<int>, $FutureProvider<int, CountFuture2Ref> {
  const CountFuture2Provider._(
      {required CountFuture2Family super.from,
      required int super.argument,
      FutureOr<int> Function(
        CountFuture2Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'myFamilyCountFuture2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<int> Function(
    CountFuture2Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countFuture2Hash();

  @override
  String toString() {
    return r'myFamilyCountFuture2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  CountFuture2Provider $copyWithCreate(
    FutureOr<int> Function(
      CountFuture2Ref ref,
    ) create,
  ) {
    return CountFuture2Provider._(
        argument: argument as int,
        from: from! as CountFuture2Family,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  FutureOr<int> create(CountFuture2Ref ref) {
    final _$cb = _createCb ?? countFuture2;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountFuture2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countFuture2Hash() => r'096675b70a267f5d7c62ac7d3e7dd231ef529034';

final class CountFuture2Family extends Family {
  const CountFuture2Family._()
      : super(
          name: r'myFamilyCountFuture2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountFuture2Provider call(
    int a,
  ) =>
      CountFuture2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$countFuture2Hash();

  @override
  String toString() => r'myFamilyCountFuture2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<int> Function(
      CountFuture2Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountFuture2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

typedef CountStream2Ref = Ref<AsyncValue<int>>;

@ProviderFor(countStream2)
const myFamilyCountStream2ProviderFamily = CountStream2Family._();

final class CountStream2Provider
    extends $FunctionalProvider<AsyncValue<int>, Stream<int>, CountStream2Ref>
    with $FutureModifier<int>, $StreamProvider<int, CountStream2Ref> {
  const CountStream2Provider._(
      {required CountStream2Family super.from,
      required int super.argument,
      Stream<int> Function(
        CountStream2Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'myFamilyCountStream2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<int> Function(
    CountStream2Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countStream2Hash();

  @override
  String toString() {
    return r'myFamilyCountStream2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  CountStream2Provider $copyWithCreate(
    Stream<int> Function(
      CountStream2Ref ref,
    ) create,
  ) {
    return CountStream2Provider._(
        argument: argument as int,
        from: from! as CountStream2Family,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  Stream<int> create(CountStream2Ref ref) {
    final _$cb = _createCb ?? countStream2;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountStream2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countStream2Hash() => r'051264dd685ebc0a57e454bb676957c93cb4ae20';

final class CountStream2Family extends Family {
  const CountStream2Family._()
      : super(
          name: r'myFamilyCountStream2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountStream2Provider call(
    int a,
  ) =>
      CountStream2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$countStream2Hash();

  @override
  String toString() => r'myFamilyCountStream2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<int> Function(
      CountStream2Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountStream2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

@ProviderFor(CountNotifier2)
const myFamilyCountNotifier2ProviderFamily = CountNotifier2Family._();

final class CountNotifier2Provider
    extends $NotifierProvider<CountNotifier2, int> {
  const CountNotifier2Provider._(
      {required CountNotifier2Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      CountNotifier2 Function()? create})
      : _createCb = create,
        super(
          name: r'myFamilyCountNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountNotifier2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  CountNotifier2 create() => _createCb?.call() ?? CountNotifier2();

  @$internal
  @override
  CountNotifier2Provider $copyWithCreate(
    CountNotifier2 Function() create,
  ) {
    return CountNotifier2Provider._(
        argument: argument as int,
        from: from! as CountNotifier2Family,
        create: create);
  }

  @$internal
  @override
  CountNotifier2Provider $copyWithBuild(
    int Function(
      Ref<int>,
      CountNotifier2,
    ) build,
  ) {
    return CountNotifier2Provider._(
        argument: argument as int,
        from: from! as CountNotifier2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<CountNotifier2, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is CountNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countNotifier2Hash() => r'ef12bb4f94add336804ae43bcdbcd8e9b0bec420';

final class CountNotifier2Family extends Family {
  const CountNotifier2Family._()
      : super(
          name: r'myFamilyCountNotifier2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountNotifier2Provider call(
    int a,
  ) =>
      CountNotifier2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$countNotifier2Hash();

  @override
  String toString() => r'myFamilyCountNotifier2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    CountNotifier2 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref<int> ref, CountNotifier2 notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$CountNotifier2 extends $Notifier<int> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;
  int get a => _$args;

  int build(
    int a,
  );
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

@ProviderFor(CountAsyncNotifier2)
const myFamilyCountAsyncNotifier2ProviderFamily = CountAsyncNotifier2Family._();

final class CountAsyncNotifier2Provider
    extends $AsyncNotifierProvider<CountAsyncNotifier2, int> {
  const CountAsyncNotifier2Provider._(
      {required CountAsyncNotifier2Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      CountAsyncNotifier2 Function()? create})
      : _createCb = create,
        super(
          name: r'myFamilyCountAsyncNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountAsyncNotifier2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countAsyncNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountAsyncNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  CountAsyncNotifier2 create() => _createCb?.call() ?? CountAsyncNotifier2();

  @$internal
  @override
  CountAsyncNotifier2Provider $copyWithCreate(
    CountAsyncNotifier2 Function() create,
  ) {
    return CountAsyncNotifier2Provider._(
        argument: argument as int,
        from: from! as CountAsyncNotifier2Family,
        create: create);
  }

  @$internal
  @override
  CountAsyncNotifier2Provider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      CountAsyncNotifier2,
    ) build,
  ) {
    return CountAsyncNotifier2Provider._(
        argument: argument as int,
        from: from! as CountAsyncNotifier2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<CountAsyncNotifier2, int> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is CountAsyncNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countAsyncNotifier2Hash() =>
    r'e4bd4d858edbb47fa0d7581f3cfa72e13c914d3d';

final class CountAsyncNotifier2Family extends Family {
  const CountAsyncNotifier2Family._()
      : super(
          name: r'myFamilyCountAsyncNotifier2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountAsyncNotifier2Provider call(
    int a,
  ) =>
      CountAsyncNotifier2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$countAsyncNotifier2Hash();

  @override
  String toString() => r'myFamilyCountAsyncNotifier2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    CountAsyncNotifier2 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountAsyncNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function(Ref<AsyncValue<int>> ref,
            CountAsyncNotifier2 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountAsyncNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$CountAsyncNotifier2 extends $AsyncNotifier<int> {
  late final _$args =
      (ref as $AsyncNotifierProviderElement).origin.argument as int;
  int get a => _$args;

  FutureOr<int> build(
    int a,
  );
  @$internal
  @override
  FutureOr<int> runBuild() => build(
        _$args,
      );
}

@ProviderFor(CountStreamNotifier2)
const myFamilyCountStreamNotifier2ProviderFamily =
    CountStreamNotifier2Family._();

final class CountStreamNotifier2Provider
    extends $StreamNotifierProvider<CountStreamNotifier2, int> {
  const CountStreamNotifier2Provider._(
      {required CountStreamNotifier2Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      CountStreamNotifier2 Function()? create})
      : _createCb = create,
        super(
          name: r'myFamilyCountStreamNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CountStreamNotifier2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$countStreamNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountStreamNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  CountStreamNotifier2 create() => _createCb?.call() ?? CountStreamNotifier2();

  @$internal
  @override
  CountStreamNotifier2Provider $copyWithCreate(
    CountStreamNotifier2 Function() create,
  ) {
    return CountStreamNotifier2Provider._(
        argument: argument as int,
        from: from! as CountStreamNotifier2Family,
        create: create);
  }

  @$internal
  @override
  CountStreamNotifier2Provider $copyWithBuild(
    Stream<int> Function(
      Ref<AsyncValue<int>>,
      CountStreamNotifier2,
    ) build,
  ) {
    return CountStreamNotifier2Provider._(
        argument: argument as int,
        from: from! as CountStreamNotifier2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<CountStreamNotifier2, int> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is CountStreamNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countStreamNotifier2Hash() =>
    r'13be1b7aa32801b33c68f2a228851d2fb6a4a9ee';

final class CountStreamNotifier2Family extends Family {
  const CountStreamNotifier2Family._()
      : super(
          name: r'myFamilyCountStreamNotifier2ProviderFamily',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountStreamNotifier2Provider call(
    int a,
  ) =>
      CountStreamNotifier2Provider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$countStreamNotifier2Hash();

  @override
  String toString() => r'myFamilyCountStreamNotifier2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    CountStreamNotifier2 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountStreamNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<int> Function(Ref<AsyncValue<int>> ref,
            CountStreamNotifier2 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as CountStreamNotifier2Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$CountStreamNotifier2 extends $StreamNotifier<int> {
  late final _$args =
      (ref as $StreamNotifierProviderElement).origin.argument as int;
  int get a => _$args;

  Stream<int> build(
    int a,
  );
  @$internal
  @override
  Stream<int> runBuild() => build(
        _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
