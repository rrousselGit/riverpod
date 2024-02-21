// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsupported_provider_value.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef IntegerRef = Ref<int>;

@ProviderFor(integer)
const integerProvider = IntegerProvider._();

final class IntegerProvider extends $FunctionalProvider<int, int, IntegerRef>
    with $Provider<int, IntegerRef> {
  const IntegerProvider._(
      {int Function(
        IntegerRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'integerProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    IntegerRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$integerHash();

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
  IntegerProvider $copyWithCreate(
    int Function(
      IntegerRef ref,
    ) create,
  ) {
    return IntegerProvider._(create: create);
  }

  @override
  int create(IntegerRef ref) {
    final _$cb = _createCb ?? integer;
    return _$cb(ref);
  }
}

String _$integerHash() => r'a8ce0296e677f64c8b9d1893eed85598c096765e';

typedef StateNotifierRef = Ref<MyStateNotifier>;

@ProviderFor(stateNotifier)
const stateNotifierProvider = StateNotifierProvider._();

final class StateNotifierProvider extends $FunctionalProvider<
    MyStateNotifier,
    MyStateNotifier,
    StateNotifierRef> with $Provider<MyStateNotifier, StateNotifierRef> {
  const StateNotifierProvider._(
      {MyStateNotifier Function(
        StateNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'stateNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyStateNotifier Function(
    StateNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$stateNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyStateNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyStateNotifier>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyStateNotifier> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  StateNotifierProvider $copyWithCreate(
    MyStateNotifier Function(
      StateNotifierRef ref,
    ) create,
  ) {
    return StateNotifierProvider._(create: create);
  }

  @override
  MyStateNotifier create(StateNotifierRef ref) {
    final _$cb = _createCb ?? stateNotifier;
    return _$cb(ref);
  }
}

String _$stateNotifierHash() => r'5d517187bf927e19246ffbcc279d59e15df8ef30';

typedef AsyncStateNotifierRef = Ref<AsyncValue<MyStateNotifier>>;

@ProviderFor(asyncStateNotifier)
const asyncStateNotifierProvider = AsyncStateNotifierProvider._();

final class AsyncStateNotifierProvider extends $FunctionalProvider<
        AsyncValue<MyStateNotifier>,
        FutureOr<MyStateNotifier>,
        AsyncStateNotifierRef>
    with
        $FutureModifier<MyStateNotifier>,
        $FutureProvider<MyStateNotifier, AsyncStateNotifierRef> {
  const AsyncStateNotifierProvider._(
      {FutureOr<MyStateNotifier> Function(
        AsyncStateNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'asyncStateNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<MyStateNotifier> Function(
    AsyncStateNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$asyncStateNotifierHash();

  @$internal
  @override
  $FutureProviderElement<MyStateNotifier> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  AsyncStateNotifierProvider $copyWithCreate(
    FutureOr<MyStateNotifier> Function(
      AsyncStateNotifierRef ref,
    ) create,
  ) {
    return AsyncStateNotifierProvider._(create: create);
  }

  @override
  FutureOr<MyStateNotifier> create(AsyncStateNotifierRef ref) {
    final _$cb = _createCb ?? asyncStateNotifier;
    return _$cb(ref);
  }
}

String _$asyncStateNotifierHash() =>
    r'66442390f13e38cd9594f841a7610ab0f632db81';

typedef StateNotifierAsyncRef = Ref<AsyncValue<MyStateNotifier>>;

@ProviderFor(stateNotifierAsync)
const stateNotifierAsyncProvider = StateNotifierAsyncProvider._();

final class StateNotifierAsyncProvider extends $FunctionalProvider<
        AsyncValue<MyStateNotifier>,
        FutureOr<MyStateNotifier>,
        StateNotifierAsyncRef>
    with
        $FutureModifier<MyStateNotifier>,
        $FutureProvider<MyStateNotifier, StateNotifierAsyncRef> {
  const StateNotifierAsyncProvider._(
      {FutureOr<MyStateNotifier> Function(
        StateNotifierAsyncRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'stateNotifierAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<MyStateNotifier> Function(
    StateNotifierAsyncRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$stateNotifierAsyncHash();

  @$internal
  @override
  $FutureProviderElement<MyStateNotifier> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  StateNotifierAsyncProvider $copyWithCreate(
    FutureOr<MyStateNotifier> Function(
      StateNotifierAsyncRef ref,
    ) create,
  ) {
    return StateNotifierAsyncProvider._(create: create);
  }

  @override
  FutureOr<MyStateNotifier> create(StateNotifierAsyncRef ref) {
    final _$cb = _createCb ?? stateNotifierAsync;
    return _$cb(ref);
  }
}

String _$stateNotifierAsyncHash() =>
    r'9a9b1986076dfdfa4490cc109f1bd0f112a7455c';

typedef ChangeNotifierRef = Ref<MyChangeNotifier>;

@ProviderFor(changeNotifier)
const changeNotifierProvider = ChangeNotifierProvider._();

final class ChangeNotifierProvider extends $FunctionalProvider<
    MyChangeNotifier,
    MyChangeNotifier,
    ChangeNotifierRef> with $Provider<MyChangeNotifier, ChangeNotifierRef> {
  const ChangeNotifierProvider._(
      {MyChangeNotifier Function(
        ChangeNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'changeNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyChangeNotifier Function(
    ChangeNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$changeNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyChangeNotifier>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyChangeNotifier> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ChangeNotifierProvider $copyWithCreate(
    MyChangeNotifier Function(
      ChangeNotifierRef ref,
    ) create,
  ) {
    return ChangeNotifierProvider._(create: create);
  }

  @override
  MyChangeNotifier create(ChangeNotifierRef ref) {
    final _$cb = _createCb ?? changeNotifier;
    return _$cb(ref);
  }
}

String _$changeNotifierHash() => r'6325328c129773979364c3cfd628f8f696bbaf66';

typedef NotifierRef = Ref<MyNotifier>;

@ProviderFor(notifier)
const notifierProvider = NotifierProvider._();

final class NotifierProvider
    extends $FunctionalProvider<MyNotifier, MyNotifier, NotifierRef>
    with $Provider<MyNotifier, NotifierRef> {
  const NotifierProvider._(
      {MyNotifier Function(
        NotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function(
    NotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyNotifier>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyNotifier> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  NotifierProvider $copyWithCreate(
    MyNotifier Function(
      NotifierRef ref,
    ) create,
  ) {
    return NotifierProvider._(create: create);
  }

  @override
  MyNotifier create(NotifierRef ref) {
    final _$cb = _createCb ?? notifier;
    return _$cb(ref);
  }
}

String _$notifierHash() => r'2f323c78400044790faaf61912fc98c6153942f6';

typedef AutoDisposeNotifierRef = Ref<MyAutoDisposeNotifier>;

@ProviderFor(autoDisposeNotifier)
const autoDisposeNotifierProvider = AutoDisposeNotifierProvider._();

final class AutoDisposeNotifierProvider extends $FunctionalProvider<
        MyAutoDisposeNotifier, MyAutoDisposeNotifier, AutoDisposeNotifierRef>
    with $Provider<MyAutoDisposeNotifier, AutoDisposeNotifierRef> {
  const AutoDisposeNotifierProvider._(
      {MyAutoDisposeNotifier Function(
        AutoDisposeNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'autoDisposeNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyAutoDisposeNotifier Function(
    AutoDisposeNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$autoDisposeNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAutoDisposeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyAutoDisposeNotifier>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyAutoDisposeNotifier> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AutoDisposeNotifierProvider $copyWithCreate(
    MyAutoDisposeNotifier Function(
      AutoDisposeNotifierRef ref,
    ) create,
  ) {
    return AutoDisposeNotifierProvider._(create: create);
  }

  @override
  MyAutoDisposeNotifier create(AutoDisposeNotifierRef ref) {
    final _$cb = _createCb ?? autoDisposeNotifier;
    return _$cb(ref);
  }
}

String _$autoDisposeNotifierHash() =>
    r'620df0fc11c887f01e125454afe8de553cfea6d0';

typedef AsyncNotifierRef = Ref<MyAsyncNotifier>;

@ProviderFor(asyncNotifier)
const asyncNotifierProvider = AsyncNotifierProvider._();

final class AsyncNotifierProvider extends $FunctionalProvider<
    MyAsyncNotifier,
    MyAsyncNotifier,
    AsyncNotifierRef> with $Provider<MyAsyncNotifier, AsyncNotifierRef> {
  const AsyncNotifierProvider._(
      {MyAsyncNotifier Function(
        AsyncNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'asyncNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyAsyncNotifier Function(
    AsyncNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$asyncNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAsyncNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyAsyncNotifier>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyAsyncNotifier> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AsyncNotifierProvider $copyWithCreate(
    MyAsyncNotifier Function(
      AsyncNotifierRef ref,
    ) create,
  ) {
    return AsyncNotifierProvider._(create: create);
  }

  @override
  MyAsyncNotifier create(AsyncNotifierRef ref) {
    final _$cb = _createCb ?? asyncNotifier;
    return _$cb(ref);
  }
}

String _$asyncNotifierHash() => r'c90348efac71d241468236924f6c6bc80ae0d0e0';

typedef RawNotifierRef = Ref<Raw<MyChangeNotifier>>;

@ProviderFor(rawNotifier)
const rawNotifierProvider = RawNotifierProvider._();

final class RawNotifierProvider extends $FunctionalProvider<
    Raw<MyChangeNotifier>,
    Raw<MyChangeNotifier>,
    RawNotifierRef> with $Provider<Raw<MyChangeNotifier>, RawNotifierRef> {
  const RawNotifierProvider._(
      {Raw<MyChangeNotifier> Function(
        RawNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<MyChangeNotifier> Function(
    RawNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<MyChangeNotifier> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<MyChangeNotifier>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<MyChangeNotifier>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawNotifierProvider $copyWithCreate(
    Raw<MyChangeNotifier> Function(
      RawNotifierRef ref,
    ) create,
  ) {
    return RawNotifierProvider._(create: create);
  }

  @override
  Raw<MyChangeNotifier> create(RawNotifierRef ref) {
    final _$cb = _createCb ?? rawNotifier;
    return _$cb(ref);
  }
}

String _$rawNotifierHash() => r'c01adc70a8e08258bf5d13024aa8e9b86359a2b2';

typedef RawFutureNotifierRef = Ref<Raw<Future<MyChangeNotifier>>>;

@ProviderFor(rawFutureNotifier)
const rawFutureNotifierProvider = RawFutureNotifierProvider._();

final class RawFutureNotifierProvider extends $FunctionalProvider<
        Raw<Future<MyChangeNotifier>>,
        Raw<Future<MyChangeNotifier>>,
        RawFutureNotifierRef>
    with $Provider<Raw<Future<MyChangeNotifier>>, RawFutureNotifierRef> {
  const RawFutureNotifierProvider._(
      {Raw<Future<MyChangeNotifier>> Function(
        RawFutureNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawFutureNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Future<MyChangeNotifier>> Function(
    RawFutureNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawFutureNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<MyChangeNotifier>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<MyChangeNotifier>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Future<MyChangeNotifier>>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawFutureNotifierProvider $copyWithCreate(
    Raw<Future<MyChangeNotifier>> Function(
      RawFutureNotifierRef ref,
    ) create,
  ) {
    return RawFutureNotifierProvider._(create: create);
  }

  @override
  Raw<Future<MyChangeNotifier>> create(RawFutureNotifierRef ref) {
    final _$cb = _createCb ?? rawFutureNotifier;
    return _$cb(ref);
  }
}

String _$rawFutureNotifierHash() => r'883253dbf7ade868c44b288ec3da02be64dcfb20';

typedef RawStreamNotifierRef = Ref<Raw<Stream<MyChangeNotifier>>>;

@ProviderFor(rawStreamNotifier)
const rawStreamNotifierProvider = RawStreamNotifierProvider._();

final class RawStreamNotifierProvider extends $FunctionalProvider<
        Raw<Stream<MyChangeNotifier>>,
        Raw<Stream<MyChangeNotifier>>,
        RawStreamNotifierRef>
    with $Provider<Raw<Stream<MyChangeNotifier>>, RawStreamNotifierRef> {
  const RawStreamNotifierProvider._(
      {Raw<Stream<MyChangeNotifier>> Function(
        RawStreamNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawStreamNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<MyChangeNotifier>> Function(
    RawStreamNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<MyChangeNotifier>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<MyChangeNotifier>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Stream<MyChangeNotifier>>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawStreamNotifierProvider $copyWithCreate(
    Raw<Stream<MyChangeNotifier>> Function(
      RawStreamNotifierRef ref,
    ) create,
  ) {
    return RawStreamNotifierProvider._(create: create);
  }

  @override
  Raw<Stream<MyChangeNotifier>> create(RawStreamNotifierRef ref) {
    final _$cb = _createCb ?? rawStreamNotifier;
    return _$cb(ref);
  }
}

String _$rawStreamNotifierHash() => r'f22f6a906e275c6245365bf029e2dc217cf3a301';

typedef FutureRawNotifierRef = Ref<AsyncValue<Raw<MyChangeNotifier>>>;

@ProviderFor(futureRawNotifier)
const futureRawNotifierProvider = FutureRawNotifierProvider._();

final class FutureRawNotifierProvider extends $FunctionalProvider<
        AsyncValue<Raw<MyChangeNotifier>>,
        FutureOr<Raw<MyChangeNotifier>>,
        FutureRawNotifierRef>
    with
        $FutureModifier<Raw<MyChangeNotifier>>,
        $FutureProvider<Raw<MyChangeNotifier>, FutureRawNotifierRef> {
  const FutureRawNotifierProvider._(
      {FutureOr<Raw<MyChangeNotifier>> Function(
        FutureRawNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'futureRawNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Raw<MyChangeNotifier>> Function(
    FutureRawNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$futureRawNotifierHash();

  @$internal
  @override
  $FutureProviderElement<Raw<MyChangeNotifier>> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  FutureRawNotifierProvider $copyWithCreate(
    FutureOr<Raw<MyChangeNotifier>> Function(
      FutureRawNotifierRef ref,
    ) create,
  ) {
    return FutureRawNotifierProvider._(create: create);
  }

  @override
  FutureOr<Raw<MyChangeNotifier>> create(FutureRawNotifierRef ref) {
    final _$cb = _createCb ?? futureRawNotifier;
    return _$cb(ref);
  }
}

String _$futureRawNotifierHash() => r'd70ca757ff2539fc698ff924c135ee5e88a98018';

typedef StreamRawNotifierRef = Ref<AsyncValue<Raw<MyChangeNotifier>>>;

@ProviderFor(streamRawNotifier)
const streamRawNotifierProvider = StreamRawNotifierProvider._();

final class StreamRawNotifierProvider extends $FunctionalProvider<
        AsyncValue<Raw<MyChangeNotifier>>,
        Stream<Raw<MyChangeNotifier>>,
        StreamRawNotifierRef>
    with
        $FutureModifier<Raw<MyChangeNotifier>>,
        $StreamProvider<Raw<MyChangeNotifier>, StreamRawNotifierRef> {
  const StreamRawNotifierProvider._(
      {Stream<Raw<MyChangeNotifier>> Function(
        StreamRawNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'streamRawNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<Raw<MyChangeNotifier>> Function(
    StreamRawNotifierRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$streamRawNotifierHash();

  @$internal
  @override
  $StreamProviderElement<Raw<MyChangeNotifier>> $createElement(
          ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  StreamRawNotifierProvider $copyWithCreate(
    Stream<Raw<MyChangeNotifier>> Function(
      StreamRawNotifierRef ref,
    ) create,
  ) {
    return StreamRawNotifierProvider._(create: create);
  }

  @override
  Stream<Raw<MyChangeNotifier>> create(StreamRawNotifierRef ref) {
    final _$cb = _createCb ?? streamRawNotifier;
    return _$cb(ref);
  }
}

String _$streamRawNotifierHash() => r'b1075c37ef3e8a83dfb9a3d469b76bd4855c336f';

@ProviderFor(StateNotifierClass)
const stateNotifierClassProvider = StateNotifierClassProvider._();

final class StateNotifierClassProvider
    extends $NotifierProvider<StateNotifierClass, MyStateNotifier> {
  const StateNotifierClassProvider._(
      {super.runNotifierBuildOverride, StateNotifierClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'stateNotifierClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final StateNotifierClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$stateNotifierClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyStateNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyStateNotifier>(value),
    );
  }

  @$internal
  @override
  StateNotifierClass create() => _createCb?.call() ?? StateNotifierClass();

  @$internal
  @override
  StateNotifierClassProvider $copyWithCreate(
    StateNotifierClass Function() create,
  ) {
    return StateNotifierClassProvider._(create: create);
  }

  @$internal
  @override
  StateNotifierClassProvider $copyWithBuild(
    MyStateNotifier Function(
      Ref<MyStateNotifier>,
      StateNotifierClass,
    ) build,
  ) {
    return StateNotifierClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<StateNotifierClass, MyStateNotifier> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$stateNotifierClassHash() =>
    r'576978be5b8a02c212afe7afbe37c733a49ecbce';

abstract class _$StateNotifierClass extends $Notifier<MyStateNotifier> {
  MyStateNotifier build();
  @$internal
  @override
  MyStateNotifier runBuild() => build();
}

@ProviderFor(SelfNotifier)
const selfNotifierProvider = SelfNotifierProvider._();

final class SelfNotifierProvider
    extends $AsyncNotifierProvider<SelfNotifier, SelfNotifier> {
  const SelfNotifierProvider._(
      {super.runNotifierBuildOverride, SelfNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'selfNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SelfNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$selfNotifierHash();

  @$internal
  @override
  SelfNotifier create() => _createCb?.call() ?? SelfNotifier();

  @$internal
  @override
  SelfNotifierProvider $copyWithCreate(
    SelfNotifier Function() create,
  ) {
    return SelfNotifierProvider._(create: create);
  }

  @$internal
  @override
  SelfNotifierProvider $copyWithBuild(
    FutureOr<SelfNotifier> Function(
      Ref<AsyncValue<SelfNotifier>>,
      SelfNotifier,
    ) build,
  ) {
    return SelfNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<SelfNotifier, SelfNotifier> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);
}

String _$selfNotifierHash() => r'5a857f5c92a9b7a35daa4e527bd333cf3d8d19ac';

abstract class _$SelfNotifier extends $AsyncNotifier<SelfNotifier> {
  FutureOr<SelfNotifier> build();
  @$internal
  @override
  FutureOr<SelfNotifier> runBuild() => build();
}

@ProviderFor(SyncSelfNotifier)
const syncSelfNotifierProvider = SyncSelfNotifierProvider._();

final class SyncSelfNotifierProvider
    extends $NotifierProvider<SyncSelfNotifier, SyncSelfNotifier> {
  const SyncSelfNotifierProvider._(
      {super.runNotifierBuildOverride, SyncSelfNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'syncSelfNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SyncSelfNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$syncSelfNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncSelfNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<SyncSelfNotifier>(value),
    );
  }

  @$internal
  @override
  SyncSelfNotifier create() => _createCb?.call() ?? SyncSelfNotifier();

  @$internal
  @override
  SyncSelfNotifierProvider $copyWithCreate(
    SyncSelfNotifier Function() create,
  ) {
    return SyncSelfNotifierProvider._(create: create);
  }

  @$internal
  @override
  SyncSelfNotifierProvider $copyWithBuild(
    SyncSelfNotifier Function(
      Ref<SyncSelfNotifier>,
      SyncSelfNotifier,
    ) build,
  ) {
    return SyncSelfNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<SyncSelfNotifier, SyncSelfNotifier> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$syncSelfNotifierHash() => r'4f3a2463cb5693a5c8d7e772b4d7c9774b9ba637';

abstract class _$SyncSelfNotifier extends $Notifier<SyncSelfNotifier> {
  SyncSelfNotifier build();
  @$internal
  @override
  SyncSelfNotifier runBuild() => build();
}

@ProviderFor(StreamSelfNotifier)
const streamSelfNotifierProvider = StreamSelfNotifierProvider._();

final class StreamSelfNotifierProvider
    extends $StreamNotifierProvider<StreamSelfNotifier, StreamSelfNotifier> {
  const StreamSelfNotifierProvider._(
      {super.runNotifierBuildOverride, StreamSelfNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'streamSelfNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final StreamSelfNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$streamSelfNotifierHash();

  @$internal
  @override
  StreamSelfNotifier create() => _createCb?.call() ?? StreamSelfNotifier();

  @$internal
  @override
  StreamSelfNotifierProvider $copyWithCreate(
    StreamSelfNotifier Function() create,
  ) {
    return StreamSelfNotifierProvider._(create: create);
  }

  @$internal
  @override
  StreamSelfNotifierProvider $copyWithBuild(
    Stream<StreamSelfNotifier> Function(
      Ref<AsyncValue<StreamSelfNotifier>>,
      StreamSelfNotifier,
    ) build,
  ) {
    return StreamSelfNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<StreamSelfNotifier, StreamSelfNotifier>
      $createElement(ProviderContainer container) =>
          $StreamNotifierProviderElement(this, container);
}

String _$streamSelfNotifierHash() =>
    r'18705475d157d8e592205406c0b884b7213d329e';

abstract class _$StreamSelfNotifier
    extends $StreamNotifier<StreamSelfNotifier> {
  Stream<StreamSelfNotifier> build();
  @$internal
  @override
  Stream<StreamSelfNotifier> runBuild() => build();
}

@ProviderFor(StateNotifierClassAsync)
const stateNotifierClassAsyncProvider = StateNotifierClassAsyncProvider._();

final class StateNotifierClassAsyncProvider
    extends $AsyncNotifierProvider<StateNotifierClassAsync, MyStateNotifier> {
  const StateNotifierClassAsyncProvider._(
      {super.runNotifierBuildOverride,
      StateNotifierClassAsync Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'stateNotifierClassAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final StateNotifierClassAsync Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$stateNotifierClassAsyncHash();

  @$internal
  @override
  StateNotifierClassAsync create() =>
      _createCb?.call() ?? StateNotifierClassAsync();

  @$internal
  @override
  StateNotifierClassAsyncProvider $copyWithCreate(
    StateNotifierClassAsync Function() create,
  ) {
    return StateNotifierClassAsyncProvider._(create: create);
  }

  @$internal
  @override
  StateNotifierClassAsyncProvider $copyWithBuild(
    FutureOr<MyStateNotifier> Function(
      Ref<AsyncValue<MyStateNotifier>>,
      StateNotifierClassAsync,
    ) build,
  ) {
    return StateNotifierClassAsyncProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<StateNotifierClassAsync, MyStateNotifier>
      $createElement(ProviderContainer container) =>
          $AsyncNotifierProviderElement(this, container);
}

String _$stateNotifierClassAsyncHash() =>
    r'06c519ed7dbdcd9440365dd2dc3ec12e603b6b7e';

abstract class _$StateNotifierClassAsync
    extends $AsyncNotifier<MyStateNotifier> {
  FutureOr<MyStateNotifier> build();
  @$internal
  @override
  FutureOr<MyStateNotifier> runBuild() => build();
}

@ProviderFor(ChangeNotifierClass)
const changeNotifierClassProvider = ChangeNotifierClassProvider._();

final class ChangeNotifierClassProvider
    extends $NotifierProvider<ChangeNotifierClass, MyChangeNotifier> {
  const ChangeNotifierClassProvider._(
      {super.runNotifierBuildOverride, ChangeNotifierClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'changeNotifierClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ChangeNotifierClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$changeNotifierClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyChangeNotifier>(value),
    );
  }

  @$internal
  @override
  ChangeNotifierClass create() => _createCb?.call() ?? ChangeNotifierClass();

  @$internal
  @override
  ChangeNotifierClassProvider $copyWithCreate(
    ChangeNotifierClass Function() create,
  ) {
    return ChangeNotifierClassProvider._(create: create);
  }

  @$internal
  @override
  ChangeNotifierClassProvider $copyWithBuild(
    MyChangeNotifier Function(
      Ref<MyChangeNotifier>,
      ChangeNotifierClass,
    ) build,
  ) {
    return ChangeNotifierClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ChangeNotifierClass, MyChangeNotifier>
      $createElement(ProviderContainer container) =>
          $NotifierProviderElement(this, container);
}

String _$changeNotifierClassHash() =>
    r'c9716469ce2f8e7a1a6063587ae8733999e51a6e';

abstract class _$ChangeNotifierClass extends $Notifier<MyChangeNotifier> {
  MyChangeNotifier build();
  @$internal
  @override
  MyChangeNotifier runBuild() => build();
}

@ProviderFor(NotifierClass)
const notifierClassProvider = NotifierClassProvider._();

final class NotifierClassProvider
    extends $NotifierProvider<NotifierClass, MyNotifier> {
  const NotifierClassProvider._(
      {super.runNotifierBuildOverride, NotifierClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notifierClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final NotifierClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notifierClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyNotifier>(value),
    );
  }

  @$internal
  @override
  NotifierClass create() => _createCb?.call() ?? NotifierClass();

  @$internal
  @override
  NotifierClassProvider $copyWithCreate(
    NotifierClass Function() create,
  ) {
    return NotifierClassProvider._(create: create);
  }

  @$internal
  @override
  NotifierClassProvider $copyWithBuild(
    MyNotifier Function(
      Ref<MyNotifier>,
      NotifierClass,
    ) build,
  ) {
    return NotifierClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NotifierClass, MyNotifier> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$notifierClassHash() => r'e7eefebec2fca4f982582449e7ec14322932b748';

abstract class _$NotifierClass extends $Notifier<MyNotifier> {
  MyNotifier build();
  @$internal
  @override
  MyNotifier runBuild() => build();
}

@ProviderFor(AsyncNotifierClass)
const asyncNotifierClassProvider = AsyncNotifierClassProvider._();

final class AsyncNotifierClassProvider
    extends $NotifierProvider<AsyncNotifierClass, MyAsyncNotifier> {
  const AsyncNotifierClassProvider._(
      {super.runNotifierBuildOverride, AsyncNotifierClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'asyncNotifierClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AsyncNotifierClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$asyncNotifierClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAsyncNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyAsyncNotifier>(value),
    );
  }

  @$internal
  @override
  AsyncNotifierClass create() => _createCb?.call() ?? AsyncNotifierClass();

  @$internal
  @override
  AsyncNotifierClassProvider $copyWithCreate(
    AsyncNotifierClass Function() create,
  ) {
    return AsyncNotifierClassProvider._(create: create);
  }

  @$internal
  @override
  AsyncNotifierClassProvider $copyWithBuild(
    MyAsyncNotifier Function(
      Ref<MyAsyncNotifier>,
      AsyncNotifierClass,
    ) build,
  ) {
    return AsyncNotifierClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AsyncNotifierClass, MyAsyncNotifier> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$asyncNotifierClassHash() =>
    r'815a238752d324b136166c409a39fd3f0db67267';

abstract class _$AsyncNotifierClass extends $Notifier<MyAsyncNotifier> {
  MyAsyncNotifier build();
  @$internal
  @override
  MyAsyncNotifier runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
