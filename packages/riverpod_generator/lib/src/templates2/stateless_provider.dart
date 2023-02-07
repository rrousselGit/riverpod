import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator2.dart';
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
    } else {
      providerType = '${leading}Provider';
    }

    final providerName = providerNameFor(provider.providerElement, options);
    final dependencies = provider.providerElement.annotation.dependencies ==
            null
        ? ''
        : 'dependencies: ${serializeDependencies(provider.providerElement.annotation.dependencies, options)},';

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.valueType}>(
  ${provider.providerElement.name},
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
$dependencies
);

typedef $refName = ${providerType}Ref<${provider.valueType}>;
''');
  }
}
