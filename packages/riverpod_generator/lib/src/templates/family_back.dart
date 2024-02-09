import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import '../type.dart';
import 'class_based_provider.dart';
import 'parameters.dart';
import 'template.dart';

String providerFamilyNameFor(
  ProviderDeclarationElement provider,
  BuildYamlOptions options,
) {
  return '${provider.name.lowerFirst}${options.providerFamilyNameSuffix ?? options.providerNameSuffix ?? 'Provider'}';
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
    var providerType = 'Provider';
    var refType = 'Ref<${provider.valueTypeDisplayString}>';
    var elementType = 'ProviderElement';

    final returnType = provider.createdTypeNode?.type;
    if (returnType != null && !returnType.isRaw) {
      if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
        providerType = 'FutureProvider';
        refType = 'Ref<AsyncValue<${provider.valueTypeDisplayString}>>';
        elementType = 'FutureProviderElement';
      } else if (returnType.isDartAsyncStream) {
        providerType = 'StreamProvider';
        refType = 'Ref<AsyncValue<${provider.valueTypeDisplayString}>>';
        elementType = 'StreamProviderElement';
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

    final createType =
        '${provider.createdTypeDisplayString} Function$typeParametersDefinition(${provider.refImplName} ref)';

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
          '(ref) => ${provider.name}$typeParametersUsage(ref as ${provider.refImplName}$typeParametersUsage, $parametersPassThrough)',
      providerType: providerType,
      parametersPassThrough: parametersPassThrough,
      createType: createType,
      overrideCreate: '(ref) => create(ref as ${provider.refImplName})',
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

  @internal
  @override
  $providerType copyWithBuild(
    ${provider.name} Function() create,
  ) {
    return $providerType._internal(
      create,
      ${parameters.map((e) => '${e.name}: ${e.name},\n').join()}
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
    final isAutoDispose = !provider.providerElement.annotation.keepAlive;

    final providerTypeNameImpl = provider.providerTypeName;
    final refNameImpl = provider.refImplName;
    final elementNameImpl = '_${providerTypeNameImpl.public}Element';
    final familyName = provider.familyTypeName;

    final parameterDefinition = buildParamDefinitionQuery(parameters);

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
    final argumentRecordType = buildParamDefinitionQuery(
      parameters,
      asRecord: true,
    );
    final argumentsToRecord = buildParamInvocationQuery({
      for (final parameter in parameters) parameter: parameter.name!.lexeme,
    });

    // TODO changelog updated to support createElement prototype change
    // TODO changelog toString()
    // TODO handle generics with $ in their name

    final encodedProviderName = providerName.encoded;
    final encodedGenerics = typeParameters == null
        ? ''
        : '<${typeParameters!.typeParameters.map((e) => '\$${e.name.lexeme.encoded}').join(',')}>';

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
$meta
const $providerName = $familyName();

$docs
final class $familyName extends Family {
  $docs
  const $familyName()
    : super(
        name: r'$providerName',
        dependencies: _dependencies,
        allTransitiveDependencies: _allTransitiveDependencies,
        debugGetCreateSourceHash: $hashFn,
        ${isAutoDispose ? 'isAutoDispose: true,' : ''}
      );

  static $dependenciesKeyword _dependencies = ${provider.dependencies(options)};

  static $dependenciesKeyword _allTransitiveDependencies = ${null};

  $docs
  $providerTypeNameImpl$typeParametersUsage call$typeParametersDefinition($parameterDefinition) {
    return $providerTypeNameImpl$typeParametersUsage($parametersPassThrough);
  }

  @override
  String toString() => '$encodedProviderName';
}

$docs
final class $providerTypeNameImpl$typeParametersDefinition extends $providerType$providerGenerics {
  $docs
  $providerTypeNameImpl($parameterDefinition) : this._internal(
          $providerCreate,
          argument: ($argumentsToRecord),
        );

  $providerTypeNameImpl._internal(
    super.create, {
      required ($argumentRecordType) super.argument,
   }) : super.internal(
          debugGetCreateSourceHash: $hashFn,
          from: $providerName,
          name: r'$providerName',
          isAutoDispose: $isAutoDispose,
          dependencies: null,
          allTransitiveDependencies: null,
       );

$providerOther

  @override
  $elementNameImpl$typeParametersUsage createElement(ProviderContainer container,) {
    return $elementNameImpl(this, container);
  }

  @internal
  @override
  $providerTypeNameImpl copyWithCreate(
    $createType create,
  ) {
    return $providerTypeNameImpl._internal(
      $overrideCreate,
      argument: argument as ($argumentRecordType),
    );
  }

  @override
  bool operator ==(Object other) {
    return ${[
      'other is $providerTypeNameImpl',
      // If there are type parameters, check the runtimeType to check them too.
      if (typeParameters?.typeParameters.isNotEmpty ?? false)
        'other.runtimeType == runtimeType',
      'other.argument == argument',
    ].join(' && ')};
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => '$encodedProviderName$encodedGenerics\$argument';
}

mixin $refNameImpl$typeParametersDefinition on $refType {
  ${parameters.map((e) {
      return '''
/// The parameter `${e.name}` of this provider.
${e.typeDisplayString} get ${e.name};''';
    }).join()}
}

class $elementNameImpl$typeParametersDefinition extends $elementType$providerGenerics with $refNameImpl$typeParametersUsage {
  $elementNameImpl(super.provider, super.container);

${parameters.map((e) => '@override ${e.typeDisplayString} get ${e.name} => (origin as $providerTypeNameImpl$typeParametersUsage).${e.name};').join()}
}
''');
  }
}
