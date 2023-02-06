import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'riverpod_ast.dart';

class RiverpodAnnotationElement {
  @internal
  RiverpodAnnotationElement({
    required this.keepAlive,
    required this.dependencies,
  }) : allTransitiveDependencies =
            _computeAllTransitiveDependencies(dependencies);

  @internal
  static RiverpodAnnotationElement? parse(Element element) {
    final annotation = riverpodType.firstAnnotationOfExact(element);
    if (annotation == null) return null;

    final dependencies = readDependencies(annotation)?.map((dep) {
      final result = _parseDependency(
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
    }).toSet();

    return RiverpodAnnotationElement(
      keepAlive: readKeepAlive(annotation),
      dependencies: dependencies,
    );
  }

  static GeneratorProviderDeclarationElement? _parseDependency(
    DartObject object, {
    required Element targetElement,
  }) {
    final functionType = object.toFunctionValue();
    if (functionType != null) {
      final provider = StatelessProviderDeclarationElement.parse(
        functionType,
        annotation: null,
      );
      if (provider != null) return provider;
    }
    final valueType = object.toTypeValue();
    if (valueType != null) {
      final provider = StatefulProviderDeclarationElement.parse(
        valueType.element! as ClassElement,
        annotation: null,
      );
      if (provider != null) return provider;
    }

    throw RiverpodAnalysisException(
      'Unsupported dependency. '
      'Only functions and classes annotated by @riverpod are supported.',
      targetElement: targetElement,
    );
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

      return StatefulProviderDeclarationElement._(
        name: element.name,
        buildMethod: buildMethod,
        element: element,
        annotation: riverpodAnnotation,
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
}

class StatelessProviderDeclarationElement
    implements GeneratorProviderDeclarationElement {
  StatelessProviderDeclarationElement._({
    required this.name,
    required this.annotation,
    required this.element,
  });

  @internal
  static StatelessProviderDeclarationElement? parse(
    ExecutableElement element, {
    required RiverpodAnnotationElement? annotation,
  }) {
    return _cache.putIfAbsent(element, () {
      final riverpodAnnotation = RiverpodAnnotationElement.parse(element);
      if (riverpodAnnotation == null) return null;

      return StatelessProviderDeclarationElement._(
        name: element.name,
        annotation: riverpodAnnotation,
        element: element,
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
