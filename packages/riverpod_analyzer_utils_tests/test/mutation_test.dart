import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Rejects mutations with a Stream return type', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation/experimental/mutation.dart';

@riverpod
class SyncNotifier<T> extends _$SyncNotifier<T> {
  @override
  T build() => throw 42;

  @mutation
  Stream<T> a() => throw 42;
}
''', (resolver, unit, units) async {
    final result =
        await resolver.resolveRiverpodAnalysisResult(ignoreErrors: true);

    expect(result.errors, hasLength(1));

    expect(
      result.errors,
      everyElement(
        isA<RiverpodAnalysisError>()
            .having((e) => e.targetNode, 'node', isNotNull)
            .having((e) => e.targetElement, 'element', isNotNull)
            .having(
              (e) => e.code,
              'code',
              RiverpodAnalysisErrorCode.unsupportedMutationReturnType,
            )
            .having(
              (e) => e.message,
              'message',
              'Mutations returning Streams are not supported',
            ),
      ),
    );
  });

  testSource('rejects abstract/static mutations', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation/experimental/mutation.dart';

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
