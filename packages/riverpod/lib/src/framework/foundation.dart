part of '../framework.dart';

/// A common interface shared by [ProviderBase] and [Family]
@sealed
abstract class ProviderOrFamily {
  /// A common interface shared by [ProviderBase] and [Family]
  const ProviderOrFamily();

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
  List<ProviderOrFamily>? get allTransitiveDependencies;
}

List<ProviderOrFamily> _allTransitiveDependencies(
  List<ProviderOrFamily> dependencies,
) {
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
/// Should override ==/hashCode when possible
@immutable
mixin ProviderListenable<State> {
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
abstract class ProviderSubscription<State> {
  /// Stops listening to the provider
  @mustCallSuper
  void close();

  /// Obtain the latest value emitted by the provider
  State read();
}
