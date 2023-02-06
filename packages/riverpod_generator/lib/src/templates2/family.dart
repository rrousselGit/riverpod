import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../models.dart';
import '../riverpod_generator2.dart';
import 'parameters.dart';
import 'template.dart';

class FamilyTemplate extends Template {
  FamilyTemplate._(
    this.provider, {
    required this.providerName,
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
    required String providerName,
    required String refName,
    required String hashFn,
  }) {
    var leading = '';
    String providerType;
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    final returnType = provider.createdType;
    if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
      providerType = '${leading}FutureProvider';
    } else {
      providerType = '${leading}Provider';
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
      providerName: providerName,
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
    required String providerName,
    required String notifierTypedefName,
    required String hashFn,
  }) {
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    String providerType;
    String notifierBaseType;
    final returnType = provider.createdType;
    if (returnType.isDartAsyncFutureOr || returnType.isDartAsyncFuture) {
      providerType = '${leading}AsyncNotifierProviderImpl';
      notifierBaseType = 'Buildless${leading}AsyncNotifier';
    } else {
      providerType = '${leading}NotifierProviderImpl';
      notifierBaseType = 'Buildless${leading}Notifier';
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
      providerName: providerName,
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
  final String providerType;
  final String providerName;
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

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
final $providerName = $familyName();

$docs
class $familyName extends Family<${provider.exposedType}> {
  $familyName();

  $providerTypeNameImpl call($parameterDefinition) {
    return $providerTypeNameImpl($parametersPassThrough);
  }

  @override
  $providerTypeNameImpl getProviderOverride(
    covariant $providerTypeNameImpl provider,
  ) {
    return call($parameterProviderPassThrough);
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'$providerName';
}

$docs
class $providerTypeNameImpl extends $providerType$providerGenerics {
  $providerTypeNameImpl($thisParameterDefinition) : super(
          $providerCreate,
          from: $providerName,
          name: r'$providerName',
          debugGetCreateSourceHash: $hashFn,
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
