part of '../framework.dart';

/// A common interface shared by [ProviderBase] and [Family]
@sealed
abstract class ProviderOrFamily {
  /// The list of providers that this provider potentially depends on.
  ///
  /// Specifying this list will tell Riverpod to automatically scope this provider
  /// if one of its dependency is overridden.
  /// The downside is that it prevents `ref.watch` & co to be used with a provider
  /// that isn't listed in [dependencies].
  List<ProviderOrFamily>? get dependencies;

  /// The family that this provider/family depends on.
  Family? get from;

  /// All the dependencies of a provider and their dependencies too.
  late final allTransitiveDependencies =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);
}

List<ProviderOrFamily> _allTransitiveDependencies(
    List<ProviderOrFamily> dependencies) {
  final result = <ProviderOrFamily>{};

  void visitDependency(ProviderOrFamily dep) {
    if (result.add(dep) && dep.dependencies != null) {
      dep.dependencies!.forEach(visitDependency);
    }
    final depFamily = dep.from;
    if (depFamily != null &&
        result.add(depFamily) &&
        depFamily.dependencies != null) {
      depFamily.dependencies!.forEach(visitDependency);
    }
  }

  dependencies.forEach(visitDependency);

  return List.unmodifiable(result);
}

// Copied from Flutter
/// Returns a summary of the runtime type and hash code of `object`.
///
/// See also:
///
///  * [Object.hashCode], a value used when placing an object in a [Map] or
///    other similar data structure, and which is also used in debug output to
///    distinguish instances of the same class (hash collisions are
///    possible, but rare enough that its use in debug output is useful).
///  * [Object.runtimeType], the [Type] of an object.
String describeIdentity(Object? object) {
  return '${object.runtimeType}#${shortHash(object)}';
}

// Copied from Flutter
/// [Object.hashCode]'s 20 least-significant bits.
String shortHash(Object? object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `ref.watch` to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
abstract class ProviderListenable<State> {}

/// Represents the subscription to a provider
abstract class ProviderSubscription<State> {
  /// Stops listening to the provider
  void close();

  /// Obtain the latest value emitted by the provider
  State read();
}
