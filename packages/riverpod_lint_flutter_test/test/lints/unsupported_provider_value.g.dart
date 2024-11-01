// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsupported_provider_value.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef IntegerRef = Ref<int>;

@ProviderFor(integer)
const integerProvider = IntegerProvider._();

final class IntegerProvider extends $FunctionalProvider<int, int>
    with $Provider<int, IntegerRef> {
  const IntegerProvider._(
      {int Function(
        IntegerRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$integerHash() => r'8ad63bb35c89ffcf2ef281d7c39539760afff303';

typedef StateNotifierRef = Ref<MyStateNotifier>;

@ProviderFor(stateNotifier)
const stateNotifierProvider = StateNotifierProvider._();

final class StateNotifierProvider
    extends $FunctionalProvider<MyStateNotifier, MyStateNotifier>
    with $Provider<MyStateNotifier, StateNotifierRef> {
  const StateNotifierProvider._(
      {MyStateNotifier Function(
        StateNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<MyStateNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$stateNotifierHash() => r'2505b564fd3a623976548c715b1623dea507f6d3';

typedef AsyncStateNotifierRef = Ref<AsyncValue<MyStateNotifier>>;

@ProviderFor(asyncStateNotifier)
const asyncStateNotifierProvider = AsyncStateNotifierProvider._();

final class AsyncStateNotifierProvider extends $FunctionalProvider<
        AsyncValue<MyStateNotifier>, FutureOr<MyStateNotifier>>
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
          retry: null,
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

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
    r'5c5954eb030f5688abdf881e047c8893c864b1a2';

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
          retry: null,
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
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$stateNotifierClassHash() =>
    r'576978be5b8a02c212afe7afbe37c733a49ecbce';

abstract class _$StateNotifierClass extends $Notifier<MyStateNotifier> {
  MyStateNotifier build();
  @$internal
  @override
  MyStateNotifier runBuild() => build();
}

typedef StateNotifierAsyncRef = Ref<AsyncValue<MyStateNotifier>>;

@ProviderFor(stateNotifierAsync)
const stateNotifierAsyncProvider = StateNotifierAsyncProvider._();

final class StateNotifierAsyncProvider extends $FunctionalProvider<
        AsyncValue<MyStateNotifier>, FutureOr<MyStateNotifier>>
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
          retry: null,
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

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
    r'ce67cf8c6f4bda46835042c17ea01186b5b399a5';

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
          retry: null,
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
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
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
          retry: null,
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
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
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
          retry: null,
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
      $createElement($ProviderPointer pointer) =>
          $StreamNotifierProviderElement(this, pointer);
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
          retry: null,
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
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(this, pointer);
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

typedef ChangeNotifierRef = Ref<MyChangeNotifier>;

@ProviderFor(changeNotifier)
const changeNotifierProvider = ChangeNotifierProvider._();

final class ChangeNotifierProvider
    extends $FunctionalProvider<MyChangeNotifier, MyChangeNotifier>
    with $Provider<MyChangeNotifier, ChangeNotifierRef> {
  const ChangeNotifierProvider._(
      {MyChangeNotifier Function(
        ChangeNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<MyChangeNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$changeNotifierHash() => r'1686043b72e25b3143c5131906924f1393569400';

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
          retry: null,
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
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$changeNotifierClassHash() =>
    r'c9716469ce2f8e7a1a6063587ae8733999e51a6e';

abstract class _$ChangeNotifierClass extends $Notifier<MyChangeNotifier> {
  MyChangeNotifier build();
  @$internal
  @override
  MyChangeNotifier runBuild() => build();
}

typedef NotifierRef = Ref<MyNotifier>;

@ProviderFor(notifier)
const notifierProvider = NotifierProvider._();

final class NotifierProvider extends $FunctionalProvider<MyNotifier, MyNotifier>
    with $Provider<MyNotifier, NotifierRef> {
  const NotifierProvider._(
      {MyNotifier Function(
        NotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<MyNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$notifierHash() => r'5ad63d9ccd05ab78e7a6ba5c763cacf0b1decb7b';

typedef AutoDisposeNotifierRef = Ref<MyAutoDisposeNotifier>;

@ProviderFor(autoDisposeNotifier)
const autoDisposeNotifierProvider = AutoDisposeNotifierProvider._();

final class AutoDisposeNotifierProvider
    extends $FunctionalProvider<MyAutoDisposeNotifier, MyAutoDisposeNotifier>
    with $Provider<MyAutoDisposeNotifier, AutoDisposeNotifierRef> {
  const AutoDisposeNotifierProvider._(
      {MyAutoDisposeNotifier Function(
        AutoDisposeNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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
    r'6aecd9dee1e2734c3acf8eab05145418d10656e1';

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
          retry: null,
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
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$notifierClassHash() => r'e7eefebec2fca4f982582449e7ec14322932b748';

abstract class _$NotifierClass extends $Notifier<MyNotifier> {
  MyNotifier build();
  @$internal
  @override
  MyNotifier runBuild() => build();
}

typedef AsyncNotifierRef = Ref<MyAsyncNotifier>;

@ProviderFor(asyncNotifier)
const asyncNotifierProvider = AsyncNotifierProvider._();

final class AsyncNotifierProvider
    extends $FunctionalProvider<MyAsyncNotifier, MyAsyncNotifier>
    with $Provider<MyAsyncNotifier, AsyncNotifierRef> {
  const AsyncNotifierProvider._(
      {MyAsyncNotifier Function(
        AsyncNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<MyAsyncNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$asyncNotifierHash() => r'8800a97f6bf80a56caf5d968d4b4ab91f7f0a64e';

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
          retry: null,
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
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$asyncNotifierClassHash() =>
    r'815a238752d324b136166c409a39fd3f0db67267';

abstract class _$AsyncNotifierClass extends $Notifier<MyAsyncNotifier> {
  MyAsyncNotifier build();
  @$internal
  @override
  MyAsyncNotifier runBuild() => build();
}

typedef RawNotifierRef = Ref<Raw<MyChangeNotifier>>;

@ProviderFor(rawNotifier)
const rawNotifierProvider = RawNotifierProvider._();

final class RawNotifierProvider
    extends $FunctionalProvider<Raw<MyChangeNotifier>, Raw<MyChangeNotifier>>
    with $Provider<Raw<MyChangeNotifier>, RawNotifierRef> {
  const RawNotifierProvider._(
      {Raw<MyChangeNotifier> Function(
        RawNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$rawNotifierHash() => r'c667d10419c9ce1fdd227e2afd1f3aaf63c3380b';

typedef RawFutureNotifierRef = Ref<Raw<Future<MyChangeNotifier>>>;

@ProviderFor(rawFutureNotifier)
const rawFutureNotifierProvider = RawFutureNotifierProvider._();

final class RawFutureNotifierProvider extends $FunctionalProvider<
        Raw<Future<MyChangeNotifier>>, Raw<Future<MyChangeNotifier>>>
    with $Provider<Raw<Future<MyChangeNotifier>>, RawFutureNotifierRef> {
  const RawFutureNotifierProvider._(
      {Raw<Future<MyChangeNotifier>> Function(
        RawFutureNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$rawFutureNotifierHash() => r'ff2744c369ebd96615f19451eae416d7afeef03f';

typedef RawStreamNotifierRef = Ref<Raw<Stream<MyChangeNotifier>>>;

@ProviderFor(rawStreamNotifier)
const rawStreamNotifierProvider = RawStreamNotifierProvider._();

final class RawStreamNotifierProvider extends $FunctionalProvider<
        Raw<Stream<MyChangeNotifier>>, Raw<Stream<MyChangeNotifier>>>
    with $Provider<Raw<Stream<MyChangeNotifier>>, RawStreamNotifierRef> {
  const RawStreamNotifierProvider._(
      {Raw<Stream<MyChangeNotifier>> Function(
        RawStreamNotifierRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
          $ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$rawStreamNotifierHash() => r'9a13efb8fbcef6c4388d5a2535b1b0aec6e46a9a';

typedef FutureRawNotifierRef = Ref<AsyncValue<Raw<MyChangeNotifier>>>;

@ProviderFor(futureRawNotifier)
const futureRawNotifierProvider = FutureRawNotifierProvider._();

final class FutureRawNotifierProvider extends $FunctionalProvider<
        AsyncValue<Raw<MyChangeNotifier>>, FutureOr<Raw<MyChangeNotifier>>>
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
          retry: null,
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

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

String _$futureRawNotifierHash() => r'87103845bce1f4cae4ad62ae3b7da6ca3539581f';

typedef StreamRawNotifierRef = Ref<AsyncValue<Raw<MyChangeNotifier>>>;

@ProviderFor(streamRawNotifier)
const streamRawNotifierProvider = StreamRawNotifierProvider._();

final class StreamRawNotifierProvider extends $FunctionalProvider<
        AsyncValue<Raw<MyChangeNotifier>>, Stream<Raw<MyChangeNotifier>>>
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
          retry: null,
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

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

String _$streamRawNotifierHash() => r'1d4abe389b7dfe1381879d8ffb174f6d1d9325e0';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
