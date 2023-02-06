import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'riverpod_ast.dart';

class RiverpodAnnotationDependencyElement {
  @internal
  RiverpodAnnotationDependencyElement(this.provider);

  static RiverpodAnnotationDependencyElement? _parse(
    DartObject object, {
    required Element targetElement,
  }) {
    final functionType = object.toFunctionValue();
    if (functionType != null) {
      final provider = StatelessProviderDeclarationElement.parse(
        functionType,
        annotation: null,
      );
      if (provider != null) {
        return RiverpodAnnotationDependencyElement(provider);
      }
    }
    final valueType = object.toTypeValue();
    if (valueType != null) {
      final provider = StatefulProviderDeclarationElement.parse(
        valueType.element! as ClassElement,
        annotation: null,
      );
      if (provider != null) {
        return RiverpodAnnotationDependencyElement(provider);
      }
    }

    throw RiverpodAnalysisException(
      'Unsupported dependency. '
      'Only functions and classes annotated by @riverpod are supported.',
      targetElement: targetElement,
    );
  }

  final ProviderDeclarationElement provider;
}

class RiverpodAnnotationElement {
  @internal
  RiverpodAnnotationElement({
    required this.keepAlive,
    required this.dependencies,
  });

  @internal
  static RiverpodAnnotationElement? parse(Element element) {
    final annotation = riverpodType.firstAnnotationOfExact(element);
    if (annotation == null) return null;

    final dependencies = readDependencies(annotation)?.map((dep) {
      final result = RiverpodAnnotationDependencyElement._parse(
        dep,
        targetElement: element,
      );
      if (result == null) {
        throw RiverpodAnalysisException(
          'Failed to parse dependency $dep',
          targetElement: element,
        );
      }
      return result;
    }).toList();

    return RiverpodAnnotationElement(
      keepAlive: readKeepAlive(annotation),
      dependencies: dependencies,
    );
  }

  @internal
  static bool readKeepAlive(DartObject object) {
    return object.getField('keepAlive')?.toBoolValue() ?? false;
  }

  @internal
  static List<DartObject>? readDependencies(DartObject object) {
    return object.getField('dependencies')?.toListValue();
  }

  final bool keepAlive;
  final List<RiverpodAnnotationDependencyElement>? dependencies;
}

class ProviderDependencyElement {
  ProviderDependencyElement(this.provider);
  final ProviderDeclarationElement provider;
}

class ProviderDependenciesElement {
  const ProviderDependenciesElement(this.dependencies);

  /// If null, it means that the provider likely has some dependencies
  /// but that they couldn't be computed.
  final Set<ProviderDependencyElement>? dependencies;

  ProviderDependenciesElement computeAllTransitiveDependencies() {
    final dependencies = this.dependencies;
    if (dependencies == null) return const ProviderDependenciesElement(null);

    final result = <ProviderDependencyElement>{...dependencies};

    for (final dependency in dependencies) {
      final transitiveDependencies =
          dependency.provider.allTransitiveDependencies;
      if (transitiveDependencies == null) {
        // The dependency has no dependency
        continue;
      }
      if (transitiveDependencies.dependencies == null) {
        // The dependency has some dependencies but they failed to compute.
        // So we propagate the fact that we couldn't compute the list of dependencies.
        return const ProviderDependenciesElement(null);
      }
      result.addAll(transitiveDependencies.dependencies!);
    }

    return ProviderDependenciesElement(result);
  }
}

abstract class ProviderDeclarationElement {
  Element get element;
  String get name;

  /// If null, the provider has no dependencies.
  ProviderDependenciesElement? get dependencies;

  /// The provider's [dependencies] and all of their dependencies too.
  ///
  /// If null, the provider has no dependencies.
  ProviderDependenciesElement? get allTransitiveDependencies;
}

/// The class name for explicitly typed provider.
///
/// Such as `FutureProvider` for `final provider = FutureProvider(...)`.
/// This is only about the type, and does not include autoDispose/family/...
enum LegacyProviderType {
  /// Type for `ChangeNotifierProvider`
  changeNotifierProvider,

  /// Type for `FutureProvider`
  futureProvider,

  /// Type for `StreamProvider`
  streamProvider,

  /// Type for `StateNotifierProvider`
  stateNotifierProvider,

  /// Type for `StateProvider`
  stateProvider,

  /// Type for `NotifierProvider`
  notifierProvider,

  /// Type for `AsyncNotifierProvider`
  asyncNotifierProvider,

  /// Type for `Provider`
  provider;

  static LegacyProviderType _parse(DartType providerType) {
    if (anyFutureProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.futureProvider;
    }
    if (anyStreamProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.streamProvider;
    }
    if (anyStateProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.stateProvider;
    }
    if (anyStateNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.stateNotifierProvider;
    }
    if (anyProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.provider;
    }
    if (anyNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.notifierProvider;
    }
    if (anyAsyncNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.asyncNotifierProvider;
    }
    if (anyChangeNotifierProviderType.isAssignableFromType(providerType)) {
      return LegacyProviderType.changeNotifierProvider;
    }

    throw StateError('Unknown provider type $providerType');
  }
}

class LegacyProviderDeclarationElement implements ProviderDeclarationElement {
  LegacyProviderDeclarationElement._({
    required this.name,
    required this.element,
    required this.isAutoDispose,
    required this.familyElement,
    required this.providerType,
    required this.dependencies,
    required this.allTransitiveDependencies,
  });

  static LegacyProviderDeclarationElement? parse(
    VariableElement element,
  ) {
    return _cache.putIfAbsent(element, () {
      bool isAutoDispose;
      LegacyFamilyInvocationElement? familyElement;
      LegacyProviderType providerType;
      if (providerBaseType.isAssignableFromType(element.type)) {
        isAutoDispose = !alwaysAliveProviderListenableType
            .isAssignableFromType(element.type);

        providerType = LegacyProviderType._parse(element.type);
      } else if (familyType.isAssignableFromType(element.type)) {
        final callFn = (element.type as InterfaceType).lookUpMethod2(
          'call',
          element.library!,
        )!;
        final parameter = callFn.parameters.single;

        isAutoDispose = !alwaysAliveProviderListenableType
            .isAssignableFromType(callFn.returnType);
        providerType = LegacyProviderType._parse(callFn.returnType);
        familyElement = LegacyFamilyInvocationElement._(parameter.type);
      } else {
        // Not a provider
        return null;
      }

      return LegacyProviderDeclarationElement._(
        name: element.name,
        element: element,
        isAutoDispose: isAutoDispose,
        familyElement: familyElement,
        providerType: providerType,
        dependencies: const ProviderDependenciesElement(null),
        allTransitiveDependencies: const ProviderDependenciesElement(null),
      );
    });
  }

  static final _cache = Expando<_Box<LegacyProviderDeclarationElement>>();

  @override
  final VariableElement element;

  @override
  final String name;

  final bool isAutoDispose;

  final LegacyFamilyInvocationElement? familyElement;

  final LegacyProviderType providerType;

  @override
  final ProviderDependenciesElement? dependencies;

  @override
  final ProviderDependenciesElement? allTransitiveDependencies;
}

class LegacyFamilyInvocationElement {
  LegacyFamilyInvocationElement._(this.parameterType);
  final DartType parameterType;
}

abstract class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;
}

class StatefulProviderDeclarationElement
    implements GeneratorProviderDeclarationElement {
  StatefulProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.buildMethod,
    required this.element,
    required this.allTransitiveDependencies,
    required this.dependencies,
  });

  @internal
  static StatefulProviderDeclarationElement? parse(
    ClassElement element, {
    required RiverpodAnnotationElement? annotation,
  }) {
    return _cache.putIfAbsent(element, () {
      final riverpodAnnotation =
          annotation ?? RiverpodAnnotationElement.parse(element);
      if (riverpodAnnotation == null) return null;

      final buildMethod = element.methods.firstWhere(
        (method) => method.name == 'build',
        orElse: () => throw RiverpodAnalysisException(
          'No "build" method found. '
          'Classes annotated with @riverpod must define a method named "build".',
        ),
      );

      final dependencies = riverpodAnnotation.dependencies.let((dependencies) {
        return ProviderDependenciesElement({
          for (final dependency in dependencies)
            ProviderDependencyElement(dependency.provider),
        });
      });

      return StatefulProviderDeclarationElement._(
        name: element.name,
        buildMethod: buildMethod,
        element: element,
        annotation: riverpodAnnotation,
        dependencies: dependencies,
        allTransitiveDependencies:
            dependencies?.computeAllTransitiveDependencies(),
      );
    });
  }

  static final _cache = Expando<_Box<StatefulProviderDeclarationElement>>();

  @override
  final ClassElement element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  final ExecutableElement buildMethod;

  @override
  final ProviderDependenciesElement? allTransitiveDependencies;

  @override
  final ProviderDependenciesElement? dependencies;
}

class StatelessProviderDeclarationElement
    implements GeneratorProviderDeclarationElement {
  StatelessProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.element,
    required this.allTransitiveDependencies,
    required this.dependencies,
  });

  @internal
  static StatelessProviderDeclarationElement? parse(
    ExecutableElement element, {
    required RiverpodAnnotationElement? annotation,
  }) {
    return _cache.putIfAbsent(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement.parse(element);
      if (riverpodAnnotation == null) return null;

      final dependencies = riverpodAnnotation.dependencies.let((dependencies) {
        return ProviderDependenciesElement({
          for (final dependency in dependencies)
            ProviderDependencyElement(dependency.provider),
        });
      });

      return StatelessProviderDeclarationElement._(
        name: element.name,
        annotation: riverpodAnnotation,
        element: element,
        dependencies: dependencies,
        allTransitiveDependencies:
            dependencies?.computeAllTransitiveDependencies(),
      );
    });
  }

  static final _cache = Expando<_Box<StatelessProviderDeclarationElement>>();

  @override
  final ExecutableElement element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  @override
  final ProviderDependenciesElement? allTransitiveDependencies;

  @override
  final ProviderDependenciesElement? dependencies;
}

/// An object for differentiating "no cache" from "cache but value is null".
class _Box<T> {
  _Box(this.value);
  final T? value;
}

extension<T> on Expando<_Box<T?>> {
  T? putIfAbsent(Object key, T? Function() value) {
    final cache = this[key];
    if (cache != null) return cache.value;

    final box = this[key] = _Box<T>(value());
    return box.value;
  }
}
