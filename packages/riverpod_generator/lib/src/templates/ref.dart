import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_generator.dart';
import 'template.dart';

class RefTemplate extends Template {
  RefTemplate(this.provider);

  final FunctionalProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final typeParametersDefinition = provider.genericsDefinition();

    buffer.writeln('''
${provider.doc} typedef ${provider.refImplName}$typeParametersDefinition = Ref<${provider.exposedTypeDisplayString}>;
''');
  }
}
