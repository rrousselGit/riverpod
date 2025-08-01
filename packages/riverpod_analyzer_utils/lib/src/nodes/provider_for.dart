part of '../nodes.dart';

@internal
(ProviderDeclarationElement?,)? parseProviderFor(
  ElementAnnotation annotation, {
  required AstNode from,
}) {
  final type = annotation.element2.cast<ExecutableElement2>()?.returnType;

  if (type == null || !providerForType.isExactlyType(type)) return null;

  final value = annotation.computeConstantValue()?.getField('value');
  if (value == null) return (null,);

  return (value.toDependency(from: from),);
}

@internal
(ProviderDeclarationElement?,)? parseFirstProviderFor(
  Annotatable annotation,
  AstNode from,
) {
  return annotation.metadata2.annotations
      .map((e) => parseProviderFor(e, from: from))
      .nonNulls
      .firstOrNull;
}
