import 'package:freezed_annotation/freezed_annotation.dart';

import '../framework.dart';

part 'future_provider.freezed.dart';

@freezed
abstract class FutureSnapshot<T> {
  @visibleForTesting
  factory FutureSnapshot.data(T value) = _Data;
  @visibleForTesting
  const factory FutureSnapshot.loading() = _Loading;
  @visibleForTesting
  factory FutureSnapshot.error(dynamic error, [StackTrace stackTrace]) = _Error;
}

final futureProvider = FutureProvider((state) async {
  return 42;
});

class FutureProvider<Res> extends BaseProvider<FutureSnapshot<Res>> {
  FutureProvider(this._create);

  final Create<Future<Res>, void> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

class _FutureProviderState<Res>
    extends BaseProviderState<FutureSnapshot<Res>, FutureProvider<Res>> {
  @override
  FutureSnapshot<Res> initState() {
    final future = provider._create(null);
    return const FutureSnapshot.loading();
  }
}
