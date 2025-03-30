// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import '../../builders.dart';

ProviderElementProxy<NotifierT, NotifierT>
    _notifier<NotifierT extends ChangeNotifier?>(
  _ChangeNotifierProviderBase<NotifierT> that,
) {
  return ProviderElementProxy<NotifierT, NotifierT>(
    that,
    (element) {
      return (element as ChangeNotifierProviderElement<NotifierT>)
          ._notifierNotifier;
    },
  );
}

// ignore: subtype_of_sealed_class
/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no longer be O(N^2) for
/// dispatching notifications, but instead O(N)
abstract class _ChangeNotifierProviderBase<NotifierT extends ChangeNotifier?>
    extends ProviderBase<NotifierT> {
  const _ChangeNotifierProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  });

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
  ProviderListenable<NotifierT> get notifier;

  NotifierT _create(covariant ChangeNotifierProviderElement<NotifierT> ref);
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class ChangeNotifierProviderRef<NotifierT extends ChangeNotifier?>
    implements Ref<NotifierT> {
  /// The [ChangeNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  @Deprecated('will be removed in 3.0.0.')
  NotifierT get notifier;
}

// ignore: subtype_of_sealed_class
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
class ChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends _ChangeNotifierProviderBase<NotifierT>
    with
        // ignore: deprecated_member_use
        AlwaysAliveProviderBase<NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  ChangeNotifierProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  ChangeNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  final NotifierT Function(
    // ignore: deprecated_member_use, deprecated_member_use_from_same_package
    ChangeNotifierProviderRef<NotifierT> ref,
  ) _createFn;

  @override
  NotifierT _create(ChangeNotifierProviderElement<NotifierT> ref) {
    return _createFn(ref);
  }

  @override
  ChangeNotifierProviderElement<NotifierT> createElement() {
    return ChangeNotifierProviderElement<NotifierT>._(this);
  }

  @override
  // ignore: deprecated_member_use, deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT>(this);

  /// {@template riverpod.override_with}
  /// Override the provider with a new initialization function.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified `dependencies`, it will have no effect.
  ///
  /// The override must not specify a `dependencies`.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       // Replace the implementation of the provider with a different one
  ///       myService.overrideWithProvider((ref) {
  ///         ref.watch('other');
  ///         return MyFakeService(),
  ///       })),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWith(
    // ignore: deprecated_member_use, deprecated_member_use_from_same_package
    Create<NotifierT, ChangeNotifierProviderRef<NotifierT>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChangeNotifierProvider<NotifierT>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// The element of [ChangeNotifierProvider].
@internal
class ChangeNotifierProviderElement<NotifierT extends ChangeNotifier?>
    extends ProviderElementBase<NotifierT>
    // ignore: deprecated_member_use, deprecated_member_use_from_same_package
    implements
        // ignore: deprecated_member_use, deprecated_member_use_from_same_package
        ChangeNotifierProviderRef<NotifierT> {
  ChangeNotifierProviderElement._(
    _ChangeNotifierProviderBase<NotifierT> super._provider,
  );

  @override
  NotifierT get notifier => _notifierNotifier.value;
  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _ChangeNotifierProviderBase<NotifierT>;

    final notifierResult =
        _notifierNotifier.result = $Result.guard(() => provider._create(this));

    // TODO test requireState, as ref.read(p) is expected to throw if notifier creation failed
    final notifier = notifierResult.requireState;

    setState(notifier);

    if (notifier != null) {
      void listener() => setState(notifier);
      notifier.addListener(listener);
      _removeListener = () => notifier.removeListener(listener);
    }
  }

  @override
  bool updateShouldNotify(NotifierT previous, NotifierT next) => true;

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    final notifier = _notifierNotifier.result?.value;
    if (notifier != null) {
      // TODO test ChangeNotifier.dispose is guarded
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase<Object?> element) elementVisitor,
    required void Function(ProxyElementValueNotifier<Object?> element)
        notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_notifierNotifier);
  }
}

// ignore: subtype_of_sealed_class
/// The [Family] of [ChangeNotifierProvider].
class ChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?, Arg>
    // ignore: deprecated_member_use, deprecated_member_use_from_same_package
    extends FamilyBase<ChangeNotifierProviderRef<NotifierT>, NotifierT, Arg,
        NotifierT, ChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [ChangeNotifierProvider].
  ChangeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: ChangeNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use, deprecated_member_use_from_same_package
    NotifierT Function(ChangeNotifierProviderRef<NotifierT> ref, Arg arg)
        create,
  ) {
    return FamilyOverrideImpl<NotifierT, Arg,
        ChangeNotifierProvider<NotifierT>>(
      this,
      (arg) => ChangeNotifierProvider<NotifierT>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0, use Ref instead')
abstract class AutoDisposeChangeNotifierProviderRef<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderRef<NotifierT>
    implements AutoDisposeRef<NotifierT> {}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.change_notifier_provider}
class AutoDisposeChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends _ChangeNotifierProviderBase<NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  AutoDisposeChangeNotifierProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeChangeNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamily.new;

  final NotifierT Function(
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeChangeNotifierProviderRef<NotifierT> ref,
  ) _createFn;

  @override
  NotifierT _create(
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeChangeNotifierProviderElement<NotifierT> ref,
  ) {
    return _createFn(ref);
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  AutoDisposeChangeNotifierProviderElement<NotifierT> createElement() {
    // ignore: deprecated_member_use_from_same_package
    return AutoDisposeChangeNotifierProviderElement<NotifierT>._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT>(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<NotifierT, AutoDisposeChangeNotifierProviderRef<NotifierT>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeChangeNotifierProvider<NotifierT>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// The element of [AutoDisposeChangeNotifierProvider].
@internal
class AutoDisposeChangeNotifierProviderElement<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderElement<NotifierT>
    with
        AutoDisposeProviderElementMixin<NotifierT>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeChangeNotifierProviderRef<NotifierT> {
  /// The [ProviderElementBase] for [ChangeNotifier]
  @Deprecated('will be removed in 3.0.0, use Ref instead')
  AutoDisposeChangeNotifierProviderElement._(
    AutoDisposeChangeNotifierProvider<NotifierT> super._provider,
  ) : super._();
}

// ignore: subtype_of_sealed_class
/// The [Family] of [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?, Arg>
    extends AutoDisposeFamilyBase<
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeChangeNotifierProviderRef<NotifierT>,
        NotifierT,
        Arg,
        NotifierT,
        AutoDisposeChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [AutoDisposeChangeNotifierProvider].
  AutoDisposeChangeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeChangeNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NotifierT Function(
      // ignore: deprecated_member_use_from_same_package
      AutoDisposeChangeNotifierProviderRef<NotifierT> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverrideImpl<NotifierT, Arg,
        AutoDisposeChangeNotifierProvider<NotifierT>>(
      this,
      (arg) => AutoDisposeChangeNotifierProvider<NotifierT>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}
