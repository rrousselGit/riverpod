import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../type.dart';
import 'family_back.dart';
import 'parameters.dart';
import 'template.dart';

class ProviderTemplate extends Template {
  ProviderTemplate(this.provider);

  final GeneratorProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    final provider = this.provider;
    final generics = provider.generics();
    final genericsDefinition = provider.genericsDefinition();

    final name = provider.providerTypeName;
    final exposedType = provider.exposedTypeDisplayString;
    final createdType = provider.createdTypeDisplayString;
    final valueType = provider.valueTypeDisplayString;
    final refType = switch (provider) {
      FunctionalProviderDeclaration() => '${provider.refImplName}$generics',
      ClassBasedProviderDeclaration() => 'Ref<$exposedType>',
    };

    switch (provider) {
      case FunctionalProviderDeclaration():
        final List<String> modifiers;

        switch (provider.createdType) {
          case SupportedCreatedType.future:
            modifiers = [
              '\$FutureModifier<$valueType>',
              '\$FutureProvider<$valueType, $refType>',
            ];
          case SupportedCreatedType.stream:
            modifiers = [
              '\$FutureModifier<$valueType>',
              '\$StreamProvider<$valueType, $refType>',
            ];
          case SupportedCreatedType.value:
            modifiers = [];
        }

        final mixins = modifiers.isEmpty ? '' : ' with ${modifiers.join(', ')}';

        buffer.writeln('''
final class $name$genericsDefinition
    extends \$FunctionalProvider<
        $exposedType,
        $createdType,
        $refType
      >
    $mixins {
''');

      case ClassBasedProviderDeclaration():
        final notifierType = '${provider.name}$generics';

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
          'final class $name$genericsDefinition extends $baseClass {',
        );
    }

    _writeMembers(buffer);

    buffer.writeln('}');
  }

  void _writeMembers(StringBuffer buffer) {
    final provider = this.provider;
    final generics = provider.generics();

    final providerParameters = provider.parameters;

    final superParameters = [
      if (!provider.providerElement.isFamily) 'from: null,',
      if (providerParameters.isEmpty) 'argument: null,',
    ].join();

    final argumentRecordType = buildParamDefinitionQuery(
      provider.parameters,
      asRecord: true,
    );

    final constructorParameters = [
      if (provider.providerElement.isFamily)
        'required ${provider.familyTypeName} super.from,',
      if (providerParameters.isNotEmpty)
        'required ($argumentRecordType) super.argument,',
    ].join();

    final localArgumentDefinition = provider.parameters.isNotEmpty
        ? 'final ($argumentRecordType) argument = this.argument! as ($argumentRecordType);'
        : '';
    final paramsPassThrough = buildParamInvocationQuery({
      for (final (index, parameter) in provider.parameters.indexed)
        if (parameter.isPositional)
          parameter: 'argument.\$${index + 1}'
        else
          parameter: 'argument.${parameter.name!.lexeme}',
    });

    buffer.writeln('''
  const ${provider.providerTypeName}._({
    ${provider.createType()}? create,
    $constructorParameters
  }): _createCb = create,
      super(
        debugGetCreateSourceHash: ${provider.hashFnName},
        name: r'${provider.name}',
        isAutoDispose: ${!provider.annotation.element.keepAlive},
        dependencies: null,
        allTransitiveDependencies: null,
        $superParameters
      );

  final ${provider.createType()}? _createCb;
''');

    switch (provider) {
      case FunctionalProviderDeclaration():
        final parameters = [
          if (providerParameters.isNotEmpty)
            'argument: argument! as ($argumentRecordType),',
          if (provider.providerElement.isFamily)
            'from: from! as ${provider.familyTypeName},',
        ].join();

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
  ${provider.createdTypeDisplayString} create(${provider.refImplName}$generics ref){
    final fn = _createCb ?? ${provider.name}$generics;
    $localArgumentDefinition
    return fn(ref, $paramsPassThrough);
  }''');

        buffer.writeln('''
  @override
  ${provider.providerTypeName}$generics copyWithCreate(
    ${provider.createType(withArguments: false)} create,
  ) {
    return ${provider.providerTypeName}$generics._(
      create: $createFn,
      $parameters
    );
  }
''');
      case ClassBasedProviderDeclaration():
        buffer.writeln('''
  @override
  ${provider.elementName}<${provider.name}$generics, ${provider.valueTypeDisplayString}> createElement(
    ProviderContainer container
  ) => ${provider.elementName}(this, container);
''');
    }

    if (provider.providerElement.isFamily) {
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
}
