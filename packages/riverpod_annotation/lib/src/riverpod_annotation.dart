// DO NOT MOVE/RENAME

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import '../experimental/scope.dart';
import '../riverpod_annotation.dart';

/// {@template riverpod_annotation.provider}
/// An annotation placed on classes or functions.
///
/// This tells riverpod_generator to generate a provider out of the annotated.
///
/// By default, Riverpod will convert [Future]s and [Stream]s into [AsyncValue]s.
/// If this is undesired, you can use [Raw] to have Riverpod forcibly return
/// the raw [Future]/[Stream] instead.
/// element.
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.function})
@sealed
final class Riverpod {
  /// {@macro riverpod_annotation.provider}
  const Riverpod({
    this.keepAlive = false,
    this.dependencies,
    this.retry,
    this.name,
  });

  /// The name of the generated provider.
  ///
  /// If null, the name will be derived from the annotated element,
  /// after applying prefix/suffix transformations from the `build.yaml`
  /// configuration.
  ///
  /// If non-null, transformation from the `build.yaml` will not be applied,
  /// and the name will be used as-is.
  ///
  /// This name should be unique within the library.
  final String? name;

  /// The default retry logic used by providers associated to this container.
  ///
  /// The default implementation:
  /// - has unlimited retries
  /// - starts with a delay of 200ms
  /// - doubles the delay on each retry up to 6.4 seconds
  /// - retries all failures
  final Duration? Function(int retryCount, Object error)? retry;

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  /// The list of providers that this provider potentially depends on.
  ///
  /// This list must contains the classes/functions annotated with `@riverpod`,
  /// not the generated providers themselves.
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
  /// @riverpod
  /// Foo root(Ref ref) => Foo();
  ///
  /// // By specifying "dependencies" (even if the list is empty),
  /// // we are saying that this provider is potentially scoped
  /// @Riverpod(dependencies: [])
  /// Foo scoped(Ref ref) => Foo();
  ///
  /// // Alternatively, notifiers with an abstract build method are also considered scoped
  /// @riverpod
  /// class MyNotifier extends _$MyNotifier {
  ///  @override
  ///  int build();
  /// }
  /// ```
  ///
  /// Then if we were to depend on `rootProvider` in a scoped provider, we
  /// could write any of:
  ///
  /// ```dart
  /// @riverpod
  /// Object? dependent(Ref ref) {
  ///   ref.watch(rootProvider);
  ///   // This provider does not depend on any scoped provider,
  ///   // as such "dependencies" is optional
  /// }
  ///
  /// @Riverpod(dependencies: [])
  /// Object? dependent(Ref ref) {
  ///   ref.watch(rootProvider);
  ///   // This provider decided to specify "dependencies" anyway, marking
  ///   // "dependentProvider" as possibly scoped.
  ///   // Since "rootProvider" is never scoped, it doesn't need to be included
  ///   // in "dependencies".
  /// }
  ///
  /// @Riverpod(dependencies: [root])
  /// Object? dependent(Ref ref) {
  ///   ref.watch(rootProvider);
  ///   // Including "rootProvider" in "dependencies" is fine too, even though
  ///   // it is not required. It is a no-op.
  /// }
  /// ```
  ///
  /// However, if we were to depend on `scopedProvider` then our only choice is:
  ///
  /// ```dart
  /// @Riverpod(dependencies: [scoped])
  /// Object? dependent(Ref ref) {
  ///   ref.watch(scopedProvider);
  ///   // Since "scopedProvider" specifies "dependencies", any provider that
  ///   // depends on it must also specify "dependencies" and include "scopedProvider".
  /// }
  /// ```
  ///
  /// In that scenario, the `dependencies` parameter is required and it must
  /// include `scopedProvider`.
  ///
  /// **Note**:
  /// It is not necessary to specify an empty "dependencies" on notifiers with
  /// an abstract build method:
  /// ```dart
  /// @riverpod
  /// class MyNotifier extends _$MyNotifier {
  ///   @override
  ///   int build(); // Valid, marks this notifier as scoped
  /// }
  /// ```
  ///
  /// See also:
  /// - [Dependencies], for specifying dependencies on non-providers.
  /// - [provider_dependencies](https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#provider_dependencies-riverpod_generator-only)
  ///   and [scoped_providers_should_specify_dependencies](https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_lint#scoped_providers_should_specify_dependencies-generator-only).\
  ///   These are lint rules that will warn about incorrect `dependencies` usages.
  final List<Object>? dependencies;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();

/// An annotation used to help the linter find the user-defined element from
/// the generated provider.
///
/// DO NOT USE
class ProviderFor {
  /// An annotation used to help the linter find the user-defined element from
  /// the generated provider.
  // Put the annotation on the constructor to avoid the linter from complaining
  // about the annotation being exported; while preventing the user from using it.
  /// @nodoc
  @internal
  const ProviderFor(this.value)
      : assert(
          value is Function || value is Type,
          '$value is not a class/function',
        );

  /// The code annotated by `@riverpod`
  final Object value;
}

/// {@template riverpod_annotation.raw}
/// An annotation for marking a value type as "should not be handled
/// by Riverpod".
///
/// This is a type-alias to [WrappedT], and has no runtime effect. It is only used
/// as metadata for the code-generator/linter.
///
/// This serves two purposes:
/// - It enables a provider to return a [Future]/[Stream] without
///   having the provider converting it into an [AsyncValue].
///   ```dart
///   @riverpod
///   Raw<Future<int>> myProvider(...) async => ...;
///   ...
///   // returns a Future<int> instead of AsyncValue<int>
///   Future<int> value = ref.watch(myProvider);
///   ```
///
/// - It can silence the linter when a provider returns a value that
///   is otherwise not supported, such as Flutter's `ChangeNotifier`:
///   ```dart
///   // Will not trigger the "unsupported return type" lint
///   @riverpod
///   Raw<MyChangeNotifier> myProvider(...) => MyChangeNotifier();
///   ```
///
/// The typedef can be used at various places within the return type declaration.
///
/// For example, a valid return type is `Future<Raw<ChangeNotifier>>`.
/// This way, Riverpod will convert the [Future] into an [AsyncValue], and
/// the usage of `ChangeNotifier` will not trigger the linter:
///
/// ```dart
/// @riverpod
/// Future<Raw<ChangeNotifier>> myProvider(...) async => ...;
/// ...
/// AsyncValue<ChangeNotifier> value = ref.watch(myProvider);
/// ```
///
/// {@endtemplate}
typedef Raw<WrappedT> = WrappedT;

/// An exception thrown when a scoped provider is accessed when not yet overridden.
///
/// Do not use
class MissingScopeException implements Exception {
  /// An exception thrown when a scoped provider is accessed when not yet overridden.
  MissingScopeException(this.ref);

  /// The [Ref] that threw the exception
  final Ref ref;

  @override
  String toString() {
    final element = ref.$element;

    return 'MissingScopeException: The provider ${element.origin} is scoped, '
        'but was accessed in a place where it is not overridden. '
        'Either you forgot to override the provider, or you tried to read it outside of where it is defined';
  }
}
