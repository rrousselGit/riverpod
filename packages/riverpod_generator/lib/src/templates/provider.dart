import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'element.dart';
import 'parameters.dart';
import 'template.dart';

class ProviderTemplate extends Template {
  ProviderTemplate(
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

  @override
  void run(StringBuffer buffer) {
    final provider = this.provider;

    final name = provider.providerTypeName;
    final exposedType = provider.exposedTypeDisplayString;
    final createdType = provider.createdTypeDisplayString;
    final valueType = provider.valueTypeDisplayString;

    switch (provider) {
      case FunctionalProviderDeclaration():
        final List<String> modifiers;

        switch (provider.createdType) {
          case SupportedCreatedType.future:
            modifiers = [
              '\$FutureModifier<$valueType>',
              '\$FutureProvider<$valueType>',
            ];
          case SupportedCreatedType.stream:
            modifiers = [
              '\$FutureModifier<$valueType>',
              '\$StreamProvider<$valueType>',
            ];
          case SupportedCreatedType.value:
            modifiers = ['\$Provider<$valueType>'];
        }

        final mixins = modifiers.isEmpty ? '' : ' with ${modifiers.join(', ')}';

        buffer.writeln('''
${provider.doc} final class $name$_genericsDefinition
    extends \$FunctionalProvider<
        $exposedType,
        $createdType
      >
    $mixins {
''');

      case ClassBasedProviderDeclaration():
        final notifierType = '${provider.name}$_generics';

        final String baseClass;

        switch (provider.createdType) {
          case SupportedCreatedType.future:
            baseClass = '\$AsyncNotifierProvider<$notifierType, $valueType>';
          case SupportedCreatedType.stream:
            baseClass = '\$StreamNotifierProvider<$notifierType, $valueType>';
          case SupportedCreatedType.value:
            baseClass = '\$NotifierProvider<$notifierType, $valueType>';
        }

        buffer.writeln(
          '${provider.doc} final class $name$_genericsDefinition extends $baseClass {',
        );
    }

    _writeMembers(buffer);

    buffer.writeln('}');
  }

  void _writeConstructor(StringBuffer buffer) {
    final superParameters = [
      if (!provider.providerElement.isFamily) 'from: null,',
      if (provider.parameters.isEmpty) 'argument: null,',
    ].join();

    final constructorParameters = [
      if (provider.providerElement.isFamily)
        'required ${provider.familyTypeName} super.from',
      if (provider.parameters.isNotEmpty)
        'required $_argumentRecordType super.argument',
    ];
    final params = constructorParameters.isEmpty
        ? ''
        : '{${constructorParameters.join(',')}}';

    buffer.writeln('''
  ${provider.doc} const ${provider.providerTypeName}._($params): super(
        $superParameters
        retry: ${provider.annotation.retryNode?.name ?? 'null'},
        name: r'${provider.providerName(options)}',
        isAutoDispose: ${!provider.annotation.element.keepAlive},
        dependencies: ${!provider.providerElement.isFamily ? provider.dependencies(options) : 'null'},
        \$allTransitiveDependencies: ${!provider.providerElement.isFamily ? provider.allTransitiveDependencies(allTransitiveDependencies) : 'null'},
      );
''');
  }

  void _writeDependencies(StringBuffer buffer) {
    final allTransitiveDependencies = this.allTransitiveDependencies;
    if (allTransitiveDependencies == null) return;

    for (final (index, transitiveDependency)
        in allTransitiveDependencies.indexed) {
      buffer.writeln(
        'static const \$allTransitiveDependencies$index = $transitiveDependency;',
      );
    }

    buffer.writeln();
  }

  void _writeMembers(StringBuffer buffer) {
    _writeConstructor(buffer);
    _writeDependencies(buffer);

    buffer.writeln('''
  @override
  String debugGetCreateSourceHash() => ${provider.hashFnName}();
''');

    _writeToString(buffer);

    switch (provider) {
      case FunctionalProviderDeclaration():
        buffer.writeln('''
  @\$internal
  @override
  ${provider.internalElementName}<${provider.valueTypeDisplayString}> \$createElement(
    \$ProviderPointer pointer
  ) => ${provider.internalElementName}(pointer);
''');

        _writeFunctionalCreate(buffer);

      case ClassBasedProviderDeclaration(:final mutations):
        final notifierType = '${provider.name}$_generics';

        buffer.writeln('''
  @\$internal
  @override
  $notifierType create() => $notifierType();
''');

        _classCreateElement(mutations, buffer, notifierType);

        for (final mutation in mutations) {
          buffer.writeln('''
  ProviderListenable<${mutation.generatedMutationInterfaceName}> get ${mutation.name}
    => \$LazyProxyListenable<${mutation.generatedMutationInterfaceName}, ${provider.exposedTypeDisplayString}>(
      this,
      (element) {
        element as ${provider.generatedElementName}$_generics;

        return element.${mutation.elementFieldName};
      },
    );
        ''');
        }
    }

    _writeCaptureGenerics(buffer);
    _writeOverrideWithValue(buffer);

    _writeEqual(buffer);
  }

  void _writeOverrideWithValue(StringBuffer buffer) {
    if (provider.createdType != SupportedCreatedType.value) return;

    buffer.writeln('''
  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(${provider.exposedTypeDisplayString} value) {
    return \$ProviderOverride(
      origin: this,
      providerOverride: \$ValueProvider<${provider.exposedTypeDisplayString}>(value),
    );
  }
''');
  }

  void _classCreateElement(
    List<Mutation> mutations,
    StringBuffer buffer,
    String notifierType,
  ) {
    if (mutations.isEmpty) {
      buffer.writeln('''
  @\$internal
  @override
  ${provider.internalElementName}<$notifierType, ${provider.valueTypeDisplayString}> \$createElement(
    \$ProviderPointer pointer
  ) => ${provider.internalElementName}(pointer);
''');

      return;
    }

    buffer.writeln('''
  @\$internal
  @override
  ${provider.generatedElementName}$_generics \$createElement(
    \$ProviderPointer pointer
  ) => ${provider.generatedElementName}(pointer);
''');
  }

  void _writeFunctionalCreate(StringBuffer buffer) {
    buffer.write('''
  @override
  ${provider.createdTypeDisplayString} create(Ref ref) {
''');

    switch (provider.parameters) {
      case []:
        buffer.writeln('return ${provider.name}$_generics(ref);');
      case [...]:
        final paramsPassThrough = buildParamInvocationQuery({
          for (final (index, parameter) in provider.parameters.indexed)
            if (provider.parameters.length == 1)
              parameter: 'argument'
            else if (parameter.isPositional)
              parameter: 'argument.\$${index + 1}'
            else
              parameter: 'argument.${parameter.name!.lexeme}',
        });

        buffer.writeln('''
        final argument = this.argument${provider.argumentCast};
        return ${provider.name}$_generics(ref, $paramsPassThrough);
      ''');
    }

    buffer.writeln('}');
  }

  void _writeEqual(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    buffer.writeln('''
  @override
  bool operator ==(Object other) {
    return ${[
      'other is ${provider.providerTypeName}',
      // If there are type parameters, check the runtimeType to check them too.
      if (provider.typeParameters?.typeParameters.isNotEmpty ?? false)
        'other.runtimeType == runtimeType',
      'other.argument == argument',
    ].join(' && ')};
  }

  @override
  int get hashCode {
    return ${switch (provider.typeParameters?.typeParameters ?? []) {
      [] => 'argument.hashCode',
      [_, ...] => 'Object.hash(runtimeType, argument)',
    }};
  }
''');
  }

  void _writeToString(StringBuffer buffer) {
    if (!provider.providerElement.isFamily) return;

    final encodedGenerics = provider.typeParameters?.typeParameters.isEmpty ??
            true
        ? ''
        : '<${provider.typeParameters!.typeParameters.map((e) => '\${${e.name}}').join(', ')}>';

    buffer.writeln('''
@override
String toString() {
  return r'${provider.providerName(options)}'
    '$encodedGenerics'
    '${switch (provider.parameters) {
      [] => '()',
      [_] => r'($argument)',
      // Calling toString on a record, do we don't add the () to avoid `provider((...))`
      [_, ...] => r'$argument',
    }}';
}
''');
  }

  void _writeCaptureGenerics(StringBuffer buffer) {
    if (_generics.isEmpty) return;

    buffer.writeln('''
\$R _captureGenerics<\$R>(
  \$R Function$_genericsDefinition() cb
) {
  return cb$_generics();
}
''');
  }
}
