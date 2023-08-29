import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'class_based_provider.dart';
import 'parameters.dart';
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
    required this.refType,
    required this.elementType,
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

  factory FamilyTemplate.functional(
    FunctionalProviderDeclaration provider, {
    required String hashFn,
    required BuildYamlOptions options,
  }) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}Provider';
    var refType = '${leading}ProviderRef';
    var elementType = '${leading}ProviderElement';
    var createdType = provider.createdType.toString();

    final returnType = provider.createdType;
    if (!returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = '${leading}FutureProvider';
        refType = '${leading}FutureProviderRef';
        elementType = '${leading}FutureProviderElement';
        // Always use FutureOr<T> in overrideWith as return value
        // or otherwise we get a compilation error.
        createdType = 'FutureOr<${provider.valueType}>';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamProvider';
        refType = '${leading}StreamProviderRef';
        elementType = '${leading}StreamProviderElement';
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
      elementType: elementType,
      refType: refType,
      providerGenerics: '<${provider.valueType}>',
      providerCreate:
          '(ref) => ${provider.name}$typeParametersUsage(ref as ${provider._refImplName}$typeParametersUsage, $parametersPassThrough)',
      providerType: providerType,
      parametersPassThrough: parametersPassThrough,
      providerOther: '''

  @override
  Override overrideWith(
    $createdType Function(${provider._refImplName} provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ${provider._providerImplName}._internal(
        (ref) => create(ref as ${provider._refImplName}),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
${parameters.map((e) => '        ${e.name}: ${e.name},\n').join()}
      ),
    );
  }
''',
    );
  }

  factory FamilyTemplate.classBased(
    ClassBasedProviderDeclaration provider, {
    required String notifierTypedefName,
    required String hashFn,
    required BuildYamlOptions options,
  }) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}NotifierProviderImpl';
    var refType = '${leading}NotifierProviderRef';
    var notifierBaseType = 'Buildless${leading}Notifier';
    var elementType = '${leading}NotifierProviderElement';

    final returnType = provider.createdType;
    if (!returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = '${leading}AsyncNotifierProviderImpl';
        refType = '${leading}AsyncNotifierProviderRef';
        notifierBaseType = 'Buildless${leading}AsyncNotifier';
        elementType = '${leading}AsyncNotifierProviderElement';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamNotifierProviderImpl';
        refType = '${leading}StreamNotifierProviderRef';
        notifierBaseType = 'Buildless${leading}StreamNotifier';
        elementType = '${leading}StreamNotifierProviderElement';
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
      elementType: elementType,
      refType: refType,
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

  @override
  Override overrideWith(${provider.name} Function() create) {
    return ProviderOverride(
      origin: this,
      override: ${provider._providerImplName}._internal(
        () => create()$cascadePropertyInit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
${parameters.map((e) => '        ${e.name}: ${e.name},\n').join()}
      ),
    );
  }
''',
    );
  }

  final GeneratorProviderDeclaration provider;
  final List<ParameterElement> parameters;
  final TypeParameterList? typeParameters;
  final BuildYamlOptions options;
  final String refType;
  final String elementType;
  final String providerType;
  final String providerGenerics;
  final String providerCreate;
  final String other;
  final String providerOther;
  final String parametersPassThrough;
  final String hashFn;

  @override
  void run(StringBuffer buffer) {
    final providerTypeNameImpl = provider._providerImplName;
    final refNameImpl = provider._refImplName;
    final elementNameImpl = '_${providerTypeNameImpl.public}Element';
    final familyName = '${provider.providerElement.name.titled}Family';

    final parameterDefinition = buildParamDefinitionQuery(parameters);
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
    return $providerTypeNameImpl$typeParametersUsage($parametersPassThrough);
  }

  @override
  $providerTypeNameImpl$anyTypeParametersUsage getProviderOverride(
    covariant $providerTypeNameImpl$anyTypeParametersUsage provider,
  ) {
    return call($parameterProviderPassThrough);
  }

  static $dependenciesKeyword _dependencies = ${serializeDependencies(provider.providerElement.annotation, options)};

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static $dependenciesKeyword _allTransitiveDependencies = ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)};

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'$providerName';
}

$docs
class $providerTypeNameImpl$typeParametersDefinition extends $providerType$providerGenerics {
  $docs
  $providerTypeNameImpl($parameterDefinition) : this._internal(
          $providerCreate,
          from: $providerName,
          name: r'$providerName',
          debugGetCreateSourceHash: $hashFn,
          dependencies: $familyName._dependencies,
          allTransitiveDependencies: $familyName._allTransitiveDependencies,
          ${parameters.map((e) => '${e.name}: ${e.name},\n').join()}
        );

  $providerTypeNameImpl._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    ${buildParamDefinitionQuery(
      parameters,
      asThisParameter: true,
      writeBrackets: false,
      asRequiredNamed: true,
    )}
  }) : super.internal();

${parameters.map((e) => 'final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

$providerOther

  @override
  $elementType$providerGenerics createElement() {
    return $elementNameImpl(this);
  }

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
}

mixin $refNameImpl on $refType<${provider.valueType}> {
  ${parameters.map((e) {
      return '''
/// The parameter `${e.name}` of this provider.
${e.type} get ${e.name};''';
    }).join()}
}

class $elementNameImpl extends $elementType$providerGenerics with $refNameImpl {
  $elementNameImpl(super.provider);

${parameters.map((e) => '@override ${e.type} get ${e.name} => (origin as $providerTypeNameImpl).${e.name};').join()}
}
''');
  }
}

extension on GeneratorProviderDeclaration {
  String get _providerImplName => '${providerElement.name.titled}Provider';

  String get _refImplName => '${providerElement.name.titled}Ref';
}
