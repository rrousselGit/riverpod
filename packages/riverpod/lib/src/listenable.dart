import 'package:meta/meta.dart';

import 'framework.dart' show ProviderElementBase;
import 'internals.dart' show OnError;
import 'pragma.dart';
import 'result.dart';

/// Listener for [_ValueListenable]
class _Listener<T> {
  _Listener._(this.onValue, this.onError, this.onDependencyMayHaveChanged);

  final void Function(T? previous, T next) onValue;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final void Function()? onDependencyMayHaveChanged;
}

/// A listenable object used by [ProviderElementBase] as a mean to subscribe
/// to subsets of the state exposed by a provider.
@internal
@optionalTypeArgs
class ProxyElementValueNotifier<T> extends _ValueListenable<T> {
  /// Directly obtain the value exposed, gratefully handling cases where
  /// [result] is null or in error state.
  T get value {
    final result = _result;
    if (result == null) {
      throw StateError('Trying to read an uninitialized value.');
    }
    return result.requireState;
  }

  /// The state associated with this notifier.
  ///
  /// Modifying this property will notify listeners.
  Result<T>? get result => _result;
  Result<T>? _result;
  set result(Result<T>? value) {
    final previous = _result;
    _result = value;
    value?.when(
      data: (newValue) => _notifyValue(previous?.stateOrNull, newValue),
      error: _notifyError,
    );
  }

  /// Updates the [result] of this [ProxyElementValueNotifier] without invoking listeners.
  // ignore: use_setters_to_change_properties, non_constant_identifier_names
  void UNSAFE_setResultWithoutNotifyingListeners(Result<T>? value) {
    _result = value;
  }
}

class _ValueListenable<T> {
  int _count = 0;
  // The _listeners is intentionally set to a fixed-length _GrowableList instead
  // of const [].
  //
  // The const [] creates an instance of _ImmutableList which would be
  // different from fixed-length _GrowableList used elsewhere in this class.
  // keeping runtime type the same during the lifetime of this class lets the
  // compiler to infer concrete type for this property, and thus improves
  // performance.
  static List<_Listener<T>?> _emptyListeners<T>() =>
      List<_Listener<T>?>.filled(0, null);

  List<_Listener<T>?> _listeners = _emptyListeners();
  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedListeners = 0;
  bool _debugDisposed = false;

  static bool debugAssertNotDisposed(_ValueListenable<Object?> notifier) {
    assert(
      !notifier._debugDisposed,
      'A ${notifier.runtimeType} was used after being disposed.\n'
      'Once you have called dispose() on a ${notifier.runtimeType}, it '
      'can no longer be used.',
    );
    return true;
  }

  /// Whether any listeners are currently registered.
  ///
  /// Clients should not depend on this value for their behavior, because having
  /// one listener's logic change when another listener happens to start or stop
  /// listening will lead to extremely hard-to-track bugs. Subclasses might use
  /// this information to determine whether to do any work when there are no
  /// listeners, however; for example, resuming a [Stream] when a listener is
  /// added and pausing it when a listener is removed.
  ///
  /// Typically this is used by overriding [addListener], checking if
  /// [hasListeners] is false before calling `super.addListener()`, and if so,
  /// starting whatever work is needed to determine when to call
  /// [_notifyListeners]; and similarly, by overriding [_removeListener], checking
  /// if [hasListeners] is false after calling `super.removeListener()`, and if
  /// so, stopping that same work.
  @protected
  bool get hasListeners {
    return _count > 0;
  }

  /// Register a closure to be called when the object changes.
  ///
  /// If the given closure is already registered, an additional instance is
  /// added, and must be removed the same number of times it is added before it
  /// will stop being called.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// {@template flutter.foundation._ChangeNotifier.addListener}
  /// If a listener is added twice, and is removed once during an iteration
  /// (e.g. in response to a notification), it will still be called again. If,
  /// on the other hand, it is removed as many times as it was registered, then
  /// it will no longer be called. This odd behavior is the result of the
  /// [_ValueListenable] not being able to determine which listener is being
  /// removed, since they are identical, therefore it will conservatively still
  /// call all the listeners when it knows that any are still registered.
  ///
  /// This surprising behavior can be unexpectedly observed when registering a
  /// listener on two separate objects which are both forwarding all
  /// registrations to a common upstream object.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [_removeListener], which removes a previously registered closure from
  ///    the list of closures that are notified when the object changes.
  void Function() addListener(
    void Function(T?, T) onChange, {
    required OnError? onError,
    required void Function()? onDependencyMayHaveChanged,
  }) {
    assert(_ValueListenable.debugAssertNotDisposed(this), '');

    final listener = _Listener._(onChange, onError, onDependencyMayHaveChanged);
    if (_count == _listeners.length) {
      if (_count == 0) {
        _listeners = List<_Listener<T>?>.filled(1, null);
      } else {
        final newListeners =
            List<_Listener<T>?>.filled(_listeners.length * 2, null);
        for (var i = 0; i < _count; i++) {
          newListeners[i] = _listeners[i];
        }
        _listeners = newListeners;
      }
    }
    _listeners[_count++] = listener;

    return () => _removeListener(listener);
  }

  void _removeAt(int index) {
    // The list holding the listeners is not growable for performances reasons.
    // We still want to shrink this list if a lot of listeners have been added
    // and then removed outside a _notifyListeners iteration.
    // We do this only when the real number of listeners is half the length
    // of our list.
    _count -= 1;
    if (_count * 2 <= _listeners.length) {
      final newListeners = List<_Listener<T>?>.filled(_count, null);

      // Listeners before the index are at the same place.
      for (var i = 0; i < index; i++) {
        newListeners[i] = _listeners[i];
      }

      // Listeners after the index move towards the start of the list.
      for (var i = index; i < _count; i++) {
        newListeners[i] = _listeners[i + 1];
      }

      _listeners = newListeners;
    } else {
      // When there are more listeners than half the length of the list, we only
      // shift our listeners, so that we avoid to reallocate memory for the
      // whole list.
      for (var i = index; i < _count; i++) {
        _listeners[i] = _listeners[i + 1];
      }
      _listeners[_count] = null;
    }
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  ///
  /// This method returns immediately if [dispose] has been called.
  ///
  /// {@macro flutter.foundation._ChangeNotifier.addListener}
  ///
  /// See also:
  ///
  ///  * [addListener], which registers a closure to be called when the object
  ///    changes.
  void _removeListener(_Listener<T> listener) {
    // This method is allowed to be called on disposed instances for usability
    // reasons. Due to how our frame scheduling logic between render objects and
    // overlays, it is common that the owner of this instance would be disposed a
    // frame earlier than the listeners. Allowing calls to this method after it
    // is disposed makes it easier for listeners to properly clean up.
    for (var i = 0; i < _count; i++) {
      final listenerAtIndex = _listeners[i];
      if (listenerAtIndex == listener) {
        if (_notificationCallStackDepth > 0) {
          // We don't resize the list during _notifyListeners iterations
          // but we set to null, the listeners we want to remove. We will
          // effectively resize the list at the end of all _notifyListeners
          // iterations.
          _listeners[i] = null;
          _reentrantlyRemovedListeners++;
        } else {
          // When we are outside the _notifyListeners iterations we can
          // effectively shrink the list.
          _removeAt(i);
        }
        break;
      }
    }
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] will throw after the object is disposed).
  ///
  /// This method should only be called by the object's owner.
  ///
  /// This method does not notify listeners, and clears the listener list once
  /// it is called. Consumers of this class must decide on whether to notify
  /// listeners or not immediately before disposal.
  @mustCallSuper
  void dispose() {
    assert(
      () {
        _debugDisposed = true;
        return true;
      }(),
      '',
    );
    _listeners = _emptyListeners();
    _count = 0;
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// Listeners should not throw.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [_removeListener].
  @protected
  @notifyDebuggerOnException
  void _notifyListeners(void Function(_Listener<T> listener) notify) {
    assert(_ValueListenable.debugAssertNotDisposed(this), '');
    if (_count == 0) {
      return;
    }

    // To make sure that listeners removed during this iteration are not called,
    // we set them to null, but we don't shrink the list right away.
    // By doing this, we can continue to iterate on our list until it reaches
    // the last listener added before the call to this method.

    // To allow potential listeners to recursively call notifyListener, we track
    // the number of times this method is called in _notificationCallStackDepth.
    // Once every recursive iteration is finished (i.e. when _notificationCallStackDepth == 0),
    // we can safely shrink our list so that it will only contain not null
    // listeners.

    _notificationCallStackDepth++;

    final end = _count;
    for (var i = 0; i < end; i++) {
      try {
        final listener = _listeners[i];
        if (listener != null) {
          notify(listener);
        }
      } catch (exception, stack) {
        throw StateError(
          'An exception was thrown inside a _ChangeNotifier listener:'
          '\n$exception\n$stack',
        );
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 && _reentrantlyRemovedListeners > 0) {
      // We really remove the listeners when all notifications are done.
      final newLength = _count - _reentrantlyRemovedListeners;
      if (newLength * 2 <= _listeners.length) {
        // As in _removeAt, we only shrink the list when the real number of
        // listeners is half the length of our list.
        final newListeners = List<_Listener<T>?>.filled(newLength, null);

        var newIndex = 0;
        for (var i = 0; i < _count; i++) {
          final listener = _listeners[i];
          if (listener != null) {
            newListeners[newIndex++] = listener;
          }
        }

        _listeners = newListeners;
      } else {
        // Otherwise we put all the null references at the end.
        for (var i = 0; i < newLength; i += 1) {
          if (_listeners[i] == null) {
            // We swap this item with the next not null item.
            var swapIndex = i + 1;
            while (_listeners[swapIndex] == null) {
              swapIndex += 1;
            }
            _listeners[i] = _listeners[swapIndex];
            _listeners[swapIndex] = null;
          }
        }
      }

      _reentrantlyRemovedListeners = 0;
      _count = newLength;
    }
  }

  void _notifyValue(T? prev, T next) {
    _notifyListeners((listener) => listener.onValue(prev, next));
  }

  void _notifyError(Object err, StackTrace stack) {
    _notifyListeners((listener) => listener.onError?.call(err, stack));
  }

  void notifyDependencyMayHaveChanged() {
    _notifyListeners((listener) => listener.onDependencyMayHaveChanged?.call());
  }
}
