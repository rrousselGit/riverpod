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

extension<CreatedT, ArgT> on Builder<CreatedT Function(Ref ref), ArgT> {
  Factory<ArgT> get unimplemented => build((ref) => throw UnimplementedError());
}

extension<CreatedT, ArgT>
    on Builder<CreatedT Function(Ref ref, Object?), ArgT> {
  Factory<ArgT> get unimplemented =>
      build((ref, _) => throw UnimplementedError());
}

extension<CreatedT, ArgT> on Builder<CreatedT Function(), ArgT> {
  Factory<ArgT> get unimplemented => build(() => throw UnimplementedError());
}

typedef Factory<CreatedT> = CreatedT Function({bool isAutoDispose});

final matrix = [
  // Functional
  Builder(Provider.new).unimplemented,
  Builder(Provider.family.call).unimplemented,
  Builder(FutureProvider.new).unimplemented,
  Builder(FutureProvider.family.call).unimplemented,
  Builder(StreamProvider.new).unimplemented,
  Builder(StreamProvider.family.call).unimplemented,
  // Notifier
  Builder(NotifierProvider.new).unimplemented,
  Builder(NotifierProvider.family.call).unimplemented,
  Builder(AsyncNotifierProvider.new).unimplemented,
  Builder(AsyncNotifierProvider.family.call).unimplemented,
  Builder(StreamNotifierProvider.new).unimplemented,
  Builder(StreamNotifierProvider.family.call).unimplemented,
  // Legacy
  Builder(StateProvider.new).unimplemented,
  Builder(StateProvider.family.call).unimplemented,
  Builder(StateNotifierProvider.new).unimplemented,
  Builder(StateNotifierProvider.family.call).unimplemented,
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
