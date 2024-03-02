part of '../riverpod_ast.dart';

abstract class ProviderDeclaration extends RiverpodAst {
  Token get name;
  AnnotatedNode get node;
  ProviderDeclarationElement get providerElement;
}
