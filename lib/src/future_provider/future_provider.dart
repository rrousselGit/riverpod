import 'package:freezed_annotation/freezed_annotation.dart';

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
class FutureProviderValue<T> {}

extension FutureProviderX<T> on ProviderListenerState<FutureProviderValue<T>> {
  _BaseFutureProviderState<T> get _state => this as _BaseFutureProviderState<T>;

  /// The [Future] originally returned by the callback passed to [FutureProvider].
  // TODO test value is identical to future returned, for stacktrace
  Future<T> get value => _state._future;
}

class FutureProvider<Res> extends BaseProvider<FutureProviderValue<Res>> {
  FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

abstract class _BaseFutureProviderState<Res> {
  Future<Res> get _future;
}

class _FutureProviderState<Res>
    extends BaseProviderState<FutureProviderValue<Res>, FutureProvider<Res>>
    implements _BaseFutureProviderState<Res>, FutureProviderValue<Res> {
  @override
  Future<Res> _future;

  @override
  FutureProviderValue<Res> initState() {
    _future = provider._create(this);
    return this;
  }
}
