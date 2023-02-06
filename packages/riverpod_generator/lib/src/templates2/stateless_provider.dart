import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../riverpod_generator2.dart';
import 'template.dart';

class StatelessProviderTemplate extends Template {
  StatelessProviderTemplate(
    this.provider, {
    required this.providerName,
    required this.refName,
    required this.hashFn,
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
  final String providerName;
  final String refName;
  final String hashFn;

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

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.valueType}>(
  ${provider.providerElement.name},
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
);

typedef $refName = ${providerType}Ref<${provider.valueType}>;
''');
  }
}
