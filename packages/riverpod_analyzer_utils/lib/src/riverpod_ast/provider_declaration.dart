part of '../riverpod_ast.dart';

abstract class ProviderDeclaration extends RiverpodAst {
  @override
  CompilationUnit get unit;
  Token get name;
  AnnotatedNode get node;
  ProviderDeclarationElement get providerElement;
}
