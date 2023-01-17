import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

import 'templates/hash.dart';

class Optional<T> {
  const Optional(this.value);

  final T? value;
}

enum ProviderType {
  provider,
  futureProvider,
  notifier,
  asyncNotifier,
}

enum AsyncType { future, futureOr, consecutive }

const _defaultProviderNameSuffix = 'Provider';

class Data {
  Data.function({
    required this.rawName,
    required this.functionName,
    required this.valueDisplayType,
    required this.asyncType,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
    required this.keepAlive,
    required this.providerDoc,
    required this.createElement,
    required this.createAst,
    required this.buildYamlOptions,
  }) : notifierName = null;

  Data.notifier({
    required this.rawName,
    required this.notifierName,
    required this.valueDisplayType,
    required this.asyncType,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
    required this.keepAlive,
    required this.providerDoc,
    required this.createElement,
    required this.createAst,
    required this.buildYamlOptions,
  }) : functionName = null;

  final ExecutableElement createElement;
  final AstNode createAst;
  final bool isScoped;
  final AsyncType asyncType;
  final bool isFamily;
  final String rawName;
  final String? functionName;
  final String? notifierName;
  final String valueDisplayType;
  final List<ParameterElement> parameters;
  final bool keepAlive;
  final String providerDoc;
  final BuildYamlOptions buildYamlOptions;

  String get hashFunctionName => '_\$${rawName}Hash';

  String get hashFn => "const bool.fromEnvironment('dart.vm.product') ? "
      'null : $hashFunctionName';

  String get refName => '${rawName.titled}Ref';

  /// foo -> fooProvider
  /// Foo -> fooProvider
  String get providerName {
    return '${rawName.lowerFirst}$_nameSuffix';
  }

  /// foo -> FooProvider
  /// Foo -> FooProvider
  String get providerTypeNameImpl {
    return '${rawName.titled}$_nameSuffix';
  }

  /// foo -> FooFamily
  /// Foo -> FooFamily
  String get familyName {
    return '${rawName.titled}Family';
  }

  String get exposedValueDisplayType {
    return asyncType != AsyncType.consecutive
        ? 'AsyncValue<$valueDisplayType>'
        : valueDisplayType;
  }

  // TODO
  String get buildValueDisplayType {
    switch (asyncType) {
      case AsyncType.future:
        return 'Future<$valueDisplayType>';
      case AsyncType.futureOr:
        return 'FutureOr<$valueDisplayType>';
      case AsyncType.consecutive:
        return valueDisplayType;
    }
  }

  late final String notifierBaseName =
      '_\$${rawName.replaceFirst(RegExp('_*'), '')}';

  late final List<ParameterElement> positionalParameters =
      parameters.where((e) => e.isPositional && e.isRequired).toList();

  late final List<ParameterElement> optionalPositionalParameters =
      parameters.where((e) => e.isPositional && e.isOptional).toList();

  late final List<ParameterElement> namedParameters =
      parameters.where((e) => e.isNamed).toList();

  bool get isNotifier => functionName == null;

  String get _nameSuffix =>
      buildYamlOptions.providerNameSuffix ?? _defaultProviderNameSuffix;

  String notifierType({bool generics = true}) {
    final trailing = generics ? '<$valueDisplayType>' : '';
    final leading = keepAlive ? '' : 'AutoDispose';

    switch (providerType) {
      case ProviderType.notifier:
        if (isFamily) {
          return 'Buildless${leading}Notifier$trailing';
        }
        return '${leading}Notifier$trailing';
      case ProviderType.asyncNotifier:
        final trailing = generics ? '<$valueDisplayType>' : '';
        if (isFamily) {
          return 'Buildless${leading}AsyncNotifier$trailing';
        }
        return '${leading}AsyncNotifier$trailing';
      default:
        throw UnsupportedError('functions do not have a notifier');
    }
  }

  String get refType {
    final leading = keepAlive ? '' : 'AutoDispose';
    switch (providerType) {
      case ProviderType.provider:
        return '${leading}ProviderRef';
      case ProviderType.futureProvider:
        return '${leading}FutureProviderRef';
      case ProviderType.notifier:
        return '${leading}NotifierProviderRef';
      case ProviderType.asyncNotifier:
        return '${leading}AsyncNotifierProviderRef';
    }
  }

  late final paramDefinition = [
    ...positionalParameters.map((e) {
      return '${e.type.getDisplayString(withNullability: true)} ${e.name},';
    }),
    if (optionalPositionalParameters.isNotEmpty) ...[
      '[',
      ...optionalPositionalParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        return '${e.type.getDisplayString(withNullability: true)} ${e.name} $defaultValue,';
      }),
      ']',
    ],
    if (namedParameters.isNotEmpty) ...[
      '{',
      ...namedParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        final leading = e.isRequired ? 'required' : '';

        return '$leading ${e.type.getDisplayString(withNullability: true)} ${e.name} $defaultValue,';
      }),
      '}',
    ],
  ].join();

  late final thisParamDefinition = [
    ...positionalParameters.map((e) {
      return 'this.${e.name},';
    }),
    if (optionalPositionalParameters.isNotEmpty) ...[
      '[',
      ...optionalPositionalParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        return 'this.${e.name} $defaultValue,';
      }),
      ']',
    ],
    if (namedParameters.isNotEmpty) ...[
      '{',
      ...namedParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        final leading = e.isRequired ? 'required' : '';

        return '$leading this.${e.name} $defaultValue,';
      }),
      '}',
    ],
  ].join();

  late final paramInvocationPassAround = parameters.map((e) {
    if (e.isNamed) {
      return '${e.name}: ${e.name},';
    }
    return '${e.name},';
  }).join();

  late final paramInvocationFromProvider = parameters.map((e) {
    if (e.isNamed) {
      return '${e.name}: provider.${e.name},';
    }
    return 'provider.${e.name},';
  }).join();

  ProviderType get providerType {
    if (isNotifier) {
      if (asyncType != AsyncType.consecutive) {
        return ProviderType.asyncNotifier;
      }
      return ProviderType.notifier;
    } else {
      if (asyncType != AsyncType.consecutive) {
        return ProviderType.futureProvider;
      }
      return ProviderType.provider;
    }
  }

  String get providerTypeDisplayString {
    final leading = keepAlive ? '' : 'AutoDispose';

    String trailing;
    if (isNotifier) {
      trailing = '<$rawName, $valueDisplayType>';
    } else {
      trailing = '<$valueDisplayType>';
    }

    switch (providerType) {
      case ProviderType.provider:
        return '${leading}Provider$trailing';
      case ProviderType.futureProvider:
        return '${leading}FutureProvider$trailing';
      case ProviderType.notifier:
        if (isFamily) return '${leading}NotifierProviderImpl$trailing';
        return '${leading}NotifierProvider$trailing';
      case ProviderType.asyncNotifier:
        if (isFamily) return '${leading}AsyncNotifierProviderImpl$trailing';
        return '${leading}AsyncNotifierProvider$trailing';
    }
  }
}

class GlobalData {
  GlobalData();

  final ElementHash hash = ElementHash();
}

class BuildYamlOptions {
  BuildYamlOptions({
    this.providerNameSuffix,
  });

  factory BuildYamlOptions.fromMap(Map<String, dynamic> map) {
    return BuildYamlOptions(
      providerNameSuffix: map['provider_name_suffix'] as String?,
    );
  }

  final String? providerNameSuffix;
}

extension on String {
  String get titled {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }

  String get lowerFirst {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toLowerCase(),
    );
  }
}
