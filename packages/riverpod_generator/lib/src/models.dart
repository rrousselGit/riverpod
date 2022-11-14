import 'package:analyzer/dart/element/element.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

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

class ProviderDependency {
  R map<R>({
    required R Function(StringProviderDependency dependency) stringDependency,
    required R Function(ReferenceProviderDependency dependency)
        referenceDependency,
  }) {
    final that = this;
    if (that is StringProviderDependency) return stringDependency(that);
    return referenceDependency(that as ReferenceProviderDependency);
  }
}

/// `@Riverpod(dependencies: ["string"])`
class StringProviderDependency extends ProviderDependency {
  StringProviderDependency(this.value);

  final String value;

  @override
  String toString() => value;
}

/// `@Riverpod(dependencies: [provider])`
class ReferenceProviderDependency extends ProviderDependency {
  ReferenceProviderDependency(this.value);

  final String value;

  @override
  String toString() => value;
}

class ProviderDependencies {
  ProviderDependencies(this.dependencies);

  final List<ProviderDependency>? dependencies;

  late final bool hasTransitiveStringDependency =
      dependencies == null || dependencies!.any((element) => false);
}

extension GeneratorNames on GeneratorProviderDefinition {
  String get _valueDisplayType =>
      type.createdType.getDisplayString(withNullability: true);

  String get hashFunctionName => '\$${name}Hash';

  String get hashFn => "const bool.fromEnvironment('dart.vm.product') ? "
      'null : $hashFunctionName';

  String get refName => '${name.titled}Ref';

  /// foo -> fooProvider
  /// Foo -> fooProvider
  String get providerName {
    return '${name.lowerFirst}Provider';
  }

  // String get dependencyList => dependencies.dependencies!.join(',');

  // String get dependencyString => dependencies.dependencies == null
  //     ? 'null'
  //     : '<ProviderOrFamily>[$dependencyList]';

  // String transitiveDependencies =
  //     'dependencies == null ? null : _allTransitiveDependencies(dependencies!)';

  /// foo -> FooProvider
  /// Foo -> FooProvider
  String get providerTypeNameImpl {
    return '${name.titled}Provider';
  }

  /// foo -> FooFamily
  /// Foo -> FooFamily
  String get familyName {
    return '${name.titled}Family';
  }

  String get exposedValueDisplayType {
    return type.map(
      (value) => _valueDisplayType,
      future: (_) => 'AsyncValue<$_valueDisplayType>',
    );
  }

  String get buildValueDisplayType {
    return type.map(
      (value) => _valueDisplayType,
      future: (_) => 'FutureOr<$_valueDisplayType>',
    );
  }

  String get notifierBaseName => '_\$${name.replaceFirst(RegExp('_*'), '')}';

  List<ParameterElement> get positionalParameters =>
      parameters.where((e) => e.isPositional && e.isRequired).toList();

  List<ParameterElement> get optionalPositionalParameters =>
      parameters.where((e) => e.isPositional && e.isOptional).toList();

  List<ParameterElement> get namedParameters =>
      parameters.where((e) => e.isNamed).toList();

  String notifierBaseType({bool generics = true}) {
    final trailing = generics ? '<$_valueDisplayType>' : '';
    final leading = isAutoDispose ? 'AutoDispose' : '';

    switch (providerType) {
      case ProviderType.notifier:
        if (parameters.isNotEmpty) {
          return 'Buildless${leading}Notifier$trailing';
        }
        return '${leading}Notifier$trailing';
      case ProviderType.asyncNotifier:
        final trailing = generics ? '<$_valueDisplayType>' : '';
        if (parameters.isNotEmpty) {
          return 'Buildless${leading}AsyncNotifier$trailing';
        }
        return '${leading}AsyncNotifier$trailing';
      default:
        throw UnsupportedError('functions do not have a notifier');
    }
  }

  String get refType {
    final leading = isAutoDispose ? 'AutoDispose' : '';
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

  String get paramDefinition => [
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

  String get thisParamDefinition => <String>[
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

  String get paramInvocationPassAround => parameters.map((e) {
        if (e.isNamed) {
          return '${e.name}: ${e.name},';
        }
        return '${e.name},';
      }).join();

  String get paramInvocationFromProvider => parameters.map((e) {
        if (e.isNamed) {
          return '${e.name}: provider.${e.name},';
        }
        return 'provider.${e.name},';
      }).join();

  ProviderType get providerType {
    if (isNotifier) {
      if (type.createsFuture) {
        return ProviderType.asyncNotifier;
      }
      return ProviderType.notifier;
    } else {
      if (type.createsFuture) return ProviderType.futureProvider;
      return ProviderType.provider;
    }
  }

  String get providerTypeDisplayString {
    final leading = isAutoDispose ? 'AutoDispose' : '';

    String trailing;
    if (isNotifier) {
      trailing = '<$name, $_valueDisplayType>';
    } else {
      trailing = '<$_valueDisplayType>';
    }

    switch (providerType) {
      case ProviderType.provider:
        return '${leading}Provider$trailing';
      case ProviderType.futureProvider:
        return '${leading}FutureProvider$trailing';
      case ProviderType.notifier:
        if (parameters.isNotEmpty) {
          return '${leading}NotifierProviderImpl$trailing';
        }
        return '${leading}NotifierProvider$trailing';
      case ProviderType.asyncNotifier:
        if (parameters.isNotEmpty) {
          return '${leading}AsyncNotifierProviderImpl$trailing';
        }
        return '${leading}AsyncNotifierProvider$trailing';
    }
  }
}

class GlobalData {
  GlobalData();

  final ElementHash hash = ElementHash();
}

extension StringExtension on String {
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
