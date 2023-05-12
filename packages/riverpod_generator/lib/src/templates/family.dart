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

class FamilyTemplate extends Template {
  FamilyTemplate._(
    this.provider, {
    required this.options,
    required this.parameters,
    required this.providerType,
    required this.providerGenerics,
    required this.providerCreate,
    required this.parametersPassThrough,
    required this.hashFn,
    this.other = '',
    this.providerOther = '',
  }) {
    if (parameters.isEmpty) {
      throw ArgumentError.value(
        parameters,
        'provider',
        'Expected a provider with parameters',
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

    return FamilyTemplate._(
      provider,
      options: options,
      parameters: parameters,
      hashFn: hashFn,
      providerGenerics: '<${provider.valueType}>',
      providerCreate: '(ref) => ${provider.name}(ref, $parametersPassThrough)',
      providerType: providerType,
      parametersPassThrough: parametersPassThrough,
      other: '''
typedef $refName = ${providerType}Ref<${provider.valueType}>;
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

    return FamilyTemplate._(
      provider,
      options: options,
      parameters: parameters,
      hashFn: hashFn,
      providerGenerics: '<${provider.name}, ${provider.valueType}>',
      providerType: providerType,
      providerCreate: '() => ${provider.name}()$cascadePropertyInit',
      parametersPassThrough: parametersPassThrough,
      other: '''
abstract class $notifierTypedefName extends $notifierBaseType<${provider.valueType}> {
  ${parameters.map((e) => 'late final ${e.type} ${e.name};').join('\n')}

  ${provider.createdType} build($parameterDefinition);
}
''',
      providerOther: '''
  @override
  ${provider.createdType} runNotifierBuild(
    covariant ${provider.name} notifier,
  ) {
    return notifier.build($parametersPassThrough);
  }
''',
    );
  }

  final GeneratorProviderDeclaration provider;
  final List<ParameterElement> parameters;
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

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
const $providerName = $familyName();

$docs
class $familyName extends Family<${provider.exposedType}> {
  $docs
  const $familyName();

  $docs
  $providerTypeNameImpl call($parameterDefinition) {
    return $providerTypeNameImpl($parametersPassThrough);
  }

  @override
  $providerTypeNameImpl getProviderOverride(
    covariant $providerTypeNameImpl provider,
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
class $providerTypeNameImpl extends $providerType$providerGenerics {
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
      ...parameters.map((e) => 'other.${e.name} == ${e.name}')
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
${parameters.map((e) => 'hash = _SystemHash.combine(hash, ${e.name}.hashCode);').join()}

    return _SystemHash.finish(hash);
  }
$providerOther
}
''');
  }
}
