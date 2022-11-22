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

class Data {
  Data.function({
    required this.rawName,
    required this.functionName,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
    required this.keepAlive,
    required this.providerDoc,
    required this.createElement,
    required this.createAst,
    required this.providerPostfix,
  }) : notifierName = null;

  Data.notifier({
    required this.rawName,
    required this.notifierName,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
    required this.keepAlive,
    required this.providerDoc,
    required this.createElement,
    required this.createAst,
    required this.providerPostfix,
  }) : functionName = null;

  final ExecutableElement createElement;
  final AstNode createAst;
  final bool isScoped;
  final bool isAsync;
  final bool isFamily;
  final String rawName;
  final String? functionName;
  final String? notifierName;
  final String valueDisplayType;
  final List<ParameterElement> parameters;
  final bool keepAlive;
  final String providerDoc;

  /// The postfix to add to the provider name.
  final String providerPostfix;

  String get hashFunctionName => '\$${rawName}Hash';

  String get hashFn => "const bool.fromEnvironment('dart.vm.product') ? "
      'null : $hashFunctionName';

  String get refName => '${rawName.titled}Ref';

  /// foo -> fooProvider
  /// Foo -> fooProvider
  String get providerName {
    return '${rawName.lowerFirst}$providerPostfix';
  }

  /// foo -> FooProvider
  /// Foo -> FooProvider
  String get providerTypeNameImpl {
    return '${rawName.titled}$providerPostfix';
  }

  /// foo -> FooFamily
  /// Foo -> FooFamily
  String get familyName {
    return '${rawName.titled}Family';
  }

  String get exposedValueDisplayType {
    return isAsync ? 'AsyncValue<$valueDisplayType>' : valueDisplayType;
  }

  String get buildValueDisplayType {
    return isAsync ? 'FutureOr<$valueDisplayType>' : valueDisplayType;
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
      if (isAsync) {
        return ProviderType.asyncNotifier;
      }
      return ProviderType.notifier;
    } else {
      if (isAsync) return ProviderType.futureProvider;
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
