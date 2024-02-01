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
    if (provider.providerElement.isFamily) {
      throw ArgumentError.value(
        provider.providerElement.isFamily,
        'provider.providerElement.isFamily',
        'Expected a non-family provider',
      );
    }
  }

  final FunctionalProviderDeclaration provider;
  final String refName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    final isAutoDispose = !provider.providerElement.annotation.keepAlive
        ? 'isAutoDispose: true,'
        : '';

    var providerType = 'Provider';
    var refType = 'Ref<${provider.valueTypeDisplayString}>';

    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if ((returnType.isDartAsyncFutureOr) || (returnType.isDartAsyncFuture)) {
        providerType = 'FutureProvider';
        refType = 'Ref<AsyncValue<${provider.valueTypeDisplayString}>>';
      } else if (returnType.isDartAsyncStream) {
        providerType = 'StreamProvider';
        refType = 'Ref<AsyncValue<${provider.valueTypeDisplayString}>>';
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
${metaAnnotations(provider.node.metadata)}
final $providerName = $providerType<${provider.valueTypeDisplayString}>.internal(
  $createFn,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
  from: null,
  argument: null,
  $isAutoDispose
  dependencies: ${serializeDependencies(provider.providerElement.annotation, options)},
  allTransitiveDependencies: ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)},
);

typedef $refName = $refType;
''');
  }
}
