// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import '../../builders.dart';

/// {@template riverpod.change_notifier_provider}
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
/// {@endtemplate}
@publicInLegacy
final class ChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends $FunctionalProvider<NotifierT, NotifierT, NotifierT>
    with LegacyProviderMixin<NotifierT, NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  ChangeNotifierProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  /// @nodoc
  @internal
  const ChangeNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
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
  Refreshable<NotifierT> get notifier =>
      ProviderElementProxy<NotifierT, NotifierT, NotifierT>(
        this,
        (element) {
          return (element as _ChangeNotifierProviderElement<NotifierT>)
              ._notifierNotifier;
        },
      );

  final NotifierT Function(Ref ref) _createFn;
  @override
  NotifierT create(Ref ref) => _createFn(ref);

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public
  _ChangeNotifierProviderElement<NotifierT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _ChangeNotifierProviderElement<NotifierT>._(pointer);
  }
}

/// The element of [ChangeNotifierProvider].
class _ChangeNotifierProviderElement<NotifierT extends ChangeNotifier?>
    extends $FunctionalProviderElement<NotifierT, NotifierT, NotifierT>
    with SyncProviderElement<NotifierT> {
  _ChangeNotifierProviderElement._(super.pointer);

  final _notifierNotifier = $Observable<NotifierT>();

  void Function()? _removeListener;

  @override
  WhenComplete create(Ref ref) {
    final notifierResult = _notifierNotifier.result = $Result.guard(
      () => provider.create(ref),
    );

    final notifier = notifierResult.requireState;

    value = AsyncData(notifier);

    if (notifier != null) {
      void listener() => ref.notifyListeners();
      notifier.addListener(listener);
      _removeListener = () => notifier.removeListener(listener);
    }

    return null;
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    final notifier = _notifierNotifier.result?.value;
    if (notifier != null) {
      container.runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitListenables(
    void Function($Observable element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_notifierNotifier);
  }
}

/// The [Family] of [ChangeNotifierProvider].
@publicInMisc
final class ChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?,
        ArgT>
    extends FunctionalFamily<NotifierT, NotifierT, ArgT, NotifierT,
        ChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [ChangeNotifierProvider].
  /// @nodoc
  @internal
  ChangeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: ChangeNotifierProvider.internal,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
