// ignore_for_file: public_member_api_docs
part of '../framework.dart';

/// A callback used by providers to create the value exposed.
///
/// If an exception is thrown within that callback, all attempts at reading
/// the provider associated with the given callback will throw.
///
/// The parameter [ref] can be used to interact with other providers
/// and the life-cycles of this provider.
///
/// See also:
///
/// - [ProviderReference], which exposes the methods to read other providers.
/// - [Provider], a provier that uses [Create] to expose an immutable value.
typedef Create<T, Ref extends ProviderReference> = T Function(Ref ref);

typedef Reader = T Function<T>(ProviderBase<Object, T> provider);

// Copied from Flutter
/// Returns a summary of the runtime type and hash code of `object`.
///
/// See also:
///
///  * [Object.hashCode], a value used when placing an object in a [Map] or
///    other similar data structure, and which is also used in debug output to
///    distinguish instances of the same class (hash collisions are
///    possible, but rare enough that its use in debug output is useful).
///  * [Object.runtimeType], the [Type] of an object.
String describeIdentity(Object object) {
  return '${object.runtimeType}#${shortHash(object)}';
}

// Copied from Flutter
/// [Object.hashCode]'s 20 least-significant bits.
String shortHash(Object object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

/// A base class for all providers, used to consume a provider.
///
/// Do not implement or extend.
abstract class ProviderListenable<Listened> {}

abstract class AlwaysAliveProviderBase<Created, Listened>
    extends ProviderBase<Created, Listened> {
  AlwaysAliveProviderBase(
    Created Function(ProviderReference ref) create,
    String name,
  ) : super(create, name);

  @override
  ProviderElement<Created, Listened> createElement() {
    return ProviderElement(this);
  }

  // Cannot be overriden by AutoDisposeProviders
  ProviderOverride overrideAsProvider(
    AlwaysAliveProviderBase<Created, Listened> provider,
  ) {
    return ProviderOverride(provider, this);
  }
}

abstract class ProviderBase<Created, Listened>
    implements ProviderListenable<Listened> {
  ProviderBase(this._create, this.name);

  final Created Function(ProviderReference ref) _create;

  final String name;

  Family _from;
  Family get from => _from;

  Object _argument;
  Object get argument => _argument;

  ProviderStateBase<Created, Listened> createState();
  ProviderElement<Created, Listened> createElement();

  @override
  String toString() {
    final content = {
      'name': name,
      'from': from,
      'argument': argument,
    }.entries.where((e) => e.value != null).map((e) => '${e.key}: ${e.value}');

    return '${describeIdentity(this)}$content';
  }

  /// Partially listen to a provider.
  ///
  /// Note: This method of listening to an object is currently only supported
  /// by `useProvider` from `hooks_riverpod` and [ProviderContainer.listen].
  ///
  /// The [select] function allows filtering unwanted rebuilds of a Widget
  /// by reading only the properties that we care about.
  ///
  /// For example, consider the following `ChangeNotifier`:
  ///
  /// ```dart
  /// class Person extends ChangeNotifier {
  ///   int _age = 0;
  ///   int get age => _age;
  ///   set age(int age) {
  ///     _age = age;
  ///     notifyListeners();
  ///   }
  ///
  ///   String _name = '';
  ///   String get name => _name;
  ///   set name(String name) {
  ///     _name = name;
  ///     notifyListeners();
  ///   }
  /// }
  ///
  /// final personProvider = ChangeNotifierProvider((_) => Person());
  /// ```
  ///
  /// In this class, both `name` and `age` may change, but a widget may need
  /// only `age`.
  ///
  /// If we used `useProvider`/`Consumer` as we normally would, this would cause
  /// widgets that only use `age` to still rebuild when `name` changes, which
  /// is inefficient.
  ///
  /// The method [select] can be used to fix this, by explicitly reading only
  /// a specific part of the object.
  ///
  /// A typical usage would be:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final age = useProvider(personProvider.select((p) => p.age));
  ///   return Text('$age');
  /// }
  /// ```
  ///
  /// This will cause our widget to rebuild **only** when `age` changes.
  ///
  ///
  /// **NOTE**: The function passed to [select] can return complex computations
  /// too.
  ///
  /// For example, instead of `age`, we could return a "isAdult" boolean:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final isAdult = useProvider(personProvider.select((p) => p.age >= 18));
  ///   return Text('$isAdult');
  /// }
  /// ```
  ///
  /// This will further optimise our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<Selected> select<Selected>(
    Selected Function(Listened value) selector,
  ) {
    return ProviderSelector<Listened, Selected>(
      provider: this,
      selector: selector,
    );
  }

  // Works only on ProviderBase<T, T> scenario by default
  // TODO support ChangeNotifier/StateNotifier
  Override overrideAsValue(Listened value) {
    return ProviderOverride(
      ValueProvider<Object, Listened>((ref) => value, value),
      this,
    );
  }
}

/// An internal class for `ProviderBase.select`.
class ProviderSelector<Input, Output> implements ProviderListenable<Output> {
  /// An internal class for `ProviderBase.select`.
  ProviderSelector({
    this.provider,
    this.selector,
  });

  final ProviderBase<Object, Input> provider;
  final Output Function(Input) selector;

  SelectorSubscription<Input, Output> _listen(
    ProviderContainer container, {
    void Function(SelectorSubscription<Input, Output> sub) mayHaveChanged,
    void Function(SelectorSubscription<Input, Output> sub) didChange,
  }) {
    return SelectorSubscription(
      container: container,
      selector: selector,
      provider: provider,
      mayHaveChanged: mayHaveChanged,
      didChange: didChange,
    );
  }
}

abstract class ProviderReference {
  bool get mounted;
  // TODO test
  ProviderContainer get container;

  void onDispose(void Function() cb);

  T read<T>(ProviderBase<Object, T> provider);
  T watch<T>(ProviderBase<Object, T> provider);
}

class _Listener<Listened> extends LinkedListEntry<_Listener<Listened>> {
  _Listener({
    this.mayHaveChanged,
    this.didChange,
    @required this.element,
  }) : lastNotificationCount = element._notificationCount - 1;

  int lastNotificationCount;

  final void Function() mayHaveChanged;
  final void Function() didChange;
  final ProviderElement<Object, Listened> element;
}

class ProviderSubscription<Listened> {
  ProviderSubscription._(this._listener);

  final _Listener<Listened> _listener;

  void close() {
    if (_listener.list != null) {
      _listener.unlink();
      _listener.element.didRemoveListener();
    }
  }

  bool flush() {
    if (_listener.list == null) {
      throw StateError(
        'Cannot call ProviderSubscription.flush() after close was called',
      );
    }
    _listener.element.flush();
    return _listener.element._notificationCount >
        _listener.lastNotificationCount;
  }

  Listened read() {
    if (_listener.list == null) {
      throw StateError(
        'Cannot call ProviderSubscription.read() after close was called',
      );
    }
    _listener.element.flush();
    _listener.lastNotificationCount = _listener.element._notificationCount;
    return _listener.element.getExposedValue();
  }
}

@visibleForTesting
class ProviderElement<Created, Listened> implements ProviderReference {
  ProviderElement(this._provider) : state = _provider.createState();

  static ProviderElement _debugCurrentlyBuildingElement;

  ProviderBase<Created, Listened> _origin;
  ProviderBase<Created, Listened> get origin => _origin;

  ProviderBase<Created, Listened> _provider;
  ProviderBase<Created, Listened> get provider => _provider;

  final ProviderStateBase<Created, Listened> state;

  ProviderContainer _container;
  @override
  ProviderContainer get container => _container;

  Set<ProviderElement> _dependents;
  @visibleForTesting
  Set<ProviderElement> get dependents => {...?_dependents};

  final _listeners = LinkedList<_Listener<Listened>>();
  var _subscriptions = <ProviderElement, ProviderSubscription>{};
  Map<ProviderElement, ProviderSubscription> _previousSubscriptions;
  DoubleLinkedQueue<void Function()> _onDisposeListeners;

  int _notificationCount = 0;
  int _notifyDidChangeLastNotificationCount = 0;
  bool _dirty = true;
  // initialized to true so that the initial state creation don't notify listeners
  bool _dependencyMayHaveChanged = true;
  // equivalent to _dependencyMayHaveChanged that does not rely on
  // ProviderSubscription.flush, to force recomputed a state
  bool _dependencyDidChange = false;

  bool get hasListeners => _listeners.isNotEmpty;

  bool _mounted = false;
  @override
  bool get mounted => _mounted;
  bool _didMount = false;

  ProviderException _exception;

  @override
  T read<T>(ProviderBase<Object, T> provider) {
    // TODO throw if non-circular dependency
    return _container.read(provider);
  }

  @override
  void onDispose(void Function() listener) {
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    _onDisposeListeners ??= DoubleLinkedQueue();
    _onDisposeListeners.add(listener);
  }

  @override
  T watch<T>(ProviderBase<Object, T> provider) {
    final element = _container.readProviderElement(provider);
    final sub = _subscriptions.putIfAbsent(element, () {
      final previousSub = _previousSubscriptions?.remove(element);
      if (previousSub != null) {
        return previousSub;
      }
      element._dependents ??= {};
      element._dependents.add(this);
      return element.listen(mayHaveChanged: _markDependencyMayHaveChanged);
    }) as ProviderSubscription<T>;
    return sub.read();
  }

  void _markDependencyMayHaveChanged(ProviderSubscription sub) {
    if (!_dependencyMayHaveChanged) {
      _dependencyMayHaveChanged = true;
      notifyMayHaveChanged();
    }
  }

  ProviderSubscription<Listened> listen({
    void Function(ProviderSubscription<Listened> sub) mayHaveChanged,
    void Function(ProviderSubscription<Listened> sub) didChange,
  }) {
    ProviderSubscription<Listened> sub;
    final entry = _Listener<Listened>(
      mayHaveChanged: mayHaveChanged == null ? null : () => mayHaveChanged(sub),
      didChange: didChange == null ? null : () => didChange(sub),
      element: this,
    );
    _listeners.add(entry);

    return sub = ProviderSubscription._(entry);
  }

  void flush() {
    if (_dependencyMayHaveChanged || _dependencyDidChange) {
      _dependencyMayHaveChanged = false;
      // must be executed before _runStateCreate() so that errors during
      // creation are not silenced
      _exception = null;
      _runOnDispose();

      var hasAnyDependencyChanged = _dependencyDidChange;
      for (final sub in _subscriptions.values) {
        if (sub.flush()) {
          hasAnyDependencyChanged = true;
        }
      }
      if (hasAnyDependencyChanged) {
        _runStateCreate();
      }
      _dependencyDidChange = false;
    }
    _dirty = false;
    if (_notifyDidChangeLastNotificationCount != _notificationCount) {
      _notifyDidChangeLastNotificationCount = _notificationCount;
      _notifyDidChange();
    }
    assert(!_dirty, 'flush did not reset the dirty flag for $provider');
    assert(
      !_dependencyMayHaveChanged,
      'flush did not reset the _dependencyMayHaveChanged flag for $provider',
    );
  }

  Listened getExposedValue() {
    assert(
      !_dependencyMayHaveChanged,
      'Called getExposedValue without calling flush before',
    );
    if (_exception != null) {
      throw _exception;
    }
    return state._exposedValue;
  }

  @protected
  void markDidChange() {
    if (!_didMount) {
      return;
    }
    _notificationCount++;
    notifyMayHaveChanged();
  }

  @protected
  void notifyMayHaveChanged() {
    assert(() {
      if (_debugCurrentlyBuildingElement == null ||
          _debugCurrentlyBuildingElement == this) {
        return true;
      }
      final parentsQueue = DoubleLinkedQueue<ProviderElement>.from(
        _subscriptions.keys,
      );

      while (parentsQueue.isNotEmpty) {
        final parent = parentsQueue.removeFirst();
        if (parent == _debugCurrentlyBuildingElement) {
          return true;
        }
        parentsQueue.addAll(parent._subscriptions.keys);
      }

      throw AssertionError('''
The provider $provider was marked as needing to be recomputed while creating ${_debugCurrentlyBuildingElement.provider},
but $provider does not depend on ${_debugCurrentlyBuildingElement.provider}.
''');
    }(), '');
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    if (_dirty) {
      return;
    }
    _dirty = true;
    for (final listener in _listeners) {
      if (listener.mayHaveChanged != null) {
        // TODO don't notify again if the listener is already notified and haven't flushed yet
        _runGuarded(listener.mayHaveChanged);
      }
    }
    if (_didMount) {
      for (final observer in _container._observers) {
        _runUnaryGuarded(
          observer.mayHaveChanged,
          _origin,
        );
      }
    }
  }

  @protected
  void _notifyDidChange() {
    for (final listener in _listeners) {
      if (listener.didChange != null) {
        _runGuarded(listener.didChange);
      }
    }
    for (final observer in _container._observers) {
      _runBinaryGuarded(
        observer.didUpdateProvider,
        _origin,
        state._exposedValue,
      );
    }
  }

  @protected
  void didRemoveListener() {}

  @protected
  @mustCallSuper
  void mount() {
    _mounted = true;
    state._element = this;
    _runStateCreate();
    _didMount = true;
    _dirty = false;
    _dependencyMayHaveChanged = false;
  }

  // ignore: use_setters_to_change_properties
  @protected
  @mustCallSuper
  void update(ProviderBase<Created, Listened> newProvider) {
    _provider = newProvider;
  }

  @protected
  @mustCallSuper
  void dispose() {
    _mounted = false;
    _runOnDispose();

    for (final sub in _subscriptions.entries) {
      sub.key._dependents.remove(this);
      sub.value.close();
    }

    for (final observer in _container._observers) {
      _runUnaryGuarded(
        observer.didDisposeProvider,
        _origin,
      );
    }

    _listeners.clear();
    state.dispose();
  }

  void markMustRecomputeState() {
    _dependencyDidChange = true;
    notifyMayHaveChanged();
  }

  @protected
  void _runOnDispose() {
    _onDisposeListeners?.forEach(_runGuarded);
    _onDisposeListeners = null;
  }

  @protected
  void _runStateCreate() {
    final previous = state._createdValue;
    _previousSubscriptions = _subscriptions;
    _subscriptions = {};
    ProviderElement previouslyBuildingElement;
    assert(() {
      previouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
      return true;
    }(), '');
    try {
      state._createdValue = _provider._create(this);
      state.valueChanged(previous: previous);
    } catch (err, stack) {
      _exception = ProviderException._(err, stack, _provider);
    } finally {
      assert(() {
        _debugCurrentlyBuildingElement = previouslyBuildingElement;
        return true;
      }(), '');
      if (_previousSubscriptions != null) {
        for (final sub in _previousSubscriptions.entries) {
          sub.key._dependents.remove(this);
          sub.value.close();
        }
      }
      _previousSubscriptions = null;
    }
  }
}

abstract class ProviderStateBase<Created, Listened> {
  ProviderElement<Created, Listened> _element;
  ProviderReference get ref => _element;

  Created _createdValue;
  Created get createdValue => _createdValue;

  Listened _exposedValue;
  Listened get exposedValue => _exposedValue;
  set exposedValue(Listened exposedValue) {
    _exposedValue = exposedValue;
    _element.markDidChange();
  }

  @protected
  void valueChanged({Created previous});

  @protected
  void dispose() {}

  @protected
  void markMayHaveChanged() => _element.notifyMayHaveChanged();
}

class ProviderException implements Exception {
  ProviderException._(this.exception, this.stackTrace, this.provider);

  final Object exception;
  final StackTrace stackTrace;
  final ProviderBase provider;

  @override
  String toString() {
    return '''
An exception was thrown while building $provider.

Thrown exception:
$exception

Stack trace:
$stackTrace
''';
  }
}
