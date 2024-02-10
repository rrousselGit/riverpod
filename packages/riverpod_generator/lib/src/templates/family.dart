import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import '../validation.dart';
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
    required this.createType,
    required this.overrideCreate,
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
    var createdType = provider.createdTypeDisplayString;

    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = '${leading}FutureProvider';
        refType = '${leading}FutureProviderRef';
        elementType = '${leading}FutureProviderElement';
        // Always use FutureOr<T> in overrideWith as return value
        // or otherwise we get a compilation error.
        createdType = 'FutureOr<${provider.valueTypeDisplayString}>';
      } else if (returnType.isDartAsyncStream) {
        providerType = '${leading}StreamProvider';
        refType = '${leading}StreamProviderRef';
        elementType = '${leading}StreamProviderElement';
      }
    }

    final parameters = provider.node.functionExpression.parameters!.parameters
        .skip(1)
        .toList();

    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name!.lexeme,
    });

    final typeParameters = provider.node.functionExpression.typeParameters;
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
      providerGenerics: '<${provider.valueTypeDisplayString}>',
      providerCreate:
          '(ref) => ${provider.name}$typeParametersUsage(ref as ${provider._refImplName}$typeParametersUsage, $parametersPassThrough)',
      providerType: providerType,
      parametersPassThrough: parametersPassThrough,
      createType:
          '${provider.createdTypeDisplayString} Function$typeParametersDefinition(${provider._refImplName} ref)',
      overrideCreate: '(ref) => create(ref as ${provider._refImplName})',
      providerOther: '''

  @override
  Override overrideWith(
    $createdType Function(${provider._refImplName}$typeParametersUsage ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ${provider._providerImplName}$typeParametersUsage._internal(
        (ref) => create(ref as ${provider._refImplName}$typeParametersUsage),
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
    validateClassBasedProvider(provider);

    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    var providerType = '${leading}NotifierProviderImpl';
    var refType = '${leading}NotifierProviderRef';
    var notifierBaseType = 'Buildless${leading}Notifier';
    var elementType = '${leading}NotifierProviderElement';

    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
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

    final parameters =
        provider.buildMethod.parameters!.parameters.whereNotNull().toList();
    final parameterDefinition = buildParamDefinitionQuery(parameters);
    final cascadePropertyInit =
        parameters.map((e) => '..${e.name} = ${e.name}').join('\n');

    final parametersPassThrough = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name!.lexeme,
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
          '<${provider.name}$typeParametersUsage, ${provider.valueTypeDisplayString}>',
      providerType: providerType,
      providerCreate: parameters.isEmpty
          // If the provider has no arguments (and therefore only generics),
          // use tear-off constructor
          ? '${provider.name.lexeme}$typeParametersUsage.new'
          : '() => ${provider.name}$typeParametersUsage()$cascadePropertyInit',
      parametersPassThrough: parametersPassThrough,
      createType: '${provider.name} Function()',
      overrideCreate: '() => create()$cascadePropertyInit',
      other: '''
abstract class $notifierTypedefName$typeParametersDefinition extends $notifierBaseType<${provider.valueTypeDisplayString}> {
  ${parameters.map((e) => 'late final ${e.typeDisplayString} ${e.name};').join('\n')}

  ${provider.createdTypeDisplayString} build($parameterDefinition);
}
''',
      providerOther: '''
  @override
  ${provider.createdTypeDisplayString} runNotifierBuild(
    covariant ${provider.name}$typeParametersUsage notifier,
  ) {
    return notifier.build($parametersPassThrough);
  }

  @override
  Override overrideWith(${provider.name}$typeParametersUsage Function() create) {
    return ProviderOverride(
      origin: this,
      override: ${provider._providerImplName}$typeParametersUsage._internal(
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
  final List<FormalParameter> parameters;
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
  final String createType;
  final String overrideCreate;

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
    final parameterThisNamedPassThrough = parameters
        .map((parameter) => '${parameter.name}: ${parameter.name},')
        .join();

    final docs = providerDocFor(provider.providerElement.element);
    final meta = metaAnnotations(provider.node.metadata);
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
    final argumentRecordType = buildParamDefinitionQuery(
      parameters,
      asRecord: true,
    );
    final argumentsToRecord = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name!.lexeme,
    });

    final familyOverrideClassName =
        '_\$${provider.name.lexeme.titled.public}FamilyOverride';

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
$meta
const $providerName = $familyName();

$docs
class $familyName extends Family {
  $docs
  const $familyName();

  static $dependenciesKeyword _dependencies = ${serializeDependencies(provider.providerElement.annotation, options)};

  static $dependenciesKeyword _allTransitiveDependencies = ${serializeAllTransitiveDependencies(provider.providerElement.annotation, options)};

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'$providerName';

  $docs
  $providerTypeNameImpl$typeParametersUsage call$typeParametersDefinition($parameterDefinition) {
    return $providerTypeNameImpl$typeParametersUsage($parametersPassThrough);
  }

  @visibleForOverriding
  @override
  $providerTypeNameImpl$anyTypeParametersUsage getProviderOverride(
    covariant $providerTypeNameImpl$anyTypeParametersUsage provider,
  ) {
    return call($parameterProviderPassThrough);
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith($createType create) {
    return $familyOverrideClassName(this, create);
  }
}

class $familyOverrideClassName implements FamilyOverride {
  $familyOverrideClassName(this.overriddenFamily, this.create);

  final $createType create;

  @override
  final $familyName overriddenFamily;

  @override
  $providerTypeNameImpl getProviderOverride(
    covariant $providerTypeNameImpl provider,
  ) {
    return provider._copyWith(create);
  }
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
    super.create, {
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

${parameters.map((e) => 'final ${e.typeDisplayString} ${e.name};').join()}

$providerOther

  @override
  ($argumentRecordType) get argument {
    return ($argumentsToRecord);
  }

  @override
  $elementType$providerGenerics createElement() {
    return $elementNameImpl(this);
  }

  $providerTypeNameImpl _copyWith(
    $createType create,
  ) {
    return $providerTypeNameImpl._internal(
      $overrideCreate,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      $parameterThisNamedPassThrough
    );
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
      ...?typeParameters?.typeParameters.map((e) => e.name),
    ].map((e) => 'hash = _SystemHash.combine(hash, $e.hashCode);').join()}

    return _SystemHash.finish(hash);
  }
}

mixin $refNameImpl$typeParametersDefinition on $refType<${provider.valueTypeDisplayString}> {
  ${parameters.map((e) {
      return '''
/// The parameter `${e.name}` of this provider.
${e.typeDisplayString} get ${e.name};''';
    }).join()}
}

class $elementNameImpl$typeParametersDefinition extends $elementType$providerGenerics with $refNameImpl$typeParametersUsage {
  $elementNameImpl(super.provider);

${parameters.map((e) => '@override ${e.typeDisplayString} get ${e.name} => (origin as $providerTypeNameImpl$typeParametersUsage).${e.name};').join()}
}
''');
  }
}

extension on GeneratorProviderDeclaration {
  String get _providerImplName => '${providerElement.name.titled}Provider';

  String get _refImplName => '${providerElement.name.titled}Ref';
}
