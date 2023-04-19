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
  Set<GeneratorProviderDeclarationElement>? dependencies,
  BuildYamlOptions options,
) {
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

class StatefulProviderTemplate extends Template {
  StatefulProviderTemplate(
    this.provider, {
    required this.notifierTypedefName,
    required this.hashFn,
    required this.options,
  }) {
    if (provider.buildMethod.parameters!.parameters.isNotEmpty) {
      throw ArgumentError.value(
        provider.buildMethod.parameters?.toSource(),
        'provider',
        'Expected a stateful provider with no parameter',
      );
    }
  }
  final StatefulProviderDeclaration provider;
  final String notifierTypedefName;
  final String hashFn;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    String notifierBaseType;
    String providerType;
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    final providerName = providerNameFor(provider.providerElement, options);
    final returnType = provider.buildMethod.returnType?.type;
    if ((returnType?.isDartAsyncFutureOr ?? false) ||
        (returnType?.isDartAsyncFuture ?? false)) {
      notifierBaseType = '${leading}AsyncNotifier';
      providerType = '${leading}AsyncNotifierProvider';
    } else if (returnType?.isDartAsyncStream ?? false) {
      notifierBaseType = '${leading}StreamNotifier';
      providerType = '${leading}StreamNotifierProvider';
    } else {
      notifierBaseType = '${leading}Notifier';
      providerType = '${leading}NotifierProvider';
    }

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.name}, ${provider.valueType}>.internal(
  ${provider.providerElement.name}.new,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
  debugFamilyCallRuntimeType: null,
  dependencies: ${serializeDependencies(provider.providerElement.annotation.dependencies, options)},
  allTransitiveDependencies: ${serializeDependencies(provider.providerElement.annotation.allTransitiveDependencies, options)},
);

typedef $notifierTypedefName = $notifierBaseType<${provider.valueType}>;
''');
  }
}
