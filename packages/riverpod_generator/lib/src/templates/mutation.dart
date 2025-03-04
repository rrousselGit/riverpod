import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:source_gen/source_gen.dart';

import '../riverpod_generator.dart';
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

    final mutationBase = switch (mutation.createdType) {
      SupportedCreatedType.future => r'$AsyncMutationBase',
      SupportedCreatedType.stream => throw InvalidGenerationSource(
          'Stream mutations are not supported',
          element: mutation.node.declaredElement,
        ),
      SupportedCreatedType.value => r'$SyncMutationBase',
    };

    buffer.writeln('''
sealed class ${mutation.generatedMutationInterfaceName} extends MutationBase<${mutation.valueDisplayType}> {
  /// Starts the mutation.
  /// 
  /// This will first set the state to [PendingMutationState], then
  /// will call [${provider.name}.${mutation.name}] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutationState] or [ErrorMutationState] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  ${mutation.node.returnType ?? ''} call${mutation.node.typeParameters.genericDefinitionDisplayString()}${mutation.node.parameters};
}

final class ${mutation.generatedMutationImplName}
  extends $mutationBase<${mutation.valueDisplayType}, ${mutation.generatedMutationImplName}, ${provider.name}>
  implements ${mutation.generatedMutationInterfaceName} {
  ${mutation.generatedMutationImplName}(this.element, {super.state, super.key});

  @override
  final ${provider.generatedElementName} element;

  @override
  \$ElementLense<${mutation.generatedMutationImplName}> get listenable => element.${mutation.elementFieldName};

  @override
  ${mutation.node.returnType ?? ''} call${mutation.node.typeParameters.genericDefinitionDisplayString()}${mutation.node.parameters} {
    return mutate(
      ${_mutationInvocation()},
      (\$notifier) => \$notifier.${mutation.name}${mutation.node.typeParameters.genericUsageDisplayString()}($parametersPassThrough),
    );
  }

  @override
  ${mutation.generatedMutationImplName} copyWith(MutationState<${mutation.valueDisplayType}> state, {Object? key}) => ${mutation.generatedMutationImplName}(element, state: state, key: key);
}
''');
  }

  String _mutationInvocation() {
    final positional = mutation.node.parameters?.parameters
            .where((e) => e.isPositional)
            .map((e) => e.name!.lexeme)
            .toList() ??
        const [];
    Map<String, String>? named = Map<String, String>.fromEntries(
      mutation.node.parameters?.parameters
              .where((e) => e.isNamed)
              .map((e) => MapEntry('#${e.name!.lexeme}', e.name!.lexeme)) ??
          const [],
    );

    if (named.isEmpty) named = null;

    final typeParams = mutation.node.typeParameters?.typeParameters
            .map((e) => e.name.lexeme)
            .toList() ??
        const [];
    if (typeParams.isEmpty) {
      return 'Invocation.method(#${mutation.name}, $positional, ${named ?? ''})';
    }

    return 'Invocation.genericMethod(#${mutation.name}, $typeParams, $positional, ${named ?? ''})';
  }
}
