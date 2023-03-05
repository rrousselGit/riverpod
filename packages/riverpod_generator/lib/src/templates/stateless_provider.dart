import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator.dart';
import 'stateful_provider.dart';
import 'template.dart';

class StatelessProviderTemplate extends Template {
  StatelessProviderTemplate(
    this.provider, {
    required this.refName,
    required this.hashFn,
    required this.options,
  }) {
    if (provider.node.functionExpression.parameters!.parameters.length > 1) {
      throw ArgumentError.value(
        provider.node.functionExpression.parameters?.toSource(),
        'provider',
        'Expected a stateless provider with no parameter',
      );
    }
  }

  final StatelessProviderDeclaration provider;
  final String refName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    String providerType;
    var leading = '';

    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    final returnType = provider.node.returnType?.type;
    if ((returnType?.isDartAsyncFutureOr ?? false) ||
        (returnType?.isDartAsyncFuture ?? false)) {
      providerType = '${leading}FutureProvider';
    } else if (returnType?.isDartAsyncStream ?? false) {
      providerType = '${leading}StreamProvider';
    } else {
      providerType = '${leading}Provider';
    }

    final providerName = providerNameFor(
      provider.providerElement,
      options,
      providerName: provider.providerElement.annotation.name,
    );

    final createFn = provider.node.externalKeyword == null
        ? provider.providerElement.name
        : '''
(_) => throw UnsupportedError(
  'The provider "$providerName" is expected to get overridden/scoped, '
  'but was accessed without an override.',
)
''';

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.valueType}>.internal(
  $createFn,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
  dependencies: ${serializeDependencies(provider.providerElement.annotation.dependencies, options)},
  allTransitiveDependencies: ${serializeDependencies(provider.providerElement.annotation.allTransitiveDependencies, options)},
);

typedef $refName = ${providerType}Ref<${provider.valueType}>;
''');
  }
}
