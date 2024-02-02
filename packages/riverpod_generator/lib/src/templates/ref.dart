import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import 'family_back.dart';
import 'template.dart';

class RefTemplate extends Template {
  RefTemplate(this.provider);

  final FunctionalProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final typeParameters = provider.node.functionExpression.typeParameters;
    final typeParametersDefinition =
        genericDefinitionDisplayString(typeParameters);

    buffer.writeln('''
typedef ${provider.refImplName}$typeParametersDefinition = Ref<${provider.exposedTypeDisplayString}>;
''');
  }
}
