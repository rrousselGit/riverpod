// ignore_for_file: invalid_use_of_internal_member

part of '../change_notifier_provider.dart';

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
        _notifierNotifier.result = Result.guard(() => provider._create(this));

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

    final notifier = _notifierNotifier.result?.stateOrNull;
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
