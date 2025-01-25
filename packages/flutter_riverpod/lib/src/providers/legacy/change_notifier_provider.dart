// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import '../../builders.dart';

ProviderElementProxy<NotifierT, NotifierT>
    _notifier<NotifierT extends ChangeNotifier?>(
  ChangeNotifierProvider<NotifierT> that,
) {
  return ProviderElementProxy<NotifierT, NotifierT>(
    that,
    (element) {
      return (element as ChangeNotifierProviderElement<NotifierT>)
          ._notifierNotifier;
    },
  );
}

/// Creates a [ChangeNotifier] and exposes its current state.
///
/// Combined with [ChangeNotifier], [ChangeNotifierProvider] can be used to manipulate
/// advanced states, that would otherwise be difficult to represent with simpler
/// providers such as [Provider] or [FutureProvider].
///
/// For example, you may have a todo-list, where you can add and remove
/// and complete a todo.
/// Using [ChangeNotifier], you could represent such state as:
///
/// ```dart
/// class TodosNotifier extends ChangeNotifier {
///   List<Todo> todos = [];
///
///   void add(Todo todo) {
///     todos.add(todo);
///     notifyListeners();
///   }
///
///   void remove(String todoId) {
///     todos.removeWhere((todo) => todo.id == todoId);
///     notifyListeners();
///   }
///
///   void toggle(String todoId) {
///     final todo = todos.firstWhere((todo) => todo.id == todoId);
///     todo.completed = !todo.completed;
///     notifyListeners();
///   }
/// }
/// ```
///
/// Which you can then pass to a [ChangeNotifierProvider] like so:
///
/// ```dart
/// final todosProvider = ChangeNotifierProvider<TodosNotifier, List<Todo>>((ref) => TodosNotifier());
/// ```
///
/// And finally, you can interact with it inside your UI:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   // rebuild the widget when the todo list changes
///   List<Todo> todos = ref.watch(todosProvider).todos;
///
///   return ListView(
///     children: [
///       for (final todo in todos)
///         CheckboxListTile(
///            value: todo.completed,
///            // When tapping on the todo, change its completed status
///            onChanged: (value) => ref.read(todosProvider.notifier).toggle(todo.id),
///            title: Text(todo.description),
///         ),
///     ],
///   );
/// }
/// ```
final class ChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends $FunctionalProvider<NotifierT, NotifierT>
    with LegacyProviderMixin<NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  ChangeNotifierProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  @internal
  const ChangeNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    super.from,
    super.argument,
    super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// Obtains the [ChangeNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [ChangeNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(changeNotifierProvider.notifier).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [ChangeNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  Refreshable<NotifierT> get notifier => _notifier<NotifierT>(this);

  final NotifierT Function(Ref ref) _createFn;

  @internal
  @override
  ChangeNotifierProviderElement<NotifierT> $createElement(
    $ProviderPointer pointer,
  ) {
    return ChangeNotifierProviderElement<NotifierT>._(this, pointer);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  ChangeNotifierProvider<NotifierT> $copyWithCreate(
    Create<NotifierT> create,
  ) {
    return ChangeNotifierProvider<NotifierT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      isAutoDispose: isAutoDispose,
      from: from,
      argument: argument,
      allTransitiveDependencies: allTransitiveDependencies,
    );
  }
}

/// The element of [ChangeNotifierProvider].
class ChangeNotifierProviderElement<NotifierT extends ChangeNotifier?>
    extends ProviderElement<NotifierT> {
  ChangeNotifierProviderElement._(this.provider, super.pointer);

  @override
  final ChangeNotifierProvider<NotifierT> provider;

  final _notifierNotifier = $ElementLense<NotifierT>();

  void Function()? _removeListener;

  @override
  WhenComplete create(
    Ref ref, {
    required bool didChangeDependency,
    required bool isFirstBuild,
  }) {
    final notifierResult = _notifierNotifier.result = $Result.guard(
      () => provider._createFn(ref),
    );

    final notifier = notifierResult.requireState;

    setStateResult(ResultData(notifier));

    if (notifier != null) {
      void listener() => setStateResult(ResultData(notifier));
      notifier.addListener(listener);
      _removeListener = () => notifier.removeListener(listener);
    }

    return null;
  }

  @override
  bool updateShouldNotify(NotifierT previous, NotifierT next) => true;

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    final notifier = _notifierNotifier.result?.stateOrNull;
    if (notifier != null) {
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_notifierNotifier);
  }
}

/// The [Family] of [ChangeNotifierProvider].
class ChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?, Arg>
    extends FunctionalFamily<NotifierT, Arg, NotifierT,
        ChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [ChangeNotifierProvider].
  ChangeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: ChangeNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  @override
  Override overrideWith(
    NotifierT Function(Ref ref, Arg arg) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ChangeNotifierProvider<NotifierT>;

        return ChangeNotifierProvider<NotifierT>.internal(
          (ref) => create(ref, provider.argument as Arg),
          from: provider.from,
          argument: provider.argument,
          isAutoDispose: provider.isAutoDispose,
          dependencies: null,
          allTransitiveDependencies: null,
          name: null,
        ).$createElement(pointer);
      },
    );
  }
}
