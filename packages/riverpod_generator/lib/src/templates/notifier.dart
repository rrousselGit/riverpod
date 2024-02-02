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
        '\$Notifier<${provider.valueTypeDisplayString}>',
    };

    final argumentRecordType = buildParamDefinitionQuery(
      provider.parameters,
      asRecord: true,
    );

    final paramsPassThrough = buildParamInvocationQuery({
      for (final (index, parameter) in provider.parameters.indexed)
        if (parameter.isPositional)
          parameter: '_\$args.\$${index + 1}'
        else
          parameter: '_\$args.${parameter.name!.lexeme}',
    });

    final _$args = r'late final _$args = '
        '(ref as ${provider.elementName}).origin.argument as ($argumentRecordType);';
    var paramOffset = 0;
    final parametersAsFields = provider.parameters
        .map(
          (p) => '${p.typeDisplayString} get ${p.name!.lexeme} => '
              '_\$args.${p.isPositional ? '\$${++paramOffset}' : p.name!.lexeme};',
        )
        .join();

    buffer.writeln('''
abstract class $notifierBaseName$genericsDefinition extends $baseClass {
  ${provider.parameters.isNotEmpty ? _$args : ''}
  $parametersAsFields

  ${provider.createdTypeDisplayString} build($buildParams);

  @\$internal
  @override
  ${provider.createdTypeDisplayString} runBuild() => build($paramsPassThrough);
}
''');
  }
}
