import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'framework.dart';

/// The most basic provider available. It creates and expose a value without
/// caring about what that value is.
///
/// Consider reading [BaseProvider] and [ProviderScope] first.
///
/// [Provider] is usually used with immutable objects, that may or may not
/// need to be "disposed".
/// While the value expose is usually immutable, it is still possible to trigger
/// updates with [Provider] if needed, thanks to the [ProviderState] object.
///
/// # Basic usage: Repository
///
/// A common use-case for this provider is a `Repository` class, which expose
/// some methods to do http requests.
/// By using [Provider], it allows us to potentially mock that `Repository` class
/// during tests (See [ProviderScope] for an example on how to do that).
///
/// A provider that expose such `Repository` would typically look like this:
///
/// ```dart
/// final useRepository = Provider((_) => Repository());
/// ```
///
/// Then, to read the provider we can do:
///
/// ```dart
/// // Note: this is a HookWidget, not a StatelessWidget
/// class MyApp extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Read our provider. Calling `useRepository` is possible only inside `build`.
///     final Repository repository = useRepository();
///
///     // use repository in some way
///   }
/// }
/// ```
///
/// # Example 2: A disposable object (Google's BLoC)
///
/// Another common use-case is objects that needs to be cleaned-up when
/// no-longer used, such that the BLoC pattern from Google.
///
// TODO: implement keepAlive
///
/// While a provider is _usually_ alive for the entire life-time of the
/// application, a provider can be explicitly told that it can dispose
/// of the associated resources when no-longer used.
///
/// This could be done through [ProviderState.keepAlive], combined with
/// [ProviderState.onDispose].
///
/// The first property tells the provider that it can clean-up the resources
/// when the provider is not listened to anymore.
///
/// The second method gives a way to perform operations when the resources are
/// disposed.
///
/// Both combined, we could create our BLoC like so:
///
/// ```dart
/// class MyBloc {
///   void dispose() {}
/// }
///
/// final useMyBloc = Provider<MyBloc>((state) {
///   // We tell Provider that resources can be disposed when no-longer used.
///   state.keepAlive = false;
///
///   // We create the object instance
///   final myBloc = MyBloc();
///
///   // We clean-up resources
///   state.onDispose(() {
///     myBloc.dispose();
///   });
///
///   // Finally, we expose the value
///   return myBloc;
/// });
/// ```
///
///
/// # Example 3: A value that changes over time ([Stream])
///
/// The value exposed by [Provider] doesn't have to never change.
/// If needed, it is possible to update the value, which will cause listeners
/// of the provider to rebuild accordingly.
///
/// To showcase this, we could use [Provider] to expose the latest value emitted
/// by a [Stream].
/// For the sake of simplicity, in our case the [Stream] will be [Stream.periodic],
/// which is a counter that automatically increment over time.
///
///
/// To do that, we could write the following:
///
/// ```dart
/// final usePeriodic = Provider((state) {
///   // A Stream that emits an incrementing value every seconds
///   final someStream = Stream<int>.periodic(const Duration(seconds: 1));
///
///   final subscription = someStream.listen((counter) {
///     // Whenever a new value is emited, we update the value exposed by Provider
///     state.value = counter;
///   });
///
///   // We cancel the subscription when the state is disposed
///   state.onDispose(subscription.cancel);
///
///   // We expose an initial value
///   return 0;
/// });
/// ```
///
/// Note: We could also use [StreamProvider] for this, which does this for us,
/// with a few extras (like reporting [Stream] errors).
///
/// See also:
///
/// - [BaseProvider], a base class that all providers implements.
///   It contains general explanation on how to use providers.
/// - [ProviderScope], the widget that stores the state of providers and expose
///   it to its descendants.

abstract class Provider<T> extends BaseProvider<T> {
  /// Creates a value using the callback and expose its result.
  ///
  /// The callback will be called _once and only once_.
  ///
  /// For updating the value exposed or doing some clean-up when the value is
  /// no longer used, see [ProviderState].
  factory Provider(T Function(ProviderState<T>) create) = _ProviderCreate<T>;

  /// AVOID using this constructor if possible.
  ///
  /// Expose a value without caching it. This can be useful when the value
  /// is created from outside of the providers. But it should not be
  /// used extensively.
  ///
  /// In most scenarios, consider using the default constructor: [Provider()].
  factory Provider.value(T value) = _ProviderValue<T>;
}

/// An object that allows manipulating the state of a provider or listening
/// to some life-cycles.
///
/// See also:
///
/// - [Provider], for some usage examples
abstract class ProviderState<T> {
  /// The value currently expose by the provider.
  ///
  /// Modifying this value will trigger widgets listening to this provider
  /// to update.
  ///
  /// It is `null` by default.
  T get value;
  set value(T newValue);

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
  var _debugIsDisposing = false;

  @override
  Res get value => state;

  @override
  set value(Res value) {
    assert(!_debugIsDisposing, 'Cannot update the state inside `onDispose`');
    state = value;
  }

  @override
  Res initState() => provider._create(this);

  @override
  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  @override
  void dispose() {
    assert(() {
      _debugIsDisposing = true;
      return true;
    }(), '');

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

class _ProviderValue<T> extends BaseProvider<T> implements Provider<T> {
  _ProviderValue(this._value);

  final T _value;

  @override
  _ProviderValueState<T> createState() => _ProviderValueState();
}

class _ProviderValueState<Res>
    extends BaseProviderState<Res, _ProviderValue<Res>> {
  @override
  Res initState() {
    return provider._value;
  }

  @override
  void didUpdateProvider(_ProviderValue<Res> oldProvider) {
    super.didUpdateProvider(oldProvider);
    if (provider._value != oldProvider._value) {
      state = provider._value;
    }
  }
}
