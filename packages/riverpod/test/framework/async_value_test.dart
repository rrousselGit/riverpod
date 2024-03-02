// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group('custom AsyncValue', () {
    test('supports when', () {
      expect(
        const CustomData(42).whenOrNull(data: (v) => v * 2),
        84,
      );

      expect(
        const CustomError<int>(42, stackTrace: StackTrace.empty)
            .whenOrNull(data: (v) => v * 2),
        null,
      );

      expect(
        const CustomLoading<int>().whenOrNull(data: (v) => v * 2),
        null,
      );
    });
  });

  test('unwrapPrevious', () {
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .unwrapPrevious(),
      const AsyncLoading<int>(),
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncLoading<int>(),
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncError('err', StackTrace.empty),
              isRefresh: false,
            ),
          )
          .unwrapPrevious(),
      const AsyncLoading<int>(),
    );

    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncLoading())
          .unwrapPrevious(),
      const AsyncData<int>(42),
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncData<int>(42),
    );

    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncLoading())
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncError(21, StackTrace.empty))
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .unwrapPrevious(),
      const AsyncError<int>(42, StackTrace.empty),
    );
  });

  group('copyWithPrevious', () {
    group('with seamless: false', () {
      test('with AsyncLoading, is identical to the incoming AsyncLoading', () {
        final incomingLoading = const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false);
        final result = const AsyncLoading<int>()
            .copyWithPrevious(incomingLoading, isRefresh: false);

        expect(result, same(incomingLoading));
      });

      test('with AsyncData, sets value and hasValue', () {
        final result = const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false);

        expect(result, isA<AsyncLoading<int>>());
        expect(result.hasValue, true);
        expect(result.value, 42);

        expect(result.hasError, false);
        expect(result.error, null);
        expect(result.stackTrace, null);
      });

      test(
          'with AsyncError, sets error and stackTraces while also importing hasValue/value',
          () {
        final error = const AsyncError<int>(Object(), StackTrace.empty)
            .copyWithPrevious(const AsyncData(42));
        final result =
            const AsyncLoading<int>().copyWithPrevious(error, isRefresh: false);

        expect(result, isA<AsyncLoading<int>>());
        expect(result.hasValue, true);
        expect(result.value, 42);

        expect(result.hasError, true);
        expect(result.error, const Object());
        expect(result.stackTrace, StackTrace.empty);
      });
    });

    group('with seamless:true', () {
      group('on AsyncError', () {
        test('with AsyncLoading', () {
          expect(
            const AsyncError<int>('err', StackTrace.empty)
                .copyWithPrevious(const AsyncLoading<int>()),
            const AsyncError<int>('err', StackTrace.empty),
          );
        });

        test('with AsyncError', () {
          expect(
            const AsyncError<int>('err', StackTrace.empty)
                .copyWithPrevious(AsyncError<int>('err2', StackTrace.current)),
            const AsyncError<int>('err', StackTrace.empty),
          );

          expect(
            const AsyncError<int>('err', StackTrace.empty).copyWithPrevious(
              AsyncError<int>('err2', StackTrace.current)
                  .copyWithPrevious(const AsyncData(42)),
            ),
            const AsyncError<int>('err', StackTrace.empty)
                .copyWithPrevious(const AsyncData(42)),
          );
        });

        test('with AsyncData', () {
          final value = const AsyncError<int>('err', StackTrace.empty)
              .copyWithPrevious(const AsyncData(42));

          expect(value, isA<AsyncError<int>>());
          expect(value.isLoading, false);
          expect(value.isRefreshing, false);
          expect(value.hasValue, true);
          expect(value.value, 42);
          expect(value.error, 'err');
          expect(value.stackTrace, StackTrace.empty);
        });
      });

      group('on AsyncData', () {
        test('with AsyncLoading', () {
          expect(
            const AsyncData<int>(42)
                .copyWithPrevious(const AsyncLoading<int>(), isRefresh: true),
            const AsyncData<int>(42),
          );
        });

        test('with AsyncData', () {
          expect(
            const AsyncData<int>(42).copyWithPrevious(const AsyncData<int>(21)),
            const AsyncData<int>(42),
          );
        });

        test('with AsyncError', () {
          expect(
            const AsyncData<int>(42).copyWithPrevious(
              const AsyncError<int>('err', StackTrace.empty),
            ),
            const AsyncData<int>(42),
          );
        });
      });

      group('on AsyncLoading', () {
        test('with AsyncLoading', () {
          expect(
            const AsyncLoading<int>()
                .copyWithPrevious(const AsyncLoading<int>()),
            const AsyncLoading<int>(),
          );
        });

        test('with AsyncError', () {
          final value = const AsyncLoading<int>()
              .copyWithPrevious(const AsyncError<int>('err', StackTrace.empty));

          expect(value, isA<AsyncError<int>>());
          expect(value.isLoading, true);
          expect(value.isRefreshing, true);
          expect(value.hasValue, false);
          expect(() => value.value, throwsA('err'));
          expect(value.error, 'err');
          expect(value.stackTrace, StackTrace.empty);
        });

        test('with AsyncError containing previous data', () {
          final value = const AsyncLoading<int>().copyWithPrevious(
            const AsyncError<int>('err', StackTrace.empty)
                .copyWithPrevious(const AsyncData(42)),
          );

          expect(value, isA<AsyncError<int>>());
          expect(value.isLoading, true);
          expect(value.isRefreshing, true);
          expect(value.hasValue, true);
          expect(value.value, 42);
          expect(value.error, 'err');
          expect(value.stackTrace, StackTrace.empty);
        });

        test('with refreshing AsyncError containing previous data', () {
          expect(
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncLoading<int>().copyWithPrevious(
                const AsyncError<int>('err', StackTrace.empty)
                    .copyWithPrevious(const AsyncData(42)),
              ),
            ),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncError<int>('err', StackTrace.empty)
                  .copyWithPrevious(const AsyncData(42)),
            ),
          );
        });

        test('with AsyncData', () {
          final value =
              const AsyncLoading<int>().copyWithPrevious(const AsyncData(42));

          expect(value, isA<AsyncData<int>>());
          expect(value.isLoading, true);
          expect(value.isRefreshing, true);
          expect(value.hasValue, true);
          expect(value.value, 42);
          expect(value.error, null);
          expect(value.stackTrace, null);
        });

        test('with refreshing AsyncData', () {
          final value = const AsyncLoading<int>().copyWithPrevious(
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
          );

          expect(value, isA<AsyncData<int>>());
          expect(value.isLoading, true);
          expect(value.isRefreshing, true);
          expect(value.hasValue, true);
          expect(value.value, 42);
          expect(value.error, null);
          expect(value.stackTrace, null);
        });
      });
    });
  });

  test('isRefreshing', () {
    expect(const AsyncLoading<int>().isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncLoading())
          .isRefreshing,
      false,
    );

    expect(const AsyncData<int>(42).isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData<int>(42))
          .isRefreshing,
      true,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData<int>(42), isRefresh: false)
          .isRefreshing,
      false,
    );

    expect(const AsyncError<int>('err', StackTrace.empty).isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError<int>('err', StackTrace.empty))
          .isRefreshing,
      true,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(
            const AsyncError<int>('err', StackTrace.empty),
            isRefresh: false,
          )
          .isRefreshing,
      false,
    );
  });

  test('isReloading', () {
    expect(const AsyncLoading<int>().isRefreshing, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncLoading())
          .isReloading,
      false,
    );

    expect(const AsyncData<int>(42).isReloading, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData<int>(42))
          .isReloading,
      false,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData<int>(42), isRefresh: false)
          .isReloading,
      true,
    );

    expect(const AsyncError<int>('err', StackTrace.empty).isReloading, false);
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError<int>('err', StackTrace.empty))
          .isReloading,
      false,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(
            const AsyncError<int>('err', StackTrace.empty),
            isRefresh: false,
          )
          .isReloading,
      true,
    );
  });

  test('isLoading', () {
    expect(const AsyncData(42).isLoading, false);
    expect(const AsyncLoading<int>().isLoading, true);
    expect(const AsyncError<int>(Object(), StackTrace.empty).isLoading, false);

    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).isLoading,
      true,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .isLoading,
      true,
    );

    expect(
      const AsyncData<int>(42).copyWithPrevious(const AsyncLoading()).isLoading,
      false,
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .isLoading,
      false,
    );
  });

  test('asError', () {
    const value = AsyncValue<int>.error(42, StackTrace.empty);

    // ignore: omit_local_variable_types, unused_local_variable, testing that assignment works,
    final AsyncError<int>? error = value.asError;

    expect(const AsyncData(42).asError, null);
    expect(const AsyncLoading<int>().asError, null);
    expect(
      const AsyncError<int>(Object(), StackTrace.empty).asError,
      const AsyncError<int>(Object(), StackTrace.empty),
    );
  });

  test('map', () {
    expect(
      const AsyncValue.data(42).map(
        data: (AsyncData<int> value) => [value.value],
        error: (value) => throw Error(),
        loading: (_) => throw Error(),
      ),
      [42],
    );

    final stack = StackTrace.current;

    expect(
      AsyncError<int>(42, stack).map(
        data: (value) => throw Error(),
        error: (AsyncError<int> error) => [error.error, error.stackTrace],
        loading: (_) => throw Error(),
      ),
      [42, stack],
    );

    expect(
      const AsyncLoading<int>().map(
        data: (value) => throw Error(),
        error: (_) => throw Error(),
        loading: (AsyncLoading<int> loading) => 'loading',
      ),
      'loading',
    );
  });

  group('maybeMap', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).maybeMap(
          data: (AsyncData<int> value) => [value.value],
          orElse: () => throw Error(),
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeMap(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().maybeMap(
          loading: (AsyncLoading<int> loading) => 'loading',
          orElse: () => throw Error(),
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).maybeMap(
          error: (_) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeMap(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncLoading<int>().maybeMap(
          data: (value) => throw Error(),
          error: (_) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );
    });
  });

  group('mapOrNull', () {
    test('supports returning null when relying on type-inference', () {
      // ignore: unused_local_variable, omit_local_variable_types
      final int? x2 = const AsyncValue.data(1).mapOrNull(
        data: (value) => null,
        error: (_) => null,
        loading: (_) => null,
      );
    });

    test('matching case', () {
      expect(
        const AsyncValue.data(42).mapOrNull(
          data: (AsyncData<int> value) => [value.value],
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).mapOrNull(
          error: (AsyncError<int> error) => [error.error, error.stackTrace],
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().mapOrNull(
          loading: (AsyncLoading<int> loading) => 'loading',
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).mapOrNull(
          error: (_) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).mapOrNull(
          data: (value) => throw Error(),
          loading: (_) => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncLoading<int>().mapOrNull(
          data: (value) => throw Error(),
          error: (_) => throw Error(),
        ),
        null,
      );
    });
  });

  group('when', () {
    test('skipReload: false, skipRefresh: true skipError: false (default)', () {
      expect(
        const AsyncLoading<int>().when(
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          loading: () => 'loading',
        ),
        'loading',
      );
      expect(
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).when(
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncError(42, StackTrace.empty))
            .when(
              data: (value) => throw Error(),
              error: (a, b) => [a, b],
              loading: () => throw Error(),
            ),
        [42, StackTrace.empty],
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError(42, StackTrace.empty),
              isRefresh: false,
            )
            .when(
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );

      expect(
        const AsyncData<int>(42).when(
          data: (value) => value,
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        42,
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42))
            .when(
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
    });

    test('skipReload: false, skipRefresh: false', () {
      expect(
        const AsyncLoading<int>().when(
          skipLoadingOnRefresh: false,
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          loading: () => 'loading',
        ),
        'loading',
      );
      expect(
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncError(42, StackTrace.empty))
            .when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError(42, StackTrace.empty),
              isRefresh: false,
            )
            .when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );

      expect(
        const AsyncData<int>(42).when(
          skipLoadingOnRefresh: false,
          data: (value) => value,
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        42,
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42))
            .when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
    });

    test('skipReload: true, skipRefresh: true', () {
      expect(
        const AsyncLoading<int>().when(
          skipLoadingOnReload: true,
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          loading: () => 'loading',
        ),
        'loading',
      );
      expect(
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).when(
              skipLoadingOnReload: true,
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnReload: true,
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncError('err', StackTrace.empty))
            .when(
              skipLoadingOnReload: true,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError('err', StackTrace.empty),
              isRefresh: false,
            )
            .when(
              skipLoadingOnReload: true,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );

      expect(
        const AsyncData<int>(42).when(
          skipLoadingOnReload: true,
          data: (value) => value,
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        42,
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42))
            .when(
              skipLoadingOnReload: true,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnReload: true,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
    });

    test('skipReload: true, skipRefresh: false', () {
      expect(
        const AsyncLoading<int>().when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: false,
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          loading: () => 'loading',
        ),
        'loading',
      );
      expect(
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => throw Error(),
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncError('err', StackTrace.empty))
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => 'loading',
            ),
        'loading',
      );
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError('err', StackTrace.empty),
              isRefresh: false,
            )
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );

      expect(
        const AsyncData<int>(42).when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: false,
          data: (value) => value,
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        42,
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42))
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: false,
              data: (value) => throw Error(),
              error: (a, b) => a,
              loading: () => throw Error(),
            ),
        'err',
      );
    });

    test('skipError: true', () {
      expect(
        const AsyncError<int>('err', StackTrace.empty).when(
          skipError: true,
          data: (value) => throw Error(),
          error: (a, b) => a,
          loading: () => throw Error(),
        ),
        'err',
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42))
            .when(
              skipError: true,
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );

      expect(
        const AsyncError<int>('err', StackTrace.empty)
            .copyWithPrevious(const AsyncData(42), isRefresh: false)
            .when(
              skipError: true,
              data: (value) => value,
              error: (a, b) => throw Error(),
              loading: () => throw Error(),
            ),
        42,
      );
    });
  });

  group('maybeWhen', () {
    test('matching case', () {
      expect(
        const AsyncValue.data(42).maybeWhen(
          data: (value) => [value],
          orElse: () => throw Error(),
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(
          42,
          stack,
        ).maybeWhen(
          error: (a, b) => [a, b],
          orElse: () => throw Error(),
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().maybeWhen(
          loading: () => 'loading',
          orElse: () => throw Error(),
        ),
        'loading',
      );
    });

    test('orElse', () {
      expect(
        const AsyncValue.data(42).maybeWhen(
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).maybeWhen(
          data: (value) => throw Error(),
          loading: () => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );

      expect(
        const AsyncLoading<int>().maybeWhen(
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
          orElse: () => 'orElse',
        ),
        'orElse',
      );
    });
  });

  group('whenOrNull', () {
    test('supports returning null when relying on type-inference', () {
      // ignore: unused_local_variable, omit_local_variable_types
      final int? x2 = const AsyncValue.data(1).whenOrNull(
        data: (value) => null,
        error: (err, stack) => null,
        loading: () => null,
      );
    });

    test('matching case', () {
      expect(
        const AsyncValue.data(42).whenOrNull(
          data: (value) => [value],
        ),
        [42],
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(
          42,
          stack,
        ).whenOrNull(
          error: (a, b) => [a, b],
        ),
        [42, stack],
      );

      expect(
        const AsyncLoading<int>().whenOrNull(
          loading: () => 'loading',
        ),
        'loading',
      );
    });

    test('or null', () {
      expect(
        const AsyncValue.data(42).whenOrNull(
          error: (a, b) => throw Error(),
          loading: () => throw Error(),
        ),
        null,
      );

      final stack = StackTrace.current;

      expect(
        AsyncError<int>(42, stack).whenOrNull(
          data: (value) => throw Error(),
          loading: () => throw Error(),
        ),
        null,
      );

      expect(
        const AsyncLoading<int>().whenOrNull(
          data: (value) => throw Error(),
          error: (a, b) => throw Error(),
        ),
        null,
      );
    });
  });

  test('==', () {
    // ignore: prefer_const_declarations
    final value = 42;
    // ignore: prefer_const_declarations
    final value2 = 21;

    final stack = StackTrace.current;
    final stack2 = StackTrace.current;

    expect(
      AsyncData<int>(value),
      AsyncData<int>(value),
    );
    expect(
      AsyncData<int>(value),
      isNot(const AsyncLoading<int>().copyWithPrevious(AsyncData(value))),
    );
    expect(
      AsyncData<int>(value),
      isNot(AsyncData<int>(value2)),
    );
    expect(
      AsyncData<int>(value),
      isNot(AsyncValue<num>.data(value)),
    );
    expect(
      AsyncValue<num>.data(value),
      isNot(AsyncData<int>(value)),
    );
    expect(
      const AsyncData<int>(42).copyWithPrevious(const AsyncLoading()),
      const AsyncData<int>(42),
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
      const AsyncData<int>(42),
    );

    expect(
      AsyncError<int>(value, stack),
      AsyncError<int>(value, stack),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(
        const AsyncLoading<int>()
            .copyWithPrevious(AsyncError<int>(value, stack)),
      ),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncValue<num>.error(value, stack)),
    );
    expect(
      AsyncValue<num>.error(value, stack),
      isNot(AsyncError<int>(value, stack)),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncError<int>(value, stack2)),
    );
    expect(
      AsyncError<int>(value, stack),
      isNot(AsyncError<int>(value2, stack)),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>(),
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading()),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading(),
      // ignore: prefer_const_constructors
      isNot(AsyncLoading<int>()),
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(null)),
      isNot(const AsyncError<int?>(42, StackTrace.empty)),
      reason: 'hasValue should be checked',
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42)),
      isNot(
        const AsyncData<int?>(42)
            .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
      ),
      reason: 'runtimeType should be checked',
    );
  });

  test('hashCode', () {
    // ignore: prefer_const_declarations
    final value = 42;
    // ignore: prefer_const_declarations
    final value2 = 21;

    final stack = StackTrace.current;
    final stack2 = StackTrace.current;

    expect(
      AsyncData<int>(value).hashCode,
      AsyncData<int>(value).hashCode,
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(
        const AsyncLoading<int>().copyWithPrevious(AsyncData(value)).hashCode,
      ),
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(AsyncData<int>(value2).hashCode),
    );
    expect(
      AsyncData<int>(value).hashCode,
      isNot(AsyncValue<num>.data(value).hashCode),
    );
    expect(
      AsyncValue<num>.data(value).hashCode,
      isNot(AsyncData<int>(value).hashCode),
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      AsyncError<int>(value, stack).hashCode,
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(
        const AsyncLoading<int>()
            .copyWithPrevious(AsyncError(value, stack))
            .hashCode,
      ),
    );

    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncValue<num>.error(value, stack).hashCode),
    );
    expect(
      AsyncValue<num>.error(value, stack).hashCode,
      isNot(AsyncError<int>(value, stack).hashCode),
    );
    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncError<int>(value, stack2).hashCode),
    );
    expect(
      AsyncError<int>(value, stack).hashCode,
      isNot(AsyncError<int>(value2, stack).hashCode),
    );

    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncLoading<int>().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncValue<num>.loading().hashCode),
    );
    expect(
      // ignore: prefer_const_constructors
      AsyncValue<num>.loading().hashCode,
      // ignore: prefer_const_constructors
      isNot(AsyncLoading<int>().hashCode),
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(null))
          .hashCode,
      isNot(const AsyncError<int?>(42, StackTrace.empty).hashCode),
      reason: 'hasValue should be checked',
    );

    expect(
      const AsyncError<int?>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .hashCode,
      isNot(
        const AsyncData<int?>(42)
            .copyWithPrevious(const AsyncError(42, StackTrace.empty))
            .hashCode,
      ),
      reason: 'runtimeType should be checked',
    );
  });

  test('requireValue', () {
    expect(const AsyncData(42).requireValue, 42);

    expect(
      () => const AsyncLoading<int>().requireValue,
      throwsStateError,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42), isRefresh: true)
          .requireValue,
      42,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(
            const AsyncError<int>('err', StackTrace.empty)
                .copyWithPrevious(const AsyncData(42)),
            isRefresh: true,
          )
          .requireValue,
      42,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42), isRefresh: true)
          .requireValue,
      42,
    );
    expect(
      () => const AsyncError<int>('err', StackTrace.empty).requireValue,
      throwsA('err'),
    );
  });

  test('toString', () {
    expect(
      const AsyncValue.data(42).toString(),
      'AsyncData<int>(value: 42)',
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty).toString(),
      'AsyncError<int>(error: 42, stackTrace: )',
    );
    expect(
      const AsyncLoading<int>().toString(),
      'AsyncLoading<int>()',
    );

    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .toString(),
      'AsyncData<int>(isLoading: true, value: 42)',
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .toString(),
      'AsyncError<int>(isLoading: true, error: 42, stackTrace: )',
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .toString(),
      'AsyncData<int>(value: 42)',
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .toString(),
      'AsyncError<int>(value: 42, error: 42, stackTrace: )',
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42), isRefresh: false)
          .toString(),
      'AsyncLoading<int>(value: 42)',
    );
  });

  test('hasValue', () {
    expect(const AsyncData(42).hasValue, true);
    expect(const AsyncLoading<int>().hasValue, false);
    expect(const AsyncError<int>('err', StackTrace.empty).hasValue, false);

    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .hasValue,
      true,
    );
    expect(
      const AsyncError<int>(42, StackTrace.empty)
          .copyWithPrevious(
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
          )
          .hasValue,
      true,
    );
    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).hasValue,
      true,
    );
  });

  test('hasError', () {
    expect(const AsyncData(42).hasError, false);
    expect(const AsyncLoading<int>().hasError, false);
    expect(const AsyncError<int>('err', StackTrace.empty).hasError, true);

    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .hasError,
      false,
    );
    expect(
      const AsyncData<int>(42)
          .copyWithPrevious(
            const AsyncLoading<int>()
                .copyWithPrevious(const AsyncError(42, StackTrace.empty)),
          )
          .hasError,
      false,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncError(42, StackTrace.empty))
          .hasError,
      true,
    );
  });

  group('whenData', () {
    test('preserves isLoading/isRefreshing', () {
      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42))
            .whenData((value) => value * 2),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(84)),
      );

      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42))
            .whenData<String>(
              (value) => Error.throwWithStackTrace(84, StackTrace.empty),
            ),
        const AsyncLoading<String>().copyWithPrevious(
          const AsyncError(84, StackTrace.empty),
        ),
      );

      expect(
        const AsyncLoading<int>()
            .copyWithPrevious(
              const AsyncError(84, StackTrace.empty),
            )
            .whenData<String>((value) => '$value'),
        const AsyncLoading<String>().copyWithPrevious(
          const AsyncError(84, StackTrace.empty),
        ),
      );
    });

    test('transforms data if any', () {
      expect(
        const AsyncValue.data(42).whenData((value) => '$value'),
        const AsyncData<String>('42'),
      );
      expect(
        const AsyncLoading<int>().whenData((value) => '$value'),
        const AsyncLoading<String>(),
      );
      expect(
        const AsyncError<int>(21, StackTrace.empty)
            .whenData((value) => '$value'),
        const AsyncError<String>(21, StackTrace.empty),
      );
    });

    test('catches errors in data transformer and return AsyncError', () {
      expect(
        const AsyncValue.data(42).whenData<int>(
          // ignore: only_throw_errors
          (value) => throw '42',
        ),
        isA<AsyncError<int>>()
            .having((e) => e.error, 'error', '42')
            .having((e) => e.stackTrace, 'stackTrace', isNotNull),
      );
    });
  });

  test('AsyncValue.asData', () {
    const value = AsyncValue<int>.data(42);

    // ignore: omit_local_variable_types, unused_local_variable, testing that assignment works,
    final AsyncData<int>? data = value.asData;

    expect(
      const AsyncValue.data(42).asData,
      const AsyncData<int>(42),
    );
    expect(const AsyncValue<void>.loading().asData, isNull);
    expect(AsyncValue<void>.error(Error(), StackTrace.empty).asData, isNull);

    expect(
      const AsyncValue<int?>.data(null).asData,
      const AsyncData<int?>(null),
    );
  });

  test('AsyncValue.value', () {
    expect(const AsyncValue.data(42).value, 42);
    expect(
      const AsyncLoading<int>().value,
      null,
    );
    expect(
      () => const AsyncError<int>('err', StackTrace.empty).value,
      throwsA('err'),
    );

    expect(
      const AsyncError<int>('err', StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .value,
      42,
    );
    expect(
      const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)).value,
      42,
    );
  });

  test('AsyncValue.valueOrNull', () {
    expect(const AsyncValue.data(42).valueOrNull, 42);
    expect(
      const AsyncLoading<int>().valueOrNull,
      null,
    );
    expect(const AsyncError<int>('err', StackTrace.empty).valueOrNull, null);

    expect(
      const AsyncError<int>('err', StackTrace.empty)
          .copyWithPrevious(const AsyncData(42))
          .valueOrNull,
      42,
    );
    expect(
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(42))
          .valueOrNull,
      42,
    );
  });

  test('AsyncValue.guard emits the data when the created future completes',
      () async {
    await expectLater(
      AsyncValue.guard(() => Future.value(42)),
      completion(const AsyncValue.data(42)),
    );
  });

  test('AsyncValue.guard emits the error when the created future fails',
      () async {
    final stack = StackTrace.current;

    await expectLater(
      AsyncValue.guard(() => Future<int>.error(42, stack)),
      completion(AsyncError<int>(42, stack)),
    );
  });

  test(
      'AsyncValue.guard emits the error when the created future fails and predicate is null',
      () async {
    final stack = StackTrace.current;

    await expectLater(
      AsyncValue.guard(
        () => Future<int>.error(42, stack),
      ),
      completion(AsyncError<int>(42, stack)),
    );
  });

  test(
      'AsyncValue.guard emits the error when the created future fails and predicate is true',
      () async {
    final stack = StackTrace.current;
    bool isInt(Object error) => error is int;

    await expectLater(
      AsyncValue.guard(
        () => Future<int>.error(42, stack),
        isInt,
      ),
      completion(AsyncError<int>(42, stack)),
    );
  });

  test('AsyncValue.guard rethrows exception if predicate is false,', () async {
    bool isInt(Object error) => error is int;

    await expectLater(
      AsyncValue.guard<int>(
        () => throw const FormatException(),
        isInt,
      ),
      throwsA(isA<FormatException>()),
    );
  });
}

class CustomLoading<T> extends AsyncLoading<T> {
  const CustomLoading();
}

class CustomData<T> extends AsyncData<T> {
  const CustomData(super.value);
}

class CustomError<T> extends AsyncError<T> {
  const CustomError(Object error, {required StackTrace stackTrace})
      : super(
          error,
          stackTrace,
        );
}
