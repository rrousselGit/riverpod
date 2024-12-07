import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_generator.dart';
import '../type.dart';
import 'element.dart';
import 'parameters.dart';
import 'template.dart';

class MutationTemplate extends Template {
  MutationTemplate(this.mutation, this.provider);

  final Mutation mutation;
  final ClassBasedProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in mutation.node.parameters!.parameters)
        parameter: parameter.name.toString(),
    });

    final mutationBase = switch (provider.createdType) {
      SupportedCreatedType.future => r'$AsyncMutationBase',
      SupportedCreatedType.stream => r'$AsyncMutationBase',
      SupportedCreatedType.value => r'$SyncMutationBase',
    };

    buffer.writeln('''
sealed class ${mutation.generatedMutationInterfaceName} extends MutationBase<${provider.valueTypeDisplayString}> {
  Future<${provider.valueTypeDisplayString}> call${mutation.node.typeParameters.genericDefinitionDisplayString()}${mutation.node.parameters};
}

final class ${mutation.generatedMutationImplName}
  extends $mutationBase<${provider.valueTypeDisplayString}, ${mutation.generatedMutationImplName}, ${provider.name}>
  implements ${mutation.generatedMutationInterfaceName} {
  ${mutation.generatedMutationImplName}(this.element, {super.state, super.key});

  @override
  final ${provider.generatedElementName} element;

  @override
  ProxyElementValueListenable<${mutation.generatedMutationImplName}> get listenable => element.${mutation.elementFieldName};

  @override
  Future<${provider.valueTypeDisplayString}> call${mutation.node.typeParameters.genericDefinitionDisplayString()}${mutation.node.parameters} {
    return mutateAsync((\$notifier) => \$notifier.${mutation.name}${mutation.node.typeParameters.genericUsageDisplayString()}($parametersPassThrough));
  }

  @override
  ${mutation.generatedMutationImplName} copyWith(MutationState<int> state, {Object? key}) => ${mutation.generatedMutationImplName}(element, state: state, key: key);
}
''');
  }
}
