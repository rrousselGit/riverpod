import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import '../riverpod_analysis.dart';

class RefLifecycleInvocation {
  RefLifecycleInvocation._(this.invocation);

  final MethodInvocation invocation;

  late final bool? isWithinBuild = invocation.inBuild;
}

mixin RefLifecycleVisitor<T> on AsyncRecursiveVisitor<T> {
  bool get generatedRef => false;

  /// A Ref/WidgetRef method was invoked. It isn't guaranteed to be watch/listen/read
  Stream<T>? visitRefInvocation(RefLifecycleInvocation node);

  @override
  Stream<T>? visitMethodInvocation(MethodInvocation node) async* {
    final superStream = super.visitMethodInvocation(node);
    if (superStream != null) yield* superStream;

    final targetType = node.target?.staticType?.element2;
    final t = node.target;

    final gen = t is SimpleIdentifier && generatedRef && t.name == 'ref';

    if (targetType == null && !gen) {
      return;
    }

    if (gen ||
        refType.isAssignableFrom(targetType!) ||
        widgetRefType.isAssignableFrom(targetType) ||
        containerType.isAssignableFrom(targetType)) {
      final refInvocStream = visitRefInvocation(RefLifecycleInvocation._(node));
      if (refInvocStream != null) yield* refInvocStream;
    }
  }
}

/// Recursively search all the places where a Provider's `ref` is used
// TODO handle Ref fn() => ref;
class ProviderRefUsageVisitor
    extends GeneralRefUsageVisitor<ProviderDeclaration>
    with RefLifecycleVisitor {
  ProviderRefUsageVisitor();

  @override
  Stream<ProviderDeclaration>? visitRefInvocation(
    RefLifecycleInvocation node,
  ) async* {
    // print(node);
    if (refBinders.contains(node.invocation.methodName.name)) {
      final providerExpression = node.invocation.argumentList.arguments.first;
      final providerOrigin =
          await GeneralProviderDeclaration.tryParse(providerExpression);

      if (providerOrigin != null) yield providerOrigin;
    }
  }
}

class GeneratedRefUsageVisitor
    extends GeneralRefUsageVisitor<GeneralProviderDeclaration> {
  @override
  bool get generatedRef => true;

  @override
  Stream<GeneralProviderDeclaration>? visitRefInvocation(
    RefLifecycleInvocation node,
  ) async* {
    if (refBinders.contains(node.invocation.methodName.name)) {
      final providerExpression = node.invocation.argumentList.arguments.first;
      final providerOrigin = await GeneralProviderDeclaration.tryParseGenerated(
        providerExpression,
      );

      if (providerOrigin != null) yield providerOrigin;
    }
  }
}

abstract class GeneralRefUsageVisitor<D extends GeneralProviderDeclaration>
    extends AsyncRecursiveVisitor<D> with RefLifecycleVisitor {
  @override
  bool get generatedRef => true;

  @override
  Stream<D>? visitArgumentList(ArgumentList node) async* {
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
      if (type != null && refType.isAssignableFrom(type)) {
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
  Stream<D>? visitAssignmentExpression(
    AssignmentExpression node,
  ) async* {
    // print(node);
    final superStream = super.visitAssignmentExpression(node);
    if (superStream != null) yield* superStream;
    final rightType = node.rightHandSide.staticType?.element2;

    if (rightType != null && refType.isAssignableFrom(rightType)) {
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
}
