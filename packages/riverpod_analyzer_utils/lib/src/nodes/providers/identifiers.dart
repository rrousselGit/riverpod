part of '../../nodes.dart';

@_ast
extension ProviderIdentifierX on SimpleIdentifier {
  ProviderIdentifier? get provider {
    return upsert('ProviderIdentifier', () {
      final element = staticElement;
      if (element is! PropertyAccessorElement) return null;

      final providerFor = parseFirstProviderFor(element.variable);

      ProviderDeclarationElement? providerElement;
      if (providerFor != null) {
        providerElement = providerFor.$1;
      } else {
        providerElement =
            LegacyProviderDeclarationElement._parse(element.variable);
      }

      if (providerElement == null) return null;

      return ProviderIdentifier._(
        node: this,
        providerElement: providerElement,
      );
    });
  }
}

final class ProviderIdentifier {
  ProviderIdentifier._({required this.node, required this.providerElement});

  final SimpleIdentifier node;
  final ProviderDeclarationElement providerElement;
}
