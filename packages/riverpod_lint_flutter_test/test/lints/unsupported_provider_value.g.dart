// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsupported_provider_value.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(integer)
const integerProvider = IntegerProvider._();

final class IntegerProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const IntegerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'integerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$integerHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return integer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$integerHash() => r'8ad63bb35c89ffcf2ef281d7c39539760afff303';

@ProviderFor(stateNotifier)
const stateProvider = StateNotifierProvider._();

final class StateNotifierProvider
    extends
        $FunctionalProvider<MyStateNotifier, MyStateNotifier, MyStateNotifier>
    with $Provider<MyStateNotifier> {
  const StateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateNotifierHash();

  @$internal
  @override
  $ProviderElement<MyStateNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyStateNotifier create(Ref ref) {
    return stateNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyStateNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyStateNotifier>(value),
    );
  }
}

String _$stateNotifierHash() => r'2505b564fd3a623976548c715b1623dea507f6d3';

@ProviderFor(asyncStateNotifier)
const asyncStateProvider = AsyncStateNotifierProvider._();

final class AsyncStateNotifierProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyStateNotifier>,
          MyStateNotifier,
          FutureOr<MyStateNotifier>
        >
    with $FutureModifier<MyStateNotifier>, $FutureProvider<MyStateNotifier> {
  const AsyncStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncStateNotifierHash();

  @$internal
  @override
  $FutureProviderElement<MyStateNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MyStateNotifier> create(Ref ref) {
    return asyncStateNotifier(ref);
  }
}

String _$asyncStateNotifierHash() =>
    r'5c5954eb030f5688abdf881e047c8893c864b1a2';

@ProviderFor(StateNotifierClass)
const stateNotifierClassProvider = StateNotifierClassProvider._();

final class StateNotifierClassProvider
    extends $NotifierProvider<StateNotifierClass, MyStateNotifier> {
  const StateNotifierClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateNotifierClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateNotifierClassHash();

  @$internal
  @override
  StateNotifierClass create() => StateNotifierClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyStateNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyStateNotifier>(value),
    );
  }
}

String _$stateNotifierClassHash() =>
    r'576978be5b8a02c212afe7afbe37c733a49ecbce';

abstract class _$StateNotifierClass extends $Notifier<MyStateNotifier> {
  MyStateNotifier build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MyStateNotifier, MyStateNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyStateNotifier, MyStateNotifier>,
              MyStateNotifier,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(stateNotifierAsync)
const stateNotifierAsyncProvider = StateNotifierAsyncProvider._();

final class StateNotifierAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyStateNotifier>,
          MyStateNotifier,
          FutureOr<MyStateNotifier>
        >
    with $FutureModifier<MyStateNotifier>, $FutureProvider<MyStateNotifier> {
  const StateNotifierAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateNotifierAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateNotifierAsyncHash();

  @$internal
  @override
  $FutureProviderElement<MyStateNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MyStateNotifier> create(Ref ref) {
    return stateNotifierAsync(ref);
  }
}

String _$stateNotifierAsyncHash() =>
    r'ce67cf8c6f4bda46835042c17ea01186b5b399a5';

@ProviderFor(SelfNotifier)
const selfProvider = SelfNotifierProvider._();

final class SelfNotifierProvider
    extends $AsyncNotifierProvider<SelfNotifier, SelfNotifier> {
  const SelfNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selfProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selfNotifierHash();

  @$internal
  @override
  SelfNotifier create() => SelfNotifier();
}

String _$selfNotifierHash() => r'5a857f5c92a9b7a35daa4e527bd333cf3d8d19ac';

abstract class _$SelfNotifier extends $AsyncNotifier<SelfNotifier> {
  FutureOr<SelfNotifier> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SelfNotifier>, SelfNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SelfNotifier>, SelfNotifier>,
              AsyncValue<SelfNotifier>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SyncSelfNotifier)
const syncSelfProvider = SyncSelfNotifierProvider._();

final class SyncSelfNotifierProvider
    extends $NotifierProvider<SyncSelfNotifier, SyncSelfNotifier> {
  const SyncSelfNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncSelfProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncSelfNotifierHash();

  @$internal
  @override
  SyncSelfNotifier create() => SyncSelfNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncSelfNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncSelfNotifier>(value),
    );
  }
}

String _$syncSelfNotifierHash() => r'4f3a2463cb5693a5c8d7e772b4d7c9774b9ba637';

abstract class _$SyncSelfNotifier extends $Notifier<SyncSelfNotifier> {
  SyncSelfNotifier build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncSelfNotifier, SyncSelfNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncSelfNotifier, SyncSelfNotifier>,
              SyncSelfNotifier,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(StreamSelfNotifier)
const streamSelfProvider = StreamSelfNotifierProvider._();

final class StreamSelfNotifierProvider
    extends $StreamNotifierProvider<StreamSelfNotifier, StreamSelfNotifier> {
  const StreamSelfNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamSelfProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamSelfNotifierHash();

  @$internal
  @override
  StreamSelfNotifier create() => StreamSelfNotifier();
}

String _$streamSelfNotifierHash() =>
    r'18705475d157d8e592205406c0b884b7213d329e';

abstract class _$StreamSelfNotifier
    extends $StreamNotifier<StreamSelfNotifier> {
  Stream<StreamSelfNotifier> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StreamSelfNotifier>, StreamSelfNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StreamSelfNotifier>, StreamSelfNotifier>,
              AsyncValue<StreamSelfNotifier>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(StateNotifierClassAsync)
const stateNotifierClassAsyncProvider = StateNotifierClassAsyncProvider._();

final class StateNotifierClassAsyncProvider
    extends $AsyncNotifierProvider<StateNotifierClassAsync, MyStateNotifier> {
  const StateNotifierClassAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateNotifierClassAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateNotifierClassAsyncHash();

  @$internal
  @override
  StateNotifierClassAsync create() => StateNotifierClassAsync();
}

String _$stateNotifierClassAsyncHash() =>
    r'06c519ed7dbdcd9440365dd2dc3ec12e603b6b7e';

abstract class _$StateNotifierClassAsync
    extends $AsyncNotifier<MyStateNotifier> {
  FutureOr<MyStateNotifier> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MyStateNotifier>, MyStateNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MyStateNotifier>, MyStateNotifier>,
              AsyncValue<MyStateNotifier>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(changeNotifier)
const changeProvider = ChangeNotifierProvider._();

final class ChangeNotifierProvider
    extends
        $FunctionalProvider<
          MyChangeNotifier,
          MyChangeNotifier,
          MyChangeNotifier
        >
    with $Provider<MyChangeNotifier> {
  const ChangeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeNotifierHash();

  @$internal
  @override
  $ProviderElement<MyChangeNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyChangeNotifier create(Ref ref) {
    return changeNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyChangeNotifier>(value),
    );
  }
}

String _$changeNotifierHash() => r'1686043b72e25b3143c5131906924f1393569400';

@ProviderFor(ChangeNotifierClass)
const changeNotifierClassProvider = ChangeNotifierClassProvider._();

final class ChangeNotifierClassProvider
    extends $NotifierProvider<ChangeNotifierClass, MyChangeNotifier> {
  const ChangeNotifierClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeNotifierClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeNotifierClassHash();

  @$internal
  @override
  ChangeNotifierClass create() => ChangeNotifierClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyChangeNotifier>(value),
    );
  }
}

String _$changeNotifierClassHash() =>
    r'c9716469ce2f8e7a1a6063587ae8733999e51a6e';

abstract class _$ChangeNotifierClass extends $Notifier<MyChangeNotifier> {
  MyChangeNotifier build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MyChangeNotifier, MyChangeNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyChangeNotifier, MyChangeNotifier>,
              MyChangeNotifier,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(notifier)
const notifierProvider = NotifierProvider._();

final class NotifierProvider
    extends $FunctionalProvider<MyNotifier, MyNotifier, MyNotifier>
    with $Provider<MyNotifier> {
  const NotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notifierHash();

  @$internal
  @override
  $ProviderElement<MyNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyNotifier create(Ref ref) {
    return notifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyNotifier>(value),
    );
  }
}

String _$notifierHash() => r'5ad63d9ccd05ab78e7a6ba5c763cacf0b1decb7b';

@ProviderFor(autoDisposeNotifier)
const autoDisposeProvider = AutoDisposeNotifierProvider._();

final class AutoDisposeNotifierProvider
    extends
        $FunctionalProvider<
          MyAutoDisposeNotifier,
          MyAutoDisposeNotifier,
          MyAutoDisposeNotifier
        >
    with $Provider<MyAutoDisposeNotifier> {
  const AutoDisposeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDisposeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeNotifierHash();

  @$internal
  @override
  $ProviderElement<MyAutoDisposeNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MyAutoDisposeNotifier create(Ref ref) {
    return autoDisposeNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAutoDisposeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyAutoDisposeNotifier>(value),
    );
  }
}

String _$autoDisposeNotifierHash() =>
    r'6aecd9dee1e2734c3acf8eab05145418d10656e1';

@ProviderFor(NotifierClass)
const notifierClassProvider = NotifierClassProvider._();

final class NotifierClassProvider
    extends $NotifierProvider<NotifierClass, MyNotifier> {
  const NotifierClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notifierClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notifierClassHash();

  @$internal
  @override
  NotifierClass create() => NotifierClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyNotifier>(value),
    );
  }
}

String _$notifierClassHash() => r'e7eefebec2fca4f982582449e7ec14322932b748';

abstract class _$NotifierClass extends $Notifier<MyNotifier> {
  MyNotifier build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MyNotifier, MyNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyNotifier, MyNotifier>,
              MyNotifier,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(asyncNotifier)
const asyncProvider = AsyncNotifierProvider._();

final class AsyncNotifierProvider
    extends
        $FunctionalProvider<MyAsyncNotifier, MyAsyncNotifier, MyAsyncNotifier>
    with $Provider<MyAsyncNotifier> {
  const AsyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncNotifierHash();

  @$internal
  @override
  $ProviderElement<MyAsyncNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyAsyncNotifier create(Ref ref) {
    return asyncNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAsyncNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyAsyncNotifier>(value),
    );
  }
}

String _$asyncNotifierHash() => r'8800a97f6bf80a56caf5d968d4b4ab91f7f0a64e';

@ProviderFor(AsyncNotifierClass)
const asyncNotifierClassProvider = AsyncNotifierClassProvider._();

final class AsyncNotifierClassProvider
    extends $NotifierProvider<AsyncNotifierClass, MyAsyncNotifier> {
  const AsyncNotifierClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncNotifierClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncNotifierClassHash();

  @$internal
  @override
  AsyncNotifierClass create() => AsyncNotifierClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyAsyncNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyAsyncNotifier>(value),
    );
  }
}

String _$asyncNotifierClassHash() =>
    r'815a238752d324b136166c409a39fd3f0db67267';

abstract class _$AsyncNotifierClass extends $Notifier<MyAsyncNotifier> {
  MyAsyncNotifier build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MyAsyncNotifier, MyAsyncNotifier>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyAsyncNotifier, MyAsyncNotifier>,
              MyAsyncNotifier,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(rawNotifier)
const rawProvider = RawNotifierProvider._();

final class RawNotifierProvider
    extends
        $FunctionalProvider<
          Raw<MyChangeNotifier>,
          Raw<MyChangeNotifier>,
          Raw<MyChangeNotifier>
        >
    with $Provider<Raw<MyChangeNotifier>> {
  const RawNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawNotifierHash();

  @$internal
  @override
  $ProviderElement<Raw<MyChangeNotifier>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<MyChangeNotifier> create(Ref ref) {
    return rawNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<MyChangeNotifier> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<MyChangeNotifier>>(value),
    );
  }
}

String _$rawNotifierHash() => r'c667d10419c9ce1fdd227e2afd1f3aaf63c3380b';

@ProviderFor(rawFutureNotifier)
const rawFutureProvider = RawFutureNotifierProvider._();

final class RawFutureNotifierProvider
    extends
        $FunctionalProvider<
          Raw<Future<MyChangeNotifier>>,
          Raw<Future<MyChangeNotifier>>,
          Raw<Future<MyChangeNotifier>>
        >
    with $Provider<Raw<Future<MyChangeNotifier>>> {
  const RawFutureNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$rawFutureNotifierHash();

  @$internal
  @override
  $ProviderElement<Raw<Future<MyChangeNotifier>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Future<MyChangeNotifier>> create(Ref ref) {
    return rawFutureNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<MyChangeNotifier>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<MyChangeNotifier>>>(
        value,
      ),
    );
  }
}

String _$rawFutureNotifierHash() => r'ff2744c369ebd96615f19451eae416d7afeef03f';

@ProviderFor(rawStreamNotifier)
const rawStreamProvider = RawStreamNotifierProvider._();

final class RawStreamNotifierProvider
    extends
        $FunctionalProvider<
          Raw<Stream<MyChangeNotifier>>,
          Raw<Stream<MyChangeNotifier>>,
          Raw<Stream<MyChangeNotifier>>
        >
    with $Provider<Raw<Stream<MyChangeNotifier>>> {
  const RawStreamNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$rawStreamNotifierHash();

  @$internal
  @override
  $ProviderElement<Raw<Stream<MyChangeNotifier>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<Stream<MyChangeNotifier>> create(Ref ref) {
    return rawStreamNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<MyChangeNotifier>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Stream<MyChangeNotifier>>>(
        value,
      ),
    );
  }
}

String _$rawStreamNotifierHash() => r'9a13efb8fbcef6c4388d5a2535b1b0aec6e46a9a';

@ProviderFor(futureRawNotifier)
const futureRawProvider = FutureRawNotifierProvider._();

final class FutureRawNotifierProvider
    extends
        $FunctionalProvider<
          AsyncValue<Raw<MyChangeNotifier>>,
          Raw<MyChangeNotifier>,
          FutureOr<Raw<MyChangeNotifier>>
        >
    with
        $FutureModifier<Raw<MyChangeNotifier>>,
        $FutureProvider<Raw<MyChangeNotifier>> {
  const FutureRawNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'futureRawProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$futureRawNotifierHash();

  @$internal
  @override
  $FutureProviderElement<Raw<MyChangeNotifier>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Raw<MyChangeNotifier>> create(Ref ref) {
    return futureRawNotifier(ref);
  }
}

String _$futureRawNotifierHash() => r'87103845bce1f4cae4ad62ae3b7da6ca3539581f';

@ProviderFor(streamRawNotifier)
const streamRawProvider = StreamRawNotifierProvider._();

final class StreamRawNotifierProvider
    extends
        $FunctionalProvider<
          AsyncValue<Raw<MyChangeNotifier>>,
          Raw<MyChangeNotifier>,
          Stream<Raw<MyChangeNotifier>>
        >
    with
        $FutureModifier<Raw<MyChangeNotifier>>,
        $StreamProvider<Raw<MyChangeNotifier>> {
  const StreamRawNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamRawProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamRawNotifierHash();

  @$internal
  @override
  $StreamProviderElement<Raw<MyChangeNotifier>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Raw<MyChangeNotifier>> create(Ref ref) {
    return streamRawNotifier(ref);
  }
}

String _$streamRawNotifierHash() => r'1d4abe389b7dfe1381879d8ffb174f6d1d9325e0';
