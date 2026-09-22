import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

class Builder<FunctionT extends Function, ArgT> {
  Builder(this.ctor);

  final ArgT Function(FunctionT create, {bool isAutoDispose}) ctor;

  Factory<ArgT> build(FunctionT fn) {
    return ({Object isAutoDispose = const Object()}) {
      switch (isAutoDispose) {
        case const Object():
          return ctor(fn);
        case bool():
          return ctor(fn, isAutoDispose: isAutoDispose);
        default:
          throw ArgumentError('isAutoDispose must be a boolean');
      }
    };
  }
}

typedef Factory<CreatedT> = CreatedT Function({bool isAutoDispose});

final matrix = [
  // Functional
  Builder(Provider<Object?>.new).build((ref) => throw UnimplementedError()),
  Builder(
    Provider.family.call<Object?, Object?>,
  ).build((ref, arg) => throw UnimplementedError()),
  Builder(FutureProvider<Object?>.new).build(
    (ref) => throw UnimplementedError(),
  ),
  Builder(
    FutureProvider.family.call<Object?, Object?>,
  ).build((ref, arg) => throw UnimplementedError()),
  Builder(StreamProvider<Object?>.new).build(
    (ref) => throw UnimplementedError(),
  ),
  Builder(
    StreamProvider.family.call<Object?, Object?>,
  ).build((ref, arg) => throw UnimplementedError()),
  // Notifier
  Builder(NotifierProvider<Notifier<Object?>, Object?>.new).build(
    () => throw UnimplementedError(),
  ),
  Builder(
    NotifierProvider.family.call<Notifier<Object?>, Object?, Object?>,
  ).build((arg) => throw UnimplementedError()),
  Builder(AsyncNotifierProvider<AsyncNotifier<Object?>, Object?>.new).build(
    () => throw UnimplementedError(),
  ),
  Builder(
    AsyncNotifierProvider.family.call<AsyncNotifier<Object?>, Object?, Object?>,
  ).build((arg) => throw UnimplementedError()),
  Builder(StreamNotifierProvider<StreamNotifier<Object?>, Object?>.new).build(
    () => throw UnimplementedError(),
  ),
  Builder(
    StreamNotifierProvider.family.call<StreamNotifier<Object?>, Object?, Object?>,
  ).build((arg) => throw UnimplementedError()),
  // Legacy
  Builder(StateProvider<Object?>.new).build(
    (ref) => throw UnimplementedError(),
  ),
  Builder(
    StateProvider.family.call<Object?, Object?>,
  ).build((ref, arg) => throw UnimplementedError()),
  Builder(StateNotifierProvider<StateNotifier<Object?>, Object?>.new).build(
    (ref) => throw UnimplementedError(),
  ),
  Builder(
    StateNotifierProvider.family.call<StateNotifier<Object?>, Object?, Object?>,
  ).build((ref, arg) => throw UnimplementedError()),
];

void main() {
  test('Defaults isAutoDispose to false', () {
    for (final builder in matrix) {
      expect(
        builder().isAutoDispose,
        isFalse,
        reason: '${builder().runtimeType}',
      );
    }
  });

  test('Can set isAutoDispose', () {
    for (final builder in matrix) {
      expect(
        builder(isAutoDispose: true).isAutoDispose,
        isTrue,
        reason: '${builder().runtimeType}',
      );
    }
  });
}
