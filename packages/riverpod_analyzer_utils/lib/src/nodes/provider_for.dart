part of '../nodes.dart';

@internal
(ProviderDeclarationElement?,)? parseProviderFor(
  ElementAnnotation annotation, {
  required Element? from,
}) {
  final type = annotation.element.cast<ExecutableElement>()?.returnType;
  if (type == null || !providerForType.isExactlyType(type)) return null;

  final value = annotation.computeConstantValue()?.getField('value');
  if (value == null) return (null,);

  return (value.toDependency(from: from),);
}

@internal
(ProviderDeclarationElement?,)? parseFirstProviderFor(Element annotation) {
  return annotation.metadata
      .map((e) => parseProviderFor(e, from: annotation))
      .whereNotNull()
      .firstOrNull;
}
