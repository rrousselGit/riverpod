import 'package:freezed_annotation/freezed_annotation.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework.dart';
import '../provider/provider.dart' show ProviderBuilder;

part 'future_provider_builder.dart';
part 'future_provider.freezed.dart';

@freezed
abstract class AsyncValue<T> {
  @visibleForTesting
  factory AsyncValue.data(T value) = _Data<T>;
  @visibleForTesting
  const factory AsyncValue.loading() = _Loading<T>;
  @visibleForTesting
  factory AsyncValue.error(dynamic error, [StackTrace stackTrace]) = _Error<T>;
}

class FutureProvider<Res> extends BaseProvider<ImmutableValue<AsyncValue<Res>>> {
  FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

class _FutureProviderState<Res>
    extends BaseProviderState<ImmutableValue<AsyncValue<Res>>, FutureProvider<Res>> {
  @override
  ImmutableValue<AsyncValue<Res>> initState() {
    _listen(provider._create(this));
    return const ImmutableValue(AsyncValue.loading());
  }

  Future<void> _listen(Future<Res> future) async {
    try {
      final value = await future;
      if (mounted) {
        // TODO test unmounted
        state = ImmutableValue(AsyncValue.data(value));
      }
    } catch (err, stack) {
      if (mounted) {
        // TODO test unmounted
        state = ImmutableValue(AsyncValue.error(err, stack));
      }
    }
  }
}
