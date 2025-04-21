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
  late final _argumentCast = provider.argumentCast;

  @override
  void run(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    final topLevelBuffer = StringBuffer();

    final parametersPassThrough = provider.argumentToRecord();
    final argument =
        provider.parameters.isEmpty ? '' : 'argument: $parametersPassThrough,';

    buffer.writeln('''
${provider.doc} final class ${provider.familyTypeName} extends Family {
  const ${provider.familyTypeName}._()
      : super(
        retry: ${provider.annotation.retryNode?.name ?? 'null'},
        name: r'${provider.providerName(options)}',
        dependencies: ${provider.dependencies(options)},
        allTransitiveDependencies: ${provider.allTransitiveDependencies(allTransitiveDependencies)},
        isAutoDispose: ${provider.providerElement.isAutoDispose},
      );

  ${provider.doc} ${provider.providerTypeName}$_generics call$_genericsDefinition($_parameterDefinition)
    => ${provider.providerTypeName}$_generics._(
      $argument
      from: this
    );

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
        '${provider.createdTypeDisplayString} Function$_genericsDefinition(Ref ref, $_argumentRecordType args,)',
      FunctionalProviderDeclaration(parameters: []) =>
        '${provider.createdTypeDisplayString} Function$_genericsDefinition(Ref ref)',
      ClassBasedProviderDeclaration(parameters: [_, ...]) =>
        '$_notifierType Function$_genericsDefinition($_argumentRecordType args,)',
      ClassBasedProviderDeclaration() =>
        '$_notifierType Function$_genericsDefinition()',
    };

    buffer.writeln('''
/// {@macro riverpod.override_with}
Override overrideWith($createType create) =>
  ${_override((buffer) {
      buffer.writeln('''
        return provider.\$view(create: ${switch ((
        hasParameters: provider.parameters.isNotEmpty,
        provider,
      )) {
        (_, hasParameters: false) => 'create$_generics',
        (FunctionalProviderDeclaration(), hasParameters: true) =>
          '(ref) => create(ref, argument)',
        (ClassBasedProviderDeclaration(), hasParameters: true) =>
          '() => create(argument)',
      }}).\$createElement(pointer);
      ''');
    })};
''');
  }

  void _writeOverrideWithBuild(
    StringBuffer buffer,
    ClassBasedProviderDeclaration provider, {
    required StringBuffer topLevelBuffer,
  }) {
    final runNotifierBuildType = '''
${provider.createdTypeDisplayString} Function$_genericsDefinition(
  Ref ref,
  $_notifierType notifier
  ${switch (provider.parameters) {
      [] => '',
      [_, ...] => ', $_argumentRecordType argument',
    }}
)''';

    buffer.writeln('''
/// {@macro riverpod.override_with_build}
Override overrideWithBuild($runNotifierBuildType build) =>
  ${_override((buffer) {
      buffer.writeln('''
        return provider.\$view(runNotifierBuildOverride: ${switch ((
        hasParameters: provider.parameters.isNotEmpty,
      )) {
        (hasParameters: false) => 'build$_generics',
        (hasParameters: true) =>
          '(ref, notifier) => build$_generics(ref, notifier, argument)',
      }}).\$createElement(pointer);
      ''');
    })};
''');
  }

  String _override(void Function(StringBuffer buffer) build) {
    final buffer = StringBuffer('''
\$FamilyOverride(
    from: this,
    createElement: 
(pointer) {
      final provider = pointer.origin as ${provider.providerTypeName};
''');

    final hasGenerics =
        provider.typeParameters?.typeParameters.isNotEmpty ?? false;
    final hasParameters = provider.parameters.isNotEmpty;
    if (hasGenerics) {
      buffer
          .writeln('return provider._captureGenerics($_genericsDefinition() {');
      buffer.writeln('provider as ${provider.providerTypeName}$_generics;');
    }
    if (hasParameters) {
      buffer.writeln('final argument = provider.argument$_argumentCast;');
    }

    build(buffer);

    if (hasGenerics) {
      buffer.writeln('});');
    }
    buffer.write('})');

    return buffer.toString();
  }
}
