// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Simple)
const simpleProvider = SimpleProvider._();

final class SimpleProvider extends $NotifierProvider<Simple, int> {
  const SimpleProvider._(
      {super.runNotifierBuildOverride, Simple Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Simple Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simpleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Simple create() => _createCb?.call() ?? Simple();

  @$internal
  @override
  SimpleProvider $copyWithCreate(
    Simple Function() create,
  ) {
    return SimpleProvider._(create: create);
  }

  @$internal
  @override
  SimpleProvider $copyWithBuild(
    int Function(
      Ref,
      Simple,
    ) build,
  ) {
    return SimpleProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$SimpleElement $createElement($ProviderPointer pointer) =>
      _$SimpleElement(this, pointer);

  ProviderListenable<Simple$Increment> get increment =>
      LazyProxyListenable<Simple$Increment, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$increment;
        },
      );

  ProviderListenable<Simple$IncrementOr> get incrementOr =>
      LazyProxyListenable<Simple$IncrementOr, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$incrementOr;
        },
      );

  ProviderListenable<Simple$Delegated> get delegated =>
      LazyProxyListenable<Simple$Delegated, int>(
        this,
        (element) {
          element as _$SimpleElement;

          return element._$delegated;
        },
      );
}

String _$simpleHash() => r'c84cd9b6e3b09516b19316b0b21ea5ba5bc08a07';

abstract class _$Simple extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

class _$SimpleElement extends $NotifierProviderElement<Simple, int> {
  _$SimpleElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$Simple$Increment(this));
    _$incrementOr.result = Result.data(_$Simple$IncrementOr(this));
    _$delegated.result = Result.data(_$Simple$Delegated(this));
  }
  final _$increment = ProxyElementValueListenable<_$Simple$Increment>();
  final _$incrementOr = ProxyElementValueListenable<_$Simple$IncrementOr>();
  final _$delegated = ProxyElementValueListenable<_$Simple$Delegated>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
    _$incrementOr.result!.stateOrNull!.reset();
    _$delegated.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$Simple$Increment
    extends $SyncMutationBase<int, _$Simple$Increment, Simple>
    implements Simple$Increment {
  _$Simple$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  ProxyElementValueListenable<_$Simple$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutateAsync(
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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call();
}

final class _$Simple$IncrementOr
    extends $SyncMutationBase<int, _$Simple$IncrementOr, Simple>
    implements Simple$IncrementOr {
  _$Simple$IncrementOr(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  ProxyElementValueListenable<_$Simple$IncrementOr> get listenable =>
      element._$incrementOr;

  @override
  Future<int> call() {
    return mutateAsync(
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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call(Future<int> Function() fn);
}

final class _$Simple$Delegated
    extends $SyncMutationBase<int, _$Simple$Delegated, Simple>
    implements Simple$Delegated {
  _$Simple$Delegated(this.element, {super.state, super.key});

  @override
  final _$SimpleElement element;

  @override
  ProxyElementValueListenable<_$Simple$Delegated> get listenable =>
      element._$delegated;

  @override
  Future<int> call(Future<int> Function() fn) {
    return mutateAsync(
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
      {required SimpleFamilyFamily super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      SimpleFamily Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'simpleFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SimpleFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simpleFamilyHash();

  @override
  String toString() {
    return r'simpleFamilyProvider'
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
  SimpleFamily create() => _createCb?.call() ?? SimpleFamily();

  @$internal
  @override
  SimpleFamilyProvider $copyWithCreate(
    SimpleFamily Function() create,
  ) {
    return SimpleFamilyProvider._(
        argument: argument as String,
        from: from! as SimpleFamilyFamily,
        create: create);
  }

  @$internal
  @override
  SimpleFamilyProvider $copyWithBuild(
    int Function(
      Ref,
      SimpleFamily,
    ) build,
  ) {
    return SimpleFamilyProvider._(
        argument: argument as String,
        from: from! as SimpleFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$SimpleFamilyElement $createElement($ProviderPointer pointer) =>
      _$SimpleFamilyElement(this, pointer);

  ProviderListenable<SimpleFamily$Increment> get increment =>
      LazyProxyListenable<SimpleFamily$Increment, int>(
        this,
        (element) {
          element as _$SimpleFamilyElement;

          return element._$increment;
        },
      );

  ProviderListenable<SimpleFamily$IncrementOr> get incrementOr =>
      LazyProxyListenable<SimpleFamily$IncrementOr, int>(
        this,
        (element) {
          element as _$SimpleFamilyElement;

          return element._$incrementOr;
        },
      );

  @override
  bool operator ==(Object other) {
    return other is SimpleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simpleFamilyHash() => r'7f7a9985568e147b78fbcd6ed7691a6677f75aeb';

final class SimpleFamilyFamily extends Family {
  const SimpleFamilyFamily._()
      : super(
          retry: null,
          name: r'simpleFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SimpleFamilyProvider call(
    String arg,
  ) =>
      SimpleFamilyProvider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$simpleFamilyHash();

  @override
  String toString() => r'simpleFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    SimpleFamily Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as SimpleFamilyProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref ref, SimpleFamily notifier, String argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as SimpleFamilyProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$SimpleFamily extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  int build(
    String arg,
  );
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

class _$SimpleFamilyElement
    extends $NotifierProviderElement<SimpleFamily, int> {
  _$SimpleFamilyElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$SimpleFamily$Increment(this));
    _$incrementOr.result = Result.data(_$SimpleFamily$IncrementOr(this));
  }
  final _$increment = ProxyElementValueListenable<_$SimpleFamily$Increment>();
  final _$incrementOr =
      ProxyElementValueListenable<_$SimpleFamily$IncrementOr>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
    _$incrementOr.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$SimpleFamily$Increment
    extends $SyncMutationBase<int, _$SimpleFamily$Increment, SimpleFamily>
    implements SimpleFamily$Increment {
  _$SimpleFamily$Increment(this.element, {super.state, super.key});

  @override
  final _$SimpleFamilyElement element;

  @override
  ProxyElementValueListenable<_$SimpleFamily$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutateAsync(
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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call();
}

final class _$SimpleFamily$IncrementOr
    extends $SyncMutationBase<int, _$SimpleFamily$IncrementOr, SimpleFamily>
    implements SimpleFamily$IncrementOr {
  _$SimpleFamily$IncrementOr(this.element, {super.state, super.key});

  @override
  final _$SimpleFamilyElement element;

  @override
  ProxyElementValueListenable<_$SimpleFamily$IncrementOr> get listenable =>
      element._$incrementOr;

  @override
  Future<int> call() {
    return mutateAsync(
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
  const SimpleAsyncProvider._(
      {super.runNotifierBuildOverride, SimpleAsync Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SimpleAsync Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simpleAsyncHash();

  @$internal
  @override
  SimpleAsync create() => _createCb?.call() ?? SimpleAsync();

  @$internal
  @override
  SimpleAsyncProvider $copyWithCreate(
    SimpleAsync Function() create,
  ) {
    return SimpleAsyncProvider._(create: create);
  }

  @$internal
  @override
  SimpleAsyncProvider $copyWithBuild(
    FutureOr<int> Function(
      Ref,
      SimpleAsync,
    ) build,
  ) {
    return SimpleAsyncProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$SimpleAsyncElement $createElement($ProviderPointer pointer) =>
      _$SimpleAsyncElement(this, pointer);

  ProviderListenable<SimpleAsync$Increment> get increment =>
      LazyProxyListenable<SimpleAsync$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$SimpleAsyncElement;

          return element._$increment;
        },
      );

  ProviderListenable<SimpleAsync$Delegated> get delegated =>
      LazyProxyListenable<SimpleAsync$Delegated, AsyncValue<int>>(
        this,
        (element) {
          element as _$SimpleAsyncElement;

          return element._$delegated;
        },
      );
}

String _$simpleAsyncHash() => r'ed00b8e5170e48855d0b3cddddabd316fef466cf';

abstract class _$SimpleAsync extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$internal
  @override
  FutureOr<int> runBuild() => build();
}

class _$SimpleAsyncElement
    extends $AsyncNotifierProviderElement<SimpleAsync, int> {
  _$SimpleAsyncElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$SimpleAsync$Increment(this));
    _$delegated.result = Result.data(_$SimpleAsync$Delegated(this));
  }
  final _$increment = ProxyElementValueListenable<_$SimpleAsync$Increment>();
  final _$delegated = ProxyElementValueListenable<_$SimpleAsync$Delegated>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
    _$delegated.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
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
  ProxyElementValueListenable<_$SimpleAsync$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutateAsync(
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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
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
  ProxyElementValueListenable<_$SimpleAsync$Delegated> get listenable =>
      element._$delegated;

  @override
  Future<int> call(Future<int> Function() fn) {
    return mutateAsync(
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
      {required SimpleAsync2Family super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      SimpleAsync2 Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'simpleAsync2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SimpleAsync2 Function()? _createCb;

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
  SimpleAsync2 create() => _createCb?.call() ?? SimpleAsync2();

  @$internal
  @override
  SimpleAsync2Provider $copyWithCreate(
    SimpleAsync2 Function() create,
  ) {
    return SimpleAsync2Provider._(
        argument: argument as String,
        from: from! as SimpleAsync2Family,
        create: create);
  }

  @$internal
  @override
  SimpleAsync2Provider $copyWithBuild(
    Stream<int> Function(
      Ref,
      SimpleAsync2,
    ) build,
  ) {
    return SimpleAsync2Provider._(
        argument: argument as String,
        from: from! as SimpleAsync2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$SimpleAsync2Element $createElement($ProviderPointer pointer) =>
      _$SimpleAsync2Element(this, pointer);

  ProviderListenable<SimpleAsync2$Increment> get increment =>
      LazyProxyListenable<SimpleAsync2$Increment, AsyncValue<int>>(
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

String _$simpleAsync2Hash() => r'7b372f85f3e4f1c2a954402b82a9a7b68bbc1407';

final class SimpleAsync2Family extends Family {
  const SimpleAsync2Family._()
      : super(
          retry: null,
          name: r'simpleAsync2Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SimpleAsync2Provider call(
    String arg,
  ) =>
      SimpleAsync2Provider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$simpleAsync2Hash();

  @override
  String toString() => r'simpleAsync2Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    SimpleAsync2 Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as SimpleAsync2Provider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<int> Function(Ref ref, SimpleAsync2 notifier, String argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as SimpleAsync2Provider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$SimpleAsync2 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  Stream<int> build(
    String arg,
  );
  @$internal
  @override
  Stream<int> runBuild() => build(
        _$args,
      );
}

class _$SimpleAsync2Element
    extends $StreamNotifierProviderElement<SimpleAsync2, int> {
  _$SimpleAsync2Element(super.provider, super.pointer) {
    _$increment.result = Result.data(_$SimpleAsync2$Increment(this));
  }
  final _$increment = ProxyElementValueListenable<_$SimpleAsync2$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
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
  ProxyElementValueListenable<_$SimpleAsync2$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call() {
    return mutateAsync(
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
  const GenericProvider._(
      {required GenericFamily super.from,
      super.runNotifierBuildOverride,
      Generic<T> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Generic<T> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<T> _copyWithCreate(
    Generic<T> Function<T extends num>() create,
  ) {
    return GenericProvider<T>._(
        from: from! as GenericFamily, create: create<T>);
  }

  GenericProvider<T> _copyWithBuild(
    FutureOr<int> Function<T extends num>(
      Ref,
      Generic<T>,
    ) build,
  ) {
    return GenericProvider<T>._(
        from: from! as GenericFamily, runNotifierBuildOverride: build<T>);
  }

  @override
  String toString() {
    return r'genericProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  Generic<T> create() => _createCb?.call() ?? Generic<T>();

  @$internal
  @override
  GenericProvider<T> $copyWithCreate(
    Generic<T> Function() create,
  ) {
    return GenericProvider<T>._(from: from! as GenericFamily, create: create);
  }

  @$internal
  @override
  GenericProvider<T> $copyWithBuild(
    FutureOr<int> Function(
      Ref,
      Generic<T>,
    ) build,
  ) {
    return GenericProvider<T>._(
        from: from! as GenericFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$GenericElement<T> $createElement($ProviderPointer pointer) =>
      _$GenericElement(this, pointer);

  ProviderListenable<Generic$Increment> get increment =>
      LazyProxyListenable<Generic$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$GenericElement<T>;

          return element._$increment;
        },
      );

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

String _$genericHash() => r'4089b4d9b08bfff0256ad67cf35780a6409f7a87';

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
    Generic<T> Function<T extends num>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function<T extends num>(Ref ref, Generic<T> notifier) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericProvider;

        return provider._copyWithBuild(build).$createElement(pointer);
      },
    );
  }
}

abstract class _$Generic<T extends num> extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$internal
  @override
  FutureOr<int> runBuild() => build();
}

class _$GenericElement<T extends num>
    extends $AsyncNotifierProviderElement<Generic<T>, int> {
  _$GenericElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$Generic$Increment(this));
  }
  final _$increment = ProxyElementValueListenable<_$Generic$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
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
  ProxyElementValueListenable<_$Generic$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call() {
    return mutateAsync(
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
  const GenericMutProvider._(
      {super.runNotifierBuildOverride, GenericMut Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'genericMutProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GenericMut Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericMutHash();

  @$internal
  @override
  GenericMut create() => _createCb?.call() ?? GenericMut();

  @$internal
  @override
  GenericMutProvider $copyWithCreate(
    GenericMut Function() create,
  ) {
    return GenericMutProvider._(create: create);
  }

  @$internal
  @override
  GenericMutProvider $copyWithBuild(
    FutureOr<int> Function(
      Ref,
      GenericMut,
    ) build,
  ) {
    return GenericMutProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$GenericMutElement $createElement($ProviderPointer pointer) =>
      _$GenericMutElement(this, pointer);

  ProviderListenable<GenericMut$Increment> get increment =>
      LazyProxyListenable<GenericMut$Increment, AsyncValue<int>>(
        this,
        (element) {
          element as _$GenericMutElement;

          return element._$increment;
        },
      );
}

String _$genericMutHash() => r'43acfc1b7cf59fb05f31ed4c2d5470422198feb0';

abstract class _$GenericMut extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$internal
  @override
  FutureOr<int> runBuild() => build();
}

class _$GenericMutElement
    extends $AsyncNotifierProviderElement<GenericMut, int> {
  _$GenericMutElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$GenericMut$Increment(this));
  }
  final _$increment = ProxyElementValueListenable<_$GenericMut$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
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
  ProxyElementValueListenable<_$GenericMut$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call<T extends num>(T value) {
    return mutateAsync(
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
  const FailingCtorProvider._(
      {super.runNotifierBuildOverride, FailingCtor Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'failingCtorProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FailingCtor Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$failingCtorHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  FailingCtor create() => _createCb?.call() ?? FailingCtor();

  @$internal
  @override
  FailingCtorProvider $copyWithCreate(
    FailingCtor Function() create,
  ) {
    return FailingCtorProvider._(create: create);
  }

  @$internal
  @override
  FailingCtorProvider $copyWithBuild(
    int Function(
      Ref,
      FailingCtor,
    ) build,
  ) {
    return FailingCtorProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  _$FailingCtorElement $createElement($ProviderPointer pointer) =>
      _$FailingCtorElement(this, pointer);

  ProviderListenable<FailingCtor$Increment> get increment =>
      LazyProxyListenable<FailingCtor$Increment, int>(
        this,
        (element) {
          element as _$FailingCtorElement;

          return element._$increment;
        },
      );
}

String _$failingCtorHash() => r'6cdef257a2d783fa5a606b411be0d23744766cdc';

abstract class _$FailingCtor extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

class _$FailingCtorElement extends $NotifierProviderElement<FailingCtor, int> {
  _$FailingCtorElement(super.provider, super.pointer) {
    _$increment.result = Result.data(_$FailingCtor$Increment(this));
  }
  final _$increment = ProxyElementValueListenable<_$FailingCtor$Increment>();
  @override
  void mount() {
    super.mount();
    _$increment.result!.stateOrNull!.reset();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );

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
  /// Lastly, if the method completes without throwing, the Notifier's state
  /// will be updated with the new value.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<int> call([int inc = 1]);
}

final class _$FailingCtor$Increment
    extends $SyncMutationBase<int, _$FailingCtor$Increment, FailingCtor>
    implements FailingCtor$Increment {
  _$FailingCtor$Increment(this.element, {super.state, super.key});

  @override
  final _$FailingCtorElement element;

  @override
  ProxyElementValueListenable<_$FailingCtor$Increment> get listenable =>
      element._$increment;

  @override
  Future<int> call([int inc = 1]) {
    return mutateAsync(
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
