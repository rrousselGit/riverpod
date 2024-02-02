import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import 'family_back.dart';
import 'parameters.dart';
import 'template.dart';

class FamilyTemplate extends Template {
  FamilyTemplate(this.provider, this.options);

  final GeneratorProviderDeclaration provider;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    // TODO add docs everywhere in generated code

    final generics = provider.generics();
    final genericsDefinition = provider.genericsDefinition();

    final parameterDefinition = buildParamDefinitionQuery(provider.parameters);

    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in provider.parameters)
        parameter: parameter.name!.lexeme,
    });
    final argument = provider.parameters.isEmpty
        ? ''
        : 'argument: ($parametersPassThrough),';

    buffer.writeln('''
final class ${provider.familyTypeName} extends Family{
  const ${provider.familyTypeName}._()
      : super(
        name: r'${provider.name}',
        dependencies: ${provider.dependencies(options)},
        allTransitiveDependencies: ${provider.allTransitiveDependencies(options)},
        debugGetCreateSourceHash: ${provider.hashFnName},
        ${provider.providerElement.isAutoDispose ? 'isAutoDispose: true,' : ''}
      );

  ${provider.providerTypeName}$generics call$genericsDefinition($parameterDefinition)
    => ${provider.providerTypeName}._(
      $argument
      from: this
    );

  @override
  String toString() => r'${provider.name}';
}
''');
  }
}
