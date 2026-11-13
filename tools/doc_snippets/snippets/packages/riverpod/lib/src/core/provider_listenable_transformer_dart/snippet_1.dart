// GENERATED from packages/riverpod/lib/src/core/provider_listenable_transformer.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
// The examples are about the deprecated API that this file declares.
// ignore_for_file: deprecated_member_use
import 'package:riverpod/misc.dart';

final class Where<T> with SyncProviderTransformerMixin<T, T> {
  Where(this.source, this.where);
  @override
  final ProviderListenable<T> source;
  final bool Function(T previous, T value) where;

  @override
  ProviderTransformer<T, T> transform(
    ProviderTransformerContext<T, T> context,
  ) {
    return ProviderTransformer(
      initState: (_) => context.sourceState.requireValue,
      listener: (self, previous, next) {
        if (where(previous.requireValue, next.requireValue)) self.state = next;
      },
    );
  }
}

extension<T> on ProviderListenable<T> {
  ProviderListenable<T> where(bool Function(T previous, T value) where) =>
      Where<T>(this, where);
}
