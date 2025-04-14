part of '../nodes.dart';

@_ast
extension ProviderListenableExpressionX on Expression {
  static final _cache = Expando<Box<ProviderListenableExpression?>>();

  ProviderListenableExpression? get providerListenable {
    return _cache.upsert(this, () {
      final returnType = staticType;
      if (returnType == null) return null;
      if (!providerListenableType.isAssignableFromType(returnType)) return null;

      final parseResult = _parsesProviderExpression(this);
      if (parseResult == null) return null;
      final (
        :provider,
        :providerPrefix,
        :familyArguments,
      ) = parseResult;

      return ProviderListenableExpression._(
        node: this,
        provider: provider,
        providerPrefix: providerPrefix,
        familyArguments: familyArguments,
      );
    });
  }
}

final class ProviderListenableExpression {
  ProviderListenableExpression._({
    required this.node,
    required this.provider,
    required this.providerPrefix,
    required this.familyArguments,
  });

  final Expression node;
  final SimpleIdentifier? providerPrefix;
  final ProviderIdentifier? provider;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}
