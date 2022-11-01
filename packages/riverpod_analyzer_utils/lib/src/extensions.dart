// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

import 'riverpod_types.dart';

/// Adds [isProviderCreation] to
extension FunctionExpressionInvocationRiverpodX
    on FunctionExpressionInvocation {
  /// Null if unknown
  bool? get isProviderCreation {
    final returnType = staticType?.element2;
    if (returnType == null) return null;

    final function = this.function;

    return providerOrFamilyType.isAssignableFrom(returnType) &&
        function is PropertyAccess &&
        (function.propertyName.name == 'autoDispose' ||
            function.propertyName.name == 'family');
  }
}

extension MethodDeclarationRiverpodX on MethodDeclaration {
  bool? get isProviderCreation {
    final isBuildMethod = name2.lexeme == 'build';
    final interface = declaredElement2?.enclosingElement3;
    if (interface == null) {
      return null;
    }
    return isBuildMethod && anyNotifierType.isAssignableFrom(interface);
  }
}

extension ClassDeclarationRiverpodX on ClassDeclaration {
  bool? get isProviderCreation {
    final interface = declaredElement2;
    if (interface == null) {
      return null;
    }
    return anyNotifierType.isAssignableFrom(interface);
  }
}

extension FunctionDeclarationRiverpodX on FunctionDeclaration {
  bool? get isProviderCreation {
    final annotation = metadata.firstWhereOrNull(
      (a) => a.name.name == 'riverpod' || a.constructorName?.name == 'Riverpod',
    );
    return annotation == null ? null : true;
  }
}

extension AstNodeRiverpodX on AstNode {
  Iterable<AstNode> get parents sync* {
    for (var node = parent; node != null; node = node.parent) {
      yield node;
    }
  }

  bool get refPassed {
    final node = this;
    if (node is MethodDeclaration) {
      if (!(node.parameters?.hasRefParameter ?? false)) {
        final enclosingElement = node.declaredElement2?.enclosingElement3;
        if (enclosingElement is ExtensionElement &&
            !anyRefType.isAssignableFromType(enclosingElement.extendedType)) {
          return false; // If ref is not passed in, there is no way the ref could be used within the the called function
        } else if (enclosingElement is InterfaceOrAugmentationElement &&
            !enclosingElement.hasRefField) {
          return false; // If ref is not passed in and not a field, there is no way the ref could be used within the the called function
        }
      }
    } else if (node is FunctionDeclaration) {
      if (!(node.functionExpression.parameters?.hasRefParameter ?? false)) {
        return false; // If ref is not passed in, there is no way the ref could be used within the the called function
      }
    }
    return true;
  }

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
      return consumerWidgetType.isAssignableFrom(classElement) ||
          consumerStateType.isAssignableFrom(classElement);
    }
    return null;
  }

  bool? isBuild({bool hasFoundFunctionExpression = false}) {
    final node = this;

    if (node is FunctionExpression) {
      if (hasFoundFunctionExpression) {
        return false;
      }
      if (node.isWidgetBuilder ?? false) {
        return true;
      }

      return parent?.isBuild(hasFoundFunctionExpression: true);
    }
    if (node is InstanceCreationExpression) {
      return node.isProviderCreation;
    }
    if (node is FunctionExpressionInvocation) {
      return node.isProviderCreation;
    }
    if (node is FunctionDeclaration) {
      return node.isProviderCreation;
    }
    if (node is MethodDeclaration) {
      if (node.isProviderCreation ?? false) {
        return true;
      }
      if (hasFoundFunctionExpression || node.name2.lexeme != 'build') {
        return false;
      }

      final classElement = node.parents
          .whereType<ClassDeclaration>()
          .firstOrNull
          ?.declaredElement2;

      if (classElement == null) return null;
      return consumerWidgetType.isAssignableFrom(classElement) ||
          consumerStateType.isAssignableFrom(classElement);
    }
    return parent?.isBuild(
      hasFoundFunctionExpression: hasFoundFunctionExpression,
    );
  }

  bool? get inBuild {
    final inBuild = parent?.isBuild();
    if (inBuild ?? false) {
      return inBuild;
    }
    return inBuild;
  }

  bool? get isInitState {
    final expr = this;
    if (expr is MethodDeclaration) {
      if (expr.name2.lexeme != 'initState') {
        return false;
      }

      final classElement = expr.parents
          .whereType<ClassDeclaration>()
          .firstOrNull
          ?.declaredElement2;

      if (classElement == null) return null;
      return consumerStateType.isAssignableFrom(classElement);
    }
    return null;
  }
}

extension FunctionExpressionRiverpodX on FunctionExpression {
  /// Null if unknown
  bool? get isWidgetBuilder {
    final returnType = declaredElement?.returnType.element2;
    if (returnType == null) return null;

    return widgetType.isAssignableFrom(returnType);
  }
}

extension InstanceCreationExpressionRiverpodX on InstanceCreationExpression {
  /// Null if unknown
  bool? get isProviderCreation {
    final type = staticType?.element2;
    if (type == null) return null;

    return providerOrFamilyType.isAssignableFrom(type);
  }
}

extension ExpressionRiverpodX on Expression {
  // ref.watch(a.notifier).state = '';
  bool? get isMutation {
    final expr = this;
    if (expr is AssignmentExpression) {
      final left = expr.leftHandSide;
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
      if (refType.isAssignableFromType(methodTarget.thisType) ||
          widgetRefType.isAssignableFromType(methodTarget.thisType)) {
        // TODO: Synchronous listen
        if (targ.methodName.name == 'watch' || targ.methodName.name == 'read') {
          return true;
        }
      }
      return false;
    } else if (expr is MethodInvocation) {
      if (expr.methodName.name == 'refresh' ||
          expr.methodName.name == 'invalidate' ||
          expr.methodName.name == 'invalidateSelf') {
        final methodTarget = expr.methodName.staticElement?.enclosingElement3;
        if (methodTarget == null || methodTarget is! InterfaceElement) {
          return null;
        }
        if (refType.isAssignableFromType(methodTarget.thisType) ||
            widgetRefType.isAssignableFromType(methodTarget.thisType)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
    return null;
  }
}

extension FormalParameterListRiverpodX on FormalParameterList {
  bool get hasRefParameter {
    return parameters.any((p) {
      final type = p.declaredElement?.type;
      return type != null && anyRefType.isAssignableFromType(type);
    });
  }
}

extension InterfaceOrAugmentationRiverpodX on InterfaceOrAugmentationElement {
  bool get hasRefField =>
      fields.any((f) => anyRefType.isAssignableFromType(f.type));
}
