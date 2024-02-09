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

  @override
  void run(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    final topLevelBuffer = StringBuffer();

    // TODO add docs everywhere in generated code

    final generics = provider.generics();
    final genericsDefinition = provider.genericsDefinition();

    final parameterDefinition = buildParamDefinitionQuery(provider.parameters);

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

  ${provider.providerTypeName}$generics call$genericsDefinition($parameterDefinition)
    => ${provider.providerTypeName}$generics._(
      $argument
      from: this
    );

  @override
  String debugGetCreateSourceHash() => ${provider.hashFnName}();
 
  @override
  String toString() => r'${provider.name}';
''');

    // _writeOverrides(
    //   buffer,
    //   topLevelBuffer: topLevelBuffer,
    //   genericsDefinition: genericsDefinition,
    // );

    buffer.writeln('}');

    buffer.write(topLevelBuffer);
  }

  void _writeOverrides(
    StringBuffer buffer, {
    required StringBuffer topLevelBuffer,
    required String genericsDefinition,
  }) {
    // overrideWith
    _writeOverrideWith(
      buffer,
      topLevelBuffer: topLevelBuffer,
      genericsDefinition: genericsDefinition,
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
    required String genericsDefinition,
  }) {
    // Encode the list of parameters into a record.
    // We do so only if there are at least two parameters.
    // TODO test
    late final argumentsType = switch (provider.parameters) {
      [final p] => p.typeDisplayString,
      _ =>
        '(${buildParamDefinitionQuery(provider.parameters, asRecord: true)})',
    };

    final createType = switch (provider) {
      FunctionalProviderDeclaration(parameters: [_, ...]) =>
        '${provider.createdTypeDisplayString} Function$genericsDefinition(${provider.refWithGenerics} ref, $argumentsType args,)',
      FunctionalProviderDeclaration(parameters: []) =>
        '${provider.createdTypeDisplayString} Function$genericsDefinition(${provider.refWithGenerics} ref)',
      ClassBasedProviderDeclaration(parameters: [_, ...]) =>
        '${provider.createdTypeDisplayString} Function$genericsDefinition(${provider.refWithGenerics} ref, $argumentsType args,)',
      ClassBasedProviderDeclaration() =>
        '${provider.createdTypeDisplayString} Function$genericsDefinition(${provider.refWithGenerics} re)',
    };

    // TODO docs
    buffer.writeln('''
Override overrideWith($createType create,) {
  return \$FamilyOverride(
    from: this,
    createElement: (container, provider) {
      provider as ProviderT;
''');

    switch (provider.parameters) {
      case [_]:
        buffer.writeln('''
      final args = provider.argument! as ${provider.parameters.single.typeDisplayString};
      ''');
    }

    ('''
      final args = provider.argument! as $_argumentRecordType;

      return provider.\$copyWithCreate(create).createElement(container);
    },
  );
}
''');
  }

  void _writeOverrideWithBuild(
    StringBuffer buffer,
    ClassBasedProviderDeclaration provider, {
    required StringBuffer topLevelBuffer,
  }) {
    // TODO docs
    buffer.writeln('''
Override overrideWithBuild() {

}
''');
  }
}
