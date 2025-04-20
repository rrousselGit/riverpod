import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'template.dart';

class ProviderVariableTemplate extends Template {
  ProviderVariableTemplate(this.provider, this.options);

  final GeneratorProviderDeclaration provider;
  final BuildYamlOptions options;

  @override
  void run(StringBuffer buffer) {
    final providerName = provider.providerName(options);

    buffer.write(provider.doc);
    provider.metadata.forEach(buffer.writeln);

    switch (provider) {
      case _ when provider.providerElement.isFamily:
        buffer
            .writeln('const $providerName = ${provider.familyTypeName}._();\n');

      case _:
        final providerType = provider.providerTypeName;
        buffer.writeln('const $providerName = $providerType._();\n');
    }
  }
}
