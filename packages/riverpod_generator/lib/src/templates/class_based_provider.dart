import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator.dart';
import '../validation.dart';
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
    if (provider.buildMethod.parameters!.parameters.isNotEmpty) {
      throw ArgumentError.value(
        provider.buildMethod.parameters?.toSource(),
        'provider',
        'Expected a class-based provider with no parameter',
      );
    }

    validateClassBasedProvider(provider);
  }

  final ClassBasedProviderDeclaration provider;
  final String notifierTypedefName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var notifierBaseType = '${leading}Notifier';
    var providerType = '${leading}NotifierProvider';

    final providerName = providerNameFor(provider.providerElement, options);
    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if ((returnType.isDartAsyncFutureOr) || (returnType.isDartAsyncFuture)) {
        notifierBaseType = '${leading}AsyncNotifier';
        providerType = '${leading}AsyncNotifierProvider';
      } else if (returnType.isDartAsyncStream) {
        notifierBaseType = '${leading}StreamNotifier';
        providerType = '${leading}StreamNotifierProvider';
      }
    }

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.name}, ${provider.valueTypeDisplayString}>.internal(
  ${provider.providerElement.name}.new,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
  dependencies: ${serializeDependencies(provider.providerElement.annotation, options)},
  allTransitiveDependencies: ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)},
);

typedef $notifierTypedefName = $notifierBaseType<${provider.valueTypeDisplayString}>;
''');
  }
}
