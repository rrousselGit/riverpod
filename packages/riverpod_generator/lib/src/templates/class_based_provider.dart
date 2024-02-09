import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator.dart';
import 'family_back.dart';
import 'template.dart';

class ClassBasedProviderTemplate extends Template {
  ClassBasedProviderTemplate(
    this.provider, {
    required this.notifierTypedefName,
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
  final ClassBasedProviderDeclaration provider;
  final String notifierTypedefName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    final isAutoDispose = !provider.providerElement.annotation.keepAlive
        ? 'isAutoDispose: true,'
        : '';

    var notifierBaseType = 'Notifier';
    var providerType = 'NotifierProvider';

    final providerName = providerNameFor(provider.providerElement, options);
    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if ((returnType.isDartAsyncFutureOr) || (returnType.isDartAsyncFuture)) {
        notifierBaseType = 'AsyncNotifier';
        providerType = 'AsyncNotifierProvider';
      } else if (returnType.isDartAsyncStream) {
        notifierBaseType = 'StreamNotifier';
        providerType = 'StreamNotifierProvider';
      }
    }

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
${metaAnnotations(provider.node.metadata)}
final $providerName = $providerType<${provider.name}, ${provider.valueTypeDisplayString}>.internal(
  ${provider.providerElement.name}.new,
  name: r'$providerName',
  from: null,
  argument: null,
  $isAutoDispose
  debugGetCreateSourceHash: $hashFn,
  dependencies: ${provider.dependencies(options)},
  allTransitiveDependencies: null,
);

typedef $notifierTypedefName = $notifierBaseType<${provider.valueTypeDisplayString}>;
''');
  }
}
