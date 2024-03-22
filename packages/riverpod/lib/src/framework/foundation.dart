part of '../framework.dart';

/// A common interface shared by [ProviderBase] and [Family]
@sealed
abstract class ProviderOrFamily implements ProviderListenableOrFamily {
  /// A common interface shared by [ProviderBase] and [Family]
  const ProviderOrFamily({
    required this.name,
    required this.dependencies,
    required this.allTransitiveDependencies,
  });

  /// The family that this provider/family depends on.
  Family<Object?>? get from;

  /// {@template riverpod.name}
  /// A custom label for providers.
  ///
  /// This is picked-up by devtools and [toString] to show better messages.
  /// {@endtemplate}
  final String? name;

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
  final Iterable<ProviderOrFamily>? allTransitiveDependencies;
}

/// A shared interface between [ProviderListenable] and [Family].
abstract class ProviderListenableOrFamily {}

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
/// Should override ==/hashCode when possible
@immutable
mixin ProviderListenable<State> implements ProviderListenableOrFamily {
  /// Starts listening to this transformer
  ProviderSubscription<State> addListener(
    Node node,
    void Function(State? previous, State next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  });

  /// Obtains the result of this provider expression without adding listener.
  State read(Node node);

  /// Partially listen to a provider.
  ///
  /// The [select] function allows filtering unwanted rebuilds of a Widget
  /// by reading only the properties that we care about.
  ///
  /// For example, consider the following `ChangeNotifier`:
  ///
  /// ```dart
  /// class Person extends ChangeNotifier {
  ///   int _age = 0;
  ///   int get age => _age;
  ///   set age(int age) {
  ///     _age = age;
  ///     notifyListeners();
  ///   }
  ///
  ///   String _name = '';
  ///   String get name => _name;
  ///   set name(String name) {
  ///     _name = name;
  ///     notifyListeners();
  ///   }
  /// }
  ///
  /// final personProvider = ChangeNotifierProvider((_) => Person());
  /// ```
  ///
  /// In this class, both `name` and `age` may change, but a widget may need
  /// only `age`.
  ///
  /// If we used `ref.watch(`/`Consumer` as we normally would, this would cause
  /// widgets that only use `age` to still rebuild when `name` changes, which
  /// is inefficient.
  ///
  /// The method [select] can be used to fix this, by explicitly reading only
  /// a specific part of the object.
  ///
  /// A typical usage would be:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final age = ref.watch(personProvider.select((p) => p.age));
  ///   return Text('$age');
  /// }
  /// ```
  ///
  /// This will cause our widget to rebuild **only** when `age` changes.
  ///
  ///
  /// **NOTE**: The function passed to [select] can return complex computations
  /// too.
  ///
  /// For example, instead of `age`, we could return a "isAdult" boolean:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final isAdult = ref.watch(personProvider.select((p) => p.age >= 18));
  ///   return Text('$isAdult');
  /// }
  /// ```
  ///
  /// This will further optimise our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<Selected> select<Selected>(
    Selected Function(State value) selector,
  ) {
    return _ProviderSelector<State, Selected>(
      provider: this,
      selector: selector,
    );
  }
}

/// Represents the subscription to a [ProviderListenable]
@optionalTypeArgs
abstract class ProviderSubscription<State> {
  /// Represents the subscription to a [ProviderListenable]
  ProviderSubscription(this.source) {
    final Object listener = source;
    if (listener is ProviderElementBase) {
      final subs = listener._subscriptions ??= [];
      subs.add(this);
    }
  }

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElementBase] or a [ProviderContainer],
  /// but may be other values in the future.
  final Node source;

  /// Whether the subscription is closed.
  bool get closed => _closed;
  var _closed = false;

  /// Obtain the latest value emitted by the provider.
  ///
  /// This method throws if [closed] is true.
  State read();

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  @mustCallSuper
  void close() {
    if (_closed) return;
    _closed = true;

    final Object listener = source;
    if (listener is ProviderElementBase) {
      listener._subscriptions?.remove(this);
    }
  }
}
