import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'framework.dart';

abstract class Provider<T> extends BaseProvider<T> {
  factory Provider(T Function(ProviderState<T>) create) = _ProviderCreate<T>;
}

/// An object that allows manipulating the state of a provider or listening
/// to some life-cycles.
///
/// See also:
///
/// - [Provider], for some usage examples
abstract class ProviderState<T> {
  // /// The value currently expose by the provider.
  // ///
  // /// Modifying this value will trigger widgets listening to this provider
  // /// to update.
  // ///
  // /// It is `null` by default.
  // T get value;
  // set value(T newValue);

  /// Whether the provider's state was disposed or not.
  ///
  /// It can be useful as, once disposed, trying to update [value]
  /// will cause an exception.
  bool get mounted;

  /// Allows performing custom operations before the provider is disposed.
  ///
  /// It is possible to call [onDispose] multiple time.
  /// All callbacks registered using [onDispose] are guanranteed to be executed,
  /// even if one of them throws. And they will be called in order of registration.
  void onDispose(VoidCallback cb);
}

class _ProviderCreate<T> extends BaseProvider<T> implements Provider<T> {
  _ProviderCreate(this._create);

  final T Function(ProviderState<T>) _create;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<Res, _ProviderCreate<Res>>
    implements ProviderState<Res> {
  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;
  // var _debugIsDisposing = false;

  // @override
  // Res get value => state;

  // @override
  // set value(Res value) {
  //   assert(!_debugIsDisposing, 'Cannot update the state inside `onDispose`');
  //   state = value;
  // }

  @override
  Res initState() => provider._create(this);

  @override
  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  @override
  void dispose() {
    // assert(() {
    //   _debugIsDisposing = true;
    //   return true;
    // }(), '');

    if (_onDisposeCallbacks != null) {
      for (final disposeCb in _onDisposeCallbacks) {
        try {
          disposeCb();
        } catch (err, stack) {
          FlutterError.reportError(
            FlutterErrorDetails(
              library: 'provider_hooks',
              exception: err,
              stack: stack,
            ),
          );
        }
      }
    }
    super.dispose();
  }
}
