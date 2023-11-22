import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'errors.dart';

class RiverpodAnnotationElement {
  @internal
  RiverpodAnnotationElement({
    required this.keepAlive,
    required this.dependencies,
  }) : allTransitiveDependencies =
            _computeAllTransitiveDependencies(dependencies);

  @internal
  static RiverpodAnnotationElement? parse(Element element) {
    DartObject? annotation;
    try {
      annotation = riverpodType.firstAnnotationOfExact(element);
    } catch (_) {
      return RiverpodAnnotationElement(
        keepAlive: false,
        dependencies: null,
      );
    }
    if (annotation == null) return null;

    final dependencies = readDependencies(annotation)?.map((dep) {
      final result = _parseDependency(
        dep,
        targetElement: element,
      );
      if (result == null) {
        errorReporter?.call(
          RiverpodAnalysisError(
            'Failed to parse dependency $dep',
            targetElement: element,
          ),
        );
        return null;
      }
      return result;
    }).toSet();

    if (dependencies?.any((e) => e == null) ?? false) {
      // One of the dependencies failed to parse
      return null;
    }

    return RiverpodAnnotationElement(
      keepAlive: readKeepAlive(annotation),
      dependencies: dependencies?.cast(),
    );
  }

  static GeneratorProviderDeclarationElement? _parseDependency(
    DartObject object, {
    required Element targetElement,
  }) {
    final functionType = object.toFunctionValue();
    if (functionType != null) {
      final provider = FunctionalProviderDeclarationElement.parse(
        functionType,
        annotation: null,
      );
      if (provider != null) return provider;
    }
    final valueType = object.toTypeValue();
    if (valueType != null) {
      final provider = ClassBasedProviderDeclarationElement.parse(
        valueType.element! as ClassElement,
        annotation: null,
      );
      if (provider != null) return provider;
    }
    errorReporter?.call(
      RiverpodAnalysisError(
        'Unsupported dependency. '
        'Only functions and classes annotated by @riverpod are supported.',
        targetElement: targetElement,
      ),
    );
    return null;
  }

  static Set<GeneratorProviderDeclarationElement>?
      _computeAllTransitiveDependencies(
    Set<GeneratorProviderDeclarationElement>? dependencies,
  ) {
    if (dependencies == null) return null;

    return {
      ...dependencies,
      for (final dependency in dependencies)
        ...?dependency.annotation.allTransitiveDependencies,
    };
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
  final Set<GeneratorProviderDeclarationElement>? dependencies;
  final Set<GeneratorProviderDeclarationElement>? allTransitiveDependencies;
}

abstract class ProviderDeclarationElement {
  bool get isAutoDispose;
  Element get element;
  String get name;
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

  static LegacyProviderType? _parse(DartType providerType) {
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

    return null;
  }
}

class LegacyProviderDeclarationElement implements ProviderDeclarationElement {
  LegacyProviderDeclarationElement._({
    required this.name,
    required this.element,
    required this.isAutoDispose,
    required this.familyElement,
    required this.providerType,
  });

  @internal
  static LegacyProviderDeclarationElement? parse(
    VariableElement element,
  ) {
    return _cache.putIfAbsent(element, () {
      // Search for @ProviderFor annotation. If present, then this is a generated provider
      if (providerForType.hasAnnotationOfExact(
        element,
        throwOnUnresolved: false,
      )) {
        return null;
      }

      bool isAutoDispose;
      LegacyFamilyInvocationElement? familyElement;
      LegacyProviderType? providerType;
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
      );
    });
  }

  static final _cache = Expando<_Box<LegacyProviderDeclarationElement>>();

  @override
  final VariableElement element;

  @override
  final String name;

  @override
  final bool isAutoDispose;

  final LegacyFamilyInvocationElement? familyElement;

  final LegacyProviderType? providerType;
}

class LegacyFamilyInvocationElement {
  LegacyFamilyInvocationElement._(this.parameterType);
  final DartType parameterType;
}

abstract class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;

  bool get isScoped => annotation.dependencies != null;

  @override
  bool get isAutoDispose => !annotation.keepAlive;
}

class ClassBasedProviderDeclarationElement
    extends GeneratorProviderDeclarationElement {
  ClassBasedProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.buildMethod,
    required this.element,
  });

  @internal
  static ClassBasedProviderDeclarationElement? parse(
    ClassElement element, {
    required RiverpodAnnotationElement? annotation,
  }) {
    return _cache.putIfAbsent(element, () {
      final riverpodAnnotation =
          annotation ?? RiverpodAnnotationElement.parse(element);
      if (riverpodAnnotation == null) return null;

      final buildMethod =
          element.methods.firstWhereOrNull((method) => method.name == 'build');

      if (buildMethod == null) {
        errorReporter?.call(
          RiverpodAnalysisError(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
            targetElement: element,
          ),
        );

        return null;
      }

      return ClassBasedProviderDeclarationElement._(
        name: element.name,
        buildMethod: buildMethod,
        element: element,
        annotation: riverpodAnnotation,
      );
    });
  }

  static final _cache = Expando<_Box<ClassBasedProviderDeclarationElement>>();

  @override
  final ClassElement element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  final ExecutableElement buildMethod;
}

class FunctionalProviderDeclarationElement
    extends GeneratorProviderDeclarationElement {
  FunctionalProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.element,
  });

  @internal
  static FunctionalProviderDeclarationElement? parse(
    ExecutableElement element, {
    required RiverpodAnnotationElement? annotation,
  }) {
    return _cache.putIfAbsent(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement.parse(element);
      if (riverpodAnnotation == null) return null;

      return FunctionalProviderDeclarationElement._(
        name: element.name,
        annotation: riverpodAnnotation,
        element: element,
      );
    });
  }

  static final _cache = Expando<_Box<FunctionalProviderDeclarationElement>>();

  @override
  final ExecutableElement element;

  @override
  final String name;

  @override
  final RiverpodAnnotationElement annotation;

  @override
  bool get isScoped => super.isScoped || element.isExternal;
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
