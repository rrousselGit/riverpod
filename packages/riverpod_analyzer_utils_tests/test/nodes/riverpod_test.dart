import 'package:analyzer/dart/ast/ast.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

import '../analyzer_test_utils.dart';
import '../matchers.dart';

void main() {
  testSource('Decode dependencies with syntax errors', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

const deps = <ProviderOrFamily>[];

@Riverpod(dependencies: deps)
int first(Ref ref) => 0;

@Riverpod(dependencies: )
int second(Ref ref) => 0;

@Riverpod(dependencies: [gibberish])
int forth(Ref ref) => 0;

@Riverpod(dependencies: [if (true) forth])
int fifth(Ref ref) => 0;

@Riverpod(dependencies: [int])
int sixth(Ref ref) => 0;

void fn() {}

@Riverpod(dependencies: [fn])
int seven(Ref ref) => 0;

@Riverpod(dependencies: ['foo'])
int eight(Ref ref) => 0;
''', (resolver, unit, units) async {
    final errors = collectErrors(() {
      for (final d in unit.declarations) {
        d.provider;
      }
    });

    expect(errors, hasLength(10));

    expect(
      errors[0].message,
      'Only list literals (using []) as supported.',
    );
    expect(errors[0].targetNode?.toSource(), 'deps');

    expect(
      errors[1].message,
      'Only list literals (using []) as supported.',
    );
    expect(errors[1].targetNode?.toSource(), '');

    expect(
      errors[2].message,
      'Only elements annotated with @riverpod are supported.',
    );
    expect(errors[2].targetNode?.toSource(), 'gibberish');

    expect(
      errors[3].message,
      'if/for/spread operators as not supported.',
    );
    expect(errors[3].targetNode?.toSource(), 'if (true) forth');

    expect(
      errors[4].message,
      'Unsupported dependency "int". Only functions and classes annotated by @riverpod are supported.',
    );
    expect(
      errors[4].targetElement.toString(),
      'Riverpod Riverpod({bool keepAlive = false, List<Object>? dependencies, Duration? Function(int, Object)? retry})',
    );

    expect(
      errors[5].message,
      'The dependency int is not a class annotated with @riverpod',
    );
    expect(errors[5].targetNode.toString(), 'int');

    expect(
      errors[6].message,
      'Unsupported dependency "void fn()". Only functions and classes annotated by @riverpod are supported.',
    );
    expect(
      errors[6].targetElement.toString(),
      'Riverpod Riverpod({bool keepAlive = false, List<Object>? dependencies, Duration? Function(int, Object)? retry})',
    );

    expect(
      errors[7].message,
      'The dependency fn is not a function annotated with @riverpod',
    );
    expect(errors[7].targetNode.toString(), 'fn');

    expect(
      errors[8].message,
      'Unsupported dependency "String (\'foo\')". Only functions and classes annotated by @riverpod are supported.',
    );
    expect(
      errors[8].targetElement.toString(),
      'Riverpod Riverpod({bool keepAlive = false, List<Object>? dependencies, Duration? Function(int, Object)? retry})',
    );

    expect(
      errors[9].message,
      'Only elements annotated with @riverpod are supported.',
    );
    expect(errors[9].targetNode.toString(), "'foo'");
  });

  testSource('Reuses elements', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int dependency(Ref ref) => 0;

@Riverpod(dependencies: [dependency])
int fn(Ref ref) => 0;

@Riverpod(dependencies: [dependency])
int fn2(Ref ref) => 0;
''', (resolver, unit, units) async {
    final dependency = unit.declarations.findByName('dependency').riverpod;

    final fn = unit.declarations.findByName('fn').riverpod;

    final fn2 = unit.declarations.findByName('fn2').riverpod;

    expect(
      dependency!.element,
      same(fn!.dependencyList!.values!.single.provider.annotation),
    );
    expect(
      fn.dependencyList!.values!.single.provider,
      same(fn2!.dependencyList!.values!.single.provider),
    );
  });

  testSource('Decodes @riverpod', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@deprecated
int unrelated() => 0;

@riverpod
int variable(Ref ref) => 0;

@Riverpod()
int constructor(Ref ref) => 0;

@Riverpod(keepAlive: false, dependencies: null)
int explicit(Ref ref) => 0;

@Riverpod(keepAlive: true, dependencies: [variable])
int constructor2(Constructor2Ref ref) => 0;

class NestedClass {
  void method() {
    @riverpod
    int value = 0;
  }
}
''', (resolver, unit, units) async {
    expect(
      unit.declarations.findByName('unrelated').riverpod,
      isNull,
    );

    final variable = unit.declarations.findByName('variable').riverpod;
    expect(
      variable,
      isRiverpod(
        node: hasToString('@riverpod'),
        element: isRiverpodAnnotationElement(
          keepAlive: false,
          dependencies: isNull,
        ),
        keepAlive: isNull,
        dependenciesNode: isNull,
        dependencyList: isNull,
      ),
    );

    expect(
      unit.declarations.findByName('constructor').riverpod,
      isRiverpod(
        node: hasToString('@Riverpod()'),
        element: isRiverpodAnnotationElement(
          keepAlive: false,
          dependencies: isNull,
        ),
        keepAlive: isNull,
        dependenciesNode: isNull,
        dependencyList: isNull,
      ),
    );

    final explicit = unit.declarations.findByName('explicit').riverpod;
    expect(
      explicit,
      isRiverpod(
        node: hasToString('@Riverpod(keepAlive: false, dependencies: null)'),
        element: isRiverpodAnnotationElement(
          keepAlive: false,
          dependencies: isNull,
        ),
        keepAlive: hasToString('keepAlive: false'),
        dependenciesNode: hasToString('dependencies: null'),
        dependencyList: isProviderDependencyList(
          node: hasToString('null'),
          values: isNull,
        ),
      ),
    );

    final constructor2 = unit.declarations.findByName('constructor2').riverpod;
    expect(
      constructor2,
      isRiverpod(
        node: hasToString(
          '@Riverpod(keepAlive: true, dependencies: [variable])',
        ),
        element: isRiverpodAnnotationElement(
          keepAlive: true,
          dependencies: [
            isFunctionalProviderDeclarationElement(name: 'variable'),
          ],
        ),
        keepAlive: hasToString('keepAlive: true'),
        dependenciesNode: hasToString('dependencies: [variable]'),
        dependencyList: isProviderDependencyList(
          node: hasToString('[variable]'),
          values: [
            isProviderDependency(
              node: hasToString('variable'),
              provider: isFunctionalProviderDeclarationElement(
                name: 'variable',
              ),
            ),
          ],
        ),
      ),
    );

    final nestedVariable = unit.declarations
        .findByName<ClassDeclaration>('NestedClass')
        .members
        .findByName<MethodDeclaration>('method')
        .body
        .cast<BlockFunctionBody>()!
        .block
        .statements
        .first
        .cast<VariableDeclarationStatement>()!
        .variables;

    expect(
      nestedVariable.riverpod,
      isRiverpod(
        node: hasToString('@riverpod'),
        element: isRiverpodAnnotationElement(
          keepAlive: false,
          dependencies: isNull,
        ),
        keepAlive: isNull,
        dependenciesNode: isNull,
        dependencyList: isNull,
      ),
    );
  });
}
