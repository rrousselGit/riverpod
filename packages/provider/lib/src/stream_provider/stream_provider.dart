import 'dart:async';

import '../common.dart';
import '../framework/framework.dart';

part 'base.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */
class StreamProviderValue<T> extends ProviderState {
  StreamProviderValue._(
    this.stream,
    BaseProviderState<StreamProviderValue<T>, AsyncValue<T>,
            BaseProvider<StreamProviderValue<T>, AsyncValue<T>>>
        _state,
  ) : super(_state);

  final Stream<T> stream;
}

/* Providers */

abstract class StreamProvider<T>
    extends BaseProvider<StreamProviderValue<T>, AsyncValue<T>> {
  factory StreamProvider(Create<Stream<T>, ProviderState> create) =
      _StreamProvider<T>;

  ProviderOverride<StreamProviderValue<T>, AsyncValue<T>> overrideWithValue(
    AsyncValue<T> value,
  );
}
