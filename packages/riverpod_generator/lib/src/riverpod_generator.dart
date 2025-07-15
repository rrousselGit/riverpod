import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates/family.dart';
import 'templates/hash.dart';
import 'templates/notifier.dart';
import 'templates/parameters.dart';
import 'templates/provider.dart';
import 'templates/provider_variable.dart';

String providerDocFor(Element element) {
  return element.documentationComment == null
      ? '/// See also [${element.name}].'
      : '${element.documentationComment}\n///\n/// Copied from [${element.name}].';
}

String metaAnnotations(NodeList<Annotation> metadata) {
  final buffer = StringBuffer();
  for (final annotation in metadata) {
    final element = annotation.elementAnnotation;
    if (element == null) continue;
    if (element.isDeprecated ||
        element.isVisibleForTesting ||
        element.isProtected) {
      buffer.writeln('$annotation');
      continue;
    }
  }

  return buffer.toString();
}

const _defaultProviderNamePrefix = '';
const _defaultProviderNameSuffix = 'Provider';

/// May be thrown by generators during [Generator.generate].
class RiverpodInvalidGenerationSourceError
    extends InvalidGenerationSourceError {
  RiverpodInvalidGenerationSourceError(
    super.message, {
    super.todo = '',
    super.element,
    AstNode? astNode,
  }) : super(node: astNode);
}

@immutable
class RiverpodGenerator extends ParserGenerator<Riverpod> {
  RiverpodGenerator(Map<String, Object?> mapConfig)
      : options = BuildYamlOptions.fromMap(mapConfig);

  final BuildYamlOptions options;

  @override
  String generateForUnit(List<CompilationUnit> compilationUnits) {
    final buffer = StringBuffer();

    final errors = <RiverpodAnalysisError>[];
    final previousErrorReporter = errorReporter;

    try {
      errorReporter = errors.add;
      _generate(compilationUnits, buffer);
    } finally {
      errorReporter = previousErrorReporter;
    }

    // Running at the end to aggregate all errors.
    for (final error in errors) {
      throw RiverpodInvalidGenerationSourceError(
        error.message,
        element: error.targetElement,
        astNode: error.targetNode,
      );
    }

    return buffer.toString();
  }

  void _generate(List<CompilationUnit> units, StringBuffer buffer) {
    final visitor = _RiverpodGeneratorVisitor(buffer, options);
    for (final unit in units.expand((e) => e.declarations)) {
      final provider = unit.provider;

      switch (provider) {
        case ClassBasedProviderDeclaration():
          visitor.visitClassBasedProviderDeclaration(provider);
        case FunctionalProviderDeclaration():
          visitor.visitFunctionalProviderDeclaration(provider);
        default:
          continue;
      }
    }

    // Only emit the header if we actually generated something
    if (buffer.isNotEmpty) {
      buffer.write('''
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
''');
    }
  }
}

class _RiverpodGeneratorVisitor {
  _RiverpodGeneratorVisitor(this.buffer, this.options);

  final StringBuffer buffer;
  final BuildYamlOptions options;

  String get prefix => options.providerNamePrefix ?? _defaultProviderNamePrefix;

  String get familyPrefix => options.providerFamilyNamePrefix ?? prefix;

  String get suffix => options.providerNameSuffix ?? _defaultProviderNameSuffix;

  String get familySuffix => options.providerFamilyNameSuffix ?? suffix;

  void visitGeneratorProviderDeclaration(
    GeneratorProviderDeclaration provider,
  ) {
    final allTransitiveDependencies =
        _computeAllTransitiveDependencies(provider);

    ProviderVariableTemplate(provider, options).run(buffer);
    ProviderTemplate(
      provider,
      options,
      allTransitiveDependencies: allTransitiveDependencies,
    ).run(buffer);
    HashFnTemplate(provider).run(buffer);
    FamilyTemplate(
      provider,
      options,
      allTransitiveDependencies: allTransitiveDependencies,
    ).run(buffer);
  }

  List<String>? _computeAllTransitiveDependencies(
    GeneratorProviderDeclaration provider,
  ) {
    final dependencies = provider.annotation.dependencyList?.values;
    if (dependencies == null) return null;

    final allTransitiveDependencies = <String>[];

    Iterable<GeneratorProviderDeclarationElement>
        computeAllTransitiveDependencies(
      GeneratorProviderDeclarationElement provider,
    ) sync* {
      final deps = provider.annotation.dependencies;
      if (deps == null) return;

      final uniqueDependencies = <GeneratorProviderDeclarationElement>{};

      for (final transitiveDependency in deps) {
        if (!uniqueDependencies.add(transitiveDependency)) continue;
        yield transitiveDependency;
        yield* computeAllTransitiveDependencies(transitiveDependency);
      }
    }

    final uniqueDependencies = <GeneratorProviderDeclarationElement>{};
    for (final dependency in dependencies) {
      if (!uniqueDependencies.add(dependency.provider)) continue;

      allTransitiveDependencies.add(dependency.provider.providerName(options));

      final uniqueTransitiveDependencies =
          computeAllTransitiveDependencies(dependency.provider)
              // Since generated code trims duplicate dependencies,
              // we have to trim them back when parsing the dependencies to
              // keep the index correct.
              .toSet()
              .indexed;

      for (final (index, transitiveDependency)
          in uniqueTransitiveDependencies) {
        if (!uniqueDependencies.add(transitiveDependency)) continue;

        allTransitiveDependencies.add(
          '${dependency.provider.providerTypeName}.\$allTransitiveDependencies$index',
        );
      }
    }

    return allTransitiveDependencies;
  }

  void visitClassBasedProviderDeclaration(
    ClassBasedProviderDeclaration provider,
  ) {
    visitGeneratorProviderDeclaration(provider);
    NotifierTemplate(provider).run(buffer);
  }

  void visitFunctionalProviderDeclaration(
    FunctionalProviderDeclaration provider,
  ) {
    visitGeneratorProviderDeclaration(provider);
  }
}

extension ProviderElementNames on GeneratorProviderDeclarationElement {
  String providerName(BuildYamlOptions options) {
    final prefix = (isFamily
            ? options.providerFamilyNamePrefix
            : options.providerNamePrefix) ??
        _defaultProviderNamePrefix;
    final suffix = (isFamily
            ? options.providerFamilyNameSuffix
            : options.providerNameSuffix) ??
        _defaultProviderNameSuffix;

    return '$prefix${prefix.isEmpty ? name.lowerFirst : name.titled}$suffix';
  }

  String get providerTypeName => '${name.titled}Provider';

  String get familyTypeName => '${name.titled}Family';

  String dependencies(BuildYamlOptions options) {
    var dependencies = annotation.dependencies?.toSet();
    if (dependencies == null && !isScoped) return 'null';
    dependencies ??= {};

    final buffer = StringBuffer('const <ProviderOrFamily>');
    buffer.write('[');

    buffer.writeAll(
      dependencies.map((e) => e.providerName(options)),
      ',',
    );

    buffer.write(']');
    return buffer.toString();
  }

  String allTransitiveDependencies(List<String>? deps) {
    var allTransitiveDependencies = deps;
    if (deps == null && !isScoped) return 'null';
    allTransitiveDependencies ??= [];

    final buffer = StringBuffer('const <ProviderOrFamily>');
    if (allTransitiveDependencies.length < 4) {
      buffer.write('[');
    } else {
      buffer.write('{');
    }

    for (var i = 0; i < allTransitiveDependencies.length; i++) {
      buffer.write('$providerTypeName.\$allTransitiveDependencies$i,');
    }

    if (allTransitiveDependencies.length < 4) {
      buffer.write(']');
    } else {
      buffer.write('}');
    }

    return buffer.toString();
  }
}

extension ProviderNames on GeneratorProviderDeclaration {
  String providerName(BuildYamlOptions options) {
    return providerElement.providerName(options);
  }

  String get providerTypeName => providerElement.providerTypeName;

  String get familyTypeName => providerElement.familyTypeName;

  String get argumentRecordType {
    // Encode the list of parameters into a record.
    // We do so only if there are at least two parameters.
    switch (parameters) {
      case [_]:
        return parameters.first.typeDisplayString;
      case []:
        return 'Never';
      case [...]:
        return '(${buildParamDefinitionQuery(parameters, asRecord: true)})';
    }
  }

  Iterable<String> get metadata {
    return ['@ProviderFor($name)'].followedBy(
      node.metadata.where((e) {
        if (e.elementAnnotation!.isDoNotStore) return false;

        final valueType = e.elementAnnotation!.computeConstantValue()?.type;
        if (valueType == null) return false;

        return !riverpodType.isExactlyType(valueType);
      }).map((e) => e.toString()),
    );
  }

  String get doc => node.doc;

  String get argumentCast {
    final type = argumentRecordType;
    if (type == 'Object?') return '';
    return ' as $type';
  }

  String argumentToRecord({String? variableName}) {
    switch (parameters) {
      case [final p]:
        return variableName ?? p.name.toString();
      case [...]:
        return '(${buildParamInvocationQuery({
              for (final parameter in parameters)
                if (variableName != null)
                  parameter: '$variableName.${parameter.name}'
                else
                  parameter: parameter.name.toString(),
            })})';
    }
  }

  String dependencies(BuildYamlOptions options) =>
      providerElement.dependencies(options);

  String allTransitiveDependencies(List<String>? allTransitiveDependencies) {
    return providerElement.allTransitiveDependencies(allTransitiveDependencies);
  }

  TypeParameterList? get typeParameters => switch (this) {
        final FunctionalProviderDeclaration p =>
          p.node.functionExpression.typeParameters,
        final ClassBasedProviderDeclaration p => p.node.typeParameters
      };

  String generics() => typeParameters.genericUsageDisplayString();
  String genericsDefinition() =>
      typeParameters.genericDefinitionDisplayString();

  String notifierBuildType({
    bool withGenericDefinition = false,
    bool withArguments = false,
  }) {
    final genericsDefinition =
        withGenericDefinition ? this.genericsDefinition() : '';
    final notifierType = '$name${generics()}';

    final parameters = withArguments
        ? buildParamDefinitionQuery(
            this.parameters,
            withDefaults: false,
          )
        : '';

    return '$createdTypeDisplayString Function$genericsDefinition(Ref, $notifierType, $parameters)';
  }

  String createType({
    bool withArguments = true,
    bool withGenericDefinition = false,
  }) {
    final generics = this.generics();
    final genericsDefinition =
        withGenericDefinition ? this.genericsDefinition() : '';

    final provider = this;
    switch (provider) {
      case FunctionalProviderDeclaration():
        final params = withArguments
            ? buildParamDefinitionQuery(
                parameters,
                withDefaults: false,
              )
            : '';

        return '${provider.createdTypeDisplayString} Function$genericsDefinition(Ref ref, $params)';
      case ClassBasedProviderDeclaration():
        return '${provider.name}$generics Function$genericsDefinition()';
    }
  }

  String get generatedElementName => '_\$${providerElement.name.public}Element';

  String get internalElementName => switch (this) {
        ClassBasedProviderDeclaration() => switch (createdType) {
            SupportedCreatedType.future => r'$AsyncNotifierProviderElement',
            SupportedCreatedType.stream => r'$StreamNotifierProviderElement',
            SupportedCreatedType.value => r'$NotifierProviderElement',
          },
        FunctionalProviderDeclaration() => switch (createdType) {
            SupportedCreatedType.future => r'$FutureProviderElement',
            SupportedCreatedType.stream => r'$StreamProviderElement',
            SupportedCreatedType.value => r'$ProviderElement',
          },
      };

  String get hashFnName => '_\$${providerElement.name.lowerFirst}Hash';

  List<FormalParameter> get parameters {
    final provider = this;
    switch (provider) {
      case FunctionalProviderDeclaration():
        return provider.node.functionExpression.parameters!.parameters
            .skip(1)
            .toList();
      case ClassBasedProviderDeclaration():
        return provider.buildMethod.parameters!.parameters.toList();
    }
  }
}

extension TypeX on TypeParameterList? {
  String genericDefinitionDisplayString() {
    return this?.toSource() ?? '';
  }

  String genericUsageDisplayString() {
    if (this == null) {
      return '';
    }

    return '<${this!.typeParameters.map((e) => e.name.lexeme).join(', ')}>';
  }
}

extension ParameterDoc on AstNode {
  String get doc {
    final builder = StringBuffer();
    final that = this;

    switch (that) {
      case AnnotatedNode():
        for (var token = that.documentationComment?.beginToken;
            token != null;
            token = token.next) {
          builder.writeln(token);
        }
      case _:
        for (Token? token = beginToken.precedingComments;
            token != null;
            token = token.next) {
          builder.writeln(token);
        }
    }

    return builder.toString();
  }
}
