part of '../riverpod_ast.dart';

abstract class ProviderDeclaration extends RiverpodAst {
  Token get name;
  AstNode get node;
  ProviderDeclarationElement get providerElement;
}
