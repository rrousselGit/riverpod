part of 'framework.dart';

/// A [ProviderReference] that allows controlling whether the associated
/// provider should dispose when all listeners are removed or not.
class AutoDisposeProviderReference extends ProviderReference {
  /// DO NOT USE, for internal usages only.
  @visibleForTesting
  AutoDisposeProviderReference(AutoDisposeProviderStateBase providerState)
      : super(providerState);

  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it no-longer have listeners.
  ///
  /// Defaults to `false`.
  bool get maintainState {
    return (_providerState as AutoDisposeProviderStateBase).maintainState;
  }

  set maintainState(bool value) {
    (_providerState as AutoDisposeProviderStateBase).maintainState = value;
  }
}

/// A base class for providers that destroy their state when no-longer listened.
///
/// See also:
///
/// - [AutoDisposeProvider], a variant of [Provider] that auto-dispose its state.
abstract class AutoDisposeProviderBase<
    Dependency extends ProviderDependencyBase,
    Result> extends ProviderBase<Dependency, Result> {
  /// Allows specifying a name
  AutoDisposeProviderBase(String name) : super(name);

  @override
  AutoDisposeProviderStateBase<Dependency, Result,
      AutoDisposeProviderBase<Dependency, Result>> createState();
}

/// A base class for providers that destroy their state when no-longer listened
/// _and_ can be overriden,
///
/// See also:
///
/// - [AutoDisposeProvider], a variant of [Provider] that auto-dispose its state.
abstract class OverridableAutoDisposeProviderBase<
        Dependency extends ProviderDependencyBase,
        Result> extends AutoDisposeProviderBase<Dependency, Result>
    implements ProviderOverride {
  /// Allows specifying a name
  OverridableAutoDisposeProviderBase(String name) : super(name);

  @override
  ProviderBase get _provider => this;

  @override
  ProviderBase<Dependency, Result> get _origin => this;

  /// Combined with [ProviderStateOwner] (or `ProviderScope` if you are using Flutter),
  /// allows overriding the behavior of this provider for a part of the application.
  ///
  /// A use-case could be for testing, to override the implementation of a
  /// `Repository` class with a fake implementation.
  ///
  /// In a Flutter application, this would look like:
  ///
  /// ```dart
  /// final repositoryProvider = Provider((_) => Repository());
  ///
  /// testWidgets('Override example', (tester) async {
  ///   await tester.pumpWidget(
  ///     ProviderScope(
  ///       overrides: [
  ///         repositoryProvider.overrideAs(
  ///           Provider((_) => FakeRepository()),
  ///         ),
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// });
  /// ```
  ProviderOverride overrideAs(
    // Auto-disposed providers can be overriden by anything that matches
    // as they don't have a `read` method.
    ProviderBase<Dependency, Result> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}

/// The state of an [AutoDisposeProvider].
abstract class AutoDisposeProviderStateBase<
        Dependency extends ProviderDependencyBase,
        Result,
        P extends AutoDisposeProviderBase<Dependency, Result>>
    extends ProviderStateBase<Dependency, Result, P> {
  bool _maintainState = false;

  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `true`,
  /// may destroy the provider state if it no-longer have listeners.
  ///
  /// Defaults to true.
  bool get maintainState => _maintainState;

  set maintainState(bool value) {
    if (value != _maintainState && !value) {
      onRemoveListener();
    }
    _maintainState = value;
  }

  @override
  void onRemoveListener() {
    if (!$hasListeners) {
      _AutoDisposer.instance.scheduleDispose(this);
    }
  }
}

/// A class that handles automatically disposing provider states when they are
/// no-longer listened.
class _AutoDisposer {
  static final _AutoDisposer instance = _AutoDisposer();

  bool _scheduled = false;
  LinkedList<_LinkedListEntry<AutoDisposeProviderStateBase>> _stateToDispose;

  void scheduleDispose(AutoDisposeProviderStateBase state) {
    _stateToDispose ??= LinkedList();
    _stateToDispose.add(_LinkedListEntry(state));

    if (!_scheduled) {
      _scheduled = true;
      Future.microtask(() {
        try {
          _performDispose();
        } finally {
          _scheduled = false;
          _stateToDispose = null;
        }
      });
    }
  }

  void _performDispose() {
    /// No need to traverse entries from children to parents as a parent cannot
    /// have no listener until its children are disposed first.
    /// Worse case scenario, a parent will be added twice to the list (parent child parent)
    /// but when the parent is traverse first, it will still have listeners,
    /// and the second time it is traversed, it won't anymore.
    for (var entry = _stateToDispose.first; entry != null; entry = entry.next) {
      if (entry.value.maintainState ||
          entry.value.$hasListeners ||
          !entry.value.mounted) {
        continue;
      }
      entry.value.dispose();
      final reader = entry.value._origin is Computed
          ? entry.value._owner._computedStateReaders[entry.value._origin]
          : entry.value._owner._stateReaders[entry.value._origin];
      // TODO remove ProviderStateReader on dispose for non-overriden providers.
      reader._providerState = null;
    }
  }
}
