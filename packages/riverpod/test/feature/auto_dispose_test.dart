// ignore_for_file: inference_failure_on_generic_invocation

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
  Builder(Provider.new).build((ref) => throw UnimplementedError()),
  Builder(Provider.family.call).build((ref, arg) => throw UnimplementedError()),
  Builder(FutureProvider.new).build((ref) => throw UnimplementedError()),
  Builder(FutureProvider.family.call)
      .build((ref, arg) => throw UnimplementedError()),
  Builder(StreamProvider.new).build((ref) => throw UnimplementedError()),
  Builder(StreamProvider.family.call)
      .build((ref, arg) => throw UnimplementedError()),
  // Notifier
  Builder(NotifierProvider.new).build(() => throw UnimplementedError()),
  Builder(NotifierProvider.family.call)
      .build((arg) => throw UnimplementedError()),
  Builder(AsyncNotifierProvider.new).build(() => throw UnimplementedError()),
  Builder(AsyncNotifierProvider.family.call)
      .build((arg) => throw UnimplementedError()),
  Builder(StreamNotifierProvider.new).build(() => throw UnimplementedError()),
  Builder(StreamNotifierProvider.family.call)
      .build((arg) => throw UnimplementedError()),
  // Legacy
  Builder(StateProvider.new).build((ref) => throw UnimplementedError()),
  Builder(StateProvider.family.call)
      .build((ref, arg) => throw UnimplementedError()),
  Builder(StateNotifierProvider.new).build((ref) => throw UnimplementedError()),
  Builder(StateNotifierProvider.family.call)
      .build((ref, arg) => throw UnimplementedError()),
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
