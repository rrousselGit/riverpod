import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import 'framework/framework.dart';

part 'common.freezed.dart';

typedef Create<Res, State extends ProviderState> = Res Function(State state);
typedef Create1<A, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
);
typedef Create2<A, B, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
);
typedef Create3<A, B, C, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
);

typedef Create4<A, B, C, D, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
  ProviderListenerState<D> forth,
);

typedef Create5<A, B, C, D, E, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
  ProviderListenerState<D> forth,
  ProviderListenerState<E> fifth,
);

typedef Create6<A, B, C, D, E, F, Res, State extends ProviderState> = Res
    Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
  ProviderListenerState<D> forth,
  ProviderListenerState<E> fifth,
  ProviderListenerState<F> sixth,
);

typedef Create7<A, B, C, D, E, F, G, Res, State extends ProviderState> = Res
    Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
  ProviderListenerState<D> forth,
  ProviderListenerState<E> fifth,
  ProviderListenerState<F> sixth,
  ProviderListenerState<G> seventh,
);

typedef Create8<A, B, C, D, E, F, G, H, Res, State extends ProviderState> = Res
    Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
  ProviderListenerState<D> forth,
  ProviderListenerState<E> fifth,
  ProviderListenerState<F> sixth,
  ProviderListenerState<G> seventh,
  ProviderListenerState<H> eighth,
);

typedef VoidCallback = void Function();

@freezed
abstract class AsyncValue<T> with _$AsyncValue<T> {
  factory AsyncValue.data(T value) = _Data<T>;
  const factory AsyncValue.loading() = _Loading<T>;
  factory AsyncValue.error(dynamic error, [StackTrace stackTrace]) = _Error<T>;
}
