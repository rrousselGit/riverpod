// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SyncTodoList)
const syncTodoListProvider = SyncTodoListProvider._();

final class SyncTodoListProvider
    extends $NotifierProvider<SyncTodoList, List<Todo>> {
  const SyncTodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncTodoListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncTodoListHash();

  @$internal
  @override
  SyncTodoList create() => SyncTodoList();

  @$internal
  @override
  _$SyncTodoListElement $createElement($ProviderPointer pointer) =>
      _$SyncTodoListElement(pointer);

  ProviderListenable<SyncTodoList$AddSync> get addSync =>
      $LazyProxyListenable<SyncTodoList$AddSync, List<Todo>>(
        this,
        (element) {
          element as _$SyncTodoListElement;

          return element._$addSync;
        },
      );

  ProviderListenable<SyncTodoList$AddAsync> get addAsync =>
      $LazyProxyListenable<SyncTodoList$AddAsync, List<Todo>>(
        this,
        (element) {
          element as _$SyncTodoListElement;

          return element._$addAsync;
        },
      );

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }
}

String _$syncTodoListHash() => r'18d459affe35603d564ac90e05c1978d4e862f40';

abstract class _$SyncTodoList extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Todo>>, List<Todo>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$SyncTodoListElement
    extends $NotifierProviderElement<SyncTodoList, List<Todo>> {
  _$SyncTodoListElement(super.pointer) {
    _$addSync.result = $Result.data(_$SyncTodoList$AddSync(this));
    _$addAsync.result = $Result.data(_$SyncTodoList$AddAsync(this));
  }
  final _$addSync = $ElementLense<_$SyncTodoList$AddSync>();
  final _$addAsync = $ElementLense<_$SyncTodoList$AddAsync>();
  @override
  void mount() {
    super.mount();
    _$addSync.result!.value!.reset();
    _$addAsync.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$addSync);
    listenableVisitor(_$addAsync);
  }
}

sealed class SyncTodoList$AddSync extends MutationBase<Todo> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SyncTodoList.addSync] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Todo call(Todo todo);
}

final class _$SyncTodoList$AddSync
    extends $SyncMutationBase<Todo, _$SyncTodoList$AddSync, SyncTodoList>
    implements SyncTodoList$AddSync {
  _$SyncTodoList$AddSync(this.element, {super.state, super.key});

  @override
  final _$SyncTodoListElement element;

  @override
  $ElementLense<_$SyncTodoList$AddSync> get listenable => element._$addSync;

  @override
  Todo call(Todo todo) {
    return mutate(
      Invocation.method(
        #addSync,
        [todo],
      ),
      ($notifier) => $notifier.addSync(
        todo,
      ),
    );
  }

  @override
  _$SyncTodoList$AddSync copyWith(MutationState<Todo> state, {Object? key}) =>
      _$SyncTodoList$AddSync(element, state: state, key: key);
}

sealed class SyncTodoList$AddAsync extends MutationBase<Todo> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SyncTodoList.addAsync] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<Todo> call(Todo todo);
}

final class _$SyncTodoList$AddAsync
    extends $AsyncMutationBase<Todo, _$SyncTodoList$AddAsync, SyncTodoList>
    implements SyncTodoList$AddAsync {
  _$SyncTodoList$AddAsync(this.element, {super.state, super.key});

  @override
  final _$SyncTodoListElement element;

  @override
  $ElementLense<_$SyncTodoList$AddAsync> get listenable => element._$addAsync;

  @override
  Future<Todo> call(Todo todo) {
    return mutate(
      Invocation.method(
        #addAsync,
        [todo],
      ),
      ($notifier) => $notifier.addAsync(
        todo,
      ),
    );
  }

  @override
  _$SyncTodoList$AddAsync copyWith(MutationState<Todo> state, {Object? key}) =>
      _$SyncTodoList$AddAsync(element, state: state, key: key);
}

@ProviderFor(AsyncTodoList)
const asyncTodoListProvider = AsyncTodoListProvider._();

final class AsyncTodoListProvider
    extends $AsyncNotifierProvider<AsyncTodoList, List<Todo>> {
  const AsyncTodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncTodoListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$asyncTodoListHash();

  @$internal
  @override
  AsyncTodoList create() => AsyncTodoList();

  @$internal
  @override
  _$AsyncTodoListElement $createElement($ProviderPointer pointer) =>
      _$AsyncTodoListElement(pointer);

  ProviderListenable<AsyncTodoList$AddSync> get addSync =>
      $LazyProxyListenable<AsyncTodoList$AddSync, AsyncValue<List<Todo>>>(
        this,
        (element) {
          element as _$AsyncTodoListElement;

          return element._$addSync;
        },
      );

  ProviderListenable<AsyncTodoList$AddAsync> get addAsync =>
      $LazyProxyListenable<AsyncTodoList$AddAsync, AsyncValue<List<Todo>>>(
        this,
        (element) {
          element as _$AsyncTodoListElement;

          return element._$addAsync;
        },
      );
}

String _$asyncTodoListHash() => r'73d9aa3b39ad5d0c157510754bfc273a98075d30';

abstract class _$AsyncTodoList extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Todo>>>,
        AsyncValue<List<Todo>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

class _$AsyncTodoListElement
    extends $AsyncNotifierProviderElement<AsyncTodoList, List<Todo>> {
  _$AsyncTodoListElement(super.pointer) {
    _$addSync.result = $Result.data(_$AsyncTodoList$AddSync(this));
    _$addAsync.result = $Result.data(_$AsyncTodoList$AddAsync(this));
  }
  final _$addSync = $ElementLense<_$AsyncTodoList$AddSync>();
  final _$addAsync = $ElementLense<_$AsyncTodoList$AddAsync>();
  @override
  void mount() {
    super.mount();
    _$addSync.result!.value!.reset();
    _$addAsync.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$addSync);
    listenableVisitor(_$addAsync);
  }
}

sealed class AsyncTodoList$AddSync extends MutationBase<Todo> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [AsyncTodoList.addSync] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Todo call(Todo todo);
}

final class _$AsyncTodoList$AddSync
    extends $SyncMutationBase<Todo, _$AsyncTodoList$AddSync, AsyncTodoList>
    implements AsyncTodoList$AddSync {
  _$AsyncTodoList$AddSync(this.element, {super.state, super.key});

  @override
  final _$AsyncTodoListElement element;

  @override
  $ElementLense<_$AsyncTodoList$AddSync> get listenable => element._$addSync;

  @override
  Todo call(Todo todo) {
    return mutate(
      Invocation.method(
        #addSync,
        [todo],
      ),
      ($notifier) => $notifier.addSync(
        todo,
      ),
    );
  }

  @override
  _$AsyncTodoList$AddSync copyWith(MutationState<Todo> state, {Object? key}) =>
      _$AsyncTodoList$AddSync(element, state: state, key: key);
}

sealed class AsyncTodoList$AddAsync extends MutationBase<Todo> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [AsyncTodoList.addAsync] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<Todo> call(Todo todo);
}

final class _$AsyncTodoList$AddAsync
    extends $AsyncMutationBase<Todo, _$AsyncTodoList$AddAsync, AsyncTodoList>
    implements AsyncTodoList$AddAsync {
  _$AsyncTodoList$AddAsync(this.element, {super.state, super.key});

  @override
  final _$AsyncTodoListElement element;

  @override
  $ElementLense<_$AsyncTodoList$AddAsync> get listenable => element._$addAsync;

  @override
  Future<Todo> call(Todo todo) {
    return mutate(
      Invocation.method(
        #addAsync,
        [todo],
      ),
      ($notifier) => $notifier.addAsync(
        todo,
      ),
    );
  }

  @override
  _$AsyncTodoList$AddAsync copyWith(MutationState<Todo> state, {Object? key}) =>
      _$AsyncTodoList$AddAsync(element, state: state, key: key);
}

@ProviderFor(Simple)
const simpleProvider = SimpleProvider._();

final class SimpleProvider extends $NotifierProvider<Simple, int> {
  const SimpleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleHash();

  @$internal
  @override
  Simple create() => Simple();

  @$internal
  @override
  _$SimpleElement $createElement($ProviderPointer pointer) =>
      _$SimpleElement(pointer);

  ProviderListenable<Simple$Increment> get increment =>
      $LazyProxyListenable<Simple$Increment, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$increment;
        },
      );

  ProviderListenable<Simple$IncrementOr> get incrementOr =>
      $LazyProxyListenable<Simple$IncrementOr, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$incrementOr;
        },
      );

  ProviderListenable<Simple$Delegated> get delegated =>
      $LazyProxyListenable<Simple$Delegated, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$delegated;
        },
      );

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$simpleHash() => r'bbccebb4e8d2a097b945f6d7ab5e54ac11781c49';

abstract class _$Simple extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$SimpleElement extends $NotifierProviderElement<Simple, int> {
  _$SimpleElement(super.pointer) {
    _$increment.result = $Result.data(_$Simple$Increment(this));
    _$incrementOr.result = $Result.data(_$Simple$IncrementOr(this));
    _$delegated.result = $Result.data(_$Simple$Delegated(this));
  }
  final _$increment = $ElementLense<_$Simple$Increment>();
  final _$incrementOr = $ElementLense<_$Simple$IncrementOr>();
  final _$delegated = $ElementLense<_$Simple$Delegated>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
    _$incrementOr.result!.value!.reset();
    _$delegated.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
    listenableVisitor(_$incrementOr);
    listenableVisitor(_$delegated);
  }
}

sealed class Simple$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [Simple.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$Simple$Increment
    extends $AsyncMutationBase<int, _$Simple$Increment, Simple>
    implements Simple$Increment {
  _$Simple$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  $ElementLense<_$Simple$Increment> get listenable => element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutate(
      Invocation.method(
        #increment,
        [inc],
      ),
      ($notifier) => $notifier.increment(
        inc,
      ),
    );
  }

  @override
  _$Simple$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$Simple$Increment(element, state: state, key: key);
}

sealed class Simple$IncrementOr extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [Simple.incrementOr] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  FutureOr<int> call();
}

final class _$Simple$IncrementOr
    extends $AsyncMutationBase<int, _$Simple$IncrementOr, Simple>
    implements Simple$IncrementOr {
  _$Simple$IncrementOr(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  $ElementLense<_$Simple$IncrementOr> get listenable => element._$incrementOr;

  @override
  FutureOr<int> call() {
    return mutate(
      Invocation.method(
        #incrementOr,
        [],
      ),
      ($notifier) => $notifier.incrementOr(),
    );
  }

  @override
  _$Simple$IncrementOr copyWith(MutationState<int> state, {Object? key}) =>
      _$Simple$IncrementOr(element, state: state, key: key);
}

sealed class Simple$Delegated extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [Simple.delegated] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call(Future<int> Function() fn);
}

final class _$Simple$Delegated
    extends $AsyncMutationBase<int, _$Simple$Delegated, Simple>
    implements Simple$Delegated {
  _$Simple$Delegated(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  $ElementLense<_$Simple$Delegated> get listenable => element._$delegated;

  @override
  Future<int> call(Future<int> Function() fn) {
    return mutate(
      Invocation.method(
        #delegated,
        [fn],
      ),
      ($notifier) => $notifier.delegated(
        fn,
      ),
    );
  }

  @override
  _$Simple$Delegated copyWith(MutationState<int> state, {Object? key}) =>
      _$Simple$Delegated(element, state: state, key: key);
}

@ProviderFor(SimpleFamily)
const simpleFamilyProvider = SimpleFamilyFamily._();

final class SimpleFamilyProvider extends $NotifierProvider<SimpleFamily, int> {
  const SimpleFamilyProvider._(
      {required SimpleFamilyFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'simpleFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleFamilyHash();

  @override
  String toString() {
    return r'simpleFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SimpleFamily create() => SimpleFamily();

  @$internal
  @override
  _$SimpleFamilyElement $createElement($ProviderPointer pointer) =>
      _$SimpleFamilyElement(pointer);

  ProviderListenable<SimpleFamily$Increment> get increment =>
      $LazyProxyListenable<SimpleFamily$Increment, int>(
        this,
        (element) {
          element as _$SimpleFamilyElement;

          return element._$increment;
        },
      );

  ProviderListenable<SimpleFamily$IncrementOr> get incrementOr =>
      $LazyProxyListenable<SimpleFamily$IncrementOr, int>(
        this,
        (element) {
          element as _$SimpleFamilyElement;

          return element._$incrementOr;
        },
      );

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SimpleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simpleFamilyHash() => r'5a1afef2fb83836b8cbdc48fda6975a9149d9f2d';

final class SimpleFamilyFamily extends $Family
    with $ClassFamilyOverride<SimpleFamily, int, int, int, String> {
  const SimpleFamilyFamily._()
      : super(
          retry: null,
          name: r'simpleFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SimpleFamilyProvider call(
    String arg,
  ) =>
      SimpleFamilyProvider._(argument: arg, from: this);

  @override
  String toString() => r'simpleFamilyProvider';
}

abstract class _$SimpleFamily extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  int build(
    String arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$SimpleFamilyElement
    extends $NotifierProviderElement<SimpleFamily, int> {
  _$SimpleFamilyElement(super.pointer) {
    _$increment.result = $Result.data(_$SimpleFamily$Increment(this));
    _$incrementOr.result = $Result.data(_$SimpleFamily$IncrementOr(this));
  }
  final _$increment = $ElementLense<_$SimpleFamily$Increment>();
  final _$incrementOr = $ElementLense<_$SimpleFamily$IncrementOr>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
    _$incrementOr.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
    listenableVisitor(_$incrementOr);
  }
}

sealed class SimpleFamily$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SimpleFamily.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$SimpleFamily$Increment
    extends $AsyncMutationBase<int, _$SimpleFamily$Increment, SimpleFamily>
    implements SimpleFamily$Increment {
  _$SimpleFamily$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleFamilyElement element;

  @override
  $ElementLense<_$SimpleFamily$Increment> get listenable => element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutate(
      Invocation.method(
        #increment,
        [inc],
      ),
      ($notifier) => $notifier.increment(
        inc,
      ),
    );
  }

  @override
  _$SimpleFamily$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$SimpleFamily$Increment(element, state: state, key: key);
}

sealed class SimpleFamily$IncrementOr extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SimpleFamily.incrementOr] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  FutureOr<int> call();
}

final class _$SimpleFamily$IncrementOr
    extends $AsyncMutationBase<int, _$SimpleFamily$IncrementOr, SimpleFamily>
    implements SimpleFamily$IncrementOr {
  _$SimpleFamily$IncrementOr(this.element, {super.state, super.key});

  @override
  final _$SimpleFamilyElement element;

  @override
  $ElementLense<_$SimpleFamily$IncrementOr> get listenable =>
      element._$incrementOr;

  @override
  FutureOr<int> call() {
    return mutate(
      Invocation.method(
        #incrementOr,
        [],
      ),
      ($notifier) => $notifier.incrementOr(),
    );
  }

  @override
  _$SimpleFamily$IncrementOr copyWith(MutationState<int> state,
          {Object? key}) =>
      _$SimpleFamily$IncrementOr(element, state: state, key: key);
}

@ProviderFor(SimpleAsync)
const simpleAsyncProvider = SimpleAsyncProvider._();

final class SimpleAsyncProvider
    extends $AsyncNotifierProvider<SimpleAsync, int> {
  const SimpleAsyncProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleAsyncHash();

  @$internal
  @override
  SimpleAsync create() => SimpleAsync();

  @$internal
  @override
  _$SimpleAsyncElement $createElement($ProviderPointer pointer) =>
      _$SimpleAsyncElement(pointer);

  ProviderListenable<SimpleAsync$Increment> get increment =>
      $LazyProxyListenable<SimpleAsync$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$SimpleAsyncElement;

          return element._$increment;
        },
      );

  ProviderListenable<SimpleAsync$Delegated> get delegated =>
      $LazyProxyListenable<SimpleAsync$Delegated, AsyncValue<int>>(
        this,
        (element) {
          element as _$SimpleAsyncElement;

          return element._$delegated;
        },
      );
}

String _$simpleAsyncHash() => r'62dd0ee93e61fa27d139247b9a899630d5d3572c';

abstract class _$SimpleAsync extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$SimpleAsyncElement
    extends $AsyncNotifierProviderElement<SimpleAsync, int> {
  _$SimpleAsyncElement(super.pointer) {
    _$increment.result = $Result.data(_$SimpleAsync$Increment(this));
    _$delegated.result = $Result.data(_$SimpleAsync$Delegated(this));
  }
  final _$increment = $ElementLense<_$SimpleAsync$Increment>();
  final _$delegated = $ElementLense<_$SimpleAsync$Delegated>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
    _$delegated.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
    listenableVisitor(_$delegated);
  }
}

sealed class SimpleAsync$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SimpleAsync.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$SimpleAsync$Increment
    extends $AsyncMutationBase<int, _$SimpleAsync$Increment, SimpleAsync>
    implements SimpleAsync$Increment {
  _$SimpleAsync$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleAsyncElement element;

  @override
  $ElementLense<_$SimpleAsync$Increment> get listenable => element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutate(
      Invocation.method(
        #increment,
        [inc],
      ),
      ($notifier) => $notifier.increment(
        inc,
      ),
    );
  }

  @override
  _$SimpleAsync$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$SimpleAsync$Increment(element, state: state, key: key);
}

sealed class SimpleAsync$Delegated extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SimpleAsync.delegated] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call(Future<int> Function() fn);
}

final class _$SimpleAsync$Delegated
    extends $AsyncMutationBase<int, _$SimpleAsync$Delegated, SimpleAsync>
    implements SimpleAsync$Delegated {
  _$SimpleAsync$Delegated(this.element, {super.state, super.key});

  @override
  final _$SimpleAsyncElement element;

  @override
  $ElementLense<_$SimpleAsync$Delegated> get listenable => element._$delegated;

  @override
  Future<int> call(Future<int> Function() fn) {
    return mutate(
      Invocation.method(
        #delegated,
        [fn],
      ),
      ($notifier) => $notifier.delegated(
        fn,
      ),
    );
  }

  @override
  _$SimpleAsync$Delegated copyWith(MutationState<int> state, {Object? key}) =>
      _$SimpleAsync$Delegated(element, state: state, key: key);
}

@ProviderFor(SimpleAsync2)
const simpleAsync2Provider = SimpleAsync2Family._();

final class SimpleAsync2Provider
    extends $StreamNotifierProvider<SimpleAsync2, int> {
  const SimpleAsync2Provider._(
      {required SimpleAsync2Family super.from, required String super.argument})
      : super(
          retry: null,
          name: r'simpleAsync2Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleAsync2Hash();

  @override
  String toString() {
    return r'simpleAsync2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SimpleAsync2 create() => SimpleAsync2();

  @$internal
  @override
  _$SimpleAsync2Element $createElement($ProviderPointer pointer) =>
      _$SimpleAsync2Element(pointer);

  ProviderListenable<SimpleAsync2$Increment> get increment =>
      $LazyProxyListenable<SimpleAsync2$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$SimpleAsync2Element;

          return element._$increment;
        },
      );

  @override
  bool operator ==(Object other) {
    return other is SimpleAsync2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simpleAsync2Hash() => r'b2268a85a058e6f40c5bbfce8c20c9d285270967';

final class SimpleAsync2Family extends $Family
    with
        $ClassFamilyOverride<SimpleAsync2, AsyncValue<int>, int, Stream<int>,
            String> {
  const SimpleAsync2Family._()
      : super(
          retry: null,
          name: r'simpleAsync2Provider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SimpleAsync2Provider call(
    String arg,
  ) =>
      SimpleAsync2Provider._(argument: arg, from: this);

  @override
  String toString() => r'simpleAsync2Provider';
}

abstract class _$SimpleAsync2 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  Stream<int> build(
    String arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$SimpleAsync2Element
    extends $StreamNotifierProviderElement<SimpleAsync2, int> {
  _$SimpleAsync2Element(super.pointer) {
    _$increment.result = $Result.data(_$SimpleAsync2$Increment(this));
  }
  final _$increment = $ElementLense<_$SimpleAsync2$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
  }
}

sealed class SimpleAsync2$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [SimpleAsync2.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call();
}

final class _$SimpleAsync2$Increment
    extends $AsyncMutationBase<int, _$SimpleAsync2$Increment, SimpleAsync2>
    implements SimpleAsync2$Increment {
  _$SimpleAsync2$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleAsync2Element element;

  @override
  $ElementLense<_$SimpleAsync2$Increment> get listenable => element._$increment;

  @override
  Future<int> call() {
    return mutate(
      Invocation.method(
        #increment,
        [],
      ),
      ($notifier) => $notifier.increment(),
    );
  }

  @override
  _$SimpleAsync2$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$SimpleAsync2$Increment(element, state: state, key: key);
}

@ProviderFor(Generic)
const genericProvider = GenericFamily._();

final class GenericProvider<T extends num>
    extends $AsyncNotifierProvider<Generic<T>, int> {
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
  Generic<T> create() => Generic<T>();

  @$internal
  @override
  _$GenericElement<T> $createElement($ProviderPointer pointer) =>
      _$GenericElement(pointer);

  ProviderListenable<Generic$Increment> get increment =>
      $LazyProxyListenable<Generic$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$GenericElement<T>;

          return element._$increment;
        },
      );

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

String _$genericHash() => r'd5341a17852b21f307e508a4f9d9470c5863aa17';

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
  Override overrideWith(Generic<T> Function<T extends num>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericProvider<T>;
              return provider.$view(create: create<T>).$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          FutureOr<int> Function<T extends num>(Ref ref, Generic<T> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericProvider;
            return provider._captureGenerics(<T extends num>() {
              provider as GenericProvider<T>;
              return provider
                  .$view(runNotifierBuildOverride: build<T>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$Generic<T extends num> extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$GenericElement<T extends num>
    extends $AsyncNotifierProviderElement<Generic<T>, int> {
  _$GenericElement(super.pointer) {
    _$increment.result = $Result.data(_$Generic$Increment(this));
  }
  final _$increment = $ElementLense<_$Generic$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
  }
}

sealed class Generic$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [Generic.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call();
}

final class _$Generic$Increment
    extends $AsyncMutationBase<int, _$Generic$Increment, Generic>
    implements Generic$Increment {
  _$Generic$Increment(this.element, {super.state, super.key});

  @override
  final _$GenericElement element;

  @override
  $ElementLense<_$Generic$Increment> get listenable => element._$increment;

  @override
  Future<int> call() {
    return mutate(
      Invocation.method(
        #increment,
        [],
      ),
      ($notifier) => $notifier.increment(),
    );
  }

  @override
  _$Generic$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$Generic$Increment(element, state: state, key: key);
}

@ProviderFor(GenericMut)
const genericMutProvider = GenericMutProvider._();

final class GenericMutProvider extends $AsyncNotifierProvider<GenericMut, int> {
  const GenericMutProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'genericMutProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericMutHash();

  @$internal
  @override
  GenericMut create() => GenericMut();

  @$internal
  @override
  _$GenericMutElement $createElement($ProviderPointer pointer) =>
      _$GenericMutElement(pointer);

  ProviderListenable<GenericMut$Increment> get increment =>
      $LazyProxyListenable<GenericMut$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$GenericMutElement;

          return element._$increment;
        },
      );
}

String _$genericMutHash() => r'1f38b70cf937501fb313ae35c8bf824728bbd8ba';

abstract class _$GenericMut extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$GenericMutElement
    extends $AsyncNotifierProviderElement<GenericMut, int> {
  _$GenericMutElement(super.pointer) {
    _$increment.result = $Result.data(_$GenericMut$Increment(this));
  }
  final _$increment = $ElementLense<_$GenericMut$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
  }
}

sealed class GenericMut$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [GenericMut.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call<T extends num>(T value);
}

final class _$GenericMut$Increment
    extends $AsyncMutationBase<int, _$GenericMut$Increment, GenericMut>
    implements GenericMut$Increment {
  _$GenericMut$Increment(this.element, {super.state, super.key});

  @override
  final _$GenericMutElement element;

  @override
  $ElementLense<_$GenericMut$Increment> get listenable => element._$increment;

  @override
  Future<int> call<T extends num>(T value) {
    return mutate(
      Invocation.genericMethod(
        #increment,
        [T],
        [value],
      ),
      ($notifier) => $notifier.increment<T>(
        value,
      ),
    );
  }

  @override
  _$GenericMut$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$GenericMut$Increment(element, state: state, key: key);
}

@ProviderFor(FailingCtor)
const failingCtorProvider = FailingCtorProvider._();

final class FailingCtorProvider extends $NotifierProvider<FailingCtor, int> {
  const FailingCtorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'failingCtorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$failingCtorHash();

  @$internal
  @override
  FailingCtor create() => FailingCtor();

  @$internal
  @override
  _$FailingCtorElement $createElement($ProviderPointer pointer) =>
      _$FailingCtorElement(pointer);

  ProviderListenable<FailingCtor$Increment> get increment =>
      $LazyProxyListenable<FailingCtor$Increment, int>(
        this,
        (element) {
          element as _$FailingCtorElement;

          return element._$increment;
        },
      );

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$failingCtorHash() => r'5d80d3b1dba058415cc8cfec17bc14e1f9c83fae';

abstract class _$FailingCtor extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$FailingCtorElement extends $NotifierProviderElement<FailingCtor, int> {
  _$FailingCtorElement(super.pointer) {
    _$increment.result = $Result.data(_$FailingCtor$Increment(this));
  }
  final _$increment = $ElementLense<_$FailingCtor$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$increment);
  }
}

sealed class FailingCtor$Increment extends MutationBase<int> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [FailingCtor.increment] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$FailingCtor$Increment
    extends $AsyncMutationBase<int, _$FailingCtor$Increment, FailingCtor>
    implements FailingCtor$Increment {
  _$FailingCtor$Increment(this.element, {super.state, super.key});

  @override
  final _$FailingCtorElement element;

  @override
  $ElementLense<_$FailingCtor$Increment> get listenable => element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutate(
      Invocation.method(
        #increment,
        [inc],
      ),
      ($notifier) => $notifier.increment(
        inc,
      ),
    );
  }

  @override
  _$FailingCtor$Increment copyWith(MutationState<int> state, {Object? key}) =>
      _$FailingCtor$Increment(element, state: state, key: key);
}

@ProviderFor(Typed)
const typedProvider = TypedProvider._();

final class TypedProvider extends $NotifierProvider<Typed, String> {
  const TypedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'typedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$typedHash();

  @$internal
  @override
  Typed create() => Typed();

  @$internal
  @override
  _$TypedElement $createElement($ProviderPointer pointer) =>
      _$TypedElement(pointer);

  ProviderListenable<Typed$Mutate> get mutate =>
      $LazyProxyListenable<Typed$Mutate, String>(
        this,
        (element) {
          element as _$TypedElement;

          return element._$mutate;
        },
      );

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$typedHash() => r'1f53e16796771d14fcdfec41d2b9f5eb70d875a7';

abstract class _$Typed extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

class _$TypedElement extends $NotifierProviderElement<Typed, String> {
  _$TypedElement(super.pointer) {
    _$mutate.result = $Result.data(_$Typed$Mutate(this));
  }
  final _$mutate = $ElementLense<_$Typed$Mutate>();
  @override
  void mount() {
    super.mount();
    _$mutate.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$mutate);
  }
}

sealed class Typed$Mutate extends MutationBase<String> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutationState], then
  /// will call [Typed.mutate] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<String> call(String one, {required String two, required String three});
}

final class _$Typed$Mutate
    extends $AsyncMutationBase<String, _$Typed$Mutate, Typed>
    implements Typed$Mutate {
  _$Typed$Mutate(this.element, {super.state, super.key});

  @override
  final _$TypedElement element;

  @override
  $ElementLense<_$Typed$Mutate> get listenable => element._$mutate;

  @override
  Future<String> call(String one,
      {required String two, required String three}) {
    return mutate(
      Invocation.method(#mutate, [one], {#two: two, #three: three}),
      ($notifier) => $notifier.mutate(
        one,
        two: two,
        three: three,
      ),
    );
  }

  @override
  _$Typed$Mutate copyWith(MutationState<String> state, {Object? key}) =>
      _$Typed$Mutate(element, state: state, key: key);
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
