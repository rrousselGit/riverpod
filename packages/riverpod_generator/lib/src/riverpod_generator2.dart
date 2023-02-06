import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
// ignore: implementation_imports, safe as we are the one controlling this file
import 'package:riverpod_annotation/src/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models.dart';
import 'parse_generator.dart';
import 'templates2/family.dart';
import 'templates2/stateful_provider.dart';
import 'templates2/stateless_provider.dart';

const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);

String providerDocFor(Element element) {
  return element.documentationComment == null
      ? '/// See also [${element.name}].'
      : '${element.documentationComment}\n///\n/// Copied from [${element.name}].';
}

String _hashFn(GeneratorProviderDeclaration provider, String hashName) {
  return "String $hashName() => '${provider.computeProviderHash()}';";
}

String _hashFnName(ProviderDeclaration provider) {
  return '_\$${provider.providerElement.name.public.lowerFirst}Hash';
}

String _hashFnIdentifier(String hashFnName) {
  return "const bool.fromEnvironment('dart.vm.product') ? "
      'null : $hashFnName';
}

@immutable
class RiverpodGenerator2 extends ParserGenerator {
  RiverpodGenerator2(Map<String, Object?> mapConfig)
      : config = BuildYamlOptions.fromMap(mapConfig);

  final BuildYamlOptions config;

  @override
  String generateForUnit(ResolvedUnitResult resolvedUnitResult) {
    final riverpodResult = parseRiverpod(
      resolvedUnitResult.unit,
      defaultFlagValue: false,
      parseStatefulProviderDeclaration: true,
      parseStatelessProviderDeclaration: true,
    );
    return runGenerator(riverpodResult);
  }

  String runGenerator(RiverpodAnalysisResult riverpodResult) {
    final suffix = config.providerNameSuffix ?? 'Provider';

    final buffer = StringBuffer('''
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment
''');

    var didEmitHashUtils = false;
    void maybeEmitHashUtils() {
      if (didEmitHashUtils) return;

      didEmitHashUtils = true;
      buffer.write('''
/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}
''');
    }

    for (final provider in riverpodResult.statefulProviderDeclarations.values) {
      final providerName = '${provider.providerElement.name.lowerFirst}$suffix';
      final notifierTypedefName = providerName.startsWith('_')
          ? '_\$${provider.providerElement.name.substring(1)}'
          : '_\$${provider.providerElement.name}';

      final parameters = provider.buildMethod.parameters?.parameters;
      if (parameters == null) continue;

      final hashFunctionName = _hashFnName(provider);
      final hashFn = _hashFnIdentifier(hashFunctionName);
      buffer.write(_hashFn(provider, hashFunctionName));

      if (parameters.isEmpty) {
        StatefulProviderTemplate(
          provider,
          providerName: providerName,
          notifierTypedefName: notifierTypedefName,
          hashFn: hashFn,
        ).run(buffer);
      } else {
        maybeEmitHashUtils();
        FamilyTemplate.stateful(
          provider,
          providerName: providerName,
          notifierTypedefName: notifierTypedefName,
          hashFn: hashFn,
        ).run(buffer);
      }
    }

    for (final provider
        in riverpodResult.statelessProviderDeclarations.values) {
      final providerName = '${provider.providerElement.name}$suffix';

      final parameters =
          provider.node.functionExpression.parameters?.parameters;
      if (parameters == null) continue;

      final hashFunctionName = _hashFnName(provider);
      final hashFn = _hashFnIdentifier(hashFunctionName);
      buffer.write(_hashFn(provider, hashFunctionName));

      final refName = '${provider.providerElement.name.titled}Ref';

      // Using >1 as functional providers always have at least one parameter: ref
      // So a provider is a "family" only if it has parameters besides the ref.
      if (parameters.length > 1) {
        maybeEmitHashUtils();
        FamilyTemplate.stateless(
          provider,
          providerName: providerName,
          refName: refName,
          hashFn: hashFn,
        ).run(buffer);
      } else {
        StatelessProviderTemplate(
          provider,
          providerName: providerName,
          refName: refName,
          hashFn: hashFn,
        ).run(buffer);
      }
    }

    return buffer.toString();
  }
}
