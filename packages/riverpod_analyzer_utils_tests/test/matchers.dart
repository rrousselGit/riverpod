import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

TypeMatcher<LegacyProviderDeclarationElement>
    isLegacyProviderDeclarationElement({
  Object? element = const Object(),
  Object? name = const Object(),
  Object? familyElement = const Object(),
  Object? providerType = const Object(),
}) {
  var matcher = isA<LegacyProviderDeclarationElement>();

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (name != const Object()) {
    matcher = matcher.having(
      (e) => e.name,
      'name',
      name,
    );
  }

  if (familyElement != const Object()) {
    matcher = matcher.having(
      (e) => e.familyElement,
      'familyElement',
      familyElement,
    );
  }

  if (providerType != const Object()) {
    matcher = matcher.having(
      (e) => e.providerType,
      'providerType',
      providerType,
    );
  }

  return matcher;
}

TypeMatcher<ProviderIdentifier> isProviderIdentifier({
  Object? node = const Object(),
  Object? providerElement = const Object(),
  Object? annotation = const Object(),
}) {
  var matcher = isA<ProviderIdentifier>();

  if (node != const Object()) {
    matcher = matcher.having(
      (e) => e.node,
      'node',
      node,
    );
  }

  if (providerElement != const Object()) {
    matcher = matcher.having(
      (e) => e.providerElement,
      'providerElement',
      providerElement,
    );
  }

  return matcher;
}

TypeMatcher<FunctionalProviderDeclarationElement>
    isFunctionalProviderDeclarationElement({
  Object? name = const Object(),
  Object? element = const Object(),
  Object? annotation = const Object(),
}) {
  var matcher = isA<FunctionalProviderDeclarationElement>();

  if (name != const Object()) {
    matcher = matcher.having(
      (e) => e.name,
      'name',
      name,
    );
  }

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (annotation != const Object()) {
    matcher = matcher.having(
      (e) => e.annotation,
      'annotation',
      annotation,
    );
  }

  return matcher;
}

TypeMatcher<ClassBasedProviderDeclarationElement>
    isClassBasedProviderDeclarationElement({
  Object? name = const Object(),
  Object? element = const Object(),
  Object? annotation = const Object(),
}) {
  var matcher = isA<ClassBasedProviderDeclarationElement>();

  if (name != const Object()) {
    matcher = matcher.having(
      (e) => e.name,
      'name',
      name,
    );
  }

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (annotation != const Object()) {
    matcher = matcher.having(
      (e) => e.annotation,
      'annotation',
      annotation,
    );
  }

  return matcher;
}

TypeMatcher<DependenciesAnnotation> isDependencies({
  Object? node = const Object(),
  Object? element = const Object(),
  Object? dependenciesNode = const Object(),
  Object? dependencies = const Object(),
}) {
  var matcher = isA<DependenciesAnnotation>();

  if (node != const Object()) {
    matcher = matcher.having(
      (e) => e.node,
      'node',
      node,
    );
  }

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (dependencies != const Object()) {
    matcher = matcher.having(
      (e) => e.dependencies,
      'dependencies',
      dependencies,
    );
  }

  if (dependenciesNode != const Object()) {
    matcher = matcher.having(
      (e) => e.dependenciesNode,
      'dependenciesNode',
      dependenciesNode,
    );
  }

  return matcher;
}

TypeMatcher<DependenciesAnnotationElement> isDependenciesElement({
  Object? element = const Object(),
  Object? dependencies = const Object(),
}) {
  var matcher = isA<DependenciesAnnotationElement>();

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (dependencies != const Object()) {
    matcher = matcher.having(
      (e) => e.dependencies,
      'dependencies',
      dependencies,
    );
  }

  return matcher;
}

TypeMatcher<RiverpodAnnotation> isRiverpod({
  Object? node = const Object(),
  Object? element = const Object(),
  Object? keepAlive = const Object(),
  Object? dependenciesNode = const Object(),
  Object? dependencyList = const Object(),
}) {
  var matcher = isA<RiverpodAnnotation>();

  if (node != const Object()) {
    matcher = matcher.having(
      (e) => e.node,
      'node',
      node,
    );
  }

  if (element != const Object()) {
    matcher = matcher.having(
      (e) => e.element,
      'element',
      element,
    );
  }

  if (keepAlive != const Object()) {
    matcher = matcher.having(
      (e) => e.keepAliveNode,
      'keepAliveNode',
      keepAlive,
    );
  }

  if (dependencyList != const Object()) {
    matcher = matcher.having(
      (e) => e.dependencyList,
      'dependencyList',
      dependencyList,
    );
  }

  if (dependenciesNode != const Object()) {
    matcher = matcher.having(
      (e) => e.dependenciesNode,
      'dependenciesNode',
      dependenciesNode,
    );
  }

  return matcher;
}

TypeMatcher<ProviderDependency> isProviderDependency({
  Object? node = const Object(),
  Object? provider = const Object(),
}) {
  var matcher = isA<ProviderDependency>();

  if (node != const Object()) {
    matcher = matcher.having(
      (e) => e.node,
      'node',
      node,
    );
  }

  if (provider != const Object()) {
    matcher = matcher.having(
      (e) => e.provider,
      'provider',
      provider,
    );
  }

  return matcher;
}

TypeMatcher<ProviderDependencyList> isProviderDependencyList({
  Object? node = const Object(),
  Object? values = const Object(),
}) {
  var matcher = isA<ProviderDependencyList>();

  if (node != const Object()) {
    matcher = matcher.having(
      (e) => e.node,
      'node',
      node,
    );
  }

  if (values != const Object()) {
    matcher = matcher.having(
      (e) => e.values,
      'values',
      values,
    );
  }

  return matcher;
}

TypeMatcher<RiverpodAnnotationElement> isRiverpodAnnotationElement({
  Object? keepAlive = const Object(),
  Object? dependencies = const Object(),
}) {
  var matcher = isA<RiverpodAnnotationElement>();

  if (keepAlive != const Object()) {
    matcher = matcher.having(
      (e) => e.keepAlive,
      'keepAlive',
      keepAlive,
    );
  }

  if (dependencies != const Object()) {
    matcher = matcher.having(
      (e) => e.dependencies,
      'dependencies',
      dependencies,
    );
  }

  return matcher;
}

Matcher hasToString(Object? expected) {
  return predicate(
    (e) => e.toString() == expected.toString(),
    'toString',
  );
}
