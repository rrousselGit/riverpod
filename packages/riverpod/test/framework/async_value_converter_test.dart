import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/async_value_converters.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncValue.next', () {
    test('returns the next AsyncData if any', () {
      expect(
        const AsyncData(21).next(const AsyncData(42)),
        const AsyncData(42),
      );
      expect(
        const AsyncError<int>(21).next(const AsyncData(42)),
        const AsyncData(42),
      );
      expect(
        const AsyncLoading<int>().next(const AsyncData(42)),
        const AsyncData(42),
      );
    });

    test('on error, keep the latest data', () {
      expect(
        const AsyncData(42).next(const AsyncError<int>('error')),
        const AsyncError<int>('error', previous: AsyncData(42)),
      );

      expect(
        const AsyncLoading<int>().next(const AsyncError<int>('error')),
        const AsyncError<int>('error'),
      );
      expect(
        const AsyncLoading<int>(previous: AsyncData(42))
            .next(const AsyncError<int>('error')),
        const AsyncError<int>('error', previous: AsyncData(42)),
      );
      expect(
        const AsyncLoading<int>(
          previous: AsyncError('error2', previous: AsyncData(42)),
        ).next(const AsyncError<int>('error')),
        const AsyncError<int>('error', previous: AsyncData(42)),
      );

      expect(
        const AsyncError<int>('error2').next(const AsyncError<int>('error')),
        const AsyncError<int>('error'),
      );
      expect(
        const AsyncError<int>('error2', previous: AsyncData(42))
            .next(const AsyncError<int>('error')),
        const AsyncError<int>('error', previous: AsyncData(42)),
      );
    });

    test('on loading, keep the latest data or error', () {
      expect(
        const AsyncData<int>(42).next(const AsyncLoading<int>()),
        const AsyncLoading<int>(previous: AsyncData<int>(42)),
      );

      expect(
        const AsyncError<int>('error').next(const AsyncLoading<int>()),
        const AsyncLoading<int>(previous: AsyncError<int>('error')),
      );
      expect(
        const AsyncError<int>('error', previous: AsyncData(42))
            .next(const AsyncLoading<int>()),
        const AsyncLoading<int>(
          previous: AsyncError<int>('error', previous: AsyncData(42)),
        ),
      );

      expect(
        const AsyncLoading<int>().next(const AsyncLoading<int>()),
        const AsyncLoading<int>(),
      );
      expect(
        const AsyncLoading<int>(previous: AsyncData(42))
            .next(const AsyncLoading<int>()),
        const AsyncLoading<int>(previous: AsyncData(42)),
      );
      expect(
        const AsyncLoading<int>(previous: AsyncError('error'))
            .next(const AsyncLoading<int>()),
        const AsyncLoading<int>(previous: AsyncError('error')),
      );
      expect(
        const AsyncLoading<int>(
          previous: AsyncError('error', previous: AsyncData(42)),
        ).next(const AsyncLoading<int>()),
        const AsyncLoading<int>(
          previous: AsyncError('error', previous: AsyncData(42)),
        ),
      );
    });
  });

  test('AsyncValue.latestDataOrError', () {
    expect(
      const AsyncData(42).latestDataOrError,
      const AsyncData(42),
    );

    expect(
      const AsyncError<int>('error').latestDataOrError,
      const AsyncError<int>('error'),
    );
    expect(
      const AsyncError<int>('error', previous: AsyncData(42)).latestDataOrError,
      const AsyncError<int>('error', previous: AsyncData(42)),
    );

    expect(const AsyncLoading<int>().latestDataOrError, null);
    expect(
      const AsyncLoading<int>(previous: AsyncData(42)).latestDataOrError,
      const AsyncData(42),
    );
    expect(
      const AsyncLoading<int>(
        previous: AsyncError<int>('error', previous: AsyncData(42)),
      ).latestDataOrError,
      const AsyncError<int>('error', previous: AsyncData(42)),
    );
  });

  test('AsyncValue.latestData', () {
    // ignore: omit_local_variable_types, unused_local_variable
    final AsyncData<int>? data = const AsyncData(42).latestData;

    expect(
      const AsyncData(42).latestData,
      const AsyncData(42),
    );

    expect(const AsyncError<int>('error').latestData, null);
    expect(
      const AsyncError<int>('error', previous: AsyncData(42)).latestData,
      const AsyncData(42),
    );

    expect(const AsyncLoading<int>().latestData, null);
    expect(
      const AsyncLoading<int>(previous: AsyncData(42)).latestData,
      const AsyncData(42),
    );
    expect(
      const AsyncLoading<int>(
        previous: AsyncError<int>('error', previous: AsyncData(42)),
      ).latestData,
      const AsyncData(42),
    );
  });
}
