import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator.dart';
import 'template.dart';

String providerNameFor(
  ProviderDeclarationElement provider,
  BuildYamlOptions options,
) {
  return '${provider.name.lowerFirst}${options.providerNameSuffix ?? 'Provider'}';
}

String? serializeDependencies(
  RiverpodAnnotationElement annotation,
  BuildYamlOptions options,
) {
  final dependencies = annotation.dependencies;
  if (dependencies == null) return 'null';

  final buffer = StringBuffer(
    '${dependencies.isEmpty ? 'const ' : ''}<ProviderOrFamily>',
  );
  // Use list vs set based on the number of dependencies to optimize "contains" call
  if (dependencies.length < 4) {
    buffer.write('[');
  } else {
    buffer.write('{');
  }

  buffer.writeAll(
    dependencies.map((e) => providerNameFor(e, options)),
    ',',
  );

  if (dependencies.length < 4) {
    buffer.write(']');
  } else {
    buffer.write('}');
  }
  return buffer.toString();
}

String? serializeAllTransitiveDependencies(
  RiverpodAnnotationElement annotation,
  BuildYamlOptions options,
) {
  // Not optimizing based off "allTransitiveDependencies" yet due to https://github.com/dart-lang/language/issues/3037
  // This could be worked around by having the "Provider" type expose
  // the transitive dependencies.
  // But this assumes that all providers have their custom Provider class.
  final dependencies = annotation.dependencies;
  if (dependencies == null) return 'null';

  final buffer = StringBuffer(
    '${dependencies.isEmpty ? 'const ' : ''}<ProviderOrFamily>',
  );

  buffer.write('{');
  buffer.writeAll(
    dependencies
        .map((e) => providerNameFor(e, options))
        .map((e) => '$e, ...?$e.allTransitiveDependencies'),
    ',',
  );
  buffer.write('}');

  return buffer.toString();
}

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
  dependencies: ${serializeDependencies(provider.providerElement.annotation, options)},
  allTransitiveDependencies: ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)},
);

typedef $notifierTypedefName = $notifierBaseType<${provider.valueTypeDisplayString}>;
''');
  }
}
