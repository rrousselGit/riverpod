part of '../riverpod_ast.dart';

abstract base class ProviderDeclaration extends RiverpodAst
    with _$ProviderDeclaration {
  Token get name;
  @override
  AnnotatedNode get node;
  ProviderDeclarationElement get providerElement;
}
