import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../type.dart';
import 'family_back.dart';
import 'parameters.dart';
import 'template.dart';

class NotifierTemplate extends Template {
  NotifierTemplate(this.provider);

  final ClassBasedProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final notifierBaseName = '_\$${provider.name.lexeme.public}';
    final genericsDefinition = provider.genericsDefinition();
    final buildParams = buildParamDefinitionQuery(provider.parameters);

    final baseClass = switch (provider.createdType) {
      SupportedCreatedType.future =>
        '\$AsyncNotifier<${provider.valueTypeDisplayString}>',
      SupportedCreatedType.stream =>
        '\$StreamNotifier<${provider.valueTypeDisplayString}>',
      SupportedCreatedType.value =>
        '\$cNotifier<${provider.valueTypeDisplayString}>',
    };

    buffer.writeln('''
abstract class $notifierBaseName$genericsDefinition extends $baseClass {
  ${provider.createdTypeDisplayString} build($buildParams);

  @\$internal
  @override
  void runBuild() {

  }
}
''');
  }
}
