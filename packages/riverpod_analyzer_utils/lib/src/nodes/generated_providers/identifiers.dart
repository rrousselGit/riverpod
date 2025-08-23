part of '../../nodes.dart';

@_ast
extension ProviderIdentifierX on SimpleIdentifier {
  static final _cache = Expando<Box<ProviderIdentifier?>>();

  ProviderIdentifier? get provider {
    return _cache.upsert(this, () {
      final element = this.element;
      if (element is! PropertyAccessorElement2) return null;
      final variable = element.variable3;
      if (variable == null) return null;

      final providerFor = parseFirstProviderFor(variable, this);

      ProviderDeclarationElement? providerElement;
      if (providerFor != null) {
        providerElement = providerFor.$1;
      } else {
        providerElement = ManualProviderDeclarationElement._parse(variable);
      }

      if (providerElement == null) return null;

      return ProviderIdentifier._(node: this, providerElement: providerElement);
    });
  }
}

final class ProviderIdentifier {
  ProviderIdentifier._({required this.node, required this.providerElement});

  final SimpleIdentifier node;
  final ProviderDeclarationElement providerElement;
}
