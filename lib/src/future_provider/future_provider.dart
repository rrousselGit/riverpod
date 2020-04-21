import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework.dart';
import '../provider/provider.dart' show ProviderBuilder;

part 'future_provider_builder.dart';

/// A placeholder used by [FutureProvider]/[FutureProviderX].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class FutureProviderValue<T> {
  FutureProviderValue._(this._future);

  final Future<T> _future;
}

extension FutureProviderX<T> on ProviderListenerState<FutureProviderValue<T>> {
  /// The [Future] originally returned by the callback passed to [FutureProvider].
  // TODO test value is identical to future returned, for stacktrace
  Future<T> get value => $instance._future;
}

class FutureProvider<Res> extends BaseProvider<FutureProviderValue<Res>> {
  FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  AsyncValue<Res> call() {
    final future = BaseProvider.use(this)._future;
    return Hook.use(_FutureAsyncValueHook(future));
  }

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

class _FutureProviderState<Res>
    extends BaseProviderState<FutureProviderValue<Res>, FutureProvider<Res>> {
  @override
  FutureProviderValue<Res> initState() {
    return FutureProviderValue._(provider._create(this));
  }
}

class _FutureAsyncValueHook<T> extends Hook<AsyncValue<T>> {
  const _FutureAsyncValueHook(this._future);

  final Future<T> _future;

  @override
  _FutureAsyncValueHookState<T> createState() {
    return _FutureAsyncValueHookState<T>();
  }
}

class _FutureAsyncValueHookState<T>
    extends HookState<AsyncValue<T>, _FutureAsyncValueHook<T>> {
  AsyncValue<T> _value = const AsyncValue.loading();

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  Future<void> _listen() async {
    try {
      final value = await hook._future;
      if (context != null) {
        // TODO test mounted
        setState(() {
          _value = AsyncValue.data(value);
        });
      }
    } catch (err, stack) {
      if (context != null) {
        // TODO test mounted
        setState(() {
          _value = AsyncValue.error(err, stack);
        });
      }
    }
  }

  @override
  AsyncValue<T> build(BuildContext context) {
    return _value;
  }
}
