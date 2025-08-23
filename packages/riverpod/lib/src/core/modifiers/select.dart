part of '../../framework.dart';

/// Adds [select] to [ProviderListenable].
extension ProviderListenableSelect<InT> on ProviderListenable<InT> {
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
  /// This will further optimize our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<OutT> select<OutT>(
    OutT Function(InT value) selector,
  ) {
    return _ProviderSelector<InT, OutT>(
      provider: this,
      selector: selector,
    );
  }
}

/// An internal class for `ProviderBase.select`.
final class _ProviderSelector<InputT, OutputT>
    implements ProviderListenable<OutputT> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenable<InputT> provider;

  /// The selector applied
  final OutputT Function(InputT) selector;

  $Result<OutputT> _select($Result<InputT> value) {
    if (kDebugMode) _debugCallbackStack++;

    try {
      return switch (value) {
        $ResultData(:final value) => $Result.data(selector(value)),
        $ResultError(:final error, :final stackTrace) =>
          $Result.error(error, stackTrace),
      };
    } catch (err, stack) {
      return $Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugCallbackStack--;
    }
  }

  void _selectOnChange({
    required InputT newState,
    required $Result<OutputT>? lastSelectedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(OutputT? prev, OutputT next) listener,
    required void Function($Result<OutputT> newState) onChange,
  }) {
    final newSelectedValue = _select($Result.data(newState));
    if (lastSelectedValue == null ||
        !lastSelectedValue.hasData ||
        !newSelectedValue.hasData ||
        lastSelectedValue.value != newSelectedValue.value) {
      onChange(newSelectedValue);
      switch (newSelectedValue) {
        case $ResultData(:final value):
          listener(lastSelectedValue?.value, value);
        case $ResultError(:final error, :final stackTrace):
          onError(error, stackTrace);
      }
    }
  }

  @override
  ProviderSubscriptionImpl<OutputT> _addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    late final ExternalProviderSubscription<InputT, OutputT> providerSub;
    $Result<OutputT>? lastSelectedValue;
    final sub = provider._addListener(
      node,
      (prev, input) {
        _selectOnChange(
          newState: input,
          lastSelectedValue: lastSelectedValue,
          listener: providerSub._notifyData,
          onError: providerSub._notifyError,
          onChange: (newState) => lastSelectedValue = newState,
        );
      },
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: onError,
    );

    if (!weak) {
      lastSelectedValue = _select(sub.readSafe());
    }

    return providerSub = ExternalProviderSubscription<InputT, OutputT>.fromSub(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () {
        // flushes the provider
        final result = sub.readSafe();
        if (result case $ResultError(:final error, :final stackTrace)) {
          return $Result.error(error, stackTrace);
        }

        // Using ! because since `sub.read` flushes the inner subscription,
        // it is guaranteed that `lastSelectedValue` is not null.
        return lastSelectedValue!;
      },
    );
  }
}
