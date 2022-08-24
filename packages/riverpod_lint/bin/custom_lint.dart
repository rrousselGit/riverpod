import 'dart:async';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_lint/src/analyzer_utils.dart';
import 'package:riverpod_lint/src/type_checker.dart';

const _providerBase = TypeChecker.fromRuntime(ProviderBase);
const _family = TypeChecker.fromRuntime(Family);
const _future = TypeChecker.fromRuntime(Future);
const _stream = TypeChecker.fromRuntime(Stream);
const _providerOrFamily = TypeChecker.any([_providerBase, _family]);
const _futureOrStream = TypeChecker.any([_future, _stream]);

const _widget = TypeChecker.fromName('Widget', packageName: 'flutter');
const _widgetState = TypeChecker.fromName('State', packageName: 'flutter');

const _widgetRef =
    TypeChecker.fromName('WidgetRef', packageName: 'flutter_riverpod');

const _consumerWidget = TypeChecker.fromName(
  'ConsumerWidget',
  packageName: 'flutter_riverpod',
);
const _consumerState = TypeChecker.fromName(
  'ConsumerState',
  packageName: 'flutter_riverpod',
);
const _ref = TypeChecker.fromRuntime(Ref);

/// [Ref] methods that can make a provider depend on another provider.
const _refBinders = {'read', 'watch', 'listen'};

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
        _providerOrFamily.isAssignableFrom(createdType)) {
      final stream = visitProviderCreation(node);
      if (stream != null) yield* stream;
    }
  }
}

class RefLifecycleInvocation {
  RefLifecycleInvocation._(this.invocation);

  // Whether the invocation is inside or outside the build method of a provider/widget
  // Null if unknown
  static bool? _isWithinBuild(AstNode node) {
    var hasFoundFunctionExpression = false;

    for (final parent in node.parents) {
      if (parent is FunctionExpression) {
        if (hasFoundFunctionExpression) return false;

        if (parent.isWidgetBuilder ?? false) {
          return true;
        }

        // Since anonymous functions could be the build of a provider,
        // we need to check their ancestors for more information.
        hasFoundFunctionExpression = true;
      }
      if (parent is InstanceCreationExpression) {
        return parent.isProviderCreation;
      }
      if (parent is FunctionExpressionInvocation) {
        return parent.isProviderCreation;
      }
      if (parent is MethodDeclaration) {
        if (hasFoundFunctionExpression || parent.name2.lexeme != 'build') {
          return false;
        }

        final classElement = parent.parents
            .whereType<ClassDeclaration>()
            .firstOrNull
            ?.declaredElement2;

        if (classElement == null) return null;
        return _consumerWidget.isAssignableFrom(classElement) ||
            _consumerState.isAssignableFrom(classElement);
      }
    }
    return null;
  }

  final MethodInvocation invocation;

  late final bool? isWithinBuild = _isWithinBuild(invocation);
}

mixin _RefLifecycleVisitor<T> on AsyncRecursiveVisitor<T> {
  /// A Ref/WidgetRef method was invoked. It isn't guaranteed to be watch/listen/read
  Stream<T>? visitRefInvocation(RefLifecycleInvocation node);

  @override
  Stream<T>? visitMethodInvocation(MethodInvocation node) async* {
    final superStream = super.visitMethodInvocation(node);
    if (superStream != null) yield* superStream;

    final targetType = node.target?.staticType?.element2;
    if (targetType == null) {
      return;
    }

    if (_ref.isAssignableFrom(targetType) ||
        _widgetRef.isAssignableFrom(targetType)) {
      final refInvocStream = visitRefInvocation(RefLifecycleInvocation._(node));
      if (refInvocStream != null) yield* refInvocStream;
    }
  }
}

/// Recursively search all the places where a Provider's `ref` is used
// TODO handle Ref fn() => ref;
class ProviderRefUsageVisitor extends AsyncRecursiveVisitor<ProviderDeclaration>
    with _RefLifecycleVisitor {
  @override
  Stream<ProviderDeclaration>? visitArgumentList(ArgumentList node) async* {
    final superStream = super.visitArgumentList(node);
    if (superStream != null) yield* superStream;
    final providerBody = node.arguments.firstOrNull;
    if (providerBody is ConstructorReference) {
      final element = providerBody
          .constructorName.staticElement?.declaration.enclosingElement3;
      if (element != null) {
        final ast = await findAstNodeForElement(element);

        final createdObjectStream = ast?.accept(this);
        if (createdObjectStream != null) yield* createdObjectStream;
      }
    }

    argumentsLoop:
    for (final arg in node.arguments) {
      final type = arg.staticType?.element2;
      if (type != null && _ref.isAssignableFrom(type)) {
        // "ref" was passed as argument to a constructor/function.
        // We now will search for the constructor/function invoked, to see how
        // it uses ref.

        for (final parent in node.parents) {
          if (parent is MethodInvocation) {
            final functionExpression = parent.function;
            final functionElement = functionExpression is Identifier
                ? functionExpression.staticElement
                : null;

            if (functionElement != null) {
              final declaration = await findAstNodeForElement(functionElement);
              final createdObjectStream = declaration?.accept(this);
              if (createdObjectStream != null) yield* createdObjectStream;
            }

            continue argumentsLoop;
          } else if (parent is InstanceCreationExpression) {
            final createdObject = parent.staticType?.element2;

            if (createdObject != null) {
              final ast = await findAstNodeForElement(createdObject);
              final createdObjectStream = ast?.accept(this);
              if (createdObjectStream != null) yield* createdObjectStream;
            }

            continue argumentsLoop;
          }
        }
      }
    }
  }

  @override
  Stream<ProviderDeclaration>? visitAssignmentExpression(
      AssignmentExpression node) async* {
    final superStream = super.visitAssignmentExpression(node);
    if (superStream != null) yield* superStream;
    final rightType = node.rightHandSide.staticType?.element2;

    if (rightType != null && _ref.isAssignableFrom(rightType)) {
      // "ref" was assigned to a variable or field
      // We now will see if it is a field, to see how the class the field is assigned to uses ref.
      for (final parent in node.parents) {
        if (parent is CascadeExpression) {
          final classElement = parent.target.staticType?.element2;
          if (classElement != null) {
            final declaration = await findAstNodeForElement(classElement);
            final objectStream = declaration?.accept(this);
            if (objectStream != null) yield* objectStream;
          }
        } else if (parent is ExpressionStatement) {
          final assignee = node.leftHandSide;
          if (assignee is PrefixedIdentifier) {
            final target = assignee.prefix.staticType?.element2;
            if (target is InterfaceElement) {
              final declaration = await findAstNodeForElement(target);
              final objectStream = declaration?.accept(this);
              if (objectStream != null) yield* objectStream;
            }
          }
        }
      }
    }
  }

  @override
  Stream<ProviderDeclaration>? visitRefInvocation(
    RefLifecycleInvocation node,
  ) async* {
    if (_refBinders.contains(node.invocation.methodName.name)) {
      final providerExpression = node.invocation.argumentList.arguments.first;
      final providerOrigin =
          await ProviderDeclaration.tryParse(providerExpression);

      if (providerOrigin != null) yield providerOrigin;
    }
  }
}

class ProviderSyncMutationVisitor extends AsyncRecursiveVisitor<Lint> {
  ProviderSyncMutationVisitor(this.unit);

  final ResolvedUnitResult unit;

  Stream<Lint> visitCalledFunction(AstNode node,
      {required AstNode callingNode}) async* {
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
  Stream<Lint>? visitPropertyAccess(PropertyAccess node) async* {
    final method = node.propertyName.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }
    yield* super.visitPropertyAccess(node) ?? const Stream.empty();
  }

  @override
  Stream<Lint>? visitPrefixedIdentifier(PrefixedIdentifier node) async* {
    final method = node.identifier.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }
    yield* super.visitPrefixedIdentifier(node) ?? const Stream.empty();
  }

  @override
  Stream<Lint>? visitFunctionExpressionInvocation(
      FunctionExpressionInvocation node) async* {
    final method = node.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method);
      if (ast != null) {
        yield* visitCalledFunction(ast as FunctionDeclaration,
            callingNode: node);
      }
    }
    yield* super.visitFunctionExpressionInvocation(node) ??
        const Stream.empty();
  }

  @override
  Stream<Lint> visitMethodInvocation(MethodInvocation node) async* {
    final method = node.methodName.staticElement;
    if (method != null) {
      final ast = await findAstNodeForElement(method.declaration!);
      if (ast != null) {
        yield* visitCalledFunction(ast, callingNode: node);
      }
    }

    yield* super.visitMethodInvocation(node) ?? const Stream.empty();
  }

  @override
  Stream<Lint>? visitInstanceCreationExpression(
      InstanceCreationExpression node) async* {
    final constructor = node.constructorName.staticElement;
    if (constructor != null) {
      if (_futureOrStream.isAssignableFrom(constructor.enclosingElement3)) {
        return;
      }

      final ast = await findAstNodeForElement(constructor.declaration);

      if (ast != null) {
        yield* visitConstructorDeclaration(ast as ConstructorDeclaration) ??
            const Stream.empty();
      }
    }
  }

  bool synchronous = true;
  @override
  Stream<Lint>? visitBlockFunctionBody(BlockFunctionBody node) async* {
    final last = synchronous;
    synchronous = true;
    yield* super.visitBlockFunctionBody(node) ?? const Stream.empty();
    synchronous = last;
  }

  @override
  Stream<Lint>? visitAwaitExpression(AwaitExpression node) async* {
    yield* super.visitAwaitExpression(node) ?? const Stream.empty();
    synchronous = false;
  }

  @override
  Stream<Lint>? visitForStatement(ForStatement node) async* {
    // First time through the loop could be synchronous, so wait till the loop is done
    yield* super.visitForStatement(node) ?? const Stream.empty();
    if (node.awaitKeyword != null) {
      synchronous = false;
    }
  }

  @override
  Stream<Lint>? visitAssignmentExpression(
      AssignmentExpression expression) async* {
    final mutate = expression.isMutation;
    if (synchronous && (mutate ?? false)) {
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
    with _RefLifecycleVisitor, _ProviderCreationVisitor {
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
    final variableDeclaration =
        node.parents.whereType<VariableDeclaration>().firstOrNull;
    final providerDeclaration = variableDeclaration?.declaredElement2 != null
        ? ProviderDeclaration._(
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
        _ref.isAssignableFrom(st) &&
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
      ConstructorDeclaration node) async* {
    final superStream = super.visitConstructorDeclaration(node);
    if (superStream != null) yield* superStream;
    for (final param in node.parameters.parameters) {
      final type = param.declaredElement?.type.element2;

      if (type != null && _widgetRef.isAssignableFrom(type)) {
        final klass = node.returnType.staticElement;
        if (klass != null &&
            (_widget.isAssignableFrom(klass) ||
                _widgetState.isAssignableFrom(klass))) {
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
    }
  }

  Stream<Lint> _checkValidProviderDeclaration(AstNode providerNode) async* {
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

    final isGlobal = declaration!.parents.any((element) =>
        element is TopLevelVariableDeclaration ||
        (element is FieldDeclaration && element.isStatic));

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

extension on AstNode {
  Iterable<AstNode> get parents sync* {
    for (var node = parent; node != null; node = node.parent) {
      yield node;
    }
  }
}

class Result<T> {
  const Result(this.value);
  final T value;

  @override
  String toString() => 'Result($value)';
}

@immutable
class ProviderDeclaration {
  ProviderDeclaration._(this.node, this.element);

  /// Decode a provider expression to extract the provider listened.
  ///
  /// For example, for:
  ///
  /// ```dart
  /// family(42).select(...)
  /// ```
  ///
  /// this will return the variable definition of `family`.
  ///
  /// Returns `null` if failed to decode the expression.
  // TODO fuse with riverpod_graph
  static FutureOr<ProviderDeclaration?> tryParse(AstNode providerExpression) {
    if (providerExpression is PropertyAccess) {
      // watch(family(0).modifier)
      final target = providerExpression.target;
      if (target != null) return ProviderDeclaration.tryParse(target);
    } else if (providerExpression is PrefixedIdentifier) {
      // watch(provider.modifier)
      return ProviderDeclaration.tryParse(providerExpression.prefix);
    } else if (providerExpression is Identifier) {
      // watch(variable)
      final Object? staticElement = providerExpression.staticElement;
      if (staticElement is PropertyAccessorElement) {
        // TODO can this be removed?
        return findAstNodeForElement(staticElement.declaration.variable)
            .then((ast) {
          if (ast is VariableDeclaration) {
            return ProviderDeclaration._(
                ast, staticElement.declaration.variable);
          }
          return null;
        });
      }
    } else if (providerExpression is FunctionExpressionInvocation) {
      // watch(family(id))
      return ProviderDeclaration.tryParse(providerExpression.function);
    } else if (providerExpression is MethodInvocation) {
      // watch(variable.select(...)) or watch(family(id).select(...))
      final target = providerExpression.target;
      if (target != null) return ProviderDeclaration.tryParse(target);
    }

    return null;
  }

  /// Finds the "dependencies:" expression in a provider creation
  ///
  /// Returns null if failed to parse.
  /// Returns Result(null) if successfully passed but no dependencies was specified
  static Result<NamedExpression?>? _findDependenciesExpression(
    VariableDeclaration node,
  ) {
    final initializer = node.initializer;
    ArgumentList argumentList;

    if (initializer is InstanceCreationExpression) {
      argumentList = initializer.argumentList;
    } else if (initializer is FunctionExpressionInvocation) {
      argumentList = initializer.argumentList;
    } else {
      return null;
    }

    return Result(
      argumentList.arguments
          .whereType<NamedExpression>()
          .firstWhereOrNull((e) => e.name.label.name == 'dependencies'),
    );
  }

  /// Decode the parameter "dependencies" from a provider
  ///
  /// Returns null if failed to decode.
  /// Returns a [Result] with `value` as null if the parameter "dependencies" was
  /// not specified.
  static Future<Result<List<ProviderDependency>?>?> _findDependencies(
    Result<NamedExpression?>? dependenciesExpressionResult,
  ) async {
    if (dependenciesExpressionResult == null) return null;
    final namedExpression = dependenciesExpressionResult.value;
    if (namedExpression == null) return const Result(null);
    final value = namedExpression.expression;
    if (value is! ListLiteral) return null;

    return Result(
      await Stream.fromIterable(value.elements)
          .asyncMap((node) async {
            final origin = await ProviderDeclaration.tryParse(node);
            if (origin == null) return null;
            return ProviderDependency(origin, node);
          })
          .where((e) => e != null)
          .cast<ProviderDependency>()
          .toList(),
    );
  }

  final VariableDeclaration node;
  final VariableElement element;

  /// The [AstNode] that points to the `dependencies` parameter of a provider
  late final dependenciesExpression = _findDependenciesExpression(node);

  /// The decoded `dependencies` of a provider
  late final dependencies = _findDependencies(dependenciesExpression);

  late final Future<bool> isScoped = dependencies.then((e) => e?.value != null);

  String get name => node.name2.lexeme;

  @override
  String toString() => node.toString();

  @override
  bool operator ==(Object other) {
    return other is ProviderDeclaration && element == other.element;
  }

  @override
  int get hashCode => element.hashCode;
}

@immutable
class ProviderDependency {
  const ProviderDependency(this.origin, this.node);

  /// The provider that is depended on
  final ProviderDeclaration origin;

  /// The [AstNode] associated with this dependency
  final AstNode node;
}

extension on FunctionExpressionInvocation {
  /// Null if unknown
  bool? get isProviderCreation {
    final returnType = staticType?.element2;
    if (returnType == null) return null;

    final function = this.function;

    return _providerOrFamily.isAssignableFrom(returnType) &&
        function is PropertyAccess &&
        (function.propertyName.name == 'autoDispose' ||
            function.propertyName.name == 'family');
  }
}

extension on AstNode {
  bool? get isWidgetBuild {
    final expr = this;
    if (expr is FunctionExpression) {
      return (this as FunctionExpression).isWidgetBuilder;
    }
    if (expr is MethodDeclaration) {
      if (expr.name2.lexeme != 'build') {
        return false;
      }

      final classElement = expr.parents
          .whereType<ClassDeclaration>()
          .firstOrNull
          ?.declaredElement2;

      if (classElement == null) return null;
      return _consumerWidget.isAssignableFrom(classElement) ||
          _consumerState.isAssignableFrom(classElement);
    }
    return null;
  }
}

extension on FunctionExpression {
  /// Null if unknown
  bool? get isWidgetBuilder {
    final returnType = declaredElement?.returnType.element2;
    if (returnType == null) return null;

    return _widget.isAssignableFrom(returnType);
  }
}

extension on InstanceCreationExpression {
  /// Null if unknown
  bool? get isProviderCreation {
    final type = staticType?.element2;
    if (type == null) return null;

    return _providerOrFamily.isAssignableFrom(type);
  }
}

extension on AssignmentExpression {
  // ref.watch(a.notifier).state = '';
  bool? get isMutation {
    final left = leftHandSide;
    if (left is! PropertyAccess || left.propertyName.name != 'state') {
      return null;
    }
    final targ = left.target;
    if (targ is! MethodInvocation) {
      return null;
    }
    final methodTarget = targ.methodName.staticElement?.enclosingElement3;
    if (methodTarget == null || methodTarget is! InterfaceElement) {
      return null;
    }
    if (_ref.isAssignableFromType(methodTarget.thisType) ||
        _widgetRef.isAssignableFromType(methodTarget.thisType)) {
      // TODO: Synchronous listen
      if (targ.methodName.name == 'watch' || targ.methodName.name == 'read') {
        return true;
      }
    }
    return false;
  }
}
