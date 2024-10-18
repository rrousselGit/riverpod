import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator.dart';
import 'class_based_provider.dart';
import 'template.dart';

class FunctionalProviderTemplate extends Template {
  FunctionalProviderTemplate(
    this.provider, {
    required this.refName,
    required this.hashFn,
    required this.options,
  }) {
    if (provider.node.functionExpression.parameters!.parameters.length > 1) {
      throw ArgumentError.value(
        provider.node.functionExpression.parameters?.toSource(),
        'provider',
        'Expected a functional provider with no parameter',
      );
    }
  }

  final FunctionalProviderDeclaration provider;
  final String refName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    var leading = '';

    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}Provider';

    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if ((returnType.isDartAsyncFutureOr) || (returnType.isDartAsyncFuture)) {
        providerType = '${leading}FutureProvider';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamProvider';
      }
    }

    final providerName = providerNameFor(provider.providerElement, options);

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
final $providerName = $providerType<${provider.valueTypeDisplayString}>.internal(
  $createFn,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
  dependencies: ${serializeDependencies(provider.providerElement.annotation, options)},
  allTransitiveDependencies: ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)},
);


@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef $refName = ${providerType}Ref<${provider.valueTypeDisplayString}>;
''');
  }
}
