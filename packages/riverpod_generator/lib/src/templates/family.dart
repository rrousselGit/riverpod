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

    buffer.writeln('''
/// {@macro riverpod.override_with}
Override overrideWith($createType create,) {
  return \$FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as ${provider.providerTypeName};
''');

    switch ((
      hasParameters: provider.parameters.isNotEmpty,
      hasGenerics: provider.typeParameters?.typeParameters.isNotEmpty ?? false,
      provider,
    )) {
      case (hasParameters: false, hasGenerics: false, _):
        buffer.writeln(
          r'return provider.$copyWithCreate(create).$createElement(pointer);',
        );
      case (hasParameters: true, hasGenerics: false, _):
        buffer.writeln('''
        final argument = provider.argument$_argumentCast;

        return provider.\$copyWithCreate(${switch (provider) {
          FunctionalProviderDeclaration() => '(ref) => create(ref, argument)',
          ClassBasedProviderDeclaration() => '() => create(argument)',
        }}).\$createElement(pointer);
      ''');

      case (hasParameters: false, hasGenerics: true, _):
        buffer.writeln(
          r'return provider._copyWithCreate(create).$createElement(pointer);',
        );

      case (
          hasParameters: true,
          hasGenerics: true,
          FunctionalProviderDeclaration()
        ):
        buffer.writeln('''
        return provider._copyWithCreate($_genericsDefinition(ref, $_parameterDefinition) {
          return create(ref, ${provider.argumentToRecord()});
        }).\$createElement(pointer);
      ''');
      case (
          hasParameters: true,
          hasGenerics: true,
          ClassBasedProviderDeclaration()
        ):
        buffer.writeln('''
        return provider._copyWithCreate($_genericsDefinition() {
          final argument = provider.argument$_argumentCast;

          return create(argument);
        }).\$createElement(pointer);
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

    buffer.writeln('''
/// {@macro riverpod.override_with_build}
Override overrideWithBuild($runNotifierBuildType build,) {
  return \$FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as ${provider.providerTypeName};
''');

    switch ((
      hasParameters: provider.parameters.isNotEmpty,
      hasGenerics: provider.typeParameters?.typeParameters.isNotEmpty ?? false,
    )) {
      case (hasParameters: false, hasGenerics: false):
        buffer.writeln(
          r'return provider.$copyWithBuild(build).$createElement(pointer);',
        );
      case (hasParameters: true, hasGenerics: false):
        buffer.writeln('''
        final argument = provider.argument$_argumentCast;

        return provider.\$copyWithBuild((ref, notifier) => build(ref, notifier, argument)).\$createElement(pointer);
      ''');

      case (hasParameters: false, hasGenerics: true):
        buffer.writeln(
          r'return provider._copyWithBuild(build).$createElement(pointer);',
        );

      case (hasParameters: true, hasGenerics: true):
        buffer.writeln('''
        return provider._copyWithBuild($_genericsDefinition(ref, notifier) {
          final argument = provider.argument$_argumentCast;

          return build(ref, notifier, argument);
        }).\$createElement(pointer);
      ''');
    }

    buffer.writeln('''
    },
  );
}''');
  }
}
