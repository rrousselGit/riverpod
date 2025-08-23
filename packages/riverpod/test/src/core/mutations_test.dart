import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('Type checkers', () async {
    final container = ProviderContainer.test();
    final mut = Mutation<void>();

    expect(
      container.read(mut),
      isA<MutationIdle<void>>()
          .having((e) => e.isIdle, 'isIdle', true)
          .having((e) => e.isPending, 'isPending', false)
          .having((e) => e.hasError, 'hasError', false)
          .having((e) => e.isSuccess, 'isSuccess', false),
    );

    final future = mut.run(container, (tsx) async {});

    expect(
      container.read(mut),
      isA<MutationPending<void>>()
          .having((e) => e.isIdle, 'isIdle', false)
          .having((e) => e.isPending, 'isPending', true)
          .having((e) => e.hasError, 'hasError', false)
          .having((e) => e.isSuccess, 'isSuccess', false),
    );

    await future;

    expect(
      container.read(mut),
      isA<MutationSuccess<void>>()
          .having((e) => e.isIdle, 'isIdle', false)
          .having((e) => e.isPending, 'isPending', false)
          .having((e) => e.hasError, 'hasError', false)
          .having((e) => e.isSuccess, 'isSuccess', true),
    );

    await mut
        .run(container, (tsx) async {
          throw Exception('error');
        })
        .catchError((_) {});

    expect(
      container.read(mut),
      isA<MutationError<void>>()
          .having((e) => e.isIdle, 'isIdle', false)
          .having((e) => e.isPending, 'isPending', false)
          .having((e) => e.hasError, 'hasError', true)
          .having((e) => e.isSuccess, 'isSuccess', false),
    );
  });
}
