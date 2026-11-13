// GENERATED from packages/riverpod/lib/src/core/provider_listenable_transformer2.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/misc.dart';

final class Where<T> extends CustomProviderListenable<T, T> {
  Where(this.source, this.where);

  @override
  final ProviderListenable<T> source;
  final bool Function(T previous, T value) where;

  @override
  _WhereTransformer<T> createTransformer() => _WhereTransformer<T>();
}

final class _WhereTransformer<T>
    extends SyncProviderTransformer2<T, T, Where<T>> {
  @override
  T initState() => sourceState.requireValue;

  @override
  void onEvent(AsyncResult<T> prev, AsyncResult<T> next) {
    if (listenable.where(prev.requireValue, next.requireValue)) {
      state = next;
    }
  }
}

extension<T> on ProviderListenable<T> {
  ProviderListenable<T> where(bool Function(T previous, T value) where) =>
      Where<T>(this, where);
}
