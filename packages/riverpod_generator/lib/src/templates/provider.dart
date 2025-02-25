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
        'required ${provider.familyTypeName} super.from,',
      if (provider.parameters.isNotEmpty)
        'required $_argumentRecordType super.argument,',
      if (provider is ClassBasedProviderDeclaration)
        'super.runNotifierBuildOverride,',
    ].join();

    buffer.writeln('''
  ${provider.doc} const ${provider.providerTypeName}._({
    $constructorParameters
    ${provider.createType()}? create
  }): _createCb = create,
      super(
        $superParameters
        retry: ${provider.annotation.retryNode?.name ?? 'null'},
        name: r'${provider.providerName(options)}',
        isAutoDispose: ${!provider.annotation.element.keepAlive},
        dependencies: ${!provider.providerElement.isFamily ? provider.dependencies(options) : 'null'},
        allTransitiveDependencies: ${!provider.providerElement.isFamily ? provider.allTransitiveDependencies(allTransitiveDependencies) : 'null'},
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
  final ${provider.createType()}? _createCb;

  @override
  String debugGetCreateSourceHash() => ${provider.hashFnName}();
''');

    final copyParameters = [
      if (provider.parameters.isNotEmpty)
        'argument: argument${provider.argumentCast},',
      if (provider.providerElement.isFamily)
        'from: from! as ${provider.familyTypeName},',
    ].join();

    _writeGenericCopyWith(buffer, copyParameters: copyParameters);
    _writeToString(buffer);
    _writeOverrideWithValue(buffer);

    switch (provider) {
      case FunctionalProviderDeclaration():
        final createParams = buildParamDefinitionQuery(provider.parameters);
        final createFn = provider.parameters.isEmpty
            ? 'create'
            : '(ref, $createParams) => create(ref)';

        buffer.writeln('''
  @\$internal
  @override
  ${provider.internalElementName}<${provider.valueTypeDisplayString}> \$createElement(
    \$ProviderPointer pointer
  ) => ${provider.internalElementName}(this, pointer);

  @override
  ${provider.providerTypeName}$_generics \$copyWithCreate(
    ${provider.createType(withArguments: false)} create,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      create: $createFn
    );
  }
''');

        _writeFunctionalCreate(buffer);

      case ClassBasedProviderDeclaration(:final mutations):
        final notifierType = '${provider.name}$_generics';

        buffer.writeln('''
  @\$internal
  @override
  $notifierType create() => _createCb?.call() ?? $notifierType();

  @\$internal
  @override
  ${provider.providerTypeName}$_generics \$copyWithCreate(
    $notifierType Function() create,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      create: create
    );
  }

  @\$internal
  @override
  ${provider.providerTypeName}$_generics \$copyWithBuild(
    ${provider.notifierBuildType()} build,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      runNotifierBuildOverride: build
    );
  }
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

    _writeEqual(buffer);
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
  ) => ${provider.internalElementName}(this, pointer);
''');

      return;
    }

    buffer.writeln('''
  @\$internal
  @override
  ${provider.generatedElementName}$_generics \$createElement(
    \$ProviderPointer pointer
  ) => ${provider.generatedElementName}(this, pointer);
''');
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

  void _writeGenericCopyWith(
    StringBuffer buffer, {
    required String copyParameters,
  }) {
    if (provider.typeParameters?.typeParameters.isEmpty ?? true) return;

    buffer.writeln('''
    ${provider.providerTypeName}$_generics _copyWithCreate(
      ${provider.createType(withGenericDefinition: true)} create,
    ) {
      return ${provider.providerTypeName}$_generics._(
        $copyParameters
        create: create$_generics
      );
    }
    ''');

    if (provider is ClassBasedProviderDeclaration) {
      buffer.writeln('''
    ${provider.providerTypeName}$_generics _copyWithBuild(
      ${provider.notifierBuildType(withGenericDefinition: true)} build,
    ) {
      return ${provider.providerTypeName}$_generics._(
        $copyParameters
        runNotifierBuildOverride: build$_generics
      );
    }
    ''');
    }
  }

  void _writeFunctionalCreate(StringBuffer buffer) {
    buffer.write('''
  @override
  ${provider.createdTypeDisplayString} create(Ref ref) {
    final _\$cb = _createCb ?? ${provider.name}$_generics;
''');

    switch (provider.parameters) {
      case []:
        buffer.writeln(r'return _$cb(ref);');
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
        return _\$cb(ref, $paramsPassThrough);
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
}
