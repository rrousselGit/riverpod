import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Decodes Dependencies', runGenerator: true, source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

@riverpod
int a(ARef ref) => 0;

@riverpod
class B extends _$B {
  @override
  int build() => 0;
}

@riverpod
int c(CRef ref, int arg) => 0;

@riverpod
class D extends _$D {
  @override
  int build(int arg) => 0;
}

@Dependencies([a, B, c, D])
class Class {}

@Dependencies([a, B, c, D])
void function() {}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.resolvedRiverpodLibraryResults.single.errors, isEmpty);

    expect(result.dependenciesAnnotations, hasLength(2));

    expect(
      result.dependenciesAnnotations[0].declaration.toString(),
      contains('Class'),
    );
    expect(
      result.dependenciesAnnotations[1].declaration.toString(),
      contains('function'),
    );

    for (final annotation in result.dependenciesAnnotations) {
      expect(annotation.dependencies, hasLength(4));

      expect(
        annotation.dependencies!.map((e) => e.node.toSource()).join(', '),
        'a, B, c, D',
      );

      expect(
        annotation.dependencies![0].provider,
        isA<FunctionalProviderDeclarationElement>()
            .having((e) => e.name, 'name', 'a'),
      );
      expect(
        annotation.dependencies![1].provider,
        isA<ClassBasedProviderDeclarationElement>()
            .having((e) => e.name, 'name', 'B'),
      );
      expect(
        annotation.dependencies![2].provider,
        isA<FunctionalProviderDeclarationElement>()
            .having((e) => e.name, 'name', 'c'),
      );
      expect(
        annotation.dependencies![3].provider,
        isA<ClassBasedProviderDeclarationElement>()
            .having((e) => e.name, 'name', 'D'),
      );
    }
  });
}
