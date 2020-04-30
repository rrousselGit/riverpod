import 'dart:async';

import '../common.dart';
import '../framework/framework.dart';

part 'base.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */
class StreamProviderValue<T> extends BaseProviderValue {
  StreamProviderValue._(this.stream);

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
