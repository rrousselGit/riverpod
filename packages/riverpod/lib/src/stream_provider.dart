import 'dart:async';

import 'builders.dart';
import 'common.dart' show AsyncLoading, AsyncValue;
import 'framework.dart';
import 'provider.dart';

part 'stream_provider/base.dart';
part 'stream_provider/auto_dispose.dart';

mixin _StreamProviderMixin<T> on ProviderBase<Stream<T>, AsyncValue<T>> {
  @override
  Override overrideWithValue(AsyncValue<T> value) {
    return ProviderOverride(
      ValueProvider<Stream<T>, AsyncValue<T>>((ref) {
        AsyncValue<T> lastValue;
        final controller = StreamController<T>();
        ref.onDispose(controller.close);

        ref.onChange = (newValue) {
          newValue.when(
            data: controller.add,
            loading: () {
              if (lastValue != null && lastValue is! AsyncLoading) {
                ref.markMustRecomputeState();
              }
            },
            error: controller.addError,
          );
          lastValue = newValue;
        };

        ref.onChange(value);

        return controller.stream.asBroadcastStream();
      }, value),
      this,
    );
  }

  ProviderBase<Stream<T>, Stream<T>> get stream;
}

/// {@template riverpod.streamprovider}
/// Hello world
/// {@endtemplate}
// TODO restore StreamProvider doc
mixin _StreamProviderStateMixin<T>
    on ProviderStateBase<Stream<T>, AsyncValue<T>> {
  StreamSubscription<T> sub;
  Stream<T> _realStream;

  @override
  void valueChanged({Stream<T> previous}) {
    if (createdValue == previous) {
      return;
    }
    _realStream = createdValue.asBroadcastStream();

    sub?.cancel();
    // TODO transition between state ??= vs =
    // TODO don't notify if already loading
    exposedValue = const AsyncValue.loading();
    sub = _realStream?.listen(
      (value) => exposedValue = AsyncValue.data(value),
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stack) {
        exposedValue = AsyncValue.error(error, stack);
      },
    );
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }
}

Future<T> _readLast<T>(
  ProviderReference ref,
  _StreamProviderMixin<T> provider,
) {
  return ref.watch(provider).when(
        data: (value) => Future.value(value),
        loading: () => ref.watch(provider.stream).first,
        error: (err, stack) => Future.error(err, stack),
      );
}

// Fork of CreatedProvider to retreive _realStream instead of createdValue

class _CreatedStreamProvider<T> extends Provider<Stream<T>> {
  _CreatedStreamProvider(
    ProviderBase<Stream<T>, Object> provider, {
    String name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final state = ref.container.readProviderElement(provider).state;

          return state is _StreamProviderStateMixin<T>
              ? state._realStream
              : state.createdValue;
        }, name: name);
}

class _AutoDisposeCreatedStreamProvider<T>
    extends AutoDisposeProvider<Stream<T>> {
  _AutoDisposeCreatedStreamProvider(
    ProviderBase<Stream<T>, Object> provider, {
    String name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final state = ref.container.readProviderElement(provider).state;

          return state is _StreamProviderStateMixin<T>
              ? state._realStream
              // Reached when using `.stream` on a `StreamProvider.overrideWithValue`
              : state.createdValue;
        }, name: name);
}
