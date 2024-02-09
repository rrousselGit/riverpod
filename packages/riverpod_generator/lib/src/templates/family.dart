import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'parameters.dart';
import 'template.dart';

class FamilyTemplate extends Template {
  FamilyTemplate(
    this.provider,
    this.options, {
    required this.allTransitiveDependencies,
  });

  final GeneratorProviderDeclaration provider;
  final BuildYamlOptions options;
  final List<String>? allTransitiveDependencies;

  late final _argumentRecordType = provider.argumentRecordType;

  late final _generics = provider.generics();
  late final _genericsDefinition = provider.genericsDefinition();
  late final _parameterDefinition =
      buildParamDefinitionQuery(provider.parameters);
  late final _notifierType = '${provider.name}$_generics';

  @override
  void run(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    final topLevelBuffer = StringBuffer();

    // TODO add docs everywhere in generated code

    final parametersPassThrough = provider.argumentToRecord();
    final argument =
        provider.parameters.isEmpty ? '' : 'argument: $parametersPassThrough,';

    buffer.writeln('''
final class ${provider.familyTypeName} extends Family {
  const ${provider.familyTypeName}._()
      : super(
        name: r'${provider.providerName(options)}',
        dependencies: ${provider.dependencies(options)},
        allTransitiveDependencies: ${provider.allTransitiveDependencies(allTransitiveDependencies)},
        ${provider.providerElement.isAutoDispose ? 'isAutoDispose: true,' : ''}
      );

  ${provider.providerTypeName}$_generics call$_genericsDefinition($_parameterDefinition)
    => ${provider.providerTypeName}$_generics._(
      $argument
      from: this
    );

  @override
  String debugGetCreateSourceHash() => ${provider.hashFnName}();
 
  @override
  String toString() => r'${provider.providerName(options)}';
''');

    _writeOverrides(buffer, topLevelBuffer: topLevelBuffer);

    buffer.writeln('}');

    buffer.write(topLevelBuffer);
  }

  void _writeOverrides(
    StringBuffer buffer, {
    required StringBuffer topLevelBuffer,
  }) {
    // overrideWith
    _writeOverrideWith(
      buffer,
      topLevelBuffer: topLevelBuffer,
    );

    // overrideWithBuild
    final provider = this.provider;
    if (provider is ClassBasedProviderDeclaration) {
      _writeOverrideWithBuild(
        buffer,
        provider,
        topLevelBuffer: topLevelBuffer,
      );
    }
  }

  void _writeOverrideWith(
    StringBuffer buffer, {
    required StringBuffer topLevelBuffer,
  }) {
    final createType = switch (provider) {
      FunctionalProviderDeclaration(parameters: [_, ...]) =>
        '${provider.createdTypeDisplayString} Function$_genericsDefinition(${provider.refWithGenerics} ref, $_argumentRecordType args,)',
      FunctionalProviderDeclaration(parameters: []) =>
        '${provider.createdTypeDisplayString} Function$_genericsDefinition(${provider.refWithGenerics} ref)',
      ClassBasedProviderDeclaration(parameters: [_, ...]) =>
        '$_notifierType Function$_genericsDefinition($_argumentRecordType args,)',
      ClassBasedProviderDeclaration() =>
        '$_notifierType Function$_genericsDefinition()',
    };

    // TODO docs
    buffer.writeln('''
Override overrideWith($createType create,) {
  return \$FamilyOverride(
    from: this,
    createElement: (container, provider) {
      provider as ${provider.providerTypeName};
''');

    switch ((
      hasParameters: provider.parameters.isNotEmpty,
      hasGenerics: provider.typeParameters?.typeParameters.isNotEmpty ?? false,
    )) {
      case (hasParameters: false, hasGenerics: false):
        buffer.writeln(
          r'return provider.$copyWithCreate(create).createElement(container);',
        );
      case (hasParameters: true, hasGenerics: false):
        buffer.writeln('''
        final argument = provider.argument as $_argumentRecordType;

        return provider.\$copyWithCreate(${switch (provider) {
          FunctionalProviderDeclaration() => '(ref) => create(ref, argument)',
          ClassBasedProviderDeclaration() => '() => create(argument)',
        }}).createElement(container);
      ''');

      case (hasParameters: false, hasGenerics: true):
        buffer.writeln(
          'return provider._copyWithCreate(create).createElement(container);',
        );

      case (hasParameters: true, hasGenerics: true):
        buffer.writeln('''
        return provider._copyWithCreate($_genericsDefinition(ref, $_parameterDefinition) {
          final argument = provider.argument as $_argumentRecordType;

          return create(ref, argument);
        }).createElement(container);
      ''');
    }

    buffer.writeln('''
    },
  );
}''');
  }

  void _writeOverrideWithBuild(
    StringBuffer buffer,
    ClassBasedProviderDeclaration provider, {
    required StringBuffer topLevelBuffer,
  }) {
    final runNotifierBuildType = '''
${provider.createdTypeDisplayString} Function$_genericsDefinition(
  ${provider.refWithGenerics} ref,
  $_notifierType notifier
  ${switch (provider.parameters) {
      [] => '',
      [_, ...] => ', $_argumentRecordType argument',
    }}
)''';

    // TODO docs
    buffer.writeln('''
Override overrideWithBuild($runNotifierBuildType build,) {
  return \$FamilyOverride(
    from: this,
    createElement: (container, provider) {
      provider as ${provider.providerTypeName};
''');

    switch ((
      hasParameters: provider.parameters.isNotEmpty,
      hasGenerics: provider.typeParameters?.typeParameters.isNotEmpty ?? false,
    )) {
      case (hasParameters: false, hasGenerics: false):
        buffer.writeln(
          r'return provider.$copyWithBuild(build).createElement(container);',
        );
      case (hasParameters: true, hasGenerics: false):
        buffer.writeln('''
        final argument = provider.argument as $_argumentRecordType;

        return provider.\$copyWithBuild((ref, notifier) => build(ref, notifier, argument)).createElement(container);
      ''');

      case (hasParameters: false, hasGenerics: true):
        buffer.writeln(
          'return provider._copyWithBuild(build).createElement(container);',
        );

      case (hasParameters: true, hasGenerics: true):
        buffer.writeln('''
        return provider._copyWithBuild($_genericsDefinition(ref, notifier, $_parameterDefinition) {
          final argument = provider.argument as $_argumentRecordType;

          return build(ref, notifier, argument);
        }).createElement(container);
      ''');
    }

    buffer.writeln('''
    },
  );
}''');
  }
}
