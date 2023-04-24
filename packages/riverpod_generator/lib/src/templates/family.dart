import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'parameters.dart';
import 'stateful_provider.dart';
import 'template.dart';

String providerFamilyNameFor(
  ProviderDeclarationElement provider,
  BuildYamlOptions options,
) {
  return '${provider.name.lowerFirst}${options.providerFamilyNameSuffix ?? options.providerNameSuffix ?? 'Provider'}';
}

String genericDefinitionDisplayString(TypeParameterList? typeParameters) {
  return typeParameters?.toSource() ?? '';
}

String genericUsageDisplayString(TypeParameterList? typeParameterList) {
  if (typeParameterList == null) {
    return '';
  }

  return '<${typeParameterList.typeParameters.map((e) => e.name.lexeme).join(', ')}>';
}

String anyGenericUsageDisplayString(TypeParameterList? typeParameterList) {
  if (typeParameterList == null) {
    return '';
  }

  return '<${typeParameterList.typeParameters.map((e) => e.declaredElement?.bound?.toString() ?? 'Object?').join(', ')}>';
}

class FamilyTemplate extends Template {
  FamilyTemplate._(
    this.provider, {
    required this.options,
    required this.parameters,
    required this.typeParameters,
    required this.providerType,
    required this.providerGenerics,
    required this.providerCreate,
    required this.parametersPassThrough,
    required this.hashFn,
    this.other = '',
    this.providerOther = '',
  }) {
    if (!provider.providerElement.isFamily) {
      throw ArgumentError.value(
        provider.providerElement.isFamily,
        'provider.providerElement.isFamily',
        'Expected a family provider',
      );
    }
  }

  factory FamilyTemplate.stateless(
    StatelessProviderDeclaration provider, {
    required String refName,
    required String hashFn,
    required BuildYamlOptions options,
  }) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}Provider';

    final returnType = provider.createdType;
    if (!returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = '${leading}FutureProvider';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamProvider';
      }
    }

    final parameters = provider
        .node.functionExpression.parameters!.parameterElements
        .whereNotNull()
        .skip(1)
        .toList();

    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name,
    });

    final typeParameters = provider.node.functionExpression.typeParameters;
    final typeParametersDefinition =
        genericDefinitionDisplayString(typeParameters);
    final typeParametersUsage = genericUsageDisplayString(typeParameters);

    return FamilyTemplate._(
      provider,
      options: options,
      parameters: parameters,
      typeParameters: typeParameters,
      hashFn: hashFn,
      providerGenerics: '<${provider.valueType}>',
      providerCreate:
          '(ref) => ${provider.name}$typeParametersUsage(ref, $parametersPassThrough)',
      providerType: providerType,
      parametersPassThrough: parametersPassThrough,
      other: '''
typedef $refName$typeParametersDefinition = ${providerType}Ref<${provider.valueType}>;
''',
    );
  }

  factory FamilyTemplate.stateful(
    StatefulProviderDeclaration provider, {
    required String notifierTypedefName,
    required String hashFn,
    required BuildYamlOptions options,
  }) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}NotifierProviderImpl';
    var notifierBaseType = 'Buildless${leading}Notifier';

    final returnType = provider.createdType;
    if (!returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = '${leading}AsyncNotifierProviderImpl';
        notifierBaseType = 'Buildless${leading}AsyncNotifier';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamNotifierProviderImpl';
        notifierBaseType = 'Buildless${leading}StreamNotifier';
      }
    }

    final parameters = provider.buildMethod.parameters!.parameterElements
        .whereNotNull()
        .toList();
    final parameterDefinition = buildParamDefinitionQuery(parameters);
    final cascadePropertyInit =
        parameters.map((e) => '..${e.name} = ${e.name}').join('\n');

    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name,
    });

    final typeParameters = provider.node.typeParameters;
    final typeParametersUsage = genericUsageDisplayString(typeParameters);
    final typeParametersDefinition =
        genericDefinitionDisplayString(typeParameters);

    return FamilyTemplate._(
      provider,
      options: options,
      parameters: parameters,
      typeParameters: typeParameters,
      hashFn: hashFn,
      providerGenerics:
          '<${provider.name}$typeParametersUsage, ${provider.valueType}>',
      providerType: providerType,
      providerCreate: parameters.isEmpty
          // If the provider has no arguments (and therefore only generics),
          // use tear-off constructor
          ? '${provider.name.lexeme}$typeParametersUsage.new'
          : '() => ${provider.name}$typeParametersUsage()$cascadePropertyInit',
      parametersPassThrough: parametersPassThrough,
      other: '''
abstract class $notifierTypedefName$typeParametersDefinition extends $notifierBaseType<${provider.valueType}> {
  ${parameters.map((e) => 'late final ${e.type} ${e.name};').join('\n')}

  ${provider.createdType} build($parameterDefinition);
}
''',
      providerOther: '''
  @override
  ${provider.createdType} runNotifierBuild(
    covariant ${provider.name}$typeParametersUsage notifier,
  ) {
    return notifier.build($parametersPassThrough);
  }
''',
    );
  }

  final GeneratorProviderDeclaration provider;
  final List<ParameterElement> parameters;
  final TypeParameterList? typeParameters;
  final BuildYamlOptions options;
  final String providerType;
  final String providerGenerics;
  final String providerCreate;
  final String other;
  final String providerOther;
  final String parametersPassThrough;
  final String hashFn;

  @override
  void run(StringBuffer buffer) {
    final providerTypeNameImpl =
        '${provider.providerElement.name.titled}Provider';
    final familyName = '${provider.providerElement.name.titled}Family';

    final parameterDefinition = buildParamDefinitionQuery(parameters);
    final thisParameterDefinition = buildParamDefinitionQuery(
      parameters,
      asThisParameter: true,
    );
    final parameterProviderPassThrough = buildParamInvocationQuery({
      for (final parameter in parameters)
        parameter: 'provider.${parameter.name}',
    });

    final docs = providerDocFor(provider.providerElement.element);
    final providerName =
        providerFamilyNameFor(provider.providerElement, options);

    final dependenciesKeyword =
        provider.providerElement.annotation.dependencies == null
            ? 'const Iterable<ProviderOrFamily>?'
            : 'final Iterable<ProviderOrFamily>';

    final typeParametersDefinition =
        genericDefinitionDisplayString(typeParameters);
    final typeParametersUsage = genericUsageDisplayString(typeParameters);
    final anyTypeParametersUsage = anyGenericUsageDisplayString(typeParameters);

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
const $providerName = $familyName();

$docs
class $familyName extends Family {
  $docs
  const $familyName();

  $docs
  $providerTypeNameImpl$typeParametersUsage call$typeParametersDefinition($parameterDefinition) {
    return $providerTypeNameImpl($parametersPassThrough);
  }

  @override
  $providerTypeNameImpl$anyTypeParametersUsage getProviderOverride(
    covariant $providerTypeNameImpl$anyTypeParametersUsage provider,
  ) {
    return call($parameterProviderPassThrough);
  }

  static $dependenciesKeyword _dependencies = ${serializeDependencies(provider.providerElement.annotation.dependencies, options)};

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static $dependenciesKeyword _allTransitiveDependencies = ${serializeDependencies(provider.providerElement.annotation.allTransitiveDependencies, options)};

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'$providerName';
}

$docs
class $providerTypeNameImpl$typeParametersDefinition extends $providerType$providerGenerics {
  $docs
  $providerTypeNameImpl($thisParameterDefinition) : super.internal(
          $providerCreate,
          from: $providerName,
          name: r'$providerName',
          debugGetCreateSourceHash: $hashFn,
          dependencies: $familyName._dependencies,
          allTransitiveDependencies: $familyName._allTransitiveDependencies,
        );

${parameters.map((e) => 'final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  @override
  bool operator ==(Object other) {
    return ${[
      'other is $providerTypeNameImpl',
      // If there are type parameters, check the runtimeType to check them too.
      if (typeParameters?.typeParameters.isNotEmpty ?? false)
        'other.runtimeType == runtimeType',
      ...parameters.map((e) => 'other.${e.name} == ${e.name}'),
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
${[
      ...parameters.map((e) => e.name),
      ...?typeParameters?.typeParameters.map((e) => e.name)
    ].map((e) => 'hash = _SystemHash.combine(hash, $e.hashCode);').join()}

    return _SystemHash.finish(hash);
  }
$providerOther
}
''');
  }
}
