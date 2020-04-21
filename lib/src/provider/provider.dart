import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../combiner.dart';
import '../framework.dart';

part 'provider1.dart';
part 'provider_builder.dart';

/// A placeholder used by [Provider] and [ProviderX].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class Immutable<T> {
  @visibleForTesting
  Immutable(this._value);

  final T _value;
}

extension ProviderX<T> on ProviderListenerState<Immutable<T>> {
  BaseProviderState<Immutable<T>, BaseProvider<Immutable<T>>> get _state {
    return this as BaseProviderState<Immutable<T>, BaseProvider<Immutable<T>>>;
  }

  // ignore: invalid_use_of_protected_member
  T get value => _state.state._value;
}

abstract class Provider<T> extends BaseProvider<Immutable<T>> {
  factory Provider(Create<T, ProviderState<T>> create) = _ProviderCreate<T>;

  T call();
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
  /// It can be useful as, once disposed, trying to update [_value]
  /// will cause an exception.
  bool get mounted;

  /// Allows performing custom operations before the provider is disposed.
  ///
  /// It is possible to call [onDispose] multiple time.
  /// All callbacks registered using [onDispose] are guanranteed to be executed,
  /// even if one of them throws. And they will be called in order of registration.
  void onDispose(VoidCallback cb);
}

class _ProviderCreate<T> extends BaseProvider<Immutable<T>>
    implements Provider<T> {
  _ProviderCreate(this._create);

  final Create<T, ProviderState<T>> _create;

  @override
  T call() => BaseProvider.use(this)._value;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<Immutable<Res>, _ProviderCreate<Res>>
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
  Immutable<Res> initState() => Immutable(provider._create(this));

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
