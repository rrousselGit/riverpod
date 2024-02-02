import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../type.dart';
import 'family_back.dart';
import 'parameters.dart';
import 'template.dart';

class ProviderTemplate extends Template {
  ProviderTemplate(this.provider, this.options);

  final GeneratorProviderDeclaration provider;
  final BuildYamlOptions options;

  late final _argumentRecordType = buildParamDefinitionQuery(
    provider.parameters,
    asRecord: true,
  );

  late final _generics = provider.generics();
  late final _genericsDefinition = provider.genericsDefinition();

  late final _refType = switch (provider) {
    FunctionalProviderDeclaration() => '${provider.refImplName}$_generics',
    ClassBasedProviderDeclaration() =>
      'Ref<${provider.exposedTypeDisplayString}>',
  };

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
              '\$FutureProvider<$valueType, $_refType>',
            ];
          case SupportedCreatedType.stream:
            modifiers = [
              '\$FutureModifier<$valueType>',
              '\$StreamProvider<$valueType, $_refType>',
            ];
          case SupportedCreatedType.value:
            modifiers = ['\$Provider<$valueType, $_refType>'];
        }

        final mixins = modifiers.isEmpty ? '' : ' with ${modifiers.join(', ')}';

        buffer.writeln('''
final class $name$_genericsDefinition
    extends \$FunctionalProvider<
        $exposedType,
        $createdType,
        $_refType
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
          'final class $name$_genericsDefinition extends $baseClass {',
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
        'required ($_argumentRecordType) super.argument,',
      if (provider is ClassBasedProviderDeclaration)
        'super.runNotifierBuildOverride,',
    ].join();

    buffer.writeln('''
  const ${provider.providerTypeName}._({
    $constructorParameters
    ${provider.createType()}? create
  }): _createCb = create,
      super(
        $superParameters
        debugGetCreateSourceHash: ${provider.hashFnName},
        name: r'${provider.name}',
        isAutoDispose: ${!provider.annotation.element.keepAlive},
        dependencies: ${!provider.providerElement.isFamily ? provider.dependencies(options) : 'null'},
        allTransitiveDependencies: ${!provider.providerElement.isFamily ? provider.allTransitiveDependencies(options) : 'null'},
      );
''');
  }

  void _writeMembers(StringBuffer buffer) {
    _writeConstructor(buffer);

    buffer.writeln('''
  final ${provider.createType()}? _createCb;
''');

    final localArgumentDefinition = provider.parameters.isNotEmpty
        ? 'final ($_argumentRecordType) argument = this.argument! as ($_argumentRecordType);'
        : '';
    final paramsPassThrough = buildParamInvocationQuery({
      for (final (index, parameter) in provider.parameters.indexed)
        if (parameter.isPositional)
          parameter: 'argument.\$${index + 1}'
        else
          parameter: 'argument.${parameter.name!.lexeme}',
    });

    final copyParameters = [
      if (provider.parameters.isNotEmpty)
        'argument: argument! as ($_argumentRecordType),',
      if (provider.providerElement.isFamily)
        'from: from! as ${provider.familyTypeName},',
    ].join();

    switch (provider) {
      case FunctionalProviderDeclaration():
        final createParams = buildParamDefinitionQuery(provider.parameters);

        final createFn = provider.parameters.isEmpty
            ? 'create'
            : '(ref, $createParams) => create(ref)';

        buffer.writeln('''
  @override
  ${provider.elementName}<${provider.valueTypeDisplayString}> createElement(
    ProviderContainer container
  ) => ${provider.elementName}(this, container);
''');

        buffer.writeln('''
  @override
  ${provider.createdTypeDisplayString} create(${provider.refImplName}$_generics ref){
    final fn = _createCb ?? ${provider.name}$_generics;
    $localArgumentDefinition
    return fn(ref, $paramsPassThrough);
  }''');

        buffer.writeln('''
  @override
  ${provider.providerTypeName}$_generics copyWithCreate(
    ${provider.createType(withArguments: false)} create,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      create: $createFn
    );
  }
''');
      case ClassBasedProviderDeclaration():
        final notifierType = '${provider.name}$_generics';

        buffer.writeln('''
  @\$internal
  @override
  $notifierType create() => _createCb?.call() ?? $notifierType();

  @\$internal
  @override
  ${provider.providerTypeName}$_generics copyWithCreate(
    $notifierType Function() create,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      create: create
    );
  }

  @\$internal
  @override
  ${provider.providerTypeName}$_generics copyWithBuild(
    ${provider.createdTypeDisplayString} Function($_refType, $notifierType) build,
  ) {
    return ${provider.providerTypeName}$_generics._(
      $copyParameters
      runNotifierBuildOverride: build
    );
  }

  @\$internal
  @override
  ${provider.elementName}<$notifierType, ${provider.valueTypeDisplayString}> createElement(
    ProviderContainer container
  ) => ${provider.elementName}(this, container);
''');
    }

    _writeEqual(buffer);
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
    ''');
  }
}
