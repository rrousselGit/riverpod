import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import '../type.dart';
import 'parameters.dart';
import 'template.dart';

class NotifierTemplate extends Template {
  NotifierTemplate(this.provider);

  final ClassBasedProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final notifierBaseName = provider.isPersisted
        ? '_\$${provider.name.lexeme.public}Base'
        : '_\$${provider.name.lexeme.public}';
    final genericsDefinition = provider.genericsDefinition();

    final baseClass = switch (provider.createdType) {
      SupportedCreatedType.future =>
        '\$AsyncNotifier<${provider.valueTypeDisplayString}>',
      SupportedCreatedType.stream =>
        '\$StreamNotifier<${provider.valueTypeDisplayString}>',
      SupportedCreatedType.value =>
        '\$Notifier<${provider.valueTypeDisplayString}>',
    };

    final paramsPassThrough = buildParamInvocationQuery({
      for (final (index, parameter) in provider.parameters.indexed)
        if (provider.parameters.length == 1)
          parameter: r'_$args'
        else if (parameter.isPositional)
          parameter: '_\$args.\$${index + 1}'
        else
          parameter: '_\$args.${parameter.name!.lexeme}',
    });

    final _$args = 'late final _\$args = ref.\$arg${provider.argumentCast};';

    var paramOffset = 0;
    final parametersAsFields = provider.parameters.map(
      (p) {
        final metadata = p.metadata.isNotEmpty
            ? '${p.metadata.map((e) => e.toSource()).join(' ')} '
            : '';
        return '${p.doc} $metadata ${p.typeDisplayString} get ${p.name!.lexeme} => ${switch (provider.parameters) {
          [_] => r'_$args;',
          _ =>
            '_\$args.${p.isPositional ? '\$${++paramOffset}' : p.name!.lexeme};',
        }}';
      },
    ).join();

    buffer.writeln('''
abstract class $notifierBaseName$genericsDefinition extends $baseClass {
  ${provider.parameters.isNotEmpty ? _$args : ''}
  $parametersAsFields
''');

    _writeBuild(buffer);

    final buildVar =
        provider.valueTypeDisplayString == 'void' ? '' : 'final created = ';

    final buildVarUsage =
        provider.valueTypeDisplayString == 'void' ? 'null' : 'created';

    buffer.writeln('''
  @\$internal
  @override
  void runBuild() {
    ${buildVar}build($paramsPassThrough);
    final ref = this.ref as \$Ref<${provider.exposedTypeDisplayString}>;
    final element = ref.element as \$ClassProviderElement<NotifierBase<${provider.exposedTypeDisplayString}>,
          ${provider.exposedTypeDisplayString}, Object?, Object?>;
    element.handleValue(ref, $buildVarUsage);
  }
}
''');
  }

  void _writeBuild(StringBuffer buffer) {
    final buildParams = buildParamDefinitionQuery(provider.parameters);

    buffer.write('${provider.createdTypeDisplayString} build($buildParams)');

    if (provider.buildMethod.isAbstract) {
      buffer.writeln('=> throw MissingScopeException(ref);');
    } else {
      buffer.writeln(';');
    }
  }
}
