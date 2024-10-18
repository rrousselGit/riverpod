import 'package:analyzer/dart/element/element.dart';
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
  final prefix =
      options.providerFamilyNamePrefix ?? options.providerNamePrefix ?? '';
  final rawProviderName = provider.name;
  final suffix = options.providerFamilyNameSuffix ??
      options.providerNameSuffix ??
      'Provider';
  return '$prefix${prefix.isEmpty ? rawProviderName.lowerFirst : rawProviderName.titled}$suffix';
}

class FamilyTemplate extends Template {
  FamilyTemplate._(
    this.provider, {
    required this.options,
    required this.parameters,
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
    if (parameters.isEmpty) {
      throw ArgumentError.value(
        parameters,
        'provider',
        'Expected a provider with parameters',
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

    final parameters =
        provider.node.functionExpression.parameters!.parameterElements
            // ignore: deprecated_member_use, stuck with SDK >=2.x.0 for now
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
      elementType: elementType,
      refType: refType,
      providerGenerics: '<${provider.valueTypeDisplayString}>',
      providerCreate:
          '(ref) => ${provider.name}(ref as ${provider._refImplName}, $parametersPassThrough)',
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

    final parameters = provider.buildMethod.parameters!.parameterElements
        // ignore: deprecated_member_use, stuck with SDK >=2.x.0 for now
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
      elementType: elementType,
      refType: refType,
      providerGenerics:
          '<${provider.name}, ${provider.valueTypeDisplayString}>',
      providerType: providerType,
      providerCreate: '() => ${provider.name}()$cascadePropertyInit',
      parametersPassThrough: parametersPassThrough,
      other: '''
abstract class $notifierTypedefName extends $notifierBaseType<${provider.valueTypeDisplayString}> {
  ${parameters.map((e) => 'late final ${e.type} ${e.name};').join('\n')}

  ${provider.createdTypeDisplayString} build($parameterDefinition);
}
''',
      providerOther: '''
  @override
  ${provider.createdTypeDisplayString} runNotifierBuild(
    covariant ${provider.name} notifier,
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

    buffer.write('''
$other

$docs
@ProviderFor(${provider.name})
const $providerName = $familyName();

$docs
class $familyName extends Family<${provider.exposedTypeDisplayString}> {
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

${parameters.map((e) => 'final ${e.type.getDisplayString()} ${e.name};').join()}

$providerOther

  @override
  $elementType$providerGenerics createElement() {
    return $elementNameImpl(this);
  }

  @override
  bool operator ==(Object other) {
    return ${[
      'other is $providerTypeNameImpl',
      ...parameters.map((e) => 'other.${e.name} == ${e.name}'),
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
${parameters.map((e) => 'hash = _SystemHash.combine(hash, ${e.name}.hashCode);').join()}

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin $refNameImpl on $refType<${provider.valueTypeDisplayString}> {
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
