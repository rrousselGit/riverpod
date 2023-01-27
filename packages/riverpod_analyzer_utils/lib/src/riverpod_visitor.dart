import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

abstract class RiverpodVisitor<T> extends RecursiveAstVisitor<T> {
  T visitProviderDeclaration();

  T visitLegacyProviderDeclaration();

  T visitStatelessProviderDeclaration();

  T visitStatefulProviderDeclaration();
}
