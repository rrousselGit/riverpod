import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource(
      'Rejects mutations with a return value non-matching the build value',
      source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class SyncNotifier<T> extends _$SyncNotifier<T> {
  @override
  T build() => throw 42;

  @mutation
  Stream<T> a() => throw 42;

  @mutation
  T b() => throw 42;

  @mutation
  FutureOr<T> c() => throw 42;

  @mutation
  Future<T> d() => throw 42;

  @mutation
  Future<int> e() => throw 42;

  @mutation
  int e() => throw 42;
}
''', (resolver, unit, units) async {
    final result =
        await resolver.resolveRiverpodAnalysisResult(ignoreErrors: true);

    expect(result.errors, hasLength(3));

    expect(
      result.errors,
      everyElement(
        isA<RiverpodAnalysisError>()
            .having((e) => e.targetNode, 'node', isNotNull)
            .having((e) => e.targetElement, 'element', isNotNull)
            .having(
              (e) => e.code,
              'code',
              RiverpodAnalysisErrorCode.mutationReturnTypeMismatch,
            )
            .having(
              (e) => e.message,
              'message',
              'The return type of mutations must match the type returned by the "build" method.',
            ),
      ),
    );
  });

  testSource('rejects abstract/static mutations', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class Abstract extends _$Abstract {
  @override
  int build() => 0;

  @mutation
  Future<int> a();

  @mutation
  static Future<int> b() async => 42;
}
''', (resolver, unit, units) async {
    final result =
        await resolver.resolveRiverpodAnalysisResult(ignoreErrors: true);

    expect(result.errors, hasLength(2));

    expect(
      result.errors,
      everyElement(
        isA<RiverpodAnalysisError>()
            .having((e) => e.targetNode, 'node', isNotNull)
            .having((e) => e.targetElement, 'element', isNotNull)
            .having(
              (e) => e.code,
              'code',
              anyOf(
                RiverpodAnalysisErrorCode.mutationIsAbstract,
                RiverpodAnalysisErrorCode.mutationIsStatic,
              ),
            ),
      ),
    );
  });
}
