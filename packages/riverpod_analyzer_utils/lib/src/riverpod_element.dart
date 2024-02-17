import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'errors.dart';

(
  Set<GeneratorProviderDeclarationElement>?,
  String? message,
) _parseProviderOrFamilyList(
  DartObject? listObject,
) {
  if (listObject == null) {
    return (null, '`dependencies` not found');
  }

  // No dependencies, not an error
  if (listObject.isNull) return (null, null);

  final dependencies = listObject.toListValue() ?? listObject.toSetValue();
  if (dependencies == null) {
    return (null, 'Not a list');
  }

  final result = <GeneratorProviderDeclarationElement>{};
  for (final dep in dependencies) {
    final functionType = dep.toFunctionValue();
    if (functionType != null) {
      final provider = FunctionalProviderDeclarationElement.parse(
        functionType,
        annotation: null,
      );
      if (provider != null) {
        result.add(provider);
        continue;
      }

      return (
        null,
        'Failed to decode $functionType',
      );
    }

    final type = dep.toTypeValue();
    if (type != null) {
      final provider = ClassBasedProviderDeclarationElement.parse(
        type.element! as ClassElement,
        annotation: null,
      );
      if (provider != null) {
        result.add(provider);
        continue;
      }

      return (
        null,
        'Failed to decode $type',
      );
    }

    return (
      null,
      'Unsupported dependency. ${dep.type}',
    );
  }

  return (result, null);
}

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

    final dependencies = _parseProviderOrFamilyList(
      annotation.getField('dependencies'),
    );

    if (dependencies.$2 case final error?) {
      errorReporter?.call(
        RiverpodAnalysisError(
          error,
          targetElement: element,
          code: RiverpodAnalysisErrorCode.riverpodDependencyParseError,
        ),
      );
      return null;
    }

    return RiverpodAnnotationElement(
      keepAlive: readKeepAlive(annotation),
      dependencies: dependencies.$1,
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

  final bool keepAlive;
  final Set<GeneratorProviderDeclarationElement>? dependencies;
  final Set<GeneratorProviderDeclarationElement>? allTransitiveDependencies;
}

abstract class ProviderDeclarationElement {
  // TODO changelog breaking: removed isAutoDispose from ProviderDeclarationElement
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

      LegacyFamilyInvocationElement? familyElement;
      LegacyProviderType? providerType;
      if (providerBaseType.isAssignableFromType(element.type)) {
        providerType = LegacyProviderType._parse(element.type);
      } else if (familyType.isAssignableFromType(element.type)) {
        final callFn = (element.type as InterfaceType).lookUpMethod2(
          'call',
          element.library!,
        )!;
        final parameter = callFn.parameters.single;

        providerType = LegacyProviderType._parse(callFn.returnType);
        familyElement = LegacyFamilyInvocationElement._(parameter.type);
      } else {
        // Not a provider
        return null;
      }

      return LegacyProviderDeclarationElement._(
        name: element.name,
        element: element,
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

  final LegacyFamilyInvocationElement? familyElement;

  final LegacyProviderType? providerType;
}

class LegacyFamilyInvocationElement {
  LegacyFamilyInvocationElement._(this.parameterType);
  final DartType parameterType;
}

// TODO changelog made sealed
sealed class GeneratorProviderDeclarationElement
    implements ProviderDeclarationElement {
  RiverpodAnnotationElement get annotation;

  /// Whether a provider has any form of parameter, be it function parameters
  /// or type parameters.
  bool get isFamily;

  bool get isScoped {
    if (annotation.dependencies != null) return true;

    // TODO changelog isScoped now supports abstract build methods
    // TODO test
    final that = this;
    return that is ClassBasedProviderDeclarationElement &&
        that.buildMethod.isAbstract;
  }

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
            code: RiverpodAnalysisErrorCode.missingNotifierBuild,
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
  bool get isFamily {
    return buildMethod.parameters.isNotEmpty ||
        element.typeParameters.isNotEmpty;
  }

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
  bool get isScoped => super.isScoped || element.isExternal;

  @override
  bool get isFamily {
    return element.parameters.length > 1 || element.typeParameters.isNotEmpty;
  }

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
