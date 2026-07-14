part of '../framework.dart';

extension<T> on ProviderListenable<T> {
  ProviderListenable<ValueListenable<T>> get listenable {
    return _ListenableListenable(this);
  }
}

class _ListenableListenable<T>
    extends CustomProviderListenable<T, ValueListenable<T>> {
  _ListenableListenable(this.source);

  final ProviderListenable<T> source;

  @override
  _ListenableTransformer2<T> createTransformer() {
    return _ListenableTransformer2();
  }
}

final class _ListenableTransformer2<T>
    extends
        SyncProviderTransformer2<
          T,
          ValueListenable<T>,
          _ListenableListenable<T>
        > {}
