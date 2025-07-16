part of '../framework.dart';

/// A shared interface between [ProviderListenable] and [Family].
@publicInMisc
interface class ProviderListenableOrFamily {}

/// A common interface shared by [ProviderBase] and [Family]
@publicInCodegen
@publicInMisc
sealed class ProviderOrFamily implements ProviderListenableOrFamily {
  /// A common interface shared by [ProviderBase] and [Family]
  const ProviderOrFamily({
    required this.name,
    required this.dependencies,
    required this.$allTransitiveDependencies,
    required this.isAutoDispose,
    required this.retry,
  });

  /// The family that this provider/family depends on.
  Family? get from;

  /// {@template riverpod.name}
  /// A custom label for providers.
  ///
  /// This is picked-up by devtools and [toString] to show better messages.
  /// {@endtemplate}
  final String? name;

  /// The retry strategy to use when a provider fails.
  ///
  /// {@template riverpod.retry}
  /// The function takes two parameters:
  /// - `retryCount`: The number of times the provider has been retried
  ///   (starting at 0).
  /// - `error`: The error that caused the retry.
  ///
  /// The default implementation ([ProviderContainer.defaultRetry]) has:
  /// - 10 retries
  /// - starts with a delay of 200ms
  /// - doubles the delay on each retry up to 6.4 seconds
  /// - retries all failures
  /// - ignores [ProviderException]s (which happens when a provider
  ///   rethrows the error of another provider)
  /// - ignores [Error]s (which are generally programming errors)
  /// {@endtemplate}
  final Retry? retry;

  /// The list of providers that this provider potentially depends on.
  ///
  /// Specifying this list is strictly equivalent to saying "This provider may
  /// be scoped". If a provider is scoped, it should specify [dependencies].
  /// If it is never scoped, it should not specify [dependencies].
  ///
  /// The content of [dependencies] should be a list of all the providers that
  /// this provider may depend on which can be scoped.
  ///
  /// For example, consider the following providers:
  /// ```dart
  /// // By not specifying "dependencies", we are saying that this provider is never scoped
  /// final rootProvider = Provider((ref) => Foo());
  /// // By specifying "dependencies" (even if the list is empty),
  /// // we are saying that this provider is potentially scoped
  /// final scopedProvider = Provider((ref) => Foo(), dependencies: []);
  /// ```
  ///
  /// Then if we were to depend on `rootProvider` in a scoped provider, we
  /// could write any of:
  ///
  /// ```dart
  /// final dependentProvider = Provider((ref) {
  ///   ref.watch(rootProvider);
  ///   // This provider does not depend on any scoped provider,
  ///   // as such "dependencies" is optional
  /// });
  ///
  /// final dependentProvider = Provider((ref) {
  ///   ref.watch(rootProvider);
  ///   // This provider decided to specify "dependencies" anyway, marking
  ///   // "dependentProvider" as possibly scoped.
  ///   // Since "rootProvider" is never scoped, it doesn't need to be included
  ///   // in "dependencies".
  /// }, dependencies: []);
  ///
  /// final dependentProvider = Provider((ref) {
  ///   ref.watch(rootProvider);
  ///   // Including "rootProvider" in "dependencies" is fine too, even though
  ///   // it is not required. It is a no-op.
  /// }, dependencies: [rootProvider]);
  /// ```
  ///
  /// However, if we were to depend on `scopedProvider` then our only choice is:
  ///
  /// ```dart
  /// final dependentProvider = Provider((ref) {
  ///   ref.watch(scopedProvider);
  ///   // Since "scopedProvider" specifies "dependencies", any provider that
  ///   // depends on it must also specify "dependencies" and include "scopedProvider".
  /// }, dependencies: [scopedProvider]);
  /// ```
  ///
  /// In that scenario, the `dependencies` parameter is required and it must
  /// include `scopedProvider`.
  ///
  /// See also:
  /// - [provider_dependencies](https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#provider_dependencies-riverpod_generator-only)
  ///   and [scoped_providers_should_specify_dependencies](https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#scoped_providers_should_specify_dependencies-generator-only).\
  ///   These are lint rules that will warn about incorrect `dependencies` usages.
  final Iterable<ProviderOrFamily>? dependencies;

  /// All the dependencies of a provider and their dependencies too.
  /// @nodoc
  @internal
  final Iterable<ProviderOrFamily>? $allTransitiveDependencies;

  /// Whether the state associated to this provider should be disposed
  /// automatically when the provider stops being listened.
  final bool isAutoDispose;
}

extension on ProviderListenableOrFamily {
  $ProviderBaseImpl<Object?>? get debugListenedProvider {
    final that = this;
    return switch (that) {
      $ProviderBaseImpl() => that,
      _ProviderSelector() => that.provider.debugListenedProvider,
      _AsyncSelector() => that.provider.debugListenedProvider,
      ProviderElementProxy() => that.provider,
      _ => null,
    };
  }
}

/// Computes the list of all dependencies of a provider.
@internal
Set<ProviderOrFamily>? computeAllTransitiveDependencies(
  Iterable<ProviderOrFamily>? dependencies,
) {
  if (dependencies == null) return null;
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
  return UnmodifiableSetView(result);
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
@internal
String describeIdentity(Object? object) {
  return '${object.runtimeType}#${shortHash(object)}';
}

// Copied from Flutter
/// [Object.hashCode]'s 20 least-significant bits.
@internal
String shortHash(Object? object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `ref.watch` to listen to
/// both a provider and `provider.select`.
///
/// Should override ==/hashCode when possible
///
/// See also:
/// - [SyncProviderTransformerMixin] and [AsyncProviderTransformerMixin], for making custom [ProviderListenable]s.
@immutable
@publicInCodegen
@publicInMisc
abstract interface class ProviderListenable<StateT>
    implements ProviderListenableOrFamily {
  /// Starts listening to this transformer
  ProviderSubscriptionImpl<StateT> _addListener(
    Node source,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  });
}
