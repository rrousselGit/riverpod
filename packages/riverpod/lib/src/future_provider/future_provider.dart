import 'dart:async';

import 'package:meta/meta.dart';

import '../common.dart';
import '../framework/framework.dart';
import '../provider/provider.dart';
import '../stream_provider.dart';

/// The state of a [FutureProvider].
class FutureProviderDependency<T> extends ProviderDependencyBase {
  FutureProviderDependency._({@required this.future});

  /// The [Future] created by [FutureProvider].
  final Future<T> future;
}

/// A provider that asynchronously creates an immutable value.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates an immutable value
/// - [StreamProvider], a provider that asynchronously expose a value which can change over time.
class FutureProvider<Res> extends AlwaysAliveProviderBase<
    FutureProviderDependency<Res>, AsyncValue<Res>> {
  /// Creates a [FutureProvider] and allows specifying a [name].
  FutureProvider(this._create, {String name}) : super(name);

  final Create<Future<Res>, ProviderReference> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }

  /// A test utility to override a [FutureProvider] with a synchronous value.
  ///
  /// Overriding a [FutureProvider] with an [AsyncValue.data]/[AsyncValue.error]
  /// bypass the loading step that most streams have, which simplifies the test.
  ///
  /// It is possible to change the state emitted by changing the override
  /// on [ProviderStateOwner]/`ProviderScope`.
  ///
  /// Once an [AsyncValue.data]/[AsyncValue.error] was emitted, it is no longer
  /// possible to change the value exposed.
  ///
  /// This will create a made up [Future] for [FutureProviderDependency.future].
  Override debugOverrideWithValue(AsyncValue<Res> value) {
    ProviderOverride res;
    assert(() {
      res = overrideAs(
        _DebugValueFutureProvider(value),
      );
      return true;
    }(), '');
    return res;
  }
}

class _FutureProviderState<Res> extends ProviderStateBase<
    FutureProviderDependency<Res>, AsyncValue<Res>, FutureProvider<Res>> {
  Future<Res> _future;

  AsyncValue<Res> _state;
  @override
  AsyncValue<Res> get state => _state;
  set state(AsyncValue<Res> state) {
    _state = state;
    markMayHaveChanged();
  }

  @override
  void initState() {
    _state = const AsyncValue.loading();
    _future = provider._create(ProviderReference(this));
    // may update the value synchronously if the future is a SynchronousFuture from flutter
    _listen();
  }

  Future<void> _listen() async {
    try {
      final value = await _future;
      if (mounted) {
        state = AsyncValue.data(value);
      }
    } catch (err, stack) {
      if (mounted) {
        state = AsyncValue.error(err, stack);
      }
    }
  }

  @override
  FutureProviderDependency<Res> createProviderDependency() {
    return FutureProviderDependency._(future: _future);
  }
}

class _DebugValueFutureProvider<Res> extends AlwaysAliveProviderBase<
    FutureProviderDependency<Res>, AsyncValue<Res>> {
  _DebugValueFutureProvider(this._value, {String name}) : super(name);

  final AsyncValue<Res> _value;

  @override
  _DebugValueFutureProviderState<Res> createState() {
    _DebugValueFutureProviderState<Res> result;
    assert(() {
      result = _DebugValueFutureProviderState<Res>();
      return true;
    }(), '');
    return result;
  }
}

class _DebugValueFutureProviderState<Res> extends ProviderStateBase<
    FutureProviderDependency<Res>,
    AsyncValue<Res>,
    _DebugValueFutureProvider<Res>> {
  final _completer = Completer<Res>();

  AsyncValue<Res> _state;
  @override
  AsyncValue<Res> get state => _state;
  set state(AsyncValue<Res> state) {
    _state = state;
    markMayHaveChanged();
  }

  @override
  void initState() {
    provider._value.when(
      data: _completer.complete,
      loading: () {},
      error: _completer.completeError,
    );

    _state = provider._value;
  }

  @override
  void didUpdateProvider(_DebugValueFutureProvider<Res> oldProvider) {
    super.didUpdateProvider(oldProvider);

    if (provider._value != oldProvider._value) {
      oldProvider._value.maybeWhen(
        loading: () {},
        orElse: () => throw UnsupportedError(
          'Once an overide was built with a data/error, its state cannot change',
        ),
      );

      provider._value.when(
        data: (value) {
          state = AsyncValue.data(value);
          _completer.complete(value);
        },
        // Never reached. Either it doesn't enter the if, or it throws before
        loading: () {},
        error: (err, stack) {
          state = AsyncValue.error(err, stack);
          _completer.completeError(err, stack);
        },
      );
    }
  }

  @override
  FutureProviderDependency<Res> createProviderDependency() {
    return FutureProviderDependency._(future: _completer.future);
  }
}

/// Creates a [FutureProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class FutureProviderFamily<Result, A>
    extends Family<FutureProvider<Result>, A> {
  /// Creates a [FutureProvider] from external parameters.
  FutureProviderFamily(
      Future<Result> Function(ProviderReference ref, A a) create)
      : super((a) => FutureProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Future<Result> Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => FutureProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
