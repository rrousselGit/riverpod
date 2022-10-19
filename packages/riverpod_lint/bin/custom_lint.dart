import 'dart:async';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

void main(List<String> args, SendPort sendPort) {
  startPlugin(sendPort, RiverpodLint());
}

class RiverpodLint extends PluginBase {
  @override
  Stream<Lint> getLints(ResolvedUnitResult unit) {
    final visitor = RiverpodVisitor(unit);
    return unit.unit.accept(visitor) ?? const Stream<Lint>.empty();
  }
}

mixin _ProviderCreationVisitor<T> on AsyncRecursiveVisitor<T> {
  /// The initialization of a provider was found
  Stream<T>? visitProviderCreation(AstNode node);

  @override
  Stream<T>? visitFunctionExpressionInvocation(
    FunctionExpressionInvocation node,
  ) async* {
    final superStream = super.visitFunctionExpressionInvocation(node);
    if (superStream != null) yield* superStream;

    if (node.isProviderCreation ?? false) {
      final stream = visitProviderCreation(node);
      if (stream != null) yield* stream;
    }
  }

  @override
  Stream<T>? visitInstanceCreationExpression(
    InstanceCreationExpression node,
  ) async* {
    final superStream = super.visitInstanceCreationExpression(node);
    if (superStream != null) yield* superStream;

    final createdType = node.staticType?.element2;
    if (createdType != null &&
        providerOrFamilyType.isAssignableFrom(createdType)) {
      final stream = visitProviderCreation(node);
      if (stream != null) yield* stream;
    }
  }

  @override
  Stream<T>? visitClassDeclaration(ClassDeclaration node) async* {
    final superStream = super.visitClassDeclaration(node);
    if (superStream != null) yield* superStream;
    if (node.isProviderCreation ?? false) {
      final stream = visitProviderCreation(node);
      if (stream != null) yield* stream;
    }
  }

  @override
  Stream<T>? visitFunctionDeclaration(FunctionDeclaration node) async* {
    final superStream = super.visitFunctionDeclaration(node);
    if (superStream != null) yield* superStream;
    if (node.isProviderCreation ?? false) {
      final stream = visitProviderCreation(node);
      if (stream != null) yield* stream;
    }
  }
}

enum AsyncContext {
  // Synchronous context in build of widget / initState or Provider
  buildSync,
  // Synchronous context in callback function
  callbackSync,
  // In callback, but after await / await_for
  callbackAfterAsync;

  bool get isSync => this == buildSync || this == callbackSync;
  bool get isAsync => this == callbackAfterAsync;
}

mixin _AsyncContextVisitor<T> on AsyncRecursiveVisitor<T> {
  AsyncContext context = AsyncContext.buildSync;
  @override
  Stream<T>? visitMethodDeclaration(MethodDeclaration node) async* {
    final last = context;
    context = AsyncContext.buildSync;
    yield* super.visitMethodDeclaration(node) ?? const Stream.empty();
    context = last;
  }

  @override
  Stream<T>? visitFunctionExpression(FunctionExpression node) async* {
    final last = context;
    if (node.isBuild() ?? false) {
      context = AsyncContext.buildSync;
    } else {
      context = AsyncContext.callbackSync;
    }
    yield* super.visitFunctionExpression(node) ?? const Stream.empty();
    context = last;
  }

  @override
  Stream<T>? visitAwaitExpression(AwaitExpression node) async* {
    yield* super.visitAwaitExpression(node) ?? const Stream.empty();
    context = AsyncContext.callbackAfterAsync;
  }

  @override
  Stream<T>? visitForStatement(ForStatement node) async* {
    // First time through the loop could be synchronous, so wait till the loop is done
    yield* super.visitForStatement(node) ?? const Stream.empty();
    if (node.awaitKeyword != null) {
      context = AsyncContext.callbackAfterAsync;
    }
  }
}

mixin _InvocationVisitor<T>
    on AsyncRecursiveVisitor<T>, _AsyncContextVisitor<T> {
  // Whether the method is forced async
  bool forceAsync = false;
  bool get asyncBad;
  Stream<T> visitCalledFunction(AstNode node, {required AstNode callingNode});
  @override
  Stream<T>? visitPropertyAccess(PropertyAccess node) async* {
    final method = node.propertyName.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null && ast.refPassed) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }
    yield* super.visitPropertyAccess(node) ?? const Stream.empty();
  }

  @override
  Stream<T>? visitPrefixedIdentifier(PrefixedIdentifier node) async* {
    final method = node.identifier.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null && ast.refPassed) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }
    yield* super.visitPrefixedIdentifier(node) ?? const Stream.empty();
  }

  @override
  Stream<T>? visitFunctionExpressionInvocation(
    FunctionExpressionInvocation node,
  ) async* {
    final method = node.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null && ast.refPassed) {
        yield* visitCalledFunction(
          ast as FunctionDeclaration,
          callingNode: node,
        );
      }
    }
    yield* super.visitFunctionExpressionInvocation(node) ??
        const Stream.empty();
  }

  @override
  Stream<T>? visitMethodInvocation(MethodInvocation node) async* {
    final method = node.methodName.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method.declaration!);
      if (ast != null && ast.refPassed) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }

    yield* super.visitMethodInvocation(node) ?? const Stream.empty();
  }

  @override
  Stream<T>? visitInstanceCreationExpression(
    InstanceCreationExpression node,
  ) async* {
    final constructor = node.constructorName.staticElement;
    if (constructor != null) {
      if (futureOrStreamType.isAssignableFrom(constructor.enclosingElement3)) {
        if (!asyncBad) {
          return;
        } else {
          for (final arg in node.argumentList.arguments) {
            // The arguments to a future or stream could be called after a widget is disposed
            final last = context;
            final lastAsync = forceAsync;
            forceAsync = true;
            context = AsyncContext.callbackAfterAsync;
            yield* visitExpression(arg) ?? const Stream.empty();
            context = last;
            forceAsync = lastAsync;
          }
        }
      } else {
        final ast = await findAstNodeForElement(constructor.declaration);

        if (ast != null) {
          yield* visitConstructorDeclaration(ast as ConstructorDeclaration) ??
              const Stream.empty();
        }
        for (final arg in node.argumentList.arguments) {
          yield* visitExpression(arg) ?? const Stream.empty();
        }
      }
    }
  }
}

class RefAsyncUsageVisitor extends AsyncRecursiveVisitor<Lint>
    with _AsyncContextVisitor, _InvocationVisitor, RefLifecycleVisitor {
  RefAsyncUsageVisitor(this.unit);
  final ResolvedUnitResult unit;

  @override
  Stream<Lint> visitCalledFunction(
    AstNode node, {
    required AstNode callingNode,
  }) async* {
    final results = node is MethodDeclaration
        ? visitMethodDeclaration(node)
        : node is FunctionDeclaration
            ? visitFunctionDeclaration(node)
            : null;
    if (results != null) {
      await for (final _ in results) {
        yield Lint(
          code: 'riverpod_no_ref_after_async',
          message:
              'Do not use ref after async gaps in flutter widgets, a function was called which uses ref after a widget could be disposed',
          location: unit.lintLocationFromOffset(
            callingNode.offset,
            length: callingNode.length,
          ),
        );
        // Only need to report the function once
        return;
      }
    }
  }

  @override
  Stream<Lint>? visitRefInvocation(RefLifecycleInvocation node) async* {
    if (context == AsyncContext.callbackAfterAsync) {
      // TODO Allow checking mounted in stateful widgets and checking mounted in StateNotifiers
      yield Lint(
        code: 'riverpod_no_ref_after_async',
        message: 'Do not use ref after async gaps in flutter widgets.',
        location: unit.lintLocationFromOffset(
          node.invocation.offset,
          length: node.invocation.length,
        ),
      );
    }
  }

  @override
  bool get asyncBad => true;
}

class ProviderSyncMutationVisitor extends AsyncRecursiveVisitor<Lint>
    with _AsyncContextVisitor, _InvocationVisitor {
  ProviderSyncMutationVisitor(this.unit);

  final ResolvedUnitResult unit;

  @override
  Stream<Lint> visitCalledFunction(
    AstNode node, {
    required AstNode callingNode,
  }) async* {
    final results = node is MethodDeclaration
        ? visitMethodDeclaration(node)
        : node is FunctionDeclaration
            ? visitFunctionDeclaration(node)
            : null;
    if (results != null) {
      await for (final _ in results) {
        yield Lint(
          code: 'riverpod_no_mutate_sync',
          message:
              'Do not mutate a provider synchronously, a function was called which mutates a provider synchronously',
          location: unit.lintLocationFromOffset(
            callingNode.offset,
            length: callingNode.length,
          ),
        );
        // Only need to report the function once
        return;
      }
    }
  }

  @override
  Stream<Lint>? visitExpression(Expression expression) async* {
    final lints = super.visitExpression(expression);
    yield* lints ?? const Stream.empty();
    final mutate = expression.isMutation;
    if (!forceAsync && context == AsyncContext.buildSync && (mutate ?? false)) {
      yield Lint(
        code: 'riverpod_no_mutate_sync',
        message: 'Do not mutate a provider synchronously',
        location: unit.lintLocationFromOffset(
          expression.offset,
          length: expression.length,
        ),
      );
    }
  }

  @override
  Stream<Lint>? visitNode(AstNode node) {
    if (!forceAsync && context == AsyncContext.buildSync) {
      return super.visitNode(node);
    }
    return null;
  }

  @override
  bool get asyncBad => false;
}

class _FindProviderCallbackVisitor
    extends CombiningRecursiveVisitor<FunctionExpression> {
  @override
  Iterable<FunctionExpression>? visitArgumentList(ArgumentList node) {
    if (node.arguments.isEmpty) return null;

    return [node.arguments.first as FunctionExpression];
  }
}

class RiverpodVisitor extends AsyncRecursiveVisitor<Lint>
    with RefLifecycleVisitor, _ProviderCreationVisitor {
  RiverpodVisitor(this.unit);

  final ResolvedUnitResult unit;

  @override
  Stream<Lint> visitRefInvocation(RefLifecycleInvocation node) async* {
    switch (node.invocation.methodName.name) {
      case 'read':
        if (node.isWithinBuild ?? false) {
          yield Lint(
            code: 'riverpod_avoid_read_inside_build',
            message:
                'Avoid using ref.read inside the build method of widgets/providers.',
            location: unit.lintLocationFromOffset(
              node.invocation.offset,
              length: node.invocation.length,
            ),
          );
        }
        final arg =
            node.invocation.argumentList.arguments.firstOrNull?.staticType;

        if (arg != null &&
            !alwaysAliveProviderListenableType.isAssignableFromType(arg)) {
          yield Lint(
            code: 'riverpod_avoid_read_on_autoDispose',
            message: 'Avoid using ref.read on an autoDispose provider',
            correction: '''
Instead use:
  final listener = ref.listen(${node.invocation.argumentList.arguments.first}, (_, __){});
  final currentValue = listener.read();
Then dispose of the listener when you no longer need the autoDispose provider to be kept alive.''',
            location: unit.lintLocationFromOffset(
              node.invocation.offset,
              length: node.invocation.length,
            ),
          );
        }
        break;
      case 'watch':
        if (node.isWithinBuild == false) {
          yield Lint(
            code: 'riverpod_avoid_watch_outside_build',
            message:
                'Avoid using ref.watch outside the build method of widgets/providers.',
            location: unit.lintLocationFromOffset(
              node.invocation.offset,
              length: node.invocation.length,
            ),
          );
        }
        break;
      default:
    }
  }

  @override
  Stream<Lint> visitProviderCreation(AstNode node) async* {
    if (node is ClassDeclaration || node is FunctionDeclaration) {
      yield* ProviderSyncMutationVisitor(unit).visitNode(node) ??
          const Stream<Lint>.empty();
      return;
    }
    final variableDeclaration =
        node.parents.whereType<VariableDeclaration>().firstOrNull;

    final providerDeclaration = variableDeclaration?.declaredElement2 != null
        ? ProviderDeclaration(
            variableDeclaration!,
            variableDeclaration.declaredElement2!,
          )
        : null;
    yield* _checkValidProviderDeclaration(node);

    if (providerDeclaration != null) {
      yield* _checkProviderDependencies(providerDeclaration);

      yield* ProviderSyncMutationVisitor(unit).visitNode(node) ??
          const Stream<Lint>.empty();
    }
  }

  @override
  Stream<Lint>? visitExpression(Expression node) async* {
    final superStream = super.visitExpression(node);
    if (superStream != null) yield* superStream;
    final st = node.staticType?.element2;
    if (st != null &&
        refType.isAssignableFrom(st) &&
        (node.parent is ExpressionFunctionBody ||
            node.parent is ReturnStatement)) {
      yield Lint(
        code: 'riverpod_ref_escape_scope',
        message: 'Ref escaped the scope via a function or return expression.',
        correction:
            'Pass ref to the function or constructor that needs it instead',
        severity: LintSeverity.warning,
        location: unit.lintLocationFromOffset(
          node.offset,
          length: node.length,
        ),
      );
    }
  }

  @override
  Stream<Lint>? visitConstructorDeclaration(
    ConstructorDeclaration node,
  ) async* {
    final superStream = super.visitConstructorDeclaration(node);
    if (superStream != null) yield* superStream;
    for (final param in node.parameters.parameters) {
      final type = param.declaredElement?.type.element2;

      if (type != null && widgetRefType.isAssignableFrom(type)) {
        final klass = node.returnType.staticElement;
        if (klass != null &&
            (widgetType.isAssignableFrom(klass) ||
                widgetStateType.isAssignableFrom(klass))) {
          yield Lint(
            code: 'riverpod_ref_escape_scope',
            message: 'Ref escaped its scope to another widget.',
            correction: 'Use a Consumer widget instead',
            severity: LintSeverity.warning,
            location: unit.lintLocationFromOffset(
              param.offset,
              length: param.length,
            ),
          );
        }
      }
    }
  }

  Stream<Lint> _checkProviderDependencies(ProviderDeclaration provider) async* {
    final providerDependencies = await provider.dependencies;
    if (providerDependencies == null) return;
    final expectedDependencies = providerDependencies.value;
    final visitor = ProviderRefUsageVisitor();
    final actualDependencies = await provider.node.accept(visitor)!.toList();

    if (expectedDependencies == null) {
      // no `dependencies` specified

      for (final actualDependency in actualDependencies) {
        if (await actualDependency.isScoped) {
          yield Lint(
            code: 'riverpod_unspecified_dependencies',
            message: 'This provider does not specify `dependencies`, '
                'yet depends on "${actualDependency.name}" which did specify its dependencies.',
            correction: 'Add `dependencies` to this provider '
                'or remove `dependencies` from "${actualDependency.name}".',
            severity: LintSeverity.warning,
            location: unit.lintLocationFromOffset(
              provider.node.offset,
              length: provider.name.length,
            ),
            getAnalysisErrorFixes: (lint) async* {
              final changeBuilder = ChangeBuilder(session: unit.session);

              final providerCallback =
                  provider.node.accept(_FindProviderCallbackVisitor())!.single;

              await changeBuilder.addDartFileEdit(unit.path, (builder) {
                builder.addSimpleInsertion(
                  providerCallback.end,
                  ', dependencies: [${actualDependencies.map((e) => e.name).join(', ')}]',
                );
              });

              yield AnalysisErrorFixes(
                lint.asAnalysisError(),
                fixes: [
                  PrioritizedSourceChange(
                    0,
                    changeBuilder.sourceChange
                      ..message = 'List all dependencies',
                  )
                ],
              );
            },
          );
        }
      }
    } else {
      for (final actualDependency in actualDependencies) {
        if (!expectedDependencies.any((e) => e.origin == actualDependency)) {
          yield Lint(
            code: 'riverpod_missing_dependency',
            message: 'This provider depends on "${actualDependency.name}" '
                'yet "${actualDependency.name}" isn\'t listed in the dependencies.',
            correction:
                'Add "${actualDependency.name}" to the list of dependencies '
                'of this provider.',
            severity: LintSeverity.warning,
            location: unit.lintLocationFromOffset(
              // TODO is there a better way to do this?
              provider.dependenciesExpression!.value!.offset,
              length: 'dependencies'.length,
            ),
          );
        }
      }

      for (final expectedDependency in expectedDependencies) {
        if (!actualDependencies.contains(expectedDependency.origin)) {
          yield Lint(
            code: 'riverpod_unused_dependency',
            message:
                'This provider specifies that it depends on "${expectedDependency.origin.name}" '
                'yet it never uses that provider.',
            correction:
                'Remove "${expectedDependency.origin.name}" from the list of dependencies.',
            severity: LintSeverity.warning,
            location: unit.lintLocationFromOffset(
              // TODO is there a better way to do this?
              expectedDependency.node.offset,
              length: expectedDependency.node.length,
            ),
          );
        }
      }
    }

    // print(
    //     'Provider\n - origin: $node\n - expected: ${dependencies.value}\n - dependencies: ${visitor.dependencies}');
  }

  @override
  Stream<Lint> visitTopLevelVariableDeclaration(
    TopLevelVariableDeclaration node,
  ) async* {
    yield* super.visitTopLevelVariableDeclaration(node) ?? const Stream.empty();
    for (final variable in node.variables.variables) {
      final type = variable.declaredElement2?.type;

      if (type != null && containerType.isAssignableFromType(type)) {
        yield Lint(
          code: 'riverpod_global_container',
          message: 'This container is global',
          correction:
              'Make the container non-global by creating it in your main and assigning it to a UncontrolledProviderScope.',
          severity: LintSeverity.warning,
          location: unit.lintLocationFromOffset(
            variable.offset,
            length: variable.length,
          ),
        );
      }
    }
  }

  @override
  Stream<Lint> visitNode(AstNode node) async* {
    yield* super.visitNode(node) ?? const Stream.empty();
    if (node.isWidgetBuild ?? false) {
      final syncMutationDetector = ProviderSyncMutationVisitor(unit);
      final results = node is MethodDeclaration
          ? syncMutationDetector.visitMethodDeclaration(node)
          : node is FunctionDeclaration
              ? syncMutationDetector.visitFunctionDeclaration(node)
              : null;
      yield* results ?? const Stream<Lint>.empty();
      final refAfterAsyncGaps = RefAsyncUsageVisitor(unit);
      final results2 = node is MethodDeclaration
          ? refAfterAsyncGaps.visitMethodDeclaration(node)
          : node is FunctionDeclaration
              ? refAfterAsyncGaps.visitFunctionDeclaration(node)
              : null;
      yield* results2 ?? const Stream<Lint>.empty();
    } else if (node.isInitState ?? false) {
      final syncMutationDetector = ProviderSyncMutationVisitor(unit);
      final results = node is MethodDeclaration
          ? syncMutationDetector.visitMethodDeclaration(node)
          : node is FunctionDeclaration
              ? syncMutationDetector.visitFunctionDeclaration(node)
              : null;
      yield* results ?? const Stream<Lint>.empty();
    }
  }

  Stream<Lint> _checkValidProviderDeclaration(AstNode providerNode) async* {
    if (providerNode is ClassDeclaration ||
        providerNode is FunctionDeclaration) {
      // Codegen provider
      return;
    }
    final declaration =
        providerNode.parents.whereType<VariableDeclaration>().firstOrNull;
    final variable = declaration?.declaredElement2;

    if (variable == null) {
      yield Lint(
        code: 'riverpod_final_provider',
        message: 'Providers should always be declared as final',
        location: unit.lintLocationFromOffset(
          providerNode.offset,
          length: providerNode.length,
        ),
      );
      return;
    }

    final isGlobal = declaration!.parents.any(
      (element) =>
          element is TopLevelVariableDeclaration ||
          (element is FieldDeclaration && element.isStatic),
    );

    if (!isGlobal) {
      yield Lint(
        code: 'riverpod_avoid_dynamic_provider',
        message:
            'Providers should be either top level variables or static properties',
        location: unit.lintLocationFromOffset(
          variable.nameOffset,
          length: variable.nameLength,
        ),
      );
    }

    if (!variable.isFinal) {
      yield Lint(
        code: 'riverpod_final_provider',
        message: 'Providers should always be declared as final',
        location: unit.lintLocationFromOffset(
          variable.nameOffset,
          length: variable.nameLength,
        ),
      );
    }
  }
}
